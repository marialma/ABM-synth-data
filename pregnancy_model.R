library(tidyverse) # most of this works in base R tho


# Modeling 100 mothers & birth outcomes.

# Constants

N <- 100
g <- 273 # gestation days

preg_rate <- 1/365  #rate of pregnancy.  i'm just gonna say that this population will gt pregnant in a year

tmax <- 365*2 # max amount of time you want to look at


# States
# N = nOt pregnant, P = Pregnant, M = miscarried, C = faCility birth, H = Home birth D = death?
health_states_t0 <- rep("O", N) # everyone starts off not pregnant

# Birth timers
birth_timer_t0 <- floor(rnorm(N, mean = 258, sd = 15)) # figure out how to skew this properly sigh i'm bad at distributions

# Miscarriage 
# danger signs 
# to do: add in age as a factor and so on
miscarriage_rate <- runif(N, min = 0, max = 1)
miscarriage_rate <- miscarriage_rate < 0.15
miscarriage_date <- sample(30:258, N, replace = TRUE) # possibly rethink how to select miscarriage - base off birth timer instead?

status_change_record <- data.frame(person_id = rep(1:100), became_pregnant = NA, gave_birth = NA, had_miscarriage = NA)

# Modeling the pregnancy
# Look i know there's a way to vectorize this but it's easier for me to think in for loops. I will vectorize later. 
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

table(health_states_t0)



# Birth Outcomes
base_facility_birth_rate <- 0.15
ed = c(1,2.02) # ORs taken from BMC paper linked below.
quintiles = c(1,1.18,1.29,1.43,1.68) # ORs taken from BMC paper linked below

# Demographics
wealth_quintile <- sample(quintiles, N, replace = TRUE)
education <- sample(ed, N, replace = TRUE) # obviously flawed because the sample for education should depend on wq but next steps.
facility_births <- base_facility_birth_rate * (wealth_quintile * education)

facility_chance <- runif(N, 0,1)
born_in_a_facility <- facility_chance < facility_births
born_in_a_facility <- ifelse(born_in_a_facility, "facility_birth", "home_birth")
status_change_record$birth_type <- ifelse(!is.na(status_change_record$gave_birth), born_in_a_facility , NA)

# create fake health record
date_start <- as.Date("2021-01-01")

fnames <- c("Anna", "Betty", "Cathy", "Devya", "Elaine", "Grace", "Helen", "Isabella", "Juma")  # come up with better list of names
lnames <- c("Lee", "Mwangi", "Kumar", "Jones", "Rodriguez", "Garcia", "Chen", "Otieno", "Mohammed", "Wang")

status_change_record$first_name <- paste0(sample(fnames, N, replace = T))
status_change_record$last_name <- paste0(sample(lnames, N, replace = T))
# generate fake date of birth eventually (whenever i figure out how to model age)

status_change_record %>% 
  gather(key = "status", value = "dates", 2:4) %>% 
  filter(!is.na(dates)) %>% 
  mutate(dates = date_start + dates) %>% 
  mutate(birth_type = ifelse(status == "gave_birth", birth_type, NA)) %>% 
  select(person_id, first_name, last_name, status, birth_type, dates) -> med_rec

# just obliterate some percentage of the records to simulate data missingness
expected_percent_captured <- 0.4
medical_records <- sample_n(med_rec, floor(nrow(med_rec) * expaected_percent_captured)) %>% arrange(dates) 

write.csv(medical_records, "fake_medical_record_1.csv")

# ref
# https://bmcpublichealth.biomedcentral.com/articles/10.1186/s12889-018-5695-z/tables/4
# limitation: paper assumes no interaction btw variables?
# https://www.un.org/en/development/desa/population/publications/pdf/popfacts/PopFacts_2019-5.pdf


# thoughts:
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

# If a facility delivery + danger signs, death risk is lower?