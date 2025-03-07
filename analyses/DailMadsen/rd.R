
#' normal comment
#+ r comment

T2 <- c(5, 5, 10, 5,3) # number of secondary periods per primary period
T <- length(T2) # number of primary periods







model<- function()
	{
	# priors
	phi ~ dbeta(pr.phi[1],pr.phi[2]) #apparent survival probability 
  gamma1 ~ dbeta(pr.gamma1[1],pr.gamma1[2]) #temporary migration: probabilty stays out conditional on being out
  for(t_ in 1:T){ #T primary periods...
     pd_a[t_] ~ dgamma(pr.pd[1],pr.pd[2]) #hyperprior on detect probs
     pd_b[t_] ~ dgamma(pr.pd[1],pr.pd[2]) #hyperprior on  detect probs
     for(tt_ in 1:T2[t_]){ #loop through secondary periods...
        pd[tt_,t_] ~ dbeta(pd_a[t_],pd_b[t_]) #secondard-period-level detection probs
     }
     p.eff[t_] <- 1-prod(1-pd[1:T2[t_],t_]) #effective detection prob per primary period
  }
  #loop through (T-1) primary periods
  #NOTE: trmat's are offset -1 in time, eg. t_=1 implies a transition between period 1 to period 2.
  for(t_ in 1:(T-1)){ 
     gamma2[t_] ~ dbeta(pr.gamma2[1],pr.gamma2[2]) #temp migration: prob migrate out conditional on being inside
     #trmat: transition matrix for Markovian latent-states
     #1=dead;2=offsite;3=onsite
     #transition are from the column --> rows
     #trmat[row,column,time] = [state at time=t_; state at time t_-1; time=t_]
     trmat[1,1,t_]<- 1 #stay dead
     trmat[2,1,t_]<- 0
     trmat[3,1,t_]<- 0
     trmat[1,2,t_]<- 1-phi #dies outside
     trmat[2,2,t_]<- gamma1*phi #stays outside | outside
     trmat[3,2,t_]<- (1-gamma1)*phi #reenters study area | outside
     trmat[1,3,t_]<- 1-phi #dies inside
     trmat[2,3,t_]<- gamma2[t_]*phi #leaves study area | inside
     trmat[3,3,t_]<- (1-gamma2[t_])*phi #stays inside | inside
  } #t_ state process
  #PART1: likelihood for first-capture (all individuals)
  for(i in 1:N){
    #Observation error during 1st capture: condition on at least one capture: 
    #the following formula is the (conditional) multinomial log-likelihood of
    #...the sequence of observations in a primary period, conditional on that we 
    #...know they were seen at least once
        LL[i]<-sum(y[i,1:T2[first[i]],first[i]]*log(pd[1:T2[first[i]],first[i]])+ (1-y[i,1:T2[first[i]],first[i]])*log(1-pd[1:T2[first[i]],first[i]])) - log(p.eff[first[i]]) #multinomial log-likelihood
	zeros[i] ~ dpois(-1*LL[i]+C) #Winbugs zeros trick, likelihood passed to JAGS as ZIP
  } #i 
  mintrick <- max(LL[1:N]) #strictly for monitoring the first-capture likelihood trick
  #PART2: loop through individuals potentially available for 2 or more primary periods
  for(i in 1:length(N.ix2)){
    #state process for latent state after their first primary period
    #draw z conditional on being seen during previous primary period
    z[N.ix2[i],first[N.ix2[i]]+1]~ dcat(trmat[1:3,3,first[N.ix2[i]]]) 
    #loop through secondary periods
    for(tt_ in 1:T2[first[N.ix2[i]]+1]){
        #likelihood of secondary periods observation, conditional on z=3
        y[N.ix2[i],tt_,first[N.ix2[i]]+1] ~ dbern(pd[tt_,first[N.ix2[i]]+1]* equals(z[N.ix2[i],first[N.ix2[i]]+1],3))
    } #tt_
 } #N.ix2
 #PART3: loop through individuals potentially available for 3 or more primary periods
 for(i in 1:length(N.ix3)){
   #loop through remain primary periods after first and second primary periods 
   for(t_ in (first[N.ix3[i]]+2):T){ 
       #state process: draw z(t_) conditional on  z(t_-1)
       z[N.ix3[i],t_]~ dcat(trmat[1:3, z[N.ix3[i],t_-1], t_-1]) #
       #Observation error: Bernoulli
       for(tt_ in 1:T2[t_]){
           #likelihood of secondary periods observation, conditional on z=3
           y[N.ix3[i],tt_,t_] ~ dbern(pd[tt_,t_]*equals(z[N.ix3[i],t_],3))
      } #tt_
    } #t_
  } #N.ix3
# estimate number of individuals available for capture (inside) per primary period
for(t_ in 1:T){
  Nin[t_] <- n.vector[t_]/p.eff[t_] 
} #t_
}