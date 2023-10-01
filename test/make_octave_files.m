# To regenerate test data saved in hdf5 format by octave,
# cd OctaveH5Reader/test
# octave make_octave_files.m

clear all

# Floating point scalar
float_scalar_1 = 1.2;
# Complex scalar
complex_scalar_1 = 1.2 + I * 2.4;
# Vectors
vector_1 = [1, 2, 3];
vector_2 = [1; 2; 3];
# Complex vectors
complex_vector_1 = [1.2 + I * 2.4, 2.3 + I * 3.5];
# Matrices
matrix_1 = reshape(1:6, 2, 3);
# cell array of strings
cell_1 = {"earth", "wind", "fire"};
# range
range_1 = 1:3:7;

# integers
# scalars
int32_scalar_1 = int32(10);
int64_scalar_1 = int64(10);
# matrices
int32_matrix_1 = ones(2, 3, "int32");

# scalar struct
struct_1 = struct();
struct_1.a = 10;
struct_1.b.c = 11;
# struct array
struct_array_1 = struct("foo", {1, 2, 3});
struct_array_2 = struct("a", {1, 2, 3}, "b", 4);
struct_array_3 = struct("c", {1, 2}, "d", struct_1);

save -hdf5 "octave_save.hdf5"
