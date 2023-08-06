#' balancos_patrimoniais UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_balancos_patrimoniais_ui <- function(id){
   ns <- NS(id)

   fluidRow(
      bs4Dash::box(
         title = tippy::tippy("Visualização Geral das Cooperativas de Crédito", "Que enviaram Balanço Patrimonial (Doc. 4010) em 12/2022 e estavam ativas em 08/2023"),
         solidHeader = TRUE,
         collapsible = FALSE,
         width = 12,
         p(""),
         sidebarLayout(
            sidebarPanel(
               selectInput(
                  inputId = ns("conta_dist"),
                  label = "Selecione uma conta",
                  choices = ""
               )
            ),

            mainPanel(
               reactable::reactableOutput(ns("tabela_cred")),
               plotly::plotlyOutput(ns("g_dist_contas"))
            )
         )
      ),

      bs4Dash::box(
         title = tippy::tippy("Visualização de informações financeiras por Cooperativa de Crédito", "Que enviaram Balanço Patrimonial (Doc. 4010) em 12/2022 e estavam ativas em 08/2023"),
         solidHeader = TRUE,
         collapsible = FALSE,
         width = 12,
         p(),
         sidebarLayout(
            sidebarPanel(
               selectInput(
                  inputId = ns("rs_coop"),
                  label = "Selecione uma Cooperativa",
                  choices = ""
               ),
               selectInput(
                  inputId = ns("conta"),
                  label = "Selecione uma conta",
                  choices = ""
               )
            ),
            mainPanel(
               plotly::plotlyOutput(ns("g_evolucao_conta"))
            )
         )
      )


)
}

#' balancos_patrimoniais Server Functions
#'
#' @noRd
mod_balancos_patrimoniais_server <- function(id){
   moduleServer( id, function(input, output, session){
      ns <- session$ns

      balanco <- data.table::fread(app_sys("data/balanco_coop_cred_1993a2022_4010.csv")) |>
         dplyr::mutate(cooperativa = paste(cnpj, razao_social, sep = " - "),
                       cooperativa = iconv(cooperativa,  "latin1", "UTF-8", "?"))


      updateSelectInput(
         inputId = "rs_coop",
         choices = balanco |> dplyr::arrange(razao_social) |> dplyr::select(cooperativa) |> unique()
      )

      observe({
         req(input$rs_coop)
         conta <- balanco |>
            dplyr::filter(cooperativa == input$rs_coop) |>
            dplyr::select(tidyselect::where(~ any(!is.na(.))), -ano, -cnpj, -razao_social, -cooperativa) |>
            names() |>
            unique()

         updateSelectInput(
            inputId = "conta",
            choices = conta
         )
      })

      output$g_evolucao_conta <- plotly::renderPlotly({
         filtered_balanco <- balanco  |>
            dplyr::filter(cooperativa == input$rs_coop)

         plotly::plot_ly(data = filtered_balanco,
                         x = ~ ano,
                         y = ~ get(input$conta)) |>
            plotly::add_lines()
      })

      updateSelectInput(
         inputId = "conta_dist",
         choices = balanco |>
            dplyr::select(tidyselect::where(~ any(!is.na(.))), -ano, -cnpj, -razao_social, -cooperativa) |>
            names() |>
            unique()
      )

      output$g_dist_contas <- plotly::renderPlotly({

         plotly::plot_ly(
            data = balanco,
            x = ~ano,
            y = ~get(input$conta_dist),
            type = "scatter",
            mode = "markers",
            text = ~cooperativa,
            source = "A"
         )
      })


      # Ainda não consegui fazer aparecer
      output$tabela_cred <- reactable::renderReactable({

         num_linha <- plotly::event_data("plotly_click", source = "A" )$pointNumber

         validate(
            need(!is.null(num_linha)), "Clique em um ponto no gráfico"
         )

         balanco |>
            dplyr::slice(num_linha + 1) |>
            dplyr::select(cnpj, razao_social) |>
            reactable::reactable()

      })



   })
}

## To be copied in the UI
# mod_balancos_patrimoniais_ui("balancos_patrimoniais_1")

## To be copied in the server
# mod_balancos_patrimoniais_server("balancos_patrimoniais_1")
