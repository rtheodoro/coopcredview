#' inicio UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_inicio_ui <- function(id){
  ns <- NS(id)
  bs4Dash::box(
     title = "Bem-vinde ao CoopCred View!",
     solidHeader = TRUE,
     collapsible = FALSE,
     width = 12,
     p("Este é um aplicado criado em Shiny utilizando Golem para o curso de Dashboard II da Curso-R."),
     p("O objetivo deste aplicativo é exibir diversas informações sobre as Cooperativas de Crédito Brasilerias."),
     p("O aplicativo ainda esta em desenvolvimento, as informações aqui não devem ser utilizadas como fonte de pesquisa.")
  )
}

#' inicio Server Functions
#'
#' @noRd
mod_inicio_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })
}

## To be copied in the UI
# mod_inicio_ui("inicio_1")

## To be copied in the server
# mod_inicio_server("inicio_1")
