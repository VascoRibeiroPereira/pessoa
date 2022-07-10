library(tidyverse)
library(httr)
library(pdftools)


myStatus = integer()

for (i in 1:5000) {
        
        tmp = paste0(
          "http://arquivopessoa.net/typographia/textos/arquivopessoa-",i,".pdf")
        myStatus = c(myStatus, GET(tmp)$status_code)
        
        Sys.sleep(.5)
        
}

obras = tibble(url_id = 1:5000, status = myStatus)

## 503 stands for service unavailable, I double checked it
second_iteration = obras %>% filter(status == 503) 


myStatus2 = integer()

for (i in second_iteration$url_id) {
        
        tmp = paste0(
          "http://arquivopessoa.net/typographia/textos/arquivopessoa-",i,".pdf")
        myStatus2 = c(myStatus2, GET(tmp)$status_code)
        
        Sys.sleep(1)
        
}

obras_second = tibble(url_id = second_iteration$url_id, status = myStatus2)

## getting all status 200 (OK) to download automatically next
obras_completas = bind_rows(obras %>% filter(status == 200), 
                            obras_second %>% filter(status == 200)) %>% 
        arrange(url_id) 



pdf_texts = list() ## recursive download and read the pdf files into a list
for (i in obras_completas$url_id) {
        
        download.file(
          paste0(
            "http://arquivopessoa.net/typographia/textos/arquivopessoa-",
            i,
            ".pdf"), 
                      destfile = "sample.pdf", mode = "wb")
        pdf_texts[[i]] <- pdftools::pdf_text("sample.pdf")
        unlink("sample.pdf")
        Sys.sleep(1)
}

## save the complete list as RData for space econ
saveRDS(pdf_texts, file="rawData.RData") 

