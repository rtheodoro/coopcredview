#' dist_coop UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_dist_coop_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' dist_coop Server Functions
#'
#' @noRd 
mod_dist_coop_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_dist_coop_ui("dist_coop_1")
    
## To be copied in the server
# mod_dist_coop_server("dist_coop_1")
