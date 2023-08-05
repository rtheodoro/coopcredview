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

  tagList(
     bs4Dash::box(title = "Estrutura de Governança das Cooperativas de Crédito em 07/2022",
                  reactable::reactableOutput(ns(
                     "tabela_governanca"
                  ))),
     bs4Dash::box(
        title = tippy::tippy("Porcentagem de Homens e Mulheres por Cargos", "em 07/2022"),
        shiny::selectInput(
           ns("cooperativa_select"),
           "Escolha uma Cooperativa:",
           choices = c("Todas", read.csv(app_sys("data/202307_CoopCred_BCB_estrutura_governanca.csv")) |> dplyr::select(nomec) |> unique())
        ),
        plotly::plotlyOutput(ns("genero_por_cargo"))
     )
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

    output$genero_por_cargo <- plotly::renderPlotly({
       cooperativa_selecionada <- input$cooperativa_select

       if (cooperativa_selecionada == "Todas") {
          dados_filtrados <- estrut_gov
       } else {
          dados_filtrados <- subset(estrut_gov, nomec == cooperativa_selecionada)
       }

       genero_counts <- table(dados_filtrados$cargo, dados_filtrados$genero)
       genero_data <- data.frame(
          Cargo = rep(rownames(genero_counts), ncol(genero_counts)),
          Genero = rep(colnames(genero_counts), each = nrow(genero_counts)),
          Count = as.vector(genero_counts)
       )

       genero_data$Genero <- ifelse(genero_data$Genero == "H", "Masculino", "Feminino")

       plotly::plot_ly(data = genero_data, x = ~Cargo, y = ~Count, color = ~Genero,
                       type = "bar", marker = list(line = list(color = "white")))
    })

  })
}

## To be copied in the UI
# mod_estrut_gov_ui("estrut_gov_1")

## To be copied in the server
# mod_estrut_gov_server("estrut_gov_1")
