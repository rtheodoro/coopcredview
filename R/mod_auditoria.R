#' auditoria UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_auditoria_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' auditoria Server Functions
#'
#' @noRd 
mod_auditoria_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_auditoria_ui("auditoria_1")
    
## To be copied in the server
# mod_auditoria_server("auditoria_1")
