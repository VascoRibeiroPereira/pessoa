library(dplyr)

raw_data = readRDS("rawData.RData")

words = c("destino", "Destino", "fado", "Fado")

full_vect = integer()
for (i in words) {
        
        tmp_vect = grep(i, raw_data)
        full_vect = c(tmp_vect, full_vect)
        
}

full_vect = full_vect %>% unique()
final_subset = raw_data[full_vect] %>% unlist


writeLines(final_subset, "text.txt")
