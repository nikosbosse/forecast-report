#' Render a Scoring Report
#'
#' @description This function renders a country level TB report.
#' @param 
#' @param format Character string, defaults to `"html_document"`. The format to render the report to.
#' See `?rmarkdown::render` for details.
#' @param interactive Logical, defaults to `FALSE`. When the format allows should graphs be interactive.
#' @param save_dir Character string, defaults to `NULL`.
#'  If not given then the report is rendered to a temporary directory (although only if `filename` is also not given).
#' @param filename Character string defaults `NULL`. Name to save the report under, defaults to `"scoring_report"`.
#' @return Renders a scoring report
#' @export
#' @importFrom utils installed.packages
#' @examples
#'
#' ## Only run the example if in an interative session
#' \dontrun{
#'
#' ## Run the TB dashboard
#' render_country_report()
#' }
#' 
#' 


## setup -----------------------------------------------------------------------
source("load-data.R")

# evaluation options
models <- "all" # models to evaluate
# root directory for the submission files
root_dir <- "../data-processed"
load_from_server <- FALSE
locations <- c("Germany", "Poland")
forecast_dates <- c("2020-10-12", "2020-10-19", "2020-10-26", "2020-11-02", 
                    "2020-11-09", "2020-11-16", "2020-11-23")
target_types <- c("case", "death")



## load data -------------------------------------------------------------------

pred <- load_submission_files(dates = forecast_dates,
                              models = models,
                              dir = root_dir) %>%
  dplyr::filter(target_end_date >= "2020-10-17") %>%
  dplyr::select(-location)

get_data(load_from_server = load_from_server,
         country = "Germany_Poland")
obs_death <- get_data(cases = FALSE)
obs_case <- get_data()


truth_data <- dplyr::bind_rows(obs_death %>%
                                 dplyr::mutate(target_type = "death"), 
                               obs_case %>%
                                 dplyr::mutate(target_type = "case")) %>%
  dplyr::rename(true_value = value) %>%
  dplyr::filter(target_end_date > (Sys.Date() - 16 * 7))


prediction_data <- pred %>%
  dplyr::filter(type == "quantile") %>%
  dplyr::mutate(target_type = ifelse(grepl("death", target), "death", "case")) %>%
  dplyr::rename(prediction = value)









render_scoring_report <- function(format = "html_document",
                                  truth_data, 
                                  prediction_data,
                                  params = list(locations = "all", 
                                                forecast_dates = "all",
                                                horizons = "all"),
                                  categories = c("model", "location", "horizon"),
                                  include = list(show_predictions = TRUE),
                                  interactive = FALSE, 
                                  save_dir = NULL,
                                  filename = NULL) {
  
  # required_packages <- c(
  #   "rmarkdown", "magrittr", "dplyr", "tibble",
  #   "ggplot2", "tidyr", "rlang"
  # )
  # 
  # not_present <- sapply(required_packages, function(package) {
  #   not_present <- !(package %in% rownames(installed.packages()))
  #   
  #   if (not_present) {
  #     message(paste0(
  #       package,
  #       " is required to use render_scoring_report, please install it before using this function"
  #     ))
  #   }
  #   
  #   return(not_present)
  # })
  # 
  # if (any(not_present)) {
  #   stop("Packages required for this report are not installed, 
  #        please use the following code to install the required packages \n\n 
  #        install.packages(c('", paste(required_packages[not_present], collapse = "', '"), "'))")
  # }
  
  # report <- system.file("rmarkdown", "country-report.Rmd", package = "scoringutils")
  # if (report == "") {
  #   stop("Could not find the report. Try re-installing `getTBinR`.", call. = FALSE)
  # }
  
  # if (is.null(save_dir) & is.null(filename)) {
  #   save_dir <- tempdir()
  #   
  #   message("Rendering report to ", save_dir)
  # }
  # 
  # 

  
  params <- list(locations = c("Germany", "Poland"), 
                 forecast_dates = "all", 
                 horizons = c(1:4), 
                 target_types = "all")
  
  
  # purrr::map2(params, names(params), function(scoring_parameter, 
  #                                             name_param) {
  #   if (scoring_parameter[1] == "all") {
  #     prediction_data %>%
  #       dplyr::pull({{name_param}}) %>%
  #       unique()
  #   }
  # })
  
  # if (locations[1] == "all") {
  #   locations <- prediction_data$location_name %>%
  #     unique()
  # }
  # 
  if (params$forecast_dates[1] == "all") {
    params$forecast_dates <- prediction_data %>%
      dplyr::pull(forecast_date) %>%
      unique() %>%
      as.character()
  }
  if (params$target_types[1] == "all") {
    params$target_types <- prediction_data %>%
      dplyr::pull(target_type) %>%
      unique()
  }
   
  # if (horizons[1] == "all") {
  #   horizons <- prediction_data %>%
  #     dplyr::pull(horizon) %>%
  #     unique()
  # }
  
  
  
  # store and load data to generate markdown report? 
  temp_dir <- tempdir()
  saveRDS(truth_data, file = paste0(temp_dir, "/truth_data.RDS"))
  saveRDS(prediction_data, file = paste0(temp_dir, "/prediction_data.RDS"))
  saveRDS(params, file = paste0(temp_dir, "/scoring_parameters.RDS"))
  
  format = "html_document"
  
  rmarkdown::render("forecast-hub-report.Rmd",
                    output_format = format,
                    # output_file = filename,
                    # output_dir = save_dir,
                    # intermediates_dir = save_dir,
                    params = list(
                      # locations = "all",
                      # forecast_dates = "all",
                      # horizons = "all",
                      temp_dir = temp_dir
                    ),
                    envir = new.env(),
                    clean = TRUE
  )
}
