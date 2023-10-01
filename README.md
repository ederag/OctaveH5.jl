# OctaveH5Reader

[![Build Status](https://github.com/ederag/OctaveH5Reader.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/ederag/OctaveH5Reader.jl/actions/workflows/CI.yml?query=branch%3Amaster)

Return values stored in a file saved by [octave](https://octave.org/)
in the hdf5 format (e.g. with `save -hdf5`).

```julia
using OctaveH5Reader

# replace with your file path (this is just a file used for testing purposes)
file_path = pkgdir(OctaveH5Reader, "test", "octave_save.hdf5")

# "complex_scalar_1" is the name of a variable that is stored in this file
var_name = "complex_scalar_1"

oh5_read(file_path, var_name)

# output

1.2 + 2.4im
```
