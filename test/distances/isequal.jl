@testset "isequal" begin

    s1 = 1.0
    s3 = 2.0

    @testset "Euclidean (unDistances.Weighted)" begin
        m1 = Euclidean(s1)
        m2 = Euclidean(s1)
        m3 = Euclidean(s3)

        @test KernelFunctions.metric_isequal(m1, m2)
        @test !KernelFunctions.metric_isequal(m1, m3)
        @test KernelFunctions.metric_hash(m1) == KernelFunctions.metric_hash(m2)
        @test KernelFunctions.metric_hash(m1) !== KernelFunctions.metric_hash(m3)
    end

    w1 = [1.0]
    w3 = [2.0]

    @testset "Distances.WeightedEuclidean" begin
        m1 = Distances.WeightedEuclidean(w1)
        m2 = Distances.WeightedEuclidean(w1)
        m3 = Distances.WeightedEuclidean(w3)

        @test KernelFunctions.KernelFunctions.metric_isequal(m1, m2)
        @test !KernelFunctions.metric_isequal(m1, m3)
        @test KernelFunctions.metric_hash(m1) == KernelFunctions.metric_hash(m2)
        @test KernelFunctions.metric_hash(m1) !== KernelFunctions.metric_hash(m3)
    end

    @testset "Distances.PeriodicEuclidean" begin
        m1 = Distances.PeriodicEuclidean(w1)
        m2 = Distances.PeriodicEuclidean(w1)
        m3 = Distances.PeriodicEuclidean(w3)

        @test KernelFunctions.metric_isequal(m1, m2)
        @test !KernelFunctions.metric_isequal(m1, m3)
        @test KernelFunctions.metric_hash(m1) == KernelFunctions.metric_hash(m2)
        @test KernelFunctions.metric_hash(m1) !== KernelFunctions.metric_hash(m3)
    end

    @testset "Distances.WeightedSqEuclidean" begin
        m1 = Distances.WeightedSqEuclidean(w1)
        m2 = Distances.WeightedSqEuclidean(w1)
        m3 = Distances.WeightedSqEuclidean(w3)

        @test KernelFunctions.metric_isequal(m1, m2)
        @test !KernelFunctions.metric_isequal(m1, m3)
        @test KernelFunctions.metric_hash(m1) == KernelFunctions.metric_hash(m2)
        @test KernelFunctions.metric_hash(m1) !== KernelFunctions.metric_hash(m3)
    end

    @testset "Distances.WeightedCityBlock" begin
        m1 = Distances.WeightedCityBlock(w1)
        m2 = Distances.WeightedCityBlock(w1)
        m3 = Distances.WeightedCityBlock(w3)

        @test KernelFunctions.metric_isequal(m1, m2)
        @test !KernelFunctions.metric_isequal(m1, m3)
        @test KernelFunctions.metric_hash(m1) == KernelFunctions.metric_hash(m2)
        @test KernelFunctions.metric_hash(m1) !== KernelFunctions.metric_hash(m3)
    end

    @testset "Distances.WeightedMinkowski" begin
        m1 = Distances.WeightedCityBlock(w1, 1)
        m2 = Distances.WeightedCityBlock(w1, 1)
        m3 = Distances.WeightedCityBlock(w3, 1)
        m4 = Distances.WeightedCityBlock(w3, 2)

        @test KernelFunctions.metric_isequal(m1, m2)
        @test !KernelFunctions.metric_isequal(m1, m3)
        @test KernelFunctions.metric_hash(m1) == KernelFunctions.metric_hash(m2)
        @test KernelFunctions.metric_hash(m1) !== KernelFunctions.metric_hash(m3)

        @test !KernelFunctions.metric_isequal(m3, m4)
        @test KernelFunctions.metric_hash(m3) !== KernelFunctions.metric_hash(m4)
    end

    @testset "Distances.WeightedHamming" begin
        m1 = Distances.WeightedHamming(w1)
        m2 = Distances.WeightedHamming(w1)
        m3 = Distances.WeightedHamming(w3)

        @test KernelFunctions.metric_isequal(m1, m2)
        @test !KernelFunctions.metric_isequal(m1, m3)
        @test KernelFunctions.metric_hash(m1) == KernelFunctions.metric_hash(m2)
        @test KernelFunctions.metric_hash(m1) !== KernelFunctions.metric_hash(m3)
    end
end
