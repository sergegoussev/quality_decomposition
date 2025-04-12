# qualdecomp_0wrapper.R 

# wrapper code for settting up environment and reading in consumer electronics scanner data 

# F Krsinich, Nov 2024

library(data.table)
library(tidyverse)
library(shiny)
library(plotly)

# 1. read in the cleaned scanner data for 10 consumer electronics products

setwd ("/posit/corpfs11-data/MEES/Prices/MAP/prd/GFK/2022.06/Inputs/02 Cleaned Data")

alldata <- readRDS("all_data 2022-09-01.rds")

# 2. reset the working directory

setwd ("/posit/corpfs11-data/MEES/Prices/GfK__Secure/Frances/JAF research/ESCoEPaper/code")

# 3. loop through the 10 different products

datalist0 <-  list()
for(j in names(alldata)){

 source("qualdecomp_1wrangle.R")
  
 source("qualdecomp_2runTPD.R")
  
  periods <- sort(unique(product_g$period))
  
datalist1 <- list()
for (k in (1:(length(periods)-1))){

    source("qualdecomp_3mnd.R")

    source("qualdecomp_4mmT.R")
 
    source("qualdecomp_5TPD.R")
    
    source("qualdecomp_6cewgmp.R") 
    
    source("qualdecomp_7GEKST.R")
  
    # get all the results together
    
    results <- data.frame(c(results_3mnd, results_4mmT, results_5TPD, results_6cewgmp, results_7GEKST)) %>%
      setNames("value") %>%
      rownames_to_column("variable") %>%
      mutate(quarter0 = periods[k], quarter1 = periods[k+1], product = j)
    
    datalist1[[k]] <- results
    
  }
  
  # join across all the periods

  all_results <- data.frame(do.call(rbind, datalist1)) 
  
  # 23.1 get data frames for each product j across all time periods k
  
  datalist0[[j]] <- all_results
  
}    

# 25. aggregate across all products

all_results_2 <- do.call(rbind, datalist0) 

rownames(all_results_2) <- (NULL)

# save results

save(all_results_2, file = "/posit/corpfs11-data/MEES/Prices/GfK__Secure/Frances/JAF research/ESCoEPaper/results/all_results_2_24112024.rda")
load(file = "/posit/corpfs11-data/MEES/Prices/GfK__Secure/Frances/JAF research/ESCoEPaper/results/all_results_2_24112024.rda")


write.csv(all_results_2, "../results/all_results_2.csv", row.names = FALSE)

periods <- sort(unique(all_results_2$quarter1)) 

source("qualdecomp_8prepgraph.R")

# now go to qualdecomp_9exploreresults.R to look at results