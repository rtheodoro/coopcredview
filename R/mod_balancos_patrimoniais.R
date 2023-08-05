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
        title = tippy::tippy("Visualização de informações financeiras das Cooperativas de Crédito", "Que enviaram seus balanços em 12/2022 e estavam ativas em 08/2023"),
        solidHeader = TRUE,
        collapsible = FALSE,
        width = 12,
        p(tippy::tippy("Balanço Patrimonial (4010).", "Consulte em: https://www.bcb.gov.br/acessoinformacao/legado?url=https:%2F%2Fwww4.bcb.gov.br%2Ffis%2Fcosif%2Fbalancetes.asp",  placement = "right")),
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
          dplyr::select(where(~ any(!is.na(.))), -ano, -cnpj, -razao_social, -cooperativa) |>
          names() |>
          unique()

       updateSelectInput(
          inputId = "conta",
          choices = conta
       )
    })

    output$g_evolucao_conta <- echarts4r::renderEcharts4r({

       balanco |>
          dplyr::filter(cooperativa == input$rs_coop) |>
          echarts4r::e_chart(x = ano) |>
          echarts4r::e_line_(serie = input$conta)
    })

  })
}

## To be copied in the UI
# mod_balancos_patrimoniais_ui("balancos_patrimoniais_1")

## To be copied in the server
# mod_balancos_patrimoniais_server("balancos_patrimoniais_1")
