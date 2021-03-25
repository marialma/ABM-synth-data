#from individual github issues

CategoryRender <- R6::R6Class(
  'CategoryRender',
  private = list(
    .output = NULL, # a char matrix representing the state of every individual at each timestep
    .categories = NULL
  ),
  public = list(
    initialize = function(timesteps, n_individuals, categories) {
      private$.categories <- categories
      private$.output <- matrix(NA, nrow = timesteps, ncol = n_individuals)
    },
    
    render = function(category_variable, timestep) {
      for (category in private$.categories) {
        private$.output[timestep, category_variable$get_index_of(category)$to_vector()] <- category
      }
    },
    
    #' @description
    #' Make a dataframe for the render
    to_dataframe = function() {
      # turn your private$.output into the dataframe you want :)
    }
  )
)