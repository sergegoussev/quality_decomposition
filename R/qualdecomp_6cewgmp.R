# qualdecomp_6cewgmp.R

# get the change in expenditure weighted geometric mean price

# F Krsinich, November 2022

# 1. change in expenditure-share-weighted geometric mean prices 

cewgmp_ln <- log(prod(all1$pi_1^all1$si_1)/prod(all0$pi_0^all0$si_0))

# 2. data for saving 
results_6cewgmp <- c(cewgmp_ln) %>%
  setNames(c("cewgmp_ln"))
