#' estrut_gov UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_estrut_gov_ui <- function(id){
  ns <- NS(id)

  bs4Dash::box(
        title = "Estrutura de Governança das Cooperativas de Crédito em 07/2022",
     reactable::reactableOutput(ns("tabela_governanca"))
  )
}

#' estrut_gov Server Functions
#'
#' @noRd
mod_estrut_gov_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    estrut_gov <- read.csv(app_sys("data/202307_CoopCred_BCB_estrutura_governanca.csv"))

    output$tabela_governanca <- reactable::renderReactable({
       reactable::reactable(
          estrut_gov,
          columns = list(
             cnpj = reactable::colDef(align = "left"),
             nome = reactable::colDef(align = "left"),
             cpf = reactable::colDef(align = "left"),
             cargo = reactable::colDef(align = "left"),
             orgao = reactable::colDef(align = "left")
          ),
          defaultColDef = reactable::colDef(width = 150),
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
# mod_estrut_gov_ui("estrut_gov_1")

## To be copied in the server
# mod_estrut_gov_server("estrut_gov_1")
