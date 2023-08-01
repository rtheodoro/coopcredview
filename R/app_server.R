#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
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

}
