#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
   tagList(
      # Leave this function for adding external resources
      golem_add_external_resources(),
      # Your application UI logic
      bs4Dash::bs4DashPage(
         bs4Dash::bs4DashNavbar(
            title = tags$div(tags$img(src="www/logo_coopcreview.png", alt = "logo", width = 40, height = 40),
                              tags$strong("CoopCred View"),
                              class = "titulo_logo")
           ),
         bs4Dash::bs4DashSidebar(
            bs4Dash::bs4SidebarMenu(

               bs4Dash::bs4SidebarMenuItem(text = "Início",
                                           tabName = "inicio"),
               bs4Dash::bs4SidebarMenuItem(text = "Informações Financeiras",
                                           tabName = "anbalancos"),
               bs4Dash::bs4SidebarMenuItem(
                  text = "Estrutura de Governança",
                  bs4Dash::bs4SidebarMenuSubItem(text = "Informações Gerais",
                                                 tabName = "infogerais"),
                  bs4Dash::bs4SidebarMenuSubItem(text = "Órgãos Estatutários",
                                                 tabName = "orgest"),
                  bs4Dash::bs4SidebarMenuSubItem(text = "Auditoria",
                                                 tabName = "auditoria")
               ),
               bs4Dash::bs4SidebarMenuItem(text = "Distribuição das Coop. Créd.",
                                           tabName = "districoop")
            )
         ),

         bs4Dash::bs4DashBody(bs4Dash::bs4TabItems(
            bs4Dash::bs4TabItem(tabName = "inicio",
                                mod_inicio_ui("inicio_1")),
            bs4Dash::bs4TabItem(tabName = "anbalancos",
                                mod_balancos_patrimoniais_ui("balancos_patrimoniais_1")),
            bs4Dash::bs4TabItem(tabName = "infogerais",
                                mod_info_gerais_ui("info_gerais_1")),
            bs4Dash::bs4TabItem(tabName = "orgest",
                                mod_estrut_gov_ui("estrut_gov_1")),
            bs4Dash::bs4TabItem(tabName = "auditoria",
                                mod_auditoria_ui("auditoria_1")),
            bs4Dash::bs4TabItem(tabName = "districoop",
                                 mod_dist_coop_ui("dist_coop_1"))
         ))
      )
   )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(ext = 'png'),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "coopcredview"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
