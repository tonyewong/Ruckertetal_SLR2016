###################################################################################
#
#  -file = "sealevel_VR_2009.R"   Code written March 2014
#  - Author: Kelsey Ruckert (klr324@psu.edu)
#
#  -This function sources the Vermeer and Rahmstorf (2009) model to be sourced into the uncertainty methods as described
#       in Ruckert et al. (2016). For further
#       description and references, please read the paper.
#
# THIS CODE IS PROVIDED AS-IS WITH NO WARRANTY (NEITHER EXPLICIT
# NOT IMPLICIT).  I SHARE THIS CODE IN HOPES THAT IT IS USEFUL,
# BUT I AM NOT LIABLE FOR THE BEHAVIOR OF THIS CODE IN YOUR OWN
# APPLICATION.  YOU ARE FREE TO SHARE THIS CODE SO LONG AS THE
# AUTHOR(S) AND VERSION HISTORY REMAIN INTACT.
#
# To use this function, simply source this file:
#   source("sealevel_VR_2009.R")
#
###################################################################################

VR_SL_model = function(parameters, Temp){ #inputs are parameters and temperature
  model.p = length(parameters) #number of parameters in the model
  a = parameters[1] # sensitivity of sea-level to temperature changes
  Ti = parameters[2] # temperature when sea-level is zero
  initialvalue = parameters[3] # initial value of sea-level in 1880
  b = parameters[4] # rapid response of sea-level term
  
  # Estimate the rate of temperature change with smoothing
  temp.dif = diff(Temp)
  temprate = rep(NA,to)
  
  for(i in 2:(length(Temp)-1)){
    temprate[i] = 0.5*(temp.dif[i-1] + temp.dif[i])
  }
  temprate[1] = temp.dif[1] - (0.5*(temp.dif[2] - temp.dif[1]))
  temprate[length(Temp)] = temp.dif[length(Temp)-1] + (0.5*(temp.dif[length(Temp)-1] - temp.dif[length(Temp)-2]))
  
  # Estimate the rate of sea-level change each year
  rate = a*(Temp - Ti) + b*temprate 
  values = rep(NA,to)
  values[1] = initialvalue
  
  #Run a forward euler to estimate sea-level over time
  for(i in from:to){
    values[i] = values[i-1]+rate[i-1]*timestep
  }
  #return sea-level, sea-level rates, and number of parameters
  return(list(sle = values, slrate = rate, trate = temprate, model.p = model.p))
}

################################### END ##########################################
