# qualdecomp_7GEKST.R

# run the GEKST decomposition

# last updated 13 May 2024

  
# 4. run jj loop across all periods 
  
datalist3 <- list()
for (jj in (1:(length(periods)))){

    allj <- product_g %>%
      filter(period == periods[jj]) %>%
      subset(select = -c(logprice, gamma)) %>%
      rename (t_j = period,
              pi_j = price,
              ei_j = expenditure,
              si_j = exp_share)
    
    setkey(allj,i)
    
# 5.1 get matched products with respect to 0j and j1 and create corresponding exp shares
    
matched0j <-  merge(all0, allj, by = "i") %>%
  #mutate(si_0j_0 = si_0/sum(si_0),
  #       si_0j_j = si_j/sum(si_j))
  mutate(si_M0j_0 = si_0/sum(si_0),
         si_M0j_j = si_j/sum(si_j))

matchedj1 <-  merge(allj, all1, by = "i") %>%
  #mutate(si_j1_j = si_j/sum(si_j),
  #       si_j1_1 = si_1/sum(si_1))
   mutate(si_Mj1_j = si_j/sum(si_j),
          si_Mj1_1 = si_1/sum(si_1))

# 5.2 get new products with respect to 0j and j1 and create corresponding exp shares
# note - the shares wrt new/disappearing products could be better named here, as they curently have the same names 
# as fr matched

new0j <- allj[!all0] %>%
  #mutate(si_0j_j = si_j/sum(si_j))
mutate(si_N0j_j = si_j/sum(si_j))

newj1 <- all1[!allj] %>%
  #mutate(si_j1_1 = si_1/sum(si_1))
mutate(si_Nj1_1 = si_1/sum(si_1))

# 5.3 get disappearing products with respect to 0j and j1 and create corresponding exp shares

disappearing0j <- all0[!allj] %>%
  #mutate(si_0j_0 = si_0/sum(si_0))
mutate(si_D0j_0 = si_0/sum(si_0))

disappearingj1 <- allj[!all1] %>%
  #mutate(si_j1_j = si_j/sum(si_j))
mutate(si_Dj1_j = si_j/sum(si_j))
    
    # 6.1 calculate GEKS term (the bit inside the j loop) (to compare with the implied GEKS from quality term, which also needs to be calculated somewhere)
    
    GEKSj <- log(prod((matched0j$pi_j/matched0j$pi_0)^((matched0j$si_M0j_0 + matched0j$si_M0j_j)/2))*prod((matchedj1$pi_1/matchedj1$pi_j)^((matchedj1$si_Mj1_j + matchedj1$si_Mj1_1)/2)))
    
    
    # 9. get decomposition terms within the jj loop ( Daniel's decomposition )
    
    #comp <- sum(((matched0j$si_0j_j - matched0j$si_0j_0))*((log(matched0j$pi_j)+log(matched0j$pi_0))/2)) +
    #  sum(((matchedj1$si_j1_1 - matchedj1$si_j1_j))*((log(matchedj1$pi_1)+log(matchedj1$pi_j))/2))
    comp <- sum(((matched0j$si_M0j_j - matched0j$si_M0j_0))*((log(matched0j$pi_j)+log(matched0j$pi_0))/2)) +
       sum(((matchedj1$si_Mj1_1 - matchedj1$si_Mj1_j))*((log(matchedj1$pi_1)+log(matchedj1$pi_j))/2))
    
    
    
    # 9.4 entry terms (Daniel's decomposition)
    
    # 9.4.1 get entry term for 0j (ref eqn 10)
    
    expshare0j_newj <- sum(new0j$ei_j)/sum(allj$ei_j)
      
    entry_0j <- expshare0j_newj*(log(prod(new0j$pi_j^new0j$si_N0j_j))-log(prod(matched0j$pi_j^matched0j$si_M0j_j)))
    #note - could restate this in the summation form to match paper
      
    # 9.4.2 get entry term for j1 (ref eqn 10)
    
    expsharej1_new1 <- sum(newj1$ei_1)/sum(all1$ei_1)
      
    entry_j1 <- expsharej1_new1*(log(prod(newj1$pi_1^newj1$si_Nj1_1))-log(prod(matchedj1$pi_1^matchedj1$si_Mj1_1)))
    #note - could restate this in the summation form to match paper
      
    # 9.5 get full entry term (ref eqn 24)
    entry <- entry_0j + entry_j1
    
    # 9.7 get exit term for 0j (ref eqn 12)
    
    expshare0j_disappearing0 <- sum(disappearing0j$ei_0)/sum(all0$ei_0)

    exit_0j <- expshare0j_disappearing0*(log(prod(disappearing0j$pi_0^disappearing0j$si_D0j_0))-log(prod(matched0j$pi_0^matched0j$si_M0j_0)))
    
    # 9.4 get exit term for j1 (ref eqn 12)
    
    expsharej1_disappearingj <- sum(disappearingj1$ei_j)/sum(allj$ei_j)
   
    exit_j1 <- expsharej1_disappearingj*(log(prod(disappearingj1$pi_j^disappearingj1$si_Dj1_j))-log(prod(matchedj1$pi_j^matchedj1$si_Mj1_j)))
    
    exit <- exit_0j + exit_j1
      
    # 10. get results from j loop out
    
    results <- data.frame(t(data.frame(c(GEKSj, comp, entry, exit)))) %>%
      rename(GEKSj=X1, comp=X2, entry=X3, exit=X4) %>%
      mutate(t0num = k, t1num = k+1, linknum = jj, t0period = periods[k], t1period = periods[k+1], linkperiod = periods[jj])
    
    # note there's redundancy in here because the (01) matching is happening for every j - leave it for now and
    # filter out the (01) results outside the loop later
    
    datalist3[[jj]] <- results
}
  
  all_results_3 <- data.frame(do.call(rbind, datalist3)) 
  rownames(all_results_3) <- 1:nrow(all_results_3)
  
  # 10.2 calculate GEKS and decomposition terms (Daniel's decomposition see eqns 24 to 26)
  
  GEKST_price_ln <- (1/length(periods))*sum(all_results_3$GEKSj) 
  
  GEKST_comp_ln <- (1/length(periods))*sum(all_results_3$comp)
  
  GEKST_entry_ln <- (1/length(periods))*sum(all_results_3$entry)
  
  GEKST_exit_ln <- (1/length(periods))*sum(all_results_3$exit)
  
  GEKST_quality_ln <- GEKST_comp_ln + GEKST_entry_ln - GEKST_exit_ln
  
  
  # 11. data for saving
  
  results_7GEKST <- c(GEKST_price_ln, GEKST_comp_ln, GEKST_entry_ln, GEKST_exit_ln, GEKST_quality_ln) %>%
    setNames(c("GEKST_price_ln", "GEKST_comp_ln", "GEKST_entry_ln", "GEKST_exit_ln","GEKST_quality_ln"))
  

