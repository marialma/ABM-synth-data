# Modeling 100 mothers & birth outcomes.
# Everyone in this model will become pregnant over 5 years? 

# Constants

N <- 100
g <- 273 # gestation days

preg_rate <- 1/365  #rate of pregnancy.  i'm just gonna say that this population will gt pregnant in a year

dt <- 1
tmax <- 365*2
steps <- tmax/dt


health_states <- c("O", "P", "B", "M") #, "M", "C", "H", "D")
health_states_t0 <- rep("O", N) # everyone starts off not pregnant

#P0 <- 0
# States
# N = nOt pregnant, P = Pregnant, M = miscarried, C = faCility birth, H = Home birth D = death
# vars

#age <- IntegerVariable$new(runif(N, 15, 51)) # should i just make this categorical? 
#wealth_quintile <- IntegerVariable$new(runif(N, 1,5)) 
#education <- IntegerVariable$new(runif(N, 0,1)) # 0 = no education, 1 = education 
#gets_ANC_visits
#existing_kids <- 
# let's say all 100 mothers are prgnant in a year, on average, so risk f pregnancy is 1/365
# every day, the mother risks developing danger signs
# younger mothers + older mothers are at higher risk for danger signs
# mothers who have never given birth before are at higher risk for danger signs 


# so, age is var, then if age < 17 & age > 35, danger sign risk is higher

# model multiparous based on age, eg, would not expect a 17 year old to have 3 kids. 
#  = pick a number from a dist * age? - prob want something with a long tail? 
# how do i model how many kids someone might have


# danger signs impact death risk
# If by day 273, the mother has not miscarried, birth will occur
# At birth, mother will either have a facility delivery or not.

# If a facility delivery + danger signs, death risk is lower. 

birth_timer_t0 <- floor(rnorm(N, mean = 258, sd = 15))


# miscarriage rate
# danger signs 
miscarriage_rate <- runif(N, min = 0, max = 1)
miscarriage_rate <- miscarriage_rate < 0.15
miscarriage_date <- sample(0:273, N, replace = TRUE)

status_change_record <- data.frame(person_id = rep(1:100), pregnant = 0, birth = 0, miscarriage = 0)

for(day in 1:tmax) {
  for(number in 1:N){
    current_state <- health_states_t0[number]
    
    if(current_state == "O") {
      got_pregnant <- runif(1, min = 0, max = 1) < preg_rate
      if(got_pregnant == TRUE ) {
        health_states_t0[number] <- "P"
        status_change_record[number,2] <- day
      } else {
        next
      }
    } else if(current_state =="P") {
      # pregnancy timer
      days_to_birth <- birth_timer_t0[number] 
      misc_dt <- miscarriage_date[number] 
      
      if(miscarriage_rate[number] == TRUE & misc_dt == days_to_birth) {
        health_states_t0[number] <- "M"
        status_change_record[number,4] <- day
      }
      if(miscarriage_rate[number] == FALSE & days_to_birth  == 0){
        health_states_t0[number] <- "B"
        status_change_record[number,3] <- day
      } else {birth_timer_t0[number] <- days_to_birth - 1}
      
      
    }
  }
}
#






# ref
# https://bmcpublichealth.biomedcentral.com/articles/10.1186/s12889-018-5695-z/tables/4
# limitation: paper assumes no interaction btw variables


# https://www.un.org/en/development/desa/population/publications/pdf/popfacts/PopFacts_2019-5.pdf
#
#