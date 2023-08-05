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

  fluidRow(column(
     7,
     bs4Dash::box(
        title = "Estrutura de Governança das Cooperativas de Crédito em 08/2023",
        reactable::reactableOutput(ns("tabela_governanca")),
        width = 12
     )),
     column(
        5,
        bs4Dash::box(
           title = tippy::tippy(
              "Contagem de Gênero em Cooperativas de Crédito em 08/2023",
              "As informações foram geradas a partir do primeiro nome, podem ter um grau de imprecisão"
           ),
           width = 12,
           shiny::selectInput(
              ns("cooperativa_select"),
              "Escolha uma Cooperativa:",
              choices = c(
                 "Todas",
                 read.csv(
                    app_sys("data/202308_CoopCred_BCB_estrutura_governanca.csv")
                 ) |>
                    dplyr::mutate(Cooperativa = paste(cnpj, nomec, sep = " - ")) |> dplyr::select(Cooperativa) |> unique()
              )
           ),
           shiny::radioButtons(
              ns("info_type"),
              label = "Ver informações por:",
              choices = c("Órgão", "Cargo"),
              selected = "Órgão"
           ),
           plotly::plotlyOutput(ns("genero_por_cargo"))
        )
     )
     )

}

#' estrut_gov Server Functions
#'
#' @noRd
mod_estrut_gov_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    estrut_gov <- read.csv(app_sys("data/202308_CoopCred_BCB_estrutura_governanca.csv")) |>
       dplyr::mutate(Cooperativa = paste(cnpj, nomec, sep = " - "))

    output$tabela_governanca <- reactable::renderReactable({
       reactable::reactable(
          estrut_gov |>
             dplyr::select(-genero, -Cooperativa),
          columns = list(
             cnpj = reactable::colDef(align = "left"),
             nome = reactable::colDef(align = "left"),
             cpf = reactable::colDef(align = "left"),
             cargo = reactable::colDef(align = "left"),
             orgao = reactable::colDef(align = "left")
          ),
          defaultColDef = reactable::colDef(width = 140),
          filterable = TRUE,        # Habilitar a filtragem
          striped = TRUE,           # Listras na tabela
          highlight = TRUE,         # Destacar linha selecionada
          bordered = TRUE,          # Borda nas células
          pagination = TRUE,        # Paginação
          height = 590
       )
    })

    filtered_data <- reactive({
       if (input$info_type == "Cargo") {
          data <- estrut_gov
          x_axis <- "cargo"
       } else {
          data <- subset(estrut_gov, !is.na(orgao))
          x_axis <- "orgao"
       }

       if (input$cooperativa_select != "Todas") {
          data <- subset(data, Cooperativa == input$cooperativa_select)
       }

       list(data = data, x_axis = x_axis)
    })

    output$genero_por_cargo <- plotly::renderPlotly({
       data <- filtered_data()$data
       data$genero <- as.character(data$genero)
       genero_counts <- table(data[[filtered_data()$x_axis]], data$genero)
       genero_data <- data.frame(
          CargoOrgao = rep(rownames(genero_counts), ncol(genero_counts)),
          Genero = rep(colnames(genero_counts), each = nrow(genero_counts)),
          Contagem = as.vector(genero_counts)
       )

       genero_data$Genero <- ifelse(genero_data$Genero == "H", "Masculino", "Feminino")

       x_axis_label <- if (input$info_type == "Cargo") {
          "Cargo"
       } else {
          "Órgão"
       }

       plotly::plot_ly(
          data = genero_data,
          x = ~CargoOrgao,
          y = ~Contagem,
          color = ~Genero,
          colors = c(Masculino = "#C9E8F5", Feminino = "#C9F5D1"),
          type = "bar",
          marker = list(line = list(color = "white"))
       )  |>
          plotly::layout(
             xaxis = list(title = x_axis_label),
             showlegend = TRUE,
             legend = list(
                x = 1,
                y = 1,
                traceorder = "normal",
                font = list(family = "sans-serif", size = 12, color = "black"),
                bgcolor = "white",
                bordercolor = "#E2E2E2",
                borderwidth = 2
             )
          )
    })
  })


}

## To be copied in the UI
# mod_estrut_gov_ui("estrut_gov_1")

## To be copied in the server
# mod_estrut_gov_server("estrut_gov_1")
