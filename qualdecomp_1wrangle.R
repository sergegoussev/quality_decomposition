# qualdecomp_1wrangle.R

# wrangle data into the right format

# F Krsinich, Nov 2022

# 1. get data for the product of interest

product <- alldata[[j]] %>% 
  subset(select = c(period,price,volume,id)) %>%
  mutate(expenditure = price*volume) %>%
  subset(select = -c(volume)) %>%
  rename(i = id) 

# 2. get expenditure shares for each product in each quarter
# 2.1 get total expenditure for each quarter

tot_exps <- product %>%
  group_by(period) %>%
  summarise(tot_exp = sum(expenditure))

# 2.2 get expenditure share for each product i and derive log of price, for use in the TPD model

product_s_l <- merge(product, tot_exps, by = "period", all = TRUE) %>%
  mutate(exp_share = expenditure/tot_exp,
         logprice = log(price)) %>%
  subset(select = -c(tot_exp)) 

# 2.3 make period a factor so that TPD model will estimate it as a categorical variable 

product_s_l$period <- as.factor(product_s_l$period)  

