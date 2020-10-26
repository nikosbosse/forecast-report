#' @title Load Forecast Hub Submission Files
#'
#' @description
#' Load forecasts from one of the forecast hubs.
#'
#' @param dir the root directory in which the forcasts lie. The root folder
#' is usually namesd "data-processed" if you just cloned the Forecast Hub repo.
#' @param dates select either "all" (default), "latest" or a vector with
#' specific dates
#' @param num_last number of last forecasts to laod. Works with "all" or with
#' a specific date.
#' @param models either "all" or a vector with model names
#' @param drop_latest_forecast drops most recent forecast. Default is FALSE
#' @return A data.frame with all loaded forecasts
#' @export
#'

load_submission_files <- function(dir,
                                  dates = c("all", "latest"),
                                  num_last = NULL,
                                  models = c("all"),
                                  drop_latest_forecast = FALSE) {
  
  if (models[1] == "all") {
    model_names <- list.files(dir)
  } else {
    model_names <- models
  }
  
  
  
  load_model_files <- function(model_name, location, case) {
    
    files <- list.files(here::here(dir, model_name))
    files <- files[grepl(".csv", files)]
    files <- files[grepl(location, files)]
    
    if (case) {
      files <- files[grepl("-case", files)]
    } else {
      files <- files[!grepl("-case", files)]
    }
    
    files <- sort(files, decreasing = TRUE)
    
    if (length(files) == 0) {
      return(NULL)
    }
    
    if (as.character(dates[1]) == "all") {
      # if num_last is specified, only fetch the last num_last
      if (!is.null(num_last)) {
        files <- files[1:min(num_last, length(files))]
      }
      # dates == "latest"
    } else if (as.character(dates[1]) == "latest") {
      
      # if num_last is specified, also fetch the last num_last
      if (is.null(num_last)) {
        num_last = 0
      }
      n <- length(files)
      files <- files[(n - num_last):n]
      # dates are specifically given
    } else {
      dates_available <- as.Date(substr(files, 1, 10))
      index <- 1:length(dates_available)
      index <- index[as.character(dates_available) %in% as.character(dates)]
      
      # only makes sense if only a single file was given
      if (!is.null(num_last)) {
        if (length(index) > 1) {
          stop("if you use num_last, you should only provide one date or 'latest'")
        }
        
        files <- files[min(1, index - num_last):index]
      } else {
        files <- files[index]
      }
    }
    
    if (drop_latest_forecast) {
      files <- files[-length(files)]
    }
    
    file_paths <- here::here(dir, model_name, files)
    
    forecasts <- purrr::map_dfr(file_paths,
                                .f = function(x) {
                                  df <- data.table::fread(x)
                                  df[, location := as.character(location)]
                                  return(df)}) %>%
      dplyr::mutate(model = model_name) %>%
      dplyr::filter(grepl("inc", target),
                    grepl("wk", target))
    
    return(forecasts)
  }
  
  locations <- c("Germany", "Poland")
  
  forecasts <- list()
  for (loc in locations) {
    for (case in c(TRUE, FALSE)) {
      forecasts[[paste0(loc, case)]] <- purrr::map_dfr(model_names,
                                         .f = function(x) {
                                           load_model_files(x, location = loc, case = case)
                                         })
    }
  }
  
  # Join forecasts ----------------------------------------------------------
  # and add state names
  forecasts <- data.table::rbindlist(forecasts)
  
  # unclear bug where there seems to be a numerical error somewhere
  forecasts[, quantile := round(quantile, 3)]
  forecasts[, horizon := as.numeric(stringi::stri_extract_first_regex(target,
                                                                      "[0-9]+"))]
  
  return(forecasts)
}









library(tibble)
library(dplyr)

dates_to_epiweek <- function(df){
  
  seq <- tibble::tibble(date = unique(df$date),
                        epiweek = lubridate::epiweek(as.Date(date)),
                        day = weekdays(as.Date(date)))
  
  epiweek_end_date <- seq %>%
    dplyr::filter(day == "Saturday")
  
  epiweek_complete <- seq %>%
    dplyr::group_by(epiweek) %>%
    dplyr::count() %>%
    dplyr::filter(n == 7) %>%
    dplyr::left_join(epiweek_end_date, by = "epiweek")
  
  df_dated <- df %>%
    dplyr::mutate(epiweek = lubridate::epiweek(as.Date(date)),
                  epiweek_end = date %in% epiweek_end_date$date,
                  epiweek_full = epiweek %in% epiweek_complete$epiweek)
  
  return(df_dated)
}





#' @title Get Truth Data from Forecast Hub Repos
#'
#' @description
#' Load forecasts from one of the forecast hubs.
#'
#' @param load_from_server Load data from Server (default is FALSE)
#' @param cumulative = FALSE
#' @param cases = TRUE
#' @param country = "Germany_Poland"
#' @param weekly = TRUE
#' @return A data.frame with all loaded forecasts
#' @export
#'

get_data <- function(load_from_server = FALSE, 
                     cumulative = FALSE,
                     cases = TRUE,
                     country = "Germany_Poland",
                     weekly = TRUE) {
  
  if (load_from_server) {
    
    # country is US
    if (country == "US") {
      incident_cases <- readr::read_csv("https://github.com/reichlab/covid19-forecast-hub/blob/master/data-truth/truth-Incident%20Cases.csv?raw=true")
      incident_deaths <- readr::read_csv("https://github.com/reichlab/covid19-forecast-hub/blob/master/data-truth/truth-Incident%20Deaths.csv?raw=true")
      
      if (!weekly) {
        # we only need cumulative data if we don't sum up anyway. Could in principle also drop cumulative data entirely
        cumulative_cases <- readr::read_csv("https://github.com/reichlab/covid19-forecast-hub/blob/master/data-truth/truth-Cumulative%20Cases.csv?raw=true")
        cumulative_deaths <- readr::read_csv("https://github.com/reichlab/covid19-forecast-hub/blob/master/data-truth/truth-Cumulative%20Deaths.csv?raw=true")
      }
      
      # country not US
    } else if (country == "Germany_Poland") {
      incident_cases <- data.table::rbindlist(list(
        readr::read_csv("https://github.com/KITmetricslab/covid19-forecast-hub-de/raw/master/data-truth/ECDC/truth_ECDC-Incident%20Cases_Germany.csv"), 
        readr::read_csv("https://github.com/KITmetricslab/covid19-forecast-hub-de/raw/master/data-truth/ECDC/truth_ECDC-Incident%20Cases_Poland.csv")
      ))
      cumulative_cases <- data.table::rbindlist(list(
        readr::read_csv("https://github.com/KITmetricslab/covid19-forecast-hub-de/raw/master/data-truth/ECDC/truth_ECDC-Cumulative%20Cases_Germany.csv"), 
        readr::read_csv("https://github.com/KITmetricslab/covid19-forecast-hub-de/raw/master/data-truth/ECDC/truth_ECDC-Cumulative%20Cases_Poland.csv")
      ))
      incident_deaths <- data.table::rbindlist(list(
        readr::read_csv("https://github.com/KITmetricslab/covid19-forecast-hub-de/raw/master/data-truth/ECDC/truth_ECDC-Incident%20Deaths_Germany.csv"), 
        readr::read_csv("https://github.com/KITmetricslab/covid19-forecast-hub-de/raw/master/data-truth/ECDC/truth_ECDC-Incident%20Deaths_Poland.csv")
      ))
      cumulative_deaths <- data.table::rbindlist(list(
        readr::read_csv("https://github.com/KITmetricslab/covid19-forecast-hub-de/raw/master/data-truth/ECDC/truth_ECDC-Cumulative%20Deaths_Germany.csv"), 
        readr::read_csv("https://github.com/KITmetricslab/covid19-forecast-hub-de/raw/master/data-truth/ECDC/truth_ECDC-Cumulative%20Deaths_Poland.csv")
      ))
    }
    
    # write incident cases and deaths
    
    if (!dir.exists(here::here("data"))) {
      dir.create(here::here("data"))
    }
    
    data.table::fwrite(incident_cases, here::here("data", paste0("daily-incidence-cases-", country, ".csv")))
    data.table::fwrite(incident_deaths, here::here("data", paste0("daily-incidence-deaths-", country, ".csv")))
    
    data.table::fwrite(cumulative_cases, here::here("data", paste0("daily-cumulative-cases-", country, ".csv")))
    data.table::fwrite(cumulative_deaths, here::here("data", paste0("daily-cumulative-deaths-", country, ".csv")))
    
    # don't return anything if you reload data from server
    return(NULL)
    
    # ----------------------------------------------------------------------------
    # if not load from server
  } else {
    incident_cases <- data.table::fread(here::here("data", paste0("daily-incidence-cases-", country, ".csv")))
    incident_deaths <- data.table::fread(here::here("data", paste0("daily-incidence-deaths-", country, ".csv")))
    
    # cumulative cases are only relevant for daily data. for weekly, they get computed
    # could in principle just omit that and have cumulative computed as well. 
    # leaving it as we actually have ground truth data available
    if (!weekly) {
      cumulative_cases <- data.table::fread(here::here("data", paste0("daily-cumulative-cases-", country, ".csv")))
      cumulative_deaths <- data.table::fread(here::here("data", paste0("daily-cumulative-deaths-", country, ".csv")))
    }
  }
  
  if (weekly) {
    # cases
    if (cases) {
      incident_cases_weekly <- incident_cases %>%
        dates_to_epiweek() %>% 
        dplyr::filter(epiweek_full == TRUE) %>% 
        dplyr::group_by(location, location_name, epiweek) %>%
        dplyr::summarise(value = sum(value), 
                         target_end_date = max(date))
      if (cumulative) {
        cumulative_cases_weekly <- incident_cases_weekly %>%
          dplyr::mutate(value = cumsum(value))
        return(cumulative_cases_weekly)
      } else {
        return(incident_cases_weekly)
      }
      
      # deaths
    } else {
      incident_deaths_weekly <- incident_deaths %>%
        dates_to_epiweek() %>% 
        dplyr::filter(epiweek_full == TRUE) %>% 
        dplyr::group_by(location, location_name, epiweek) %>%
        dplyr::summarise(value = sum(value), 
                         target_end_date = max(date))
      if (cumulative) {
        cumulative_deaths_weekly <- incident_deaths_weekly %>%
          dplyr::mutate(value = cumsum(value))
        return(cumulative_deaths_weekly)
      } else {
        return(incident_deaths_weekly)
      }
    }
  }
  
  # if not weekly
  if (cases) {
    if (cumulative) {
      return(cumulative_cases)
    } else {
      return(incident_cases)
    }
  } else {
    if (cumulative) {
      return(cumulative_deaths)
    } else {
      return(incident_deaths)
    }
  }
}



