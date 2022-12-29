"""Compose a markdown string linking a lexeme identified by
abbreviated URN `ref` to the corresponding article in
the Furman University on line LSJ.
$(SIGNATURES)
"""
function linkarticle(ref)
	fubaseurn = "urn:cite2:hmt:lsj.chicago_md:"
	fubaseurl = "http://folio2.furman.edu/lsj/?urn="
	parts = split(ref, ".")
	target = string(fubaseurl, fubaseurn, parts[2])
	"[$(ref)]($(target))"
end