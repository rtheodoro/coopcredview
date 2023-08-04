#' info_gerais UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_info_gerais_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' info_gerais Server Functions
#'
#' @noRd 
mod_info_gerais_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_info_gerais_ui("info_gerais_1")
    
## To be copied in the server
# mod_info_gerais_server("info_gerais_1")
