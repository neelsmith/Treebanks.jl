### A Pluto.jl notebook ###
# v0.19.16

using Markdown
using InteractiveUtils

# ╔═╡ f292bf5e-67ac-408d-93ba-b8b7bd0998d3
using Treebanks

# ╔═╡ 6db390ee-701e-11ed-06fa-ab04b7e54531
repo = pwd() |> dirname

# ╔═╡ 78a903ef-7d4d-4e6c-9e69-01434bcfbba6
begin
	using Pkg
	Pkg.activate(repo)
	Pkg.instantiate()
	Pkg.add("Treebanks")
end

# ╔═╡ 23edaff3-8f33-4593-a864-5eb85e4ca1dd
f = joinpath(repo, "test", "data", "0540-001.xml")

# ╔═╡ b1abe0a7-ab82-4cbd-be22-e713469bb418
tb = readtreebank(f)

# ╔═╡ Cell order:
# ╠═6db390ee-701e-11ed-06fa-ab04b7e54531
# ╠═78a903ef-7d4d-4e6c-9e69-01434bcfbba6
# ╠═f292bf5e-67ac-408d-93ba-b8b7bd0998d3
# ╠═23edaff3-8f33-4593-a864-5eb85e4ca1dd
# ╠═b1abe0a7-ab82-4cbd-be22-e713469bb418
