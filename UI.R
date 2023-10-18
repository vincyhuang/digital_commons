# Digital Commons v1.0
# function.R

library(shiny)
library(shinydashboard)


ui <- dashboardPage(
  dashboardHeader(
    title = "CDC Digital Commons"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Main Page", tabName = "main"),
      menuItem("Health", tabName = "health"),
      menuItem("Age Distribution", tabName = "age"),
      menuItem("Employment", tabName = "employment"),
      # menuItem("Transportation", tabName = "transportation"),
      # menuItem("Child", tabName = "child"),
      # menuItem("Air Quality", tabName = "air"),
      # menuItem("Crime", tabName = "crime"),
      menuItem("Other websites", tabName = "linkpage"),
      menuItem("Data Uploading", tabName = "upload")
    )
  ),
  dashboardBody(
    tabItems(
    # Main ####
      tabItem(tabName = "main",
        fluidPage(
            wellPanel(   
              h2("Data Overview"),
              fluidRow(
                valueBoxOutput("Datasets", width = 3),
                valueBoxOutput("MainAgeGroup", width = 3), 
                valueBoxOutput("MainBorough", width = 3), 
                valueBoxOutput("MainYear", width = 3))
                    ), #wellPanel
            h2("Data Type"),
                   wellPanel(
                     fluidRow(
                       column(width = 3, height = 3,
                             HTML('<div style="text-align:center;"> 
                                    <img src="./images/medical.svg" width="100" height="100">
                                     <p style="font-size: 20px;">Health</p>
                                    </div>')  
                       ), #column
                       column(width = 3,height = 3,

                              HTML('<div style="text-align:center;"> 
                                    <img src="./images/education.svg" width="100" height="100">
                                     <p style="font-size: 20px;">Age Distribution</p>
                                    </div>')  
                       ), #column
                       column(width = 3,height = 3,
                                   
                                     HTML('<div style="text-align:center;"> 
                                    <img src="./images/transportation.svg" width="100" height="100">
                                    <p style="font-size: 20px;">Transportation</p>
                                    </div>')  
                       ), #column
                       column(width = 3,height = 3,
                              HTML('<div style="text-align:center;"> 
                                    <img src="./images/equality.svg" width="100" height="100">
                                    <p style="font-size: 20px;">Employment</p>
                                    </div>')  
                       ) #column
                     ), # fluidRow
                     fluidRow(
                       column(width = 3, height = 3,
                              HTML('<div style="text-align:center;"> 
                                    <img src="./images/child.svg" width="100" height="100">
                                     <p style="font-size: 20px;">Child</p>
                                    </div>')  
                       ), #column
                       column(width = 3,height = 3,
                              
                              HTML('<div style="text-align:center;"> 
                                    <img src="./images/air.svg" width="100" height="100">
                                     <p style="font-size: 20px;">Air Quality</p>
                                    </div>')  
                       ), #column
                       column(width = 3,height = 3,
                              
                              HTML('<div style="text-align:center;"> 
                                    <img src="./images/house.svg" width="100" height="100">
                                    <p style="font-size: 20px;">Housing Stock</p>
                                    </div>')  
                       ), #column
                       column(width = 3,height = 3,
                              HTML('<div style="text-align:center;"> 
                                    <img src="./images/crime.svg" width="100" height="100">
                                    <p style="font-size: 20px;">Crime</p>
                                    </div>')  
                       ) #column
                     ) # fluidRow
                    ), # wellPanel
            wellPanel(
              h2("Map is underdevelopment"),
              fluidRow(
                      leafletOutput('map')
              ) # fluidRow
            ) # wellPage
             ) #fluidpage
      ), #tabItem
      
      # HEALTH ####
      tabItem(tabName = "health",
              fluidPage(
              box(width = 12, 
                  selectInput("hour", "Filter:", 
                              choices = c("night-time", "day-time"),
                              multiple = TRUE,
                              selected = c("night-time", "day-time")),
                  title = "Hospital admission caused by violence by hour", collapsible = T, 
                  plotlyOutput("hospital_adimission_hour"),
                  downloadLink('download_hospital_hour', 'Download data - Hospital admission caused by violence by hour')
                  ),
              
              box(width = 12, 
                  selectInput("day", "",
                              choices = c("weekday", "weekend"),
                              multiple = TRUE,
                              selected = c("weekday", "weekend")),
                  title = "Hospital admission caused by violence by day", collapsible = T,   
                  plotlyOutput("hospital_adimission_day"),
                  downloadLink('download_hospital_day', 'Download data - Hospital admission caused by violence by day')
                  ),
              
              box(width = 12, 
                  selectInput("month", "",
                              choices = c("Q1", "Q2", "Q3", "Q4"),
                              multiple = TRUE,
                              selected = c("Q1", "Q2", "Q3", "Q4")),
                  title = "Hospital admission caused by violence by month", collapsible = T,   
                  plotlyOutput("hospital_adimission_month"),
                  downloadLink('download_hospital_month', 'Download data - Hospital admission caused by violence by month')
                )
              )# fluidPage
      ), #tabItem
    
    # AGE ####
    tabItem(tabName = "age",
            fluidPage(
              h4(textOutput("age_median")),
              box(width = 12, 
                  selectInput("age_gender", "Filter:", 
                              choices = c("Male", "Female"),
                              multiple = TRUE,
                              selected =  c("Male", "Female")),
                  title = "Age Distribution", collapsible = T, 
                  plotlyOutput("age_distribution"),
                  downloadLink('download_age', 'Download data - Age distribution')
              )
            )# fluidPage
    ), #tabItem
    # EMPLOYMENT ####
    tabItem(tabName = "employment",
            fluidPage(
              h4(textOutput("employment")),
              box(width = 12, 
                  title = "Occupation", collapsible = T, 
                  plotOutput("occupation"),
                  downloadLink('download_occupation', 'Download data - Occupation')
              )
            )# fluidPage
    ), #tabItem
    
    # HYPERLINK page ####
    tabItem(tabName = "linkpage",
            fluidPage(
              dataTableOutput("link")
            )
          ), #tabItem
    # Datasets uploading page ####
    tabItem(tabName = "upload",
    h3('fill in the below form to submit the dataset profile'),
    br(),
    fileInput("file_upload", NULL, buttonLabel = "Upload...", multiple = TRUE, accept = c(".csv", ".xlsx"))
    # ,
    # dataTableOutput("data_uploaded")
    ) #tabItem
  ) # tabItems
) #dashboardBody
) #dashboardPage


