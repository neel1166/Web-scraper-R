path <- "G3_Genes_Genomes_Genetics.txt" #path to the scraped txt file
print(path)

article <- file(path,open="r")
lines <- readLines(article)
for (i in 1:length(lines)){
  print(lines[i])
}
close(conn)
