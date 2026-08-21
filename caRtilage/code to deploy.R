# Load required package
library(rsconnect)

# set account information
rsconnect::setAccountInfo(name='andersjensen14',
                          token='65F3C1AB0D09A281E15DDE8E14128461',
                          secret='LY/2JPzSw89SFRP99qH2nVEa+RaZ+ITJvA49F5ZM')

# Deploy the app
deployApp(appDir = "X:/Protein Atlas Data/Tissues/Tendon/Tendon Shiny App/")

# See where it went wrong
rsconnect::showLogs(appPath = "X:/Protein Atlas Data/Tissues/Tendon/Tendon Shiny App/")


