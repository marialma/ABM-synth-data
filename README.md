# ABM-synth-data
Generating synthetic health data with an agent based model


[Synthea](https://github.com/synthetichealth/synthea) is great if you have/ want really in depth patient records. But, sometimes you don't get stuff in that much detail. This is an attempt to generate synthetic health data for settings where you kinda don't have that much information.


Goal is synthetic health data in a rural community health setting.
What I want to use this for is to generate fake patients so i can build tools without using real health data.

# Actual code is in pregnancy_model.R

## maternal health outcomes
using maternal health outcomes as a test case. see dag.png


## to do
* add in age, ~~wealth, education,~~ health visits & kids vars
* add in danger signs + interaction with age + kids + health visits
  * add deaths
* model each ANC visit?
* ~~figure out how to get it to give me the state of each individual at each timestep instead of the number of individuals in each state~~


## log
* 2020-03-14 - pregnancies, births, miscarriages are modeled.
* 2021-02-09 - scrapped using individual package; modeling using other means instead for flexibility. I think this is necessary to generate data that looks like it could conceivably be medical record data.
* 2021-02-09 - added in facility birth



## refs
* [Doctor, H.V., Nkhana-Salimu, S. & Abdulsalam-Anibilowo, M. Health facility delivery in sub-Saharan Africa: successes, challenges, and implications for the 2030 development agenda. BMC Public Health 18, 765 (2018).](https://bmcpublichealth.biomedcentral.com/articles/10.1186/s12889-018-5695-z/tables/4)
  *  limitation: paper assumes no interaction btw variables. obvs not true given that wealth + education are usually correlated. but whatever this is the best data i have right now anyway


* [Population Division of the United Nations Department of Economic and Social Affairs. Potential impact of later childbearing on future population.(2019)](https://www.un.org/en/development/desa/population/publications/pdf/popfacts/PopFacts_2019-5.pdf)
