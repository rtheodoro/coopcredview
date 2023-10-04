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


  fluidRow(
     bs4Dash::box(
        title = "Informações gerais das Cooperativa de Crédito em 08/2023",
        reactable::reactableOutput(ns("info_gerais")),
        width = 6
     ),
     bs4Dash::box(
        title = tippy::tippy(
           "Visualização Geral das Cooperativas de Crédito",
           "Estavam ativas em 08/2023"
        ),
        solidHeader = TRUE,
        collapsible = FALSE,
        width = 6,
        shiny::radioButtons(
           ns("classe"),
           label = tippy::tippy("Selecione a classe:", "Algumas não preencheram esta informação"),
           choices = c("Todas", "Singular", "Central", "Confederação"),
           selected = "Todas"
        ),

        plotly::plotlyOutput(ns("g_dist_est"))

     )
  )



}

#' info_gerais Server Functions
#'
#' @noRd
mod_info_gerais_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    qtd_pac <- read.csv(app_sys("202308_CoopCred_BCB_numero_de_agencias.csv")) |> dplyr::select(-nome_coop)
    info_gerais <- read.csv(app_sys("202308_CoopCred_BCB_info_gerais.csv")) |>
       dplyr::select(-regimeEspecial, -ato_presi, -nome_Liquidante, -telefone_ddd, -telefone_numero, -filiacao, -filiacao_central) |>
       dplyr::left_join(qtd_pac, by = "cnpj") |>
       dplyr::select(cnpj, nome_coop, numeroAgencias, tidyselect::everything())

    output$info_gerais <- reactable::renderReactable({
       reactable::reactable(
          info_gerais,
          defaultColDef = reactable::colDef(width = 150, align = "left"),
          filterable = TRUE,        # Habilitar a filtragem
          striped = TRUE,           # Listras na tabela
          highlight = TRUE,         # Destacar linha selecionada
          bordered = TRUE,          # Borda nas células
          pagination = TRUE,        # Paginação
          height = 590
       )
    })


    filtered_data <- reactive({
       if (input$classe == "Singular") {
          coluna <- "Singular"
       } else if (input$classe == "Central") {
          coluna <- "Central"
       } else if (input$classe == "Confederação") {
          coluna <- "Confederação"
       } else {
          coluna <- c("Singular", "Central", "Confederação")
       }

       list(coluna = coluna)
    })

    output$g_dist_est <- plotly::renderPlotly({
       filtered <- filtered_data()

       cooperativas_por_uf <- info_gerais  |>
          dplyr::filter(classe %in% filtered$coluna) |>
          dplyr::group_by(uf)  |>
          dplyr::summarise(qtd_cooperativas = dplyr::n())  |>
          dplyr::arrange(qtd_cooperativas) # Não está organizando as barras

       plotly::plot_ly(
          data = cooperativas_por_uf,
          x = ~qtd_cooperativas,
          y = ~uf,
          type = "bar",
          orientation = 'h'
       ) |>
          plotly::layout(
             xaxis = list(title = "Quantidade de Cooperativas"),
             yaxis = list(title = "UF")
          )
    })

  })
}

## To be copied in the UI
# mod_info_gerais_ui("info_gerais_1")

## To be copied in the server
# mod_info_gerais_server("info_gerais_1")
