library(shiny.router)
source("pages.R")

router <- router_ui(
  route("/", home_page),
  route("settings", settings_page),
  route("contact", contact_page)
)
