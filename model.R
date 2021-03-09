#library('remotes')
#install_github('mrc-ide/individual')


#https://github.com/mrc-ide/individual
# thanks, sean


# Modeling 100 mothers & birth outcomes.
# Everyone in this model will become pregnant over 5 years? 

population <- 100

# States
N <- State$new('N', population) # Not pregnant
P <- State$new('P', 0) # Pregnant
M <- State$new('M', 0) # Miscarriage
B <- State$new('B', 0) # Birth
C <- State$new('C', 0) # faCility
H <- State$new('H', 0) # Home birth
D <- State$new('D', 0) # Death


# let's say all 100 mothers are prgnant in a year, on average, so risk f pregnancy is 1/365
# every day, the mother risks developing danger signs
# younger mothers + older mothers are at higher risk for danger signs
# mothers who have never given birth before are at higher risk for danger signs 

# so, age is var, then if age < 17 & age > 35, danger sign risk is higher

# model parity based on age, eg, would not expect a 17 year old to have 3 kids. 
# parity = pick a number from a dist * age? - prob want something with a long tail? 
# how do i model how many kids someone might have


# danger signs impact death risk
# If by day 273, the mother has not miscarried, birth will occur
# At birth, mother will either have a facility delivery or not.

# If a facility delivery + danger signs, death risk is lower. 

# parity <- Variable$new(‘parity’, runif ( 0, 4)? )


# Individuals
human <- Individual$new(
  'human',
  list(N, P, M, B, C, H, D),
  variables = list(danger_signs, facility_birth)
)

pregnancy_event <- Event$new('pregnancy')





miscarriage_event <- Event$new('miscarriage')

birth_event <- Event$new('birth')

facility_birth_event <- Event$new('facility')

death_event <- Event$new('death')

