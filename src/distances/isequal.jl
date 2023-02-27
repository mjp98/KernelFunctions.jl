# Define custom `isequal` and `hash` for weighted metrics
# https://github.com/JuliaStats/Distances.jl/issues/247

metric_isequal(m1, m2) = isequal(m1, m2)
metric_hash(m, h::UInt) = hash(m, h)

function metric_isequal(m1::WeightedEuclidean, m2::WeightedEuclidean)
    return isequal(m1.weights, m2.weights)
end

metric_hash(m::WeightedEuclidean, h::UInt) = hash(m.weights, hash(nameof(typeof(m)), h))

function metric_isequal(m1::PeriodicEuclidean, m2::PeriodicEuclidean)
    return isequal(m1.periods, m2.periods)
end

metric_hash(m::PeriodicEuclidean, h::UInt) = hash(m.periods, hash(nameof(typeof(m)), h))

function metric_isequal(m1::WeightedSqEuclidean, m2::WeightedSqEuclidean)
    return isequal(m1.weights, m2.weights)
end

metric_hash(m::WeightedSqEuclidean, h::UInt) = hash(m.weights, hash(nameof(typeof(m)), h))

function metric_isequal(m1::WeightedCityblock, m2::WeightedCityblock)
    return isequal(m1.weights, m2.weights)
end

metric_hash(m::WeightedCityblock, h::UInt) = hash(m.weights, hash(nameof(typeof(m)), h))

function metric_isequal(m1::WeightedMinkowski, m2::WeightedMinkowski)
    return isequal(m1.weights, m2.weights) && isequal(m1.p, m2.p)
end

function metric_hash(m::WeightedMinkowski, h::UInt)
    return hash(m.p, hash(m.weights, hash(nameof(typeof(m)), h)))
end

metric_isequal(m1::WeightedHamming, m2::WeightedHamming) = isequal(m1.weights, m2.weights)
metric_hash(m::WeightedMinkowski, h::UInt) = hash(m.weights, hash(nameof(typeof(m)), h))
