# Custom Kernels

## Creating your own kernel

KernelFunctions.jl contains the most popular kernels already but you might want to make your own!

Here are a few ways depending on how complicated your kernel is:

### SimpleKernel for kernel functions depending on a metric

If your kernel function is of the form `k(x, y) = f(d(x, y))` where `d(x, y)` is a `PreMetric`,
you can construct your custom kernel by defining `kappa` and `metric` for your kernel.
Here is for example how one can define the `SqExponentialKernel` again:

```julia
struct MyKernel <: KernelFunctions.SimpleKernel end

KernelFunctions.kappa(::MyKernel, d2::Real) = exp(-d2)
KernelFunctions.metric(::MyKernel) = SqEuclidean()
```

### Kernel for more complex kernels

If your kernel does not satisfy such a representation, all you need to do is define `(k::MyKernel)(x, y)` and inherit from `Kernel`.
For example, we recreate here the `NeuralNetworkKernel`:

```julia
struct MyKernel <: KernelFunctions.Kernel end

(::MyKernel)(x, y) = asin(dot(x, y) / sqrt((1 + sum(abs2, x)) * (1 + sum(abs2, y))))
```

Note that the fallback implementation of the base `Kernel` evaluation does not use `Distances.jl` and can therefore be a bit slower.

### Equality

The interface tests include basic tests that `Base.hash` and `Base.:(==)`. 
It is necessary to overload these functions specially when a kernel is parametrized by a mutable type, such as a `Vector`.
The expectation is that two kernels `k1` and `k2` may (and as far as possible should) be equal `k1==k2` if all of

1. `nameof(typeof(k1)) == nameof(typeof(k2))` same base `struct` type (stripped of parameters)
2. all parameters are `isequal`
3. `isequal(k1(x, y), k2(x, y))` for any `x` and `y`

The precise implementation and behaviour is left to the user.

As an example, the implementation for `PeriodicKernel` is

```julia
struct PeriodicKernel{T} <: SimpleKernel
    r::Vector{T}
    # constructor ...
end

Base.hash(k::PeriodicKernel, h::UInt) = hash(k.r, hash(nameof(typeof(k)), h))
Base.:(==)(k1::PeriodicKernel, k2::PeriodicKernel) = isequal(k1.r, k2.r)
```

### Additional Options

Finally there are additional functions you can define to bring in more features:
 - `KernelFunctions.iskroncompatible(k::MyKernel)`: if your kernel factorizes in dimensions, you can declare your kernel as `iskroncompatible(k) = true` to use Kronecker methods.
 - `KernelFunctions.dim(x::MyDataType)`: by default the dimension of the inputs will only be checked for vectors of type `AbstractVector{<:Real}`. If you want to check the dimensionality of your inputs, dispatch the `dim` function on your datatype. Note that `0` is the default.
 - `dim` is called within `KernelFunctions.validate_inputs(x::MyDataType, y::MyDataType)`, which can instead be directly overloaded if you want to run special checks for your input types.
 - `kernelmatrix(k::MyKernel, ...)`: you can redefine the diverse `kernelmatrix` functions to eventually optimize the computations.
 - `Base.print(io::IO, k::MyKernel)`: if you want to specialize the printing of your kernel.

KernelFunctions uses [Functors.jl](https://github.com/FluxML/Functors.jl) for specifying trainable kernel parameters
in a way that is compatible with the [Flux ML framework](https://github.com/FluxML/Flux.jl).
You can use `Functors.@functor` if all fields of your kernel struct are trainable. Note that optimization algorithms
in Flux are not compatible with scalar parameters (yet), and hence vector-valued parameters should be preferred.

```julia
import Functors

struct MyKernel{T} <: KernelFunctions.Kernel
    a::Vector{T}
end

Functors.@functor MyKernel
```

If only a subset of the fields are trainable, you have to specify explicitly how to (re)construct the kernel with
modified parameter values by [implementing `Functors.functor(::Type{<:MyKernel}, x)` for your kernel struct](https://github.com/FluxML/Functors.jl/issues/3):

```julia
import Functors

struct MyKernel{T} <: KernelFunctions.Kernel
    n::Int
    a::Vector{T}
end

function Functors.functor(::Type{<:MyKernel}, x::MyKernel)
    function reconstruct_mykernel(xs)
        # keep field `n` of the original kernel and set `a` to (possibly different) `xs.a`
        return MyKernel(x.n, xs.a)
    end
    return (a = x.a,), reconstruct_mykernel
end
```
