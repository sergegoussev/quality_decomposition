# qualdecomp_5TPD.R

# Run the TPD decomposition (see p 2 Ana's 17/11 decomposition)

# F Krsinich, November 2022

# 1. TPD decomposition

TPD_price_ln <- fullTPD$TPD_price_ln[k]

TPD_entry_ln <- sum(all1$si_1*all1$gi) - sum(matched01$si_1*matched01$gi) 

TPD_exit_ln <- sum(all0$si_0*all0$gi) - sum(matched01$si_0*matched01$gi)

TPD_comp_ln <- sum((matched01$si_1 - matched01$si_0)*matched01$gi)

TPD_quality_ln <- TPD_comp_ln + TPD_entry_ln - TPD_exit_ln 

# 2. data for saving

results_5TPD <- c(TPD_price_ln, TPD_entry_ln, TPD_exit_ln, TPD_comp_ln, TPD_quality_ln) %>%
  setNames(c("TPD_price_ln", "TPD_entry_ln", "TPD_exit_ln", "TPD_comp_ln", "TPD_quality_ln"))
