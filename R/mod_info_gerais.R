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

  bs4Dash::box(
     title = "Informações gerais das Cooperativa de Crédito em 07/2022",
     reactable::reactableOutput(ns("info_gerais"))
  )

}

#' info_gerais Server Functions
#'
#' @noRd
mod_info_gerais_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    info_gerais <- read.csv(app_sys("data/202307_CoopCred_BCB_info_gerais.csv"))

    output$info_gerais <- reactable::renderReactable({
       reactable::reactable(
          info_gerais,
          defaultColDef = reactable::colDef(width = 150, align = "left"),
          filterable = TRUE,  # Habilitar a filtragem
          striped = TRUE,           # Listras na tabela
          highlight = TRUE,         # Destacar linha selecionada
          bordered = TRUE,          # Borda nas células
          pagination = TRUE         # Paginação
       )
    })

  })
}

## To be copied in the UI
# mod_info_gerais_ui("info_gerais_1")

## To be copied in the server
# mod_info_gerais_server("info_gerais_1")
