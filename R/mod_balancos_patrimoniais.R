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

     bs4Dash::box(
        title = "Visualização de informações financeiras das Cooperativas de Crédito que enviaram seus balanços em 12/2022 e estavam ativas em 08/2023",
        solidHeader = TRUE,
        collapsible = FALSE,
        width = 12,
        p("Balanço Patrimonial (4010)."),
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
              echarts4r::echarts4rOutput(ns("g_evolucao_conta"))
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

    balanco <- read.csv(app_sys("data/balanco_coop_cred_2010a2022_4010.csv"))

    updateSelectInput(
       inputId = "rs_coop",
       choices = balanco |> dplyr::select(razao_social) |> unique() |> dplyr::arrange(razao_social)
    )

    observe({
       req(input$rs_coop)
       conta <- balanco |>
          dplyr::filter(razao_social == input$rs_coop) |>
          dplyr::select(where(~ any(!is.na(.))), -ano, -cnpj, -razao_social) |>
          names() |>
          unique()

       updateSelectInput(
          inputId = "conta",
          choices = conta
       )
    })

    output$g_evolucao_conta <- echarts4r::renderEcharts4r({

       balanco |>
          dplyr::filter(razao_social == input$rs_coop) |>
          dplyr::mutate(ano = as.Date(sprintf("%s-%s-01", substr(ano, 1, 4), substr(ano, 5, 6)))) |>
          echarts4r::e_chart(x = ano) |>
          echarts4r::e_line_(serie = input$conta)
    })

  })
}

## To be copied in the UI
# mod_balancos_patrimoniais_ui("balancos_patrimoniais_1")

## To be copied in the server
# mod_balancos_patrimoniais_server("balancos_patrimoniais_1")
