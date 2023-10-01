using Documenter
using OctaveH5Reader
using Test

@testset "OctaveH5Reader.jl" begin
	@testset "Doctest" begin
		doctest(OctaveH5Reader)
	end
	@testset "Read" begin
		include("notebooks/base.jl")
	end
end
