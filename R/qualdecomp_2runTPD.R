# qualdecomp_2runTPD.R

# run the TPD model for each product

# F Krsinich, November 2024

# run TPD model across full estimation window (9 quarters, in this case)

# 1. run TPD regression model

TPD_model <- lm(logprice ~ period + i, data=product_s_l, weight = exp_share) 



# 2. get fixed effects (ie parameters on product i's) across the 9 quarters for each product (these are the gammas, in Ana's formulation) 

coeff <- data.frame(TPD_model$coefficients) %>%
  rownames_to_column("row_names") %>%
  filter(substr(row_names,1,1) == "i")

coeff_prod <- data.table(coeff) %>%
  mutate(i = substr(row_names, 2, 1000000L)) %>%
  rename(gamma = TPD_model.coefficients) %>%
  subset(select = c(i, gamma)) %>%
  setkey(i)

# 2.2 get the coefficients on time (which the TPD index is derived from)

coeff_time <- data.frame(TPD_model$coefficients) %>%
  rownames_to_column("row_names") %>%
  filter(substr(row_names,1,6) == "period") %>%
  rename(date = row_names, time_coeff = TPD_model.coefficients)


#fullTPD <- coeff_time %>%
#  mutate(TPD_price_ln = ifelse(date == "period2020-09-01",time_coeff,time_coeff-lag(time_coeff)),
#         quarter1 = substring(date,7,16),
#         value = ifelse(date == "period2020-09-01", TPD_price_ln, TPD_price_ln-lag(TPD_price_ln))) %>%
#  subset(select = -date)

fullTPD <- coeff_time %>%
  mutate(TPD_price_ln = ifelse(date == "period2020-09-01",time_coeff,time_coeff-lag(time_coeff)),
         quarter1 = substring(date,7,16)) %>%
  subset(select = -date)

# 3. get all product names

all_prod <- data.table(sort(unique(product$i))) %>%
  rename(i = V1) %>%
  setkey(i)

# 4. set base product coeff to 0

base_coeff <- all_prod[!coeff_prod] %>%
  mutate(gamma = 0) 

# 5. get all coefficients

full_coeffs <- rbind(base_coeff, coeff_prod) 

# 6. add gammas back onto data

product_g <- merge(product_s_l, full_coeffs, by = "i", all = TRUE) %>%
  mutate(period = as.Date(period)) 
