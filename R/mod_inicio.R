#' inicio UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_inicio_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' inicio Server Functions
#'
#' @noRd 
mod_inicio_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_inicio_ui("inicio_1")
    
## To be copied in the server
# mod_inicio_server("inicio_1")
