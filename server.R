# Digital Commons v1.0
# Server.R

function(input, output) {
  
  # Main page ####
    
    output$Age_group <- renderText({
     t = uniqueN(unique(dt$Age_group))
    })
    
    output$Datasets <- renderValueBox({
      valueBox(
        2L,
       "Datasets",
        icon = icon('database'),#icon("sign-in"),
        color = "blue"
      )
    })
    
    output$MainAgeGroup <- renderValueBox({
      valueBox(
        18L,
        "Age group",
        icon = icon('users'),#icon("sign-in"),
        color = "maroon"
      )
    })

    output$MainBorough <- renderValueBox({
      valueBox(
        1L,
        "Metropolitan Borough",
        icon = icon('map'),#icon("sign-in"),
        color = "yellow"
      )
    })

    output$MainYear <- renderValueBox({
      valueBox(
        1L,
        "Year",
        icon = icon('calendar'), #icon("sign-out"),
        color = "teal"
      )
    })
 
    # HEALTH ####
    
    dt1 <- reactive({
      if(('day-time' %in% input$hour) && ("night-time" %in% input$hour)) {
      filtered_data = dt_hospital_by_hour
      } else if ('day-time' %in% input$hour) {
        filtered_data = dt_hospital_by_hour[ time >= 7 & time <= 23]
      } else if("night-time" %in% input$hour) {
        filtered_data = dt_hospital_by_hour[ time >= 0 & time <= 6]
      } 
      return(filtered_data)
    })
    
    output$hospital_adimission_hour <- renderPlotly({
      
      plot_ly(data = dt1(), x = ~time, y = ~count, color = ~region, type = "scatter", mode = "lines") %>%
        layout(title = "Hospital admission by hour",
               xaxis = list(title = "Time", dtick = 1),
               yaxis = list(title = "Count"))
      
    })
    
    dt2 <- reactive({
      if(('weekday' %in% input$day) && ("weekend" %in% input$day)) {
        filtered_data = dt_hospital_by_day
      } else if ('weekday' %in% input$day) {
        filtered_data = dt_hospital_by_day[day %in% 
                                              c("Mon", "Tues", 'Wed', 'Thu', 'Fri')]
      } else  if("weekend" %in% input$day) {
        filtered_data = dt_hospital_by_day[day %in% 
                                              c("Sat", "Sun")]
      }
      return(filtered_data)
    })
    
    output$hospital_adimission_day <- renderPlotly({
      
      plot_ly(data = dt2(), x = ~day, y = ~count, color = ~region, type = "scatter", mode = "lines") %>%
        layout(title = "Hospital admission by day",
               xaxis = list(title = "Day"),
               yaxis = list(title = "Count"))
      
    })
    
    dt3 <- reactive({
      if(('Q1' %in% input$month) && ("Q2" %in% input$month) && ('Q3' %in% input$month) && ("Q4" %in% input$month)) {
        filtered_data = dt_hospital_by_month
      } else if ('Q1' %in% input$month) {
        filtered_data = dt_hospital_by_month[month %in% 
                                             c("1", "2", '3')]
      } else  if("Q2" %in% input$month) {
        filtered_data = dt_hospital_by_month[month %in% 
                                               c("4", "5", '6')]
      } else if ('Q3' %in% input$month) {
        filtered_data = dt_hospital_by_month[month %in% 
                                               c("7", "8", '9')]
      } else  if("Q4" %in% input$month) {
        filtered_data = dt_hospital_by_month[month %in% 
                                               c("10", "11", '12')]
      }
      return(filtered_data)
    })
    
    output$hospital_adimission_month <- renderPlotly({
      
      plot_ly(data = dt3(), x = ~month, y = ~count, color = ~region, type = "scatter", mode = "lines") %>%
        layout(title = "Hospital admission by month",
               xaxis = list(title = "Month"),
               yaxis = list(title = "Count"))
      
    })
    
    #downloaddata ####
    output$download_hospital_hour <- downloadHandler(
      filename = function() {
        paste('hospital_admission_hour-', Sys.Date(), '.csv', sep='')
      },
      content = function(con) {
        write.csv(dt_hospital_by_hour, con)
      }
    )
    
    output$download_hospital_day <- downloadHandler(
      filename = function() {
        paste('hospital_admission_day-', Sys.Date(), '.csv', sep='')
      },
      content = function(con) {
        write.csv(dt_hospital_by_day, con)
      }
    )
    
    output$download_hospital_month <- downloadHandler(
      filename = function() {
        paste('hospital_admission_month-', Sys.Date(), '.csv', sep='')
      },
      content = function(con) {
        write.csv(dt_hospital_by_month, con)
      }
    )
    
    # AGE DISTRIBUTION ####
    
    output$age_median <- renderText({
      t = dt_widnes_age_median[, `Median age`]
      paste0("Midian Age : ", t)
    })
    
   
    dt_widnes_age$Counts = as.numeric(dt_widnes_age$Counts)
    
    widnes_age = reactive({
      dt_widnes_age[, .(Age, Sex, Counts)]
      if(('Female' %in% input$age_gender) && ("Male" %in% input$age_gender)) {
        dt_widnes_age
      } else if ('Female' %in% input$age_gender) {
        dt_widnes_age = dt_widnes_age[Sex == "Female"]
      } else if("Male" %in% input$age_gender) {
        dt_widnes_age = dt_widnes_age[Sex == "Male"]
      }
      return(dt_widnes_age)
    })

    output$age_distribution = renderPlotly({
    ggplot(data = widnes_age(), 
           aes(x = Age, y = Counts, fill = Sex)) + 
      geom_bar(stat = "identity", position = position_dodge()) +
        scale_y_continuous(breaks = c(0, 500, 1000, 1500, 2000)) + 
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
      
    })
    
    output$download_age <- downloadHandler(
      filename = function() {
        paste('age_distribution_', Sys.Date(), '.csv', sep='')
      },
      content = function(con) {
        write.csv(dt_widnes_age, con)
      }
    )
    # Employment ####
   
    widnes_occupation = reactive({
      dt_widnes_occupation
    })
    
    
    output$occupation = renderPlot({
      ggplot(widnes_occupation(), aes(x = "", y = Counts, fill = Occupation)) +
        geom_bar(stat="identity", width=1, color="white") +
        geom_text(aes(label = paste0(`Percentage per BUA`, '%')), 
                   position = position_stack(vjust = 0.5), size = 3.5, color = "white") +
        coord_polar("y", start=0) +
        theme_void() + 
        theme(legend.text = element_text(size = 12))
    })
    
    output$download_occupation <- downloadHandler(
      filename = function() {
        paste('occupation_', Sys.Date(), '.csv', sep='')
      },
      content = function(con) {
        write.csv(dt_widnes_employment, con)
      }
    )
    
    # HYPERLINK page ####
    output$link <- renderDataTable({
      datatable(websitelink[, "link", drop = FALSE], escape = FALSE)
    })
    
    
    # MAP ####
    # widnes_summary = reactive({
    #   tt = dt_widnes_population$Counts
    #   ttt = dt_widnes_age_median$`Median age`
    #   tmp = paste0("Widnes, Cheshire<br>",
    #         "population in 2021: ", tt, '<br>',
    #         "median age in 2021: ", ttt)
    # })
    # 
    # 
    # output$map = renderLeaflet({
    #   dt = widnes_summary()
    #   leaflet() %>%
    #           addTiles() %>%
    #           setView(lng =-2.7326, lat = 53.3644, zoom = 13) %>%
    #           addMarkers(lng = -2.7326, lat = 53.3644,
    #                      popup = dt, options = popupOptions(maxWidth = 500))
    #   })
    # 

    # DATA UPLOAD page ####
    # upload data
}

