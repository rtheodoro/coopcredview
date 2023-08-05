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
     title = "Informações gerais das Cooperativa de Crédito em 07/2023",
     reactable::reactableOutput(ns("info_gerais")),
     width = 12
  )

}

#' info_gerais Server Functions
#'
#' @noRd
mod_info_gerais_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    qtd_pac <- read.csv(app_sys("data/202307_CoopCred_BCB_numero_de_agencias.csv")) |> dplyr::select(-nome_coop)

    info_gerais <- read.csv(app_sys("data/202307_CoopCred_BCB_info_gerais.csv")) |>
       dplyr::select(-regimeEspecial, -ato_presi, -nome_Liquidante, -telefone_ddd, -telefone_numero, -filiacao, -filiacao_central) |>
       dplyr::left_join(qtd_pac, by = "cnpj") |>
       dplyr::select(cnpj, nome_coop, numeroAgencias, everything())

    output$info_gerais <- reactable::renderReactable({
       reactable::reactable(
          info_gerais,
          defaultColDef = reactable::colDef(width = 150, align = "left"),
          filterable = TRUE,  # Habilitar a filtragem
          striped = TRUE,           # Listras na tabela
          highlight = TRUE,         # Destacar linha selecionada
          bordered = TRUE,          # Borda nas células
          pagination = TRUE,         # Paginação
          height = 590
       )
    })

  })
}

## To be copied in the UI
# mod_info_gerais_ui("info_gerais_1")

## To be copied in the server
# mod_info_gerais_server("info_gerais_1")
