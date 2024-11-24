# qualdecomp_4mmT.R

# run the matched-model Tornqvist decomposition (see p2 Ana's 17/11 decomposition)

# F Krsinich, November 2022

# 1. matched-model Tornqvist price index (see p2 Ana's 17/11 decomposition)

MMT_price_ln <- sum((matched01$si_01_0 + matched01$si_01_1)/2*(matched01$lpi_1 - matched01$lpi_0))

MMT_comp_ln <- sum((matched01$si_01_1 - matched01$si_01_0)*(matched01$lpi_1 + matched01$lpi_0)/2)

MMT_entry_ln <- sum(all1$si_1*all1$lpi_1) - sum(matched01$si_01_1*matched01$lpi_1)

MMT_exit_ln <- sum(all0$si_0*all0$lpi_0) - sum(matched01$si_01_0*matched01$lpi_0)

MMT_quality_ln <- MMT_comp_ln + MMT_entry_ln -MMT_exit_ln

#2. data for saving

results_4mmT <- c(MMT_price_ln, MMT_comp_ln, MMT_entry_ln, MMT_exit_ln, MMT_quality_ln) %>%
  setNames(c("MMT_price_ln", "MMT_comp_ln", "MMT_entry_ln", "MMT_exit_ln", "MMT_quality_ln"))
