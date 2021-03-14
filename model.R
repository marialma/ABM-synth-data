#library('remotes')
#install_github('mrc-ide/individual')

library(individual)
#https://github.com/mrc-ide/individual
# thanks, sean


# Modeling 100 mothers & birth outcomes.
# Everyone in this model will become pregnant over 5 years? 

# Constants

N <- 100
g <- 273 # gestation

preg_rate <- 1/365  #rate of pregnancy.  i'm just gonna say that this population will gt pregnant in a year

dt <- 1
tmax <- 365*2
steps <- tmax/dt


health_states <- c("O", "P", "B", "M") #, "M", "C", "H", "D")
health_states_t0 <- rep("O", N) # everyone starts off not pregnant

#P0 <- 0
# States
# N = nOt pregnant, P = Pregnant, M = miscarried, C = faCility birth, H = Home birth D = death
health <- CategoricalVariable$new(categories = health_states,initial_values = health_states_t0)

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




birth_timer_t0 <- rep(273, N)

birth_timer <- IntegerVariable$new(birth_timer_t0)

# Processes

pregnancy_process <- function(timestep) {
  P <- health$get_size_of("O")
  O <- health$get_index_of("O")
  O$sample(rate = preg_rate)
  health$queue_update(value = "P",index = O)
  
}
miscarriage_process <- bernoulli_process(health, "P", "M", rate = 0.1/273)



birth_process <- function(timestep) {
  pregnant_people <- health$get_index_of("P")
  birth_update <- birth_timer$get_values(index = pregnant_people)
  birth_update <- birth_update - 1
  birth_timer$queue_update(value = birth_update,index = pregnant_people)
  birth_timer$.update()
}

birth <- function(timestep) {
  ready_to_birth <- birth_timer$get_index_of(set = c(0))
  health$queue_update(index = ready_to_birth, value = "B")
}

# death_process <- function(timestep){}


pregnancy_event <- TargetedEvent$new(population_size = N)
pregnancy_event$add_listener(function(t, target) {
  health$queue_update('P', target)
})



health_render <- Render$new(timesteps = steps)
health_render_process <- categorical_count_renderer_process(
  renderer = health_render,
  variable = health,
  categories = health_states
)



simulation_loop(
  variables = list(health),
  processes = list(pregnancy_process, miscarriage_process, birth_process, birth, health_render_process),
  events = list(pregnancy_event),
  timesteps=365*2
)




states <- health_render$to_dataframe()

library(ggplot2)
library(tidyverse)
states %>%
  gather(state, var, -timestep) %>% 
  ggplot() + geom_line(aes(x=timestep, y= var, color = state))
 

# health_cols <-  c("royalblue3","firebrick3","darkorchid3", "black")
# matplot(
#   x = states[[1]]*dt, y = states[-1],
#   type="l",lwd=2,lty = 1,col = adjustcolor(col = health_cols, alpha.f = 0.85),
#   xlab = "Time",ylab = "Count"
# )
# legend(
#   x = "topright",pch = rep(16,3),
#   col = health_cols,bg = "transparent",
#   legend = health_states, cex = 1.5
# )
# 

# 

# ref
# https://bmcpublichealth.biomedcentral.com/articles/10.1186/s12889-018-5695-z/tables/4
# limitation: paper assumes no interaction btw variables


# https://www.un.org/en/development/desa/population/publications/pdf/popfacts/PopFacts_2019-5.pdf
#
#