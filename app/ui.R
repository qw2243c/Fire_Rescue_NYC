
shinyUI(

  div(id="canvas",
      
  navbarPage(strong("Fire & Rescue NYC",style="color: white;"), theme = "styles.css",
 
  # 1.INTRO TAB
  tabPanel("Intro",
    mainPanel(width=12,
      h1(strong("Project: Open Data NYC - an RShiny app development project"),
         style = "color:white; "),
      br(),
      br(),
      p(strong("Do you know on average each year there are 134 millions fire incidents happening in the New York, sixty three hundred firefighter's injuries and death recorded, with direct property damages over 14 billions?",
               style = "color:white; font-size:16pt"),
      br(),
      br(),
      p(strong("Indeed, fire loss is devastating!"),
        style = "color:white; font-size:16pt"),
      br(),
      br(),
      p(strong("In this project, we have developed an App using R Shiny to visualize NYC fire incident data. This App can not only help the government and FDNY to have better policy-makings, provide useful information for insurance companies to design more profitable quotes regarding the property insurance and guide the residents to get access to those fire incidents in NYC.",
               style = "color:white; font-size:16pt")),
      br(),br(),br(), br(),br(),br(),
      br(),br(),br(), br(),
      br(),br(),br(),
      p(em(a("Github link",href="https://github.com/TZstatsADS/Spring2018-Project2-Group1",style = "color:white")))
      )
      )
  ),

  # 2.Map  
  tabPanel("Map",
           sidebarPanel(
             checkboxGroupInput("enable_marker4", "Add Markers for: ",
                                choices = c("Fire Station" = 1,
                                            "Incidents" = 2),
                                selected = 2),
             checkboxGroupInput("Borough_selected2", "Select Borough: ",
                                choices = c( "BRONX"=1,
                                             "BROOKLYN"=2,
                                             "MANHATTAN"=3,
                                             "QUEENS"=4,
                                             "RICHMOND"=5),
                                selected = 1:4),
             
             dateRangeInput('dateRange',
                            label = 'Date range input: yyyy-mm-dd',
                            start = '2013-01-01', end = '2016-12-31',
                            width = '300px'
             ),
             
             checkboxGroupInput("Class_selected3", "Select incident type: ",
                                choices = c( "School Fire"=1,
                                             "Store Fire"=2,
                                             "Hospital Fire"=3,
                                             "Private Dwelling Fire"=4,
                                             "Automobile Fire"=5,
                                             "Other Commercial Building Fire"= 6),
                                selected = 1:6)
             
           ),
           mainPanel(leafletOutput("map4", width = "100%", height = "800px"))
           
  ),
  
   # 3.STAT TAB
   tabPanel("Statistics",
      wellPanel(style = "overflow-y:scroll; height: 850px; max-height: 750px; background-color: #ffffff;",
      tabsetPanel(type="tabs", 
                  tabPanel(title="Fire Incident Types",
                           style = "background-color: #ffffff;",
                           img(src="cooledited.gif", width = "900px"),
                           absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE, draggable = TRUE,
                                         top = 150, left = "auto", right = 50, bottom = "auto", width = 310, height = "auto",
                                         p("This animation visualizes the 911 cases by classification for each month. We could find that majority of the fire cases responded by NYFD is related to private dwelling fire. The second main classification is commercial building. School Fire, Store Fire and Hospital Fire relatively account for a small proportion of total cases. We do observe a fluctuation regarding the auto mobile fire percentages. They tend to increase at first then decrease. Other than that, we haven’t seen dramatic changes within the observation period starting from Jan 2013 to Feb 2015."))
                           
                  ),
                  tabPanel(title="Facilities in Each Borough",
                           style = "background-color: #ffffff;",
                           includeHTML("../output/Facilities_in_Each_Borough.html"),
                           absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE, draggable = TRUE,
                                         top = 150, left = "auto", right = 50, bottom = "auto", width = 310, height = "auto",
                                         p("The interactive circle packing plots shows the number of firestations in each borough."))
                                                       
                           ),
                  tabPanel(title="Alarm Sources",
                           style = "background-color: #ffffff;",
                           includeHTML("../output/Alarm_sources.html"),
                           absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE, draggable = TRUE,
                                         top = 150, left = "auto", right = 50, bottom = "auto", width = 310, height = "auto",
                                         p("This bar plot animation shows the changes of how emergency alarms are sent to people. UCT/911 is the most used method to inform people the emergency while other methods such as EMS are not so frequently used. This plot can be helpful to indicate where people can receive information while in an emergency."))
                           
                  ),
                  tabPanel(title="Incidents in Each Borough",
                           style = "background-color: #ffffff;",
                           includeHTML("../output/Incidents_in_Each_Borough-copy.html"),
                           absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE, draggable = TRUE,
                                         top = "auto", left = 50, right = "auto", bottom = 40, width = 800, height = "auto",
                                         p("Incidents in Each Borough
                                           Ladder companies (also known as truck companies) are tasked with search and rescue, forcible entry, and ventilation at the scene of a fire.
                                           Engine companies are tasked with securing a water supply from a fire hydrant, then extinguishing a fire. 
                                           Other companies: Field Communications Unit , Brush Fire Unit etc. These companies usually have special equipment to handle specific task. 
                                           Obviously, Brooklyn and Queens have more incidents than other boroughs. We noticed that queens borough require more ladder unit than average.
                                           
                                           Obviously, Brooklyn and Queens have more incidents than other boroughs. We noticed that queens borough require more ladder unit than average."))
                           
                  ),
                  tabPanel(title="Fire House Response Time",
                           style = "background-color: #ffffff;",
                           img(src="response time.jpeg"),
                           absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE, draggable = TRUE,
                                         top = 150, left = "auto", right = 50, bottom = "auto", width = 310, height = "auto",
                                         p("This plot shows the dipatch response time from each incidents in each borough. To be more informative, we only contained the response time over 100 seconds. We can see from the plot that it takes longer for firestations in Queen to response. Furthemore, firestations in Brooklyn have some extremly longer response times than firestations in other boroughs."))
                           
                  
                  )
                  )
  ))
  

           
  )
   
))
