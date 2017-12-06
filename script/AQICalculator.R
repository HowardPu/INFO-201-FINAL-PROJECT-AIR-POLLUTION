library("dplyr")

# An air quality index (AQI) is a number used by government agencies to communicate to the public 
# how polluted the air currently is or how polluted it is forecast to become
# (See https://en.wikipedia.org/wiki/Air_quality_index)

# The formula of calculating AQI is from this website
# (http://www.ciese.org/curriculum/bus/newhaven/9/lesson1/)

# For the AQI breakpoints, we decided to follow the US standard, which has 
# been summarized by Environmental Protection Agency (EPA)
# AQI breakpoint : (https://aqs.epa.gov/aqsweb/documents/codetables/aqi_breakpoints.html)

# And our AQI breakpoints is modified from the previous AQI breakpoint in such a way that
# modication can simplify the overall program complexity and enhance the calculation performance.

# Take the data frame of api index breakpoint, the name of the pollutant, and concentration as input
# return the Aqi index corresponds to given concentartion
AqiCalculator <- function(aqi.breakpoint, pollutant.name, concentration) {
  parameters <- filter(aqi.breakpoint, Parameter == pollutant.name & 
                       concentration >= Low.Breakpoint & concentration <= High.Breakpoint)
  numerator <- parameters$High.AQI - parameters$Low.AQI
  denominator <- parameters$High.Breakpoint - parameters$Low.Breakpoint
  coefficient <- concentration - parameters$Low.Breakpoint
  aqi <- numerator / denominator * coefficient + parameters$Low.AQI
  return(aqi)
}

# return the list of api of a list of concentration
# Note: since when we use lapply, the filter inside AqiCalculator can produce error
<<<<<<< HEAD
#       and therefore iteraterion in this program is necessary.
=======
#       and therefore we have to use iteraterion.
>>>>>>> 10c9d9804041fe50a68fde4aa0c1ec7e78d4df2b
AqiCalculatorWithList <- function(aqi.breakpoint, pollutant.name, list) {
  index <- 1
  result <- c(AqiCalculator(aqi.breakpoint, pollutant.name, list[1]))
  while(index < length(list)) {
    index <- index + 1
    result <- c(result, AqiCalculator(aqi.breakpoint, pollutant.name, list[index]))
  }
  return(result)
}
