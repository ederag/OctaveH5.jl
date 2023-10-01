### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ b633e34a-5147-11ee-23fd-9fc18b7a06aa
import Pkg

# ╔═╡ 803f83a0-8d44-4850-9516-a6ba3337237f
begin
	using TestEnv
	notebook_file_project = Base.current_project()
	# until Pluto knows that TestEnv.activate should disable Pluto pkg system
	Pkg.activate(notebook_file_project);
	# TestEnv.activate(base_project)
	TestEnv.activate()
	Base.active_project()
end

# ╔═╡ 63be37e7-ffd6-4d5f-a993-a19b6f746788
using OctaveH5Reader

# ╔═╡ 29ba5050-5998-401a-977f-bfe9d49d52f9
using PlutoLinks: @use_file

# ╔═╡ 1b267920-ee1e-47fa-bffb-45912a4073ae
using Markdown

# ╔═╡ 0c3b0c1d-29ff-4ab6-aca6-8f5543d8ce53
@use_file md_file = pkgdir(OctaveH5Reader, "README.md");

# ╔═╡ 1be3d701-653d-439a-8822-f681bbd443e4
# in principle, the cell below should render the README.md,
# and be updated every time the README.md is saved to disk
# (thanks to PlutoLinks.@use_file)

# ╔═╡ 3693cf49-1a31-43fb-84d1-02368b15fb57
read(md_file, String) |> Markdown.parse

# ╔═╡ Cell order:
# ╠═b633e34a-5147-11ee-23fd-9fc18b7a06aa
# ╠═803f83a0-8d44-4850-9516-a6ba3337237f
# ╠═63be37e7-ffd6-4d5f-a993-a19b6f746788
# ╠═29ba5050-5998-401a-977f-bfe9d49d52f9
# ╠═0c3b0c1d-29ff-4ab6-aca6-8f5543d8ce53
# ╠═1b267920-ee1e-47fa-bffb-45912a4073ae
# ╠═1be3d701-653d-439a-8822-f681bbd443e4
# ╠═3693cf49-1a31-43fb-84d1-02368b15fb57
