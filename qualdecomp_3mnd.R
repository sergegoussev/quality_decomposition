# qual_index_3mnd.R

# Get matched, new and disappearing subsets for each pair of adjacent periods

# F Krsinich, Novemebr 2022

# 1.1 get data for each quarter separately  

all0 <- product_g %>%
  filter(period == periods[k]) %>%
  rename (t_0 = period,
          pi_0 = price,
          lpi_0 = logprice,
          ei_0 = expenditure,
          si_0 = exp_share, 
          gi = gamma)

all1 <- product_g %>%
  filter(period == periods[k+1]) %>%
  rename (t_1 = period,
          pi_1 = price,
          lpi_1 = logprice,
          ei_1 = expenditure,
          si_1 = exp_share,
          gi = gamma)

# 1.2 set keys for later matching

setkey(all0,i)
setkey(all1,i)

# 2. get subsets that are matched, new and disappearing with corresponding exp shares

matched01 <-  merge(all0, all1, by = "i") %>%
  mutate(si_01_0 = ei_0/sum(ei_0),
         si_01_1 = ei_1/sum(ei_1)) %>%
  rename(gi = gi.x) %>%
  subset(select = -gi.y)

new01 <- all1[!all0] %>%
  mutate(si_01_1 = ei_1/sum(ei_1))

disappearing01 <- all0[!all1] %>%
  mutate(si_01_0 = ei_0/sum(ei_0))

# 6. get expenditure share of set of matched, new and disappearing products in time 0 and time 1

# 6.1 get total expenditures in time 0 and time 1 

exp_0 <- tot_exps$tot_exp[k]
exp_1 <- tot_exps$tot_exp[k+1]

# 6.2 get expenditure share of set of matched products in time 0 and time 1

expshare_matched0 <- sum(matched01$ei_0)/sum(all0$ei_0)
expshare_matched1 <- sum(matched01$ei_1)/sum(all1$ei_1)

# 6.3 get expenditure share of set of disappearing products in time 0

expshare_disappearing0 <- sum(disappearing01$ei_0)/sum(all0$ei_0)

# 6.4 get expenditure share of set of new products in time 1

expshare_new1 <- sum(new01$ei_1)/sum(all1$ei_1)

# 7. combined data for saving

results_3mnd <- c(expshare_matched0,expshare_matched1,expshare_disappearing0,expshare_new1) %>%
  setNames(c("expshare_matched0","expshare_matched1","expshare_disappearing0","expshare_new1"))



