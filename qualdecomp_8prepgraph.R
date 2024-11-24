# qualdecomp_8prepgraph.R

# wrangle data into right form for graphing within shinyapp

# F Krsinich, April 2023

# 1. add more variables to help with graphing

graphdata_exp <- all_results_2 %>%
  filter(substr(variable,1,3) == "exp")

graphdata_results <- all_results_2 %>%
  filter(substr(variable,1,3) %in% c("MMT","TPD","GEK")) %>%
  mutate(method = ifelse(substr(variable,1,5) == "GEKST","GEKST",ifelse(substr(variable,1,4) == "MMTi","MMTi",substr(variable,1,3))),
         term = ifelse(variable %in% c("GEKST_comp_ln","MMT_comp_ln","MMTi_comp_ln","TPD_comp_ln"),"comp",
                       ifelse(variable %in% c("GEKST_entry_ln","MMT_entry_ln","MMTi_entry_ln","TPD_entry_ln"), "entry",
                                              ifelse(variable %in% c("GEKST_exit_ln","MMT_exit_ln","MMTi_exit_ln","TPD_exit_ln"), "exit",
                                                                     ifelse(variable %in% c("GEKST_price_ln","MMT_price_ln","MMTi_price_ln","TPD_price_ln"), "price", "quality")))))

graphdata_unitvalue <- all_results_2 %>%
  filter(variable == "cewgmp_ln") %>%
  mutate(term = "cewgmp_ln")

methods <- sort(unique(graphdata_results$method))
products <- sort(unique(graphdata_results$product))
terms <- sort(unique(graphdata_results$term))

# 2. derive indexes (code below ends up with NA values, even though it seems to work
# OK for graphing, need to fix it up)

## 2.1 indexes associated with the multialteral methods
# set it up generally across products and methods and terms

graphdata_results_index <- graphdata_results %>%
  arrange(product, method, term, quarter1) %>%
  subset(select = -quarter0) %>%
  rename(quarter = quarter1)

graphdata_results_index_base <- graphdata_results_index %>%
  distinct(variable, product, method, term) %>%
  mutate(quarter = as.Date("2020-06-01"), value = 0)

indexes <- rbind(graphdata_results_index, graphdata_results_index_base) %>%
  arrange(product, method, term, quarter) %>%
  group_by(product, method, term) %>%
  mutate(index = cumsum(value))

## 2.2 index from un-quality adjusted prices (ie the CEWGMP)

graphdata_unitvalue_index <- graphdata_unitvalue %>%
  arrange(product, quarter1) %>%
  subset(select = -quarter0) %>%
  rename(quarter = quarter1)

graphdata_unitvalue_index_base <- graphdata_unitvalue_index %>%
  distinct(variable, product, term) %>%
  mutate(quarter = as.Date("2020-06-01"), value = 0)

uv_indexes <- rbind(graphdata_unitvalue_index, graphdata_unitvalue_index_base) %>%
  arrange(product, quarter) %>%
  group_by(product) %>%
  mutate(index = cumsum(value))

# now go to DAFqual_index_9exploreresults.R to explore


