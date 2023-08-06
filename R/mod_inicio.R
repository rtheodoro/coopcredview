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
     title = tags$strong("Bem-vinde ao CoopCred View"),
     solidHeader = TRUE,
     collapsible = FALSE,
     width = 12,
     p("Este é um aplicativo criado em {Shiny} utilizando {Golem} para o curso de Dashboard II da ", tags$a("Curso-R.", href = "https://curso-r.com/", target = "_blank")),
     p("O objetivo deste aplicativo é exibir diversas informações sobre as Cooperativas de Crédito Brasilerias, disponibilizadas pelo Bacen em 08/2023."),
     p("O aplicativo ainda esta em desenvolvimento, ", tags$strong("as informações aqui não devem ser utilizadas como fonte de pesquisa.")),
     tags$div(
        tags$h6(tags$strong("Repositórios utilizados:")),
        tags$ul(
           tags$li("Código deste app:", tags$a("https://github.com/rtheodoro/coopcredview", href = "https://github.com/rtheodoro/coopcredview", target = "_blank")),
           tags$li("Código do webscraping dos Órgãos Estatutários:", tags$a("https://github.com/rtheodoro/orgaos-estatutarios-coop-cred-bacen", href = "https://github.com/rtheodoro/orgaos-estatutarios-coop-cred-bacen", target = "_blank")),
           tags$li("Código do webscraping dos Balanços Patrimoniais:", tags$a("https://github.com/rtheodoro/webscraping-balancos-patrimoniais-de-coop-cred", href = "https://github.com/rtheodoro/webscraping-balancos-patrimoniais-de-coop-cred", target = "_blank")),
           tags$li("Fique a vontade para contribuir e deixar a estrelinha! :D")
        )
     ),
     tags$div(
        tags$h6(tags$strong("Próximos passos:")),
        tags$ul(
           tags$li("Não consegui adicionar a logo ao lado de CoopCred View (o favicon esta o antigo também)."),
           tags$li("Item 1: Melhorar a visualização dos balanços. Não estou conseguindo adicionar duas ou mais contas no eixo Y."),
           tags$li("Item 2: Melhorar mapa."),
           tags$li("Item 3: Adicionar informações dos auditores independentes."),
           tags$li("Item 4: Adicionar informações do IF Data."),
           tags$li("Item 5: Cruzar informações das tabelas"),
           tags$li("Item 6: Cruzar informações com a base de CNPJ da RFB"),
           tags$li("Item 7: Cruzar informações com a base de CNPJ da RAIS")
        )
     ),
     p(tags$strong("Contato:"), "rtheodoro@usp.br")

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
