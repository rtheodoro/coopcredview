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


  fluidRow(
     bs4Dash::box(
        title = "Informações sobre auditoria independente das Cooperativa de Crédito em 08/2023",
        reactable::reactableOutput(ns("auditor_ind")),
        width = 6
     ),
     bs4Dash::box(
        title = tippy::tippy(
           "Visualização da Auditoria das Cooperativas de Crédito",
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
        plotly::plotlyOutput(ns("g_audit"))
     ),
     bs4Dash::box(
        title = "Informações sobre auditoria das Cooperativa de Crédito por Tamanho (em construção)",
        reactable::reactableOutput(ns("audit_tam")),
        width = 6
     ),
     bs4Dash::box(
        title = "Novo Gráfico em Construção",
        plotly::plotlyOutput(ns("novo_plotly_output")),
        width = 6
     )
  )

}

#' auditoria Server Functions
#'
#' @noRd
mod_auditoria_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    auditor_independente <- read.csv(app_sys("202308_CoopCred_BCB_auditorIndependente.csv")) |>
       dplyr::mutate(
          big_four = dplyr::case_when(
             auditorIndependente == "ERNST & YOUNG AUDITORES INDEPENDENTES S/S LTDA" ~ "Sim",
             auditorIndependente == "DELOITTE TOUCHE TOHMATSU AUDITORES INDEPENDENTES LTDA" ~ "Sim",
             auditorIndependente == "KPMG AUDITORES INDEPENDENTES" ~ "Sim",
             auditorIndependente == "PRICEWATERHOUSECOOPERS AUDITORES INDEPENDENTES LTDA" ~ "Sim",
             .default = "Não"
          )
       ) |>
       dplyr::left_join(read.csv(app_sys("202308_CoopCred_BCB_info_gerais.csv")) |> dplyr::select(cnpj, classe))



    output$auditor_ind <- reactable::renderReactable({
       reactable::reactable(
          auditor_independente,
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

    output$g_audit <- plotly::renderPlotly({
       filtered <- filtered_data()

       cooperativas_por_auditor <- auditor_independente  |>
          dplyr::filter(classe %in% filtered$coluna) |>
          dplyr::group_by(big_four)  |>
          dplyr::summarise(qtd_cooperativas = dplyr::n())  |>
          dplyr::arrange(qtd_cooperativas)

       plotly::plot_ly(
          data = cooperativas_por_auditor,
          x = ~ qtd_cooperativas,
          y = ~ big_four,
          type = "bar",
          orientation = 'h'
       ) |>
       plotly::layout(
          xaxis = list(title = "Quantidade de Cooperativas"),
          yaxis = list(title = "Big Four")
       )
    })



  })
}

## To be copied in the UI
# mod_auditoria_ui("auditoria_1")

## To be copied in the server
# mod_auditoria_server("auditoria_1")
