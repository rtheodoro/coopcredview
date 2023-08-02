#' dist_coopcred UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_dist_coopcred_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' dist_coopcred Server Functions
#'
#' @noRd 
mod_dist_coopcred_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_dist_coopcred_ui("dist_coopcred_1")
    
## To be copied in the server
# mod_dist_coopcred_server("dist_coopcred_1")
