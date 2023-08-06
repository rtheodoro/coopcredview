#' dist_coop UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_dist_coop_ui <- function(id){
  ns <- NS(id)

  fluidPage(
     titlePanel("Distribuição das Cooperativas de Crédito no Brasil - 08/2023"),
     hr(),
     fluidRow(column(
        width = 3,
        selectInput(
           inputId = ns("classe"),
           label = "Selecione uma classe",
           choices = ""
        )
     ),
     column(
        width = 3,
        selectInput(
           inputId = ns("indice"),
           label = "Selecione um índice",
           choices = c(
              "Número de Agências" = "numeroAgencias"
           )
        )
     )),
     fluidRow(
        column(width = 7,
               leaflet::leafletOutput(ns("mapa"))),
        column(width = 5,
               reactable::reactableOutput(ns("tabela")))
     )
  )
}

#' dist_coop Server Functions
#'
#' @noRd
mod_dist_coop_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    qtd_pac <- read.csv(app_sys("data/202308_CoopCred_BCB_numero_de_agencias.csv")) |> dplyr::select(-nome_coop)

    geo_estados <- readRDS(app_sys("data/geo_estados.rds"))

    info_gerais <- read.csv(app_sys("data/202308_CoopCred_BCB_info_gerais.csv")) |>
       dplyr::select(-regimeEspecial, -ato_presi, -nome_Liquidante, -telefone_ddd, -telefone_numero, -filiacao, -filiacao_central) |>
       dplyr::mutate(matriz_filial = "M") |>
       dplyr::left_join(qtd_pac, by = "cnpj") |>
       dplyr::select(cnpj, nome_coop, numeroAgencias, classe, municipio, uf)

    rede_atendimento <- read.csv(app_sys("data/202308_CoopCred_BCB_rede_atendimento.csv")) |>
       dplyr::select(cnpj, municipio, uf) |>
       dplyr::mutate(matriz_filial = "F") |>
       dplyr::left_join(info_gerais |> dplyr::select(cnpj, nome_coop))

    updateSelectInput(
       inputId = "classe",
       choices = info_gerais |> dplyr::select(classe) |> unique()
    )


    info_gerais_filtrada <- reactive({
       info_gerais |>
          dplyr::filter(classe == input$classe)
    })

    output$mapa <- leaflet::renderLeaflet({
       tab <- info_gerais_filtrada() |>
          dplyr::group_by(uf) |>
          dplyr::summarise(quantidade_media = mean(.data[[input$indice]], na.rm = TRUE)) |>
          dplyr::right_join(geo_estados,
                            by = c("uf" = "abbrev_state")) |>
          sf::st_as_sf()

       pegar_cor <- leaflet::colorNumeric(palette = rev(viridis::plasma(8)),
                                          domain = tab$quantidade_media)

       tab |>
          leaflet::leaflet() |>
          leaflet::addTiles() |>
          leaflet::addPolygons(
             fillColor = ~ pegar_cor(quantidade_media),
             color = "black",
             weight = 1,
             fillOpacity = 0.8,
             label = ~ name_state,
             layerId = ~ uf
          ) |>
          leaflet::addLegend(
             pal = pegar_cor,
             values = ~ quantidade_media,
             opacity = 0.7,
             title = NULL,
             position = "bottomright"
          )

    })

    output$tabela <- reactable::renderReactable({
       estado <- input$mapa_shape_click$id

       validate(need(
          !is.null(estado),
          glue::glue(
             "Clique em um estado para ver os 10 municípios com o maior {input$indice}."
          )
       ))

       info_gerais_filtrada() |>
          dplyr::filter(uf == estado) |>
          dplyr::arrange(desc(.data[[input$indice]])) |>
          dplyr::slice(1:10) |>
          dplyr::select(cnpj,
                        nome_coop,
                        municipio,
                        uf,
                        input$indice) |>
          reactable::reactable()

    })



  })
}

## To be copied in the UI
# mod_dist_coop_ui("dist_coop_1")

## To be copied in the server
# mod_dist_coop_server("dist_coop_1")
