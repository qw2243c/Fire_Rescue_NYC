
shinyServer(function(input, output) {
    
    output$map4 <- renderLeaflet({

      Date.start <- substr(paste(as.character(input$dateRange), collapse = ""), start = 1, stop = 10)
      Date.end <- substr(paste(as.character(input$dateRange), collapse = ""), start = 11, stop = 20)

      Date.sel.tmp <- data.frame(DATE =
                               seq(as.Date(Date.start), by = "day",
                                   length.out = as.numeric(difftime(strptime(Date.end, format = "%Y-%m-%d"),
                                                    strptime(Date.start, format = "%Y-%m-%d"),units="days")) + 1
                               )
                             )
      swapchar <- function(chr){
        return(
          paste(substr(chr,start = 6,stop=7),
                substr(chr,start = 9,stop=10),
                substr(chr,start = 1,stop=4),
                sep = "-")
        )
      }
      Date.sel <- apply(Date.sel.tmp,2,swapchar)
      
      
      # select chosen data according to date
      incident.data.selected.sel1 =
        incident.data.selected %>%
        filter(INCIDENT_DATE %in% as.character(Date.sel))
      
      # select chosen data according to classfication
      fire.class.pool <- c("School Fire","Store Fire","Hospital Fire",
                           "Private Dwelling Fire","Automobile Fire",
                           "Other Commercial Building Fire")
      
      ## select classfication
      classification.pool.selected <- fire.class.pool[as.numeric(input$Class_selected3)]
      incident.data.selected.sel =
        incident.data.selected.sel1 %>%
        filter(FIRE_CLASS %in% classification.pool.selected)

      incident.table <- table(incident.data.selected.sel$ZIPCODE)
      Incident.zipcode.amount <- data.frame(names(incident.table),as.numeric(unname(incident.table)))
      names(Incident.zipcode.amount) <- c("Incident.zipcode", "Incident.amount")

      
      ## Borough.zipcode
      Borough.zipcode <- dlply(incident.data.selected.sel, "INCIDENT_BOROUGH")
      f <- function(df) {na.omit(unique(df$ZIPCODE))}
      Borough.zipcode <- lapply(Borough.zipcode, f)
      names(Borough.zipcode)[5] <- "RICHMOND"
      
      ## select zip code
      Borough.zipcode.selected <- as.vector(unlist(Borough.zipcode))
      if (!is.null(input$Borough_selected2 ) ){
        Borough.zipcode.selected <- as.vector(unlist(Borough.zipcode[as.numeric(input$Borough_selected2)]))
      }

      # select chosen data according to zipcode
      Firehouse.sel =
        Firehouse %>%
        filter(Postcode %in% Borough.zipcode.selected)
      
      selZip <- subset(NYCzipcodes, NYCzipcodes$ZIPCODE %in% Borough.zipcode.selected)

      # ----- Transform to EPSG 4326 - WGS84 (required)
      subdat<-spTransform(selZip, CRS("+init=epsg:4326"))

      # ----- save the data slot
      subdat_data=subdat@data[,c("ZIPCODE", "POPULATION")]
      subdat.rownames=rownames(subdat_data)
      subdat_data=
        subdat_data %>%
        left_join(Incident.zipcode.amount, by=c("ZIPCODE" = "Incident.zipcode"))
      rownames(subdat_data)=subdat.rownames
      
      # ----- to write to geojson we need a SpatialPolygonsDataFrame
      subdat<-SpatialPolygonsDataFrame(subdat, data=subdat_data)

      # ----- set uo color pallette https://rstudio.github.io/leaflet/colors.html
      # Create a continuous palette function
      pal <- colorNumeric(
        palette = heat.colors(20, alpha = 0.5),
        domain =  c(1:1009)#subdat$Incident.amount
      )
      if(2%in%input$enable_marker4){
        M4 <- leaflet(subdat) %>%
          addProviderTiles("Stamen.TonerLite") %>%
          addPolygons(
            stroke = T, weight=1,
            fillOpacity = 0.6,
            color = ~pal(Incident.amount)
          )%>%
        addLegend("Incident amount level", pal = pal, values = seq(0,1100,by=100),
                  position = c("topright"),
                  title = "Incident Amount",
                  #labFormat = labelFormat(prefix = "$"),
                  opacity = 1
        )
      }else{M4<-leaflet()%>%
        addProviderTiles("Stamen.TonerLite")}
      
      # Prepar the text for the tooltip:
      mytext=paste("Name: ", Firehouse.sel$FacilityName, "<br/>", 
                   "Address: ", Firehouse.sel$FacilityAddress, "<br/>", 
                   "Borough: ", Firehouse.sel$Borough, "<br/>", 
                   "Postcode: ", Firehouse.sel$Postcode, "<br/>",sep="") %>%
        lapply(htmltools::HTML)
      
      
      if(1%in%input$enable_marker4) {
      M4  %>%
      addMarkers(lat = ~Latitude, lng = ~Longitude, popup=NULL,
                 icon=icons(iconUrl = "http://icons.iconarchive.com/icons/fatcow/farm-fresh/32/fire-extinguisher-icon.png",
                            iconWidth = 10,iconHeight = 10),
                 label = mytext,
                 labelOptions = labelOptions(style = list("font-weight" = "normal", padding = "3px 8px"), textsize = "13px", 
                                             direction = "auto"),
                 data = Firehouse.sel
      )
      }
      else {
        M4
      }
    })
})
