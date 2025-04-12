# qualdecomp_9exploreresults.R

# graphs for UNSW-ESCoE paper and presentstion

# Nov 2024

# 1. price indexes (Appendix A1.1)

sub <- indexes %>%
  filter(term == "price")

ggplot(sub, aes(quarter, index, colour = variable))+
  geom_line()+
  facet_wrap(~product, nrow = 2) +  
  theme(legend.position = "bottom")

# 2.  quality indexes (Appendix A1.2)

sub <- indexes %>%
  filter(term == "quality")

ggplot(sub, aes(quarter, index, colour = variable))+
  geom_line()+
  facet_wrap(~product, nrow = 2) +
  theme(legend.position = "bottom")

# 3. entry indexes (Appendix A1.3)

sub <- indexes %>%
  filter(term == "entry")

ggplot(sub, aes(quarter, index, colour = variable))+
  geom_line()+
  facet_wrap(~product, nrow = 2) +
  theme(legend.position = "bottom")

# 4. exit indexes (Appendix A1.4)

sub <- indexes %>%
  filter(term == "exit")

ggplot(sub, aes(quarter, index, colour = variable))+
  geom_line()+
  facet_wrap(~product, nrow = 2) +
  theme(legend.position = "bottom")


# 5. composition indexes (Appendix A1.5)

sub <- indexes %>%
  filter(term == "comp")

ggplot(sub, aes(quarter, index, colour = variable))+
  geom_line()+
  facet_wrap(~product, nrow = 2) +
  theme(legend.position = "bottom")

# 6. decomposition for each method

# 6.1 MMT decompositions (Appendix A1.6)

sub <- indexes %>%
  filter(method == "MMT")

ggplot(sub, aes(quarter, index, colour = variable))+
  geom_line()+
  facet_wrap(~product, nrow = 2) +
  theme(legend.position = "bottom")

# 6.2 GEKST decompositions (Appendix A1.7)

sub <- indexes %>%
  filter(method == "GEKST")

ggplot(sub, aes(quarter, index, colour = variable))+
  geom_line()+
  facet_wrap(~product, nrow = 2) +
  theme(legend.position = "bottom")

# 6.3 TPD decompositions (Appendix A1.8)

sub <- indexes %>%
  filter(method == "TPD")

ggplot(sub, aes(quarter, index, colour = variable))+
  geom_line()+
  facet_wrap(~product, nrow = 2) +
  theme(legend.position = "bottom")

# 7. subset to three products with different results across methods: desktops, mfdprinters and TVs.
# and get quality indexes (figure 1.)

sub_3products <- indexes %>%
  filter(product %in% c("desktop", "mfdprinters", "tv"))

sub <- sub_3products %>%
  filter(term == "quality")

ggplot(sub, aes(quarter, index, colour = variable))+
  geom_line()+
  facet_wrap(~product, nrow = 1) +
  theme(legend.position = "bottom")



# 8. scatter plots of the quarterly change (across all terms and products)

# 8.1 transform data - get different indexes on different columns (short fat data)

sub_MMT <- indexes %>%
  filter(method == "MMT") %>%
  subset(select = c(value, quarter, product, term)) %>%
  rename(MMT = value)

sub_GEKST <- indexes %>%
  filter(method == "GEKST") %>%
  subset(select = c(value, quarter, product, term)) %>%
  rename(GEKST = value)

sub_TPD <- indexes %>%
  filter(method == "TPD") %>%
  subset(select = c(value, quarter, product, term)) %>%
  rename(TPD = value)

all1 <- merge(sub_MMT, sub_GEKST, by = c("quarter", "product", "term"))
all <- merge(all1, sub_TPD, by = c("quarter", "product", "term"))

#  8.2 get range across all so all plots can be put on the same scale

max_range <- range(c(all$MMT, all$GEKST, all$TPD), na.rm = TRUE)

#  8.3 scatter plots comparing terms across each pair of methods (Appendix A1.9)

# 8.3.1 GEKST vs MMT

ggplot(all, aes(MMT, GEKST, colour = product))+
  geom_point()+
  facet_wrap(~term, nrow = 1) +
  theme(legend.position = "bottom")+
  ggtitle("GEKST vs MMT") +
  scale_x_continuous(limits = max_range) +
  scale_y_continuous(limits = max_range)

# 8.3.2 TPD vs MMT

ggplot(all, aes(MMT, TPD, colour = product))+
  geom_point()+
  facet_wrap(~term, nrow = 1) +
  theme(legend.position = "bottom")+
  ggtitle("TPD vs MMT") +
  scale_x_continuous(limits = max_range) +
  scale_y_continuous(limits = max_range)

# 8.3.3 GEKST vs TPD 

ggplot(all, aes(TPD, GEKST, colour = product))+
  geom_point()+
  facet_wrap(~term, nrow = 1) +
  theme(legend.position = "bottom")+
  ggtitle("GEKST vs TPD") +
  scale_x_continuous(limits = max_range) +
  scale_y_continuous(limits = max_range)

#  9. as above but without smartphones (figure 2.)

# 9.1 remove smartphones

all_nosp <- all %>%
  filter(product != "smartphones")

# 9.2 getting range across all so I can get them on the same scale

max_range <- range(c(all_nosp$MMT, all_nosp$GEKST, all_nosp$TPD), na.rm = TRUE)

# 9.3 plots

ggplot(all_nosp, aes(MMT, GEKST, colour = product))+
  geom_point()+
  facet_wrap(~term, nrow = 1) +
  theme(legend.position = "bottom")+
  ggtitle("GEKST vs MMT - no smartphones") +
  scale_x_continuous(limits = max_range) +
  scale_y_continuous(limits = max_range)

ggplot(all_nosp, aes(MMT, TPD, colour = product))+
  geom_point()+
  facet_wrap(~term, nrow = 1) +
  theme(legend.position = "bottom")+
  ggtitle("TPD vs MMT - no smartphones") +
  scale_x_continuous(limits = max_range) +
  scale_y_continuous(limits = max_range)

ggplot(all_nosp, aes(TPD, GEKST, colour = product))+
  geom_point()+
  facet_wrap(~term, nrow = 1) +
  theme(legend.position = "bottom")+
  ggtitle("GEKST vs TPD - no smartphones") +
  scale_x_continuous(limits = max_range) +
  scale_y_continuous(limits = max_range)

# 10. decompositions for TVs (for presentation slides)

tv_data <- indexes %>%
  filter(product == "tv")

ggplot(tv_data, aes(quarter, index, colour = term))+
  geom_line()+
  facet_wrap(~method)



