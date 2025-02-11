module OctaveH5Reader

# Take the README.md as this module docstring
@doc let
	path = pkgdir(OctaveH5Reader, "README.md")
	include_dependency(path)
	text = Base.read(path, String)
	# The code blocks in the README.md should be julia blocks for the syntax highlighter.
	replace(text, "```julia" => "```jldoctest")
end OctaveH5Reader


using HDF5
using StructArrays

export oh5_read


"""
    oh5_read(file_path::AbstractString, name::AbstractString)

Read a file written in the octave HDF5 format, located at at `file_path`,
and return the value of the variable stored as `name`.
When several names are given, return a `NamedTuple` of the corresponding values.

# Examples
```jldoctest; setup=:(using OctaveH5Reader)
julia> file_path = pkgdir(OctaveH5Reader, "test", "octave_save.hdf5");

julia> oh5_read(file_path, "float_scalar_1")
1.2

julia> fs1, cs1 = oh5_read(file_path, "float_scalar_1", "complex_scalar_1");

julia> fs1
1.2

julia> cs1
1.2 + 2.4im
```
"""
# `oh5_read` instead of just `read` to lift any ambiguity with Base.read
function oh5_read(file_path::AbstractString, name::AbstractString)
	h5open(file_path, "r") do h5
		_read_single(h5, name)
	end
end

function oh5_read(file_path::AbstractString, names::AbstractString...;
	h5_names = identity,
	nt_names = identity,
)
	# reserve oh5_read(path) for the future
	isempty(names) && throw(ArgumentError("need at least one name"))
	# The names can be used as NamedTuple keys:
	# https://docs.octave.org/latest/Variables.html
	# > The name of a variable must be a sequence of letters, digits and underscores,
	# > but it may not begin with a digit.
	h5open(file_path, "r") do h5
		NamedTuple(Symbol(nt_names(name)) => _read_single(h5, h5_names(name)) for name in names)
	end
end

function _read_single(h5::Union{HDF5.File, HDF5.Group}, name::AbstractString)
	name_group = HDF5.open_group(h5, name)
	octave_type = HDF5.read(name_group, "type")

	if octave_type == "cell"
		value_group = HDF5.open_group(name_group, "value")
		dims::Vector{Int64} = HDF5.read(value_group, "dims")
		A = [
			subvalue = _read_single(value_group, "_$(idx)")
			for idx in 0:(prod(dims) - 1)  # HDF5 stores with zero-indexing
		]
		return reshape(A, dims...)
	elseif octave_type == "struct"
		nt = _read_struct(name_group)
		return StructArray(nt)
	elseif octave_type == "scalar struct"
		return _read_struct(name_group)
	elseif octave_type in ("scalar", "matrix") || match(integer_type_regexp, octave_type) !== nothing
		return HDF5.read(name_group, "value")
	elseif octave_type == "complex scalar"
		octave_value = HDF5.read(name_group, "value")  # (:real, :imag) NamedTuple
		return Complex(octave_value...)
	elseif octave_type == "complex matrix"
		octave_value = HDF5.read(name_group, "value")  # array of (:real, :imag) NamedTuple
		return [Complex(x.real, x.imag) for x in octave_value]
	elseif octave_type == "range"
		val = HDF5.read(name_group, "value")
		return range(; start = val.base, stop = val.limit, step = val.increment)
	elseif octave_type == "string"
		raw_value = HDF5.read(name_group, "value")
		# TODO: not robust; should look at octave's format and see
		#       StringEncodings.decode
		# "air" is stored as 1×3 Matrix{Int8} by octave
		# but String wants a vector of Uint8
		converted = convert.(UInt8, vec(raw_value))
		return String(converted)
	else
		@warn "Unknown type '$octave_type' for '$name'"
		return nothing
	end
end


"""Regular expression matching known integer types."""
integer_type_regexp = r"(u)?(int(8|16|32|64) )(scalar|matrix)"


"""Return a NamedTuple from a struct stored in octave HDF5 format.
Keys are the field names of the octave struct (or struct array).
"""
function _read_struct(name_group::HDF5.Group)
	value_group = HDF5.open_group(name_group, "value")
	return NamedTuple(
		_symbol_value_pair(subgroup)
		for subgroup in value_group
	)
end

"""Return the symbol => value pair for an octave hdf5 subgroup"""
function _symbol_value_pair(subgroup::HDF5.Group)
	subname = _subgroup_basename(subgroup)
	value = _read_single(HDF5.parent(subgroup), subname)
	Symbol(subname) => value
end

"""Base name of the parent subgroup, without any parent path or '/'"""
_subgroup_basename(subgroup::HDF5.Group) = last(split(HDF5.name(subgroup), '/'))


# This would look better than OctaveH5Reader.oh5_read for people who prefer to qualify calls.
read = oh5_read

end  # module OctaveH5Reader
