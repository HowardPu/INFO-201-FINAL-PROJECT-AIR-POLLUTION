library("dplyr")


# Take the data frame of api index breakpoint, the name of the pollutant, and concentration as input
# return the Aqi index corresponds to given concentartion
AqiCalculator <- function(api.breakpoint, pollutant.name, concentration) {
  parameters <- filter(api.breakpoint, Parameter == pollutant.name & 
                       concentration >= Low.Breakpoint & concentration <= High.Breakpoint)
  numerator <- parameters$High.AQI - parameters$Low.AQI
  denominator <- parameters$High.Breakpoint - parameters$Low.Breakpoint
  coefficient <- concentration - parameters$Low.Breakpoint
  aqi <- numerator / denominator * coefficient + parameters$Low.AQI
  return(aqi)
}

# return the list of api of a list of concentration
# Note: since when we use lapply, the filter inside AqiCalculator can produce error
#       and therefore we have to use iteraterion.
AqiCalculatorWithList <- function(api.breakpoint, pollutant.name, list) {
  index <- 1
  result <- c(ApiCalculator(api.breakpoint, pollutant.name, list[1]))
  while(index < length(list)) {
    index <- index + 1
    result <- c(result, ApiCalculator(api.breakpoint, pollutant.name, list[index]))
  }
  return(result)
}