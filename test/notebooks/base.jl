### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ f0be54c2-4a74-11ee-02b2-c7d52deb67e7
import Pkg

# ╔═╡ 214f7687-b2b4-4a1b-8b06-15209834eefc
# ╠═╡ skip_as_script = true
#=╠═╡
begin
	using TestEnv
	notebook_file_project = Base.current_project()
	# until Pluto knows that TestEnv.activate should disable Pluto pkg system
	Pkg.activate(notebook_file_project);
	# TestEnv.activate(base_project)
	TestEnv.activate()
	Base.active_project()
end
  ╠═╡ =#

# ╔═╡ 4711c6b7-d465-4377-965d-53fd64b3e6ae
using PlutoLinks

# ╔═╡ b4ebd2e6-66c9-4118-802a-4e77347d91e0
using PlutoTest

# ╔═╡ c64c4f0b-91b2-4c5a-a622-0662bb600d82
using StructArrays

# ╔═╡ 705b4a98-7cf9-491a-8e69-f206a8b3ef87
PlutoLinks.@revise using OctaveH5Reader

# ╔═╡ b3d925e4-364f-4a57-afa1-913d11e5ba61
file_path = pkgdir(OctaveH5Reader, "test", "octave_save.hdf5")

# ╔═╡ 70ce5b29-3be5-4cd5-ac52-0974d52c8266
PlutoTest.@test_throws ArgumentError oh5_read(file_path)

# ╔═╡ a1558566-2a96-4da9-837c-5650269961ae
md"""
##### Floating point scalar
"""

# ╔═╡ 3fcdd6cc-9bf3-44a9-a49c-f2503209c0cc
float_scalar_1 = oh5_read(file_path, "float_scalar_1")

# ╔═╡ 1841402b-9844-414a-a318-bba0e35dac1e
PlutoTest.@test float_scalar_1 === 1.2

# ╔═╡ 3416c610-c6b7-4959-8565-c386a9d41c4d
md"""
##### Complex scalar
"""

# ╔═╡ 3c1b2914-57b8-47b0-871c-161f8987ba4d
 complex_scalar_1 = oh5_read(file_path, "complex_scalar_1")

# ╔═╡ 8d666b69-7a94-41d8-94a6-bce0a020f864
PlutoTest.@test complex_scalar_1 === 1.2 + 2.4im

# ╔═╡ 5af591a9-92d6-4ef7-b0cc-beac268c1bfa
md"""
#### Arrays
"""

# ╔═╡ cc312222-4734-48b5-a55f-8cea1a4b8351
md"""
##### Vectors

Note: octave stores all vectors as matrices,
there is no way of knowing the intent (e.g. "list" or "row vector" ?).
The user has to do conversion to the right type (e.g. with `vec`)
"""

# ╔═╡ c60cb02b-6551-448e-ab2c-6edbeaa79068
vector_1 = oh5_read(file_path, "vector_1")

# ╔═╡ 9971b707-8cb4-44ef-a906-61be8a678309
PlutoTest.@test vector_1 == reshape([1.0, 2.0, 3.0], 1, 3)

# ╔═╡ 88363f2f-060a-4c7d-81c8-ca6271ef3edb
PlutoTest.@test typeof(vector_1) == Matrix{Float64}

# ╔═╡ 1b5aa936-1010-4f17-a873-99511d5f19ed
vector_2 = oh5_read(file_path, "vector_2")

# ╔═╡ 95b74870-5642-49bf-bed9-3ce89e6d7068
PlutoTest.@test vector_2 == reshape([1.0, 2.0, 3.0], 3, 1)

# ╔═╡ 29d07eca-5d9f-496c-a196-848b35074e73
PlutoTest.@test isconcretetype(eltype(vector_2))

# ╔═╡ 4beffb8a-9ce0-435f-9d28-ee40d0c31665
complex_vector_1 = oh5_read(file_path, "complex_vector_1")

# ╔═╡ 5e5a0326-14f6-48d9-a533-9df78d632e65
PlutoTest.@test typeof(complex_vector_1) == Matrix{ComplexF64}

# ╔═╡ d53f7628-e9e3-4de0-ae1d-421d7d05361c
PlutoTest.@test complex_vector_1 == [1.2+2.4im 2.3+3.5im]

# ╔═╡ 3db925f9-0990-4d11-9ece-a84b194a0875
md"""
##### Matrix
"""

# ╔═╡ 0775c61b-60b7-4523-8658-07cc8b9a9b71
matrix_1 = oh5_read(file_path, "matrix_1")

# ╔═╡ b053cb5d-43fb-4c32-a67c-0bf0ff1f422b
PlutoTest.@test matrix_1 == reshape(1:6, 2, 3)

# ╔═╡ 9bf0a6a4-a637-487b-ac18-438d21eda905
PlutoTest.@test typeof(matrix_1) == Matrix{Float64}

# ╔═╡ 0d3a06ef-1aba-4d54-a2ee-3a87322198e2
md"""
##### Cell array
"""

# ╔═╡ 8dcd269b-ca02-4dea-86fb-4a2ae97550dd
cell_1 = oh5_read(file_path, "cell_1")

# ╔═╡ d35fd6fd-bda8-4af0-9496-34e3c6023aa2
PlutoTest.@test isconcretetype(typeof(cell_1))

# ╔═╡ fde4aad5-a5ce-4bd5-ace8-dca61eef1f9c
PlutoTest.@test cell_1 == reshape(["earth", "wind", "fire"], 3, 1)

# ╔═╡ 1620b514-8f57-4f8b-8a91-9d2c41e6d4fd
md"""
#### Range
"""

# ╔═╡ 120cb988-5a33-4cde-8383-5bfb21343c8a
range_1 = oh5_read(file_path, "range_1")

# ╔═╡ 27c2da30-00d1-48ab-bbb2-4e3bbf0e7850
PlutoTest.@test range_1 === 1.0:3.0:7.0

# ╔═╡ 1d61e9b8-c1ad-4fee-963e-575efc1ec5ea
md"""
#### Integers
"""

# ╔═╡ 7ee63e15-5575-4af6-a86b-a6b1d932de5d
int32_scalar_1 = oh5_read(file_path, "int32_scalar_1")

# ╔═╡ 48a1da8c-0b96-4b1b-8051-49553efd2374
PlutoTest.@test int32_scalar_1 === Int32(10)

# ╔═╡ a74aece6-c6e6-4928-a5c1-82ec06d380b2
int64_scalar_1 = oh5_read(file_path, "int64_scalar_1")

# ╔═╡ 5ca37e80-0e59-4ce7-b78e-2ccfc7f224fd
PlutoTest.@test int64_scalar_1 === Int64(10)

# ╔═╡ 1d5fbad3-db65-40d2-9194-33ef03c5a68c
match_int64_scalar = match(OctaveH5Reader.integer_type_regexp, "int64 scalar")

# ╔═╡ 167f3f25-538b-48a2-8870-0e9071ddde6c
PlutoTest.@test !isnothing(match_int64_scalar)

# ╔═╡ d0c29241-f2c9-41f4-92bd-73a6cbc75284
int32_matrix_1 = oh5_read(file_path, "int32_matrix_1")

# ╔═╡ e9dc8ad9-4a77-4329-b9f1-b446ed2553fd
PlutoTest.@test int32_matrix_1 == ones(2, 3)

# ╔═╡ 82fc18aa-c6ff-4bdc-813b-d2bebb89d250
PlutoTest.@test eltype(int32_matrix_1) == Int32

# ╔═╡ eb930eee-01c4-4195-8275-1fbe8f96c8e3
md"""
#### Structures
"""

# ╔═╡ 95cc557d-95aa-4dba-b003-d8926933d84a
md"""
##### scalar struct
"""

# ╔═╡ 3bc2d2a2-615c-42e0-87ed-1a71f2526b07
struct_1 = oh5_read(file_path, "struct_1")

# ╔═╡ 34a50170-b0d2-4deb-b0f2-9994e97ad5e2
PlutoTest.@test keys(struct_1) == (:a, :b)

# ╔═╡ 6db609ba-e4f3-462b-be38-c557a0702e69
PlutoTest.@test struct_1.a === 10.0

# ╔═╡ 36503abe-6563-447f-96c5-0042f02a0693
PlutoTest.@test struct_1.b === (; c = 11.0)

# ╔═╡ 74896d2f-ad16-40aa-a9de-fe18cd27d20d
md"""
##### struct arrays
"""

# ╔═╡ 7234456f-2508-4175-8e83-91b02dd97161
struct_array_1 = oh5_read(file_path, "struct_array_1")

# ╔═╡ 7313607a-dcca-4e85-b5dd-8ac30d4d6948
PlutoTest.@test eltype(struct_array_1) == NamedTuple{(:foo,), Tuple{Float64}}

# ╔═╡ 0079ecb3-0018-4a16-858c-8f4798529834
PlutoTest.@test size(struct_array_1.foo) == (3, 1)

# ╔═╡ 9eff2090-8dff-44b3-b677-cb4d35b295e1
PlutoTest.@test vec(struct_array_1.foo) == 1:3

# ╔═╡ c1496b0c-8e57-404e-86cd-5751be8a6f25
struct_array_2 = oh5_read(file_path, "struct_array_2")

# ╔═╡ 4229c583-6183-41c1-a4c5-9db79f6bd073
PlutoTest.@test size(struct_array_2.a) == size(struct_array_2.b)

# ╔═╡ 1ba1e55c-979b-414b-ba3a-71454efefc97
PlutoTest.@test vec(struct_array_2.a) == 1:3

# ╔═╡ 44434bab-a5bc-40b6-8cb4-3297c06efbd4
PlutoTest.@test vec(struct_array_2.b) == [4, 4, 4]

# ╔═╡ c0afc09b-dc93-4c6d-99c3-914c5b5a8fad
struct_array_3 = oh5_read(file_path, "struct_array_3")

# ╔═╡ 3bfc37f5-57d7-4b88-99ac-4a7e72aa3670
PlutoTest.@test size(struct_array_3.d) == (2, 1)

# ╔═╡ 95b8e083-f08d-43d2-920e-57151a676339
PlutoTest.@test all(==(struct_1), struct_array_3.d)

# ╔═╡ 9d3a75a2-9919-40ce-b0c8-401ec3935ab7
md"""
#### Batch requests
"""

# ╔═╡ 4bebb10d-ce88-4519-bcb4-8c4f889bb220
mult_res = oh5_read(
	file_path,
	"float_scalar_1", "complex_scalar_1"
)

# ╔═╡ 7b3a6626-9695-473f-884a-5c6ad6f41385
PlutoTest.@test typeof(mult_res) == NamedTuple{
	(:float_scalar_1, :complex_scalar_1),
	Tuple{Float64, ComplexF64}
}

# ╔═╡ 07fd3a29-07ef-43d0-88b5-73264d6ccf54
PlutoTest.@test mult_res.float_scalar_1 === float_scalar_1

# ╔═╡ af941c85-21b3-4b5e-9a5c-8d0c4689c1c3
mult_float_scalar_1, mult_complex_scalar_1 = mult_res

# ╔═╡ 29637f1f-4095-457e-812e-0645bd381af2
PlutoTest.@test mult_float_scalar_1 === float_scalar_1

# ╔═╡ eb58b7de-d8d3-4796-8f5a-9e8c2473f17a
PlutoTest.@test mult_complex_scalar_1 === complex_scalar_1

# ╔═╡ 716f0ec8-5fe2-404b-a36d-7801934a6802
md"""
##### Name manipulations
"""

# ╔═╡ 30fa0fc1-2e88-4e29-b879-8a3bb053b7bc
mult_res_2 = oh5_read(
	file_path,
	"float", "complex";
	h5_names = name -> string(name, "_scalar_1")
)

# ╔═╡ 34c66955-5504-41a9-ae5b-1a55ec377a79
PlutoTest.@test mult_res_2 == (; float = 1.2, complex = 1.2 + 2.4im)

# ╔═╡ ebe396ae-e061-45ce-911d-70dd2898d03d
mult_res_3 = oh5_read(
	file_path,
	"float_scalar_1", "complex_scalar_1";
	nt_names = name -> replace(name, "_scalar_1" => "_nt")
)

# ╔═╡ de1b64cd-db24-47be-9686-67882a99e3d3
PlutoTest.@test mult_res_3 == (; float_nt = 1.2, complex_nt = 1.2 + 2.4im)

# ╔═╡ 98c1ed5c-b5b6-4372-bd2c-e7224a8cfe50
mult_res_4 = oh5_read(
	file_path,
	"float", "complex";
	h5_names = name -> string(name, "_scalar_1"),
	nt_names = name -> string(name, "_nt2")
)

# ╔═╡ 268a046f-6447-404b-8064-a433c78eea4f
PlutoTest.@test mult_res_4 == (; float_nt2 = 1.2, complex_nt2 = 1.2 + 2.4im)

# ╔═╡ Cell order:
# ╠═f0be54c2-4a74-11ee-02b2-c7d52deb67e7
# ╠═214f7687-b2b4-4a1b-8b06-15209834eefc
# ╠═4711c6b7-d465-4377-965d-53fd64b3e6ae
# ╠═b4ebd2e6-66c9-4118-802a-4e77347d91e0
# ╠═c64c4f0b-91b2-4c5a-a622-0662bb600d82
# ╠═705b4a98-7cf9-491a-8e69-f206a8b3ef87
# ╠═b3d925e4-364f-4a57-afa1-913d11e5ba61
# ╠═70ce5b29-3be5-4cd5-ac52-0974d52c8266
# ╠═a1558566-2a96-4da9-837c-5650269961ae
# ╠═3fcdd6cc-9bf3-44a9-a49c-f2503209c0cc
# ╠═1841402b-9844-414a-a318-bba0e35dac1e
# ╟─3416c610-c6b7-4959-8565-c386a9d41c4d
# ╠═3c1b2914-57b8-47b0-871c-161f8987ba4d
# ╠═8d666b69-7a94-41d8-94a6-bce0a020f864
# ╟─5af591a9-92d6-4ef7-b0cc-beac268c1bfa
# ╠═cc312222-4734-48b5-a55f-8cea1a4b8351
# ╠═c60cb02b-6551-448e-ab2c-6edbeaa79068
# ╠═9971b707-8cb4-44ef-a906-61be8a678309
# ╠═88363f2f-060a-4c7d-81c8-ca6271ef3edb
# ╠═1b5aa936-1010-4f17-a873-99511d5f19ed
# ╠═95b74870-5642-49bf-bed9-3ce89e6d7068
# ╠═29d07eca-5d9f-496c-a196-848b35074e73
# ╠═4beffb8a-9ce0-435f-9d28-ee40d0c31665
# ╠═d53f7628-e9e3-4de0-ae1d-421d7d05361c
# ╠═5e5a0326-14f6-48d9-a533-9df78d632e65
# ╠═3db925f9-0990-4d11-9ece-a84b194a0875
# ╠═0775c61b-60b7-4523-8658-07cc8b9a9b71
# ╠═b053cb5d-43fb-4c32-a67c-0bf0ff1f422b
# ╠═9bf0a6a4-a637-487b-ac18-438d21eda905
# ╟─0d3a06ef-1aba-4d54-a2ee-3a87322198e2
# ╠═8dcd269b-ca02-4dea-86fb-4a2ae97550dd
# ╠═d35fd6fd-bda8-4af0-9496-34e3c6023aa2
# ╠═fde4aad5-a5ce-4bd5-ace8-dca61eef1f9c
# ╟─1620b514-8f57-4f8b-8a91-9d2c41e6d4fd
# ╠═120cb988-5a33-4cde-8383-5bfb21343c8a
# ╠═27c2da30-00d1-48ab-bbb2-4e3bbf0e7850
# ╟─1d61e9b8-c1ad-4fee-963e-575efc1ec5ea
# ╠═7ee63e15-5575-4af6-a86b-a6b1d932de5d
# ╠═48a1da8c-0b96-4b1b-8051-49553efd2374
# ╠═a74aece6-c6e6-4928-a5c1-82ec06d380b2
# ╠═5ca37e80-0e59-4ce7-b78e-2ccfc7f224fd
# ╠═1d5fbad3-db65-40d2-9194-33ef03c5a68c
# ╠═167f3f25-538b-48a2-8870-0e9071ddde6c
# ╠═d0c29241-f2c9-41f4-92bd-73a6cbc75284
# ╠═e9dc8ad9-4a77-4329-b9f1-b446ed2553fd
# ╠═82fc18aa-c6ff-4bdc-813b-d2bebb89d250
# ╟─eb930eee-01c4-4195-8275-1fbe8f96c8e3
# ╟─95cc557d-95aa-4dba-b003-d8926933d84a
# ╠═3bc2d2a2-615c-42e0-87ed-1a71f2526b07
# ╠═34a50170-b0d2-4deb-b0f2-9994e97ad5e2
# ╠═6db609ba-e4f3-462b-be38-c557a0702e69
# ╠═36503abe-6563-447f-96c5-0042f02a0693
# ╠═74896d2f-ad16-40aa-a9de-fe18cd27d20d
# ╠═7234456f-2508-4175-8e83-91b02dd97161
# ╠═7313607a-dcca-4e85-b5dd-8ac30d4d6948
# ╠═0079ecb3-0018-4a16-858c-8f4798529834
# ╠═9eff2090-8dff-44b3-b677-cb4d35b295e1
# ╠═c1496b0c-8e57-404e-86cd-5751be8a6f25
# ╠═4229c583-6183-41c1-a4c5-9db79f6bd073
# ╠═1ba1e55c-979b-414b-ba3a-71454efefc97
# ╠═44434bab-a5bc-40b6-8cb4-3297c06efbd4
# ╠═c0afc09b-dc93-4c6d-99c3-914c5b5a8fad
# ╠═3bfc37f5-57d7-4b88-99ac-4a7e72aa3670
# ╠═95b8e083-f08d-43d2-920e-57151a676339
# ╟─9d3a75a2-9919-40ce-b0c8-401ec3935ab7
# ╠═4bebb10d-ce88-4519-bcb4-8c4f889bb220
# ╠═7b3a6626-9695-473f-884a-5c6ad6f41385
# ╠═07fd3a29-07ef-43d0-88b5-73264d6ccf54
# ╠═af941c85-21b3-4b5e-9a5c-8d0c4689c1c3
# ╠═29637f1f-4095-457e-812e-0645bd381af2
# ╠═eb58b7de-d8d3-4796-8f5a-9e8c2473f17a
# ╠═716f0ec8-5fe2-404b-a36d-7801934a6802
# ╠═30fa0fc1-2e88-4e29-b879-8a3bb053b7bc
# ╠═34c66955-5504-41a9-ae5b-1a55ec377a79
# ╠═ebe396ae-e061-45ce-911d-70dd2898d03d
# ╠═de1b64cd-db24-47be-9686-67882a99e3d3
# ╠═98c1ed5c-b5b6-4372-bd2c-e7224a8cfe50
# ╠═268a046f-6447-404b-8064-a433c78eea4f
