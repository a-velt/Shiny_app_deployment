#' Shiny application
#'
#' This function allows to launch the shiny app and open a web browser with the application available
#' @param - no param for this function
#' @export
#' @examples shiny_application()
shiny_application <- function() { 
	appDir <- system.file("hackathon_application", package = "hackathon")
	shiny::runApp(appDir, host='0.0.0.0', port=3838)
}

