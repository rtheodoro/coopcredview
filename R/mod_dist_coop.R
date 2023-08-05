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
  bs4Dash::box(
     title = "Mapa das Cooperativa de Crédito em 08/2023",
     leaflet::leafletOutput(ns("mapa"))
  )
}

#' dist_coop Server Functions
#'
#' @noRd
mod_dist_coop_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    localizacao_coop <- read.csv(app_sys("data/202308_CoopCred_BCB_info_gerais.csv")) |>
       dplyr::select(municipio, uf)

    output$mapa <- leaflet::renderLeaflet({
       leaflet::leaflet(data = localizacao_coop)  |>
          leaflet::addTiles()  |>
          leaflet::addMarkers(
             lng = ~Longitude,
             lat = ~Latitude,
             popup = ~Cidade
          )
    })


  })
}

## To be copied in the UI
# mod_dist_coop_ui("dist_coop_1")

## To be copied in the server
# mod_dist_coop_server("dist_coop_1")
