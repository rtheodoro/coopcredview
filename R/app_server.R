#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
   mod_inicio_server("inicio_1")
   mod_balancos_patrimoniais_server("balancos_patrimoniais_1")
   mod_dist_coopcred_server("dist_coopcred_1")

}
