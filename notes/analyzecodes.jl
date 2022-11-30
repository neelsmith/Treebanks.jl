f = "codelist.txt"

allcodes = readlines(f)
labels = ["part of speech", "person", "number", "tense", "mood", "voice", "gender", "case", "degree"]

for n in 1:9
    vallist = map(code -> code[n], allcodes)
    println("$(n): $(labels[n])")
    println(join(unique(vallist), "\n"))
    println("\n\n")
end