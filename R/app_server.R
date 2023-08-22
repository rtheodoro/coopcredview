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
   mod_info_gerais_server("info_gerais_1")
   mod_estrut_gov_server("estrut_gov_1")
   mod_auditoria_server("auditoria_1")
   mod_dist_coop_server("dist_coop_1")

}
