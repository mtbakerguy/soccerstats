require('RCurl')
s <- read.csv(text=getURL('https://raw.githubusercontent.com/mtbakerguy/soccerstats/master/soccerstats.csv'))
startDate <- as.Date(s[1,]$Date,format='%d-%b-%Y')
endDate <- as.Date(s[nrow(s),]$Date,format='%d-%b-%Y')

plotter <- function(firstU,secondU,firstT,secondT,metricname,plottype) {
   par(mfrow=c(2,3)) 
   if(plottype == 1) {
       hist(firstU,main=paste('First Half',metricname,'Distribution(Us)'),xlab=paste('#',metricname,sep=''))
       hist(secondU,main=paste('Second Half',metricname,'Distribution(Us)'),xlab=paste('#',metricname,sep=''))
       hist(firstU + secondU,main=paste('Total',metricname,'Distribution(Us)'),xlab=paste('#',metricname,sep=''))
       hist(firstT,main=paste('First Half',metricname,'Distribution(Them)'),xlab=paste('#',metricname,sep=''))
       hist(secondT,main=paste('Second Half',metricname,'Distribution(Them)'),xlab=paste('#',metricname,sep=''))
       hist(firstT + secondT,main=paste('Total',metricname,'Distribution(Them)'),xlab=paste('#',metricname,sep=''))
   } else if(plottype == 2) {
       boxplot(firstU,main=paste('First Half',metricname,'Distribution(Us)'))
       boxplot(secondU,main=paste('Second Half',metricname,'Distribution(Us)'))
       boxplot(firstU + secondU,main=paste('Total',metricname,'Distribution(Us)'))
       boxplot(firstT,main=paste('First Half',metricname,'Distribution(Them)'))
       boxplot(secondT,main=paste('Second Half',metricname,'Distribution(Them)'))
       boxplot(firstT + secondT,main=paste('Total',metricname,'Distribution(Them)'))
   } else if(plottype == 3) {
       par(mfrow=c(3,1))
       ylimit <- max(na.omit(firstU),na.omit(firstT))
       plot(na.omit(firstU),main=paste('First Half',metricname),col='blue',pch='U',ylim=c(0,ylimit),
            xaxt='n',xlab='',ylab='Count')
       par(new=TRUE)
       points(na.omit(firstT),pch='T',col='red')
       ylimit <- max(na.omit(secondU),na.omit(secondT))
       plot(na.omit(secondU),main=paste('Second Half',metricname),col='blue',pch='U',ylim=c(0,ylimit),
            xaxt='n',xlab='',ylab='Count')
       par(new=TRUE)
       points(na.omit(secondT),pch='T',col='red')
       ylimit <- max(na.omit(firstU) + na.omit(secondU),na.omit(firstT) + na.omit(secondT))
       plot(na.omit(firstU) + na.omit(secondU),main=paste('Total',metricname),col='blue',pch='U',ylim=c(0,ylimit),
            xaxt='n',xlab='',ylab='Count')
       par(new=TRUE)
       points(na.omit(secondU) + na.omit(secondT),pch='T',col='red')
   }
}

server <- function(input, output) {
    output$plots <- renderPlot({
    d <- input$checkGroup
    start <- input$daterange[1]
    end <- input$daterange[2]
    #sprime <- s[as.Date(s$Date,format='%d-%b-%Y') >= start & as.Date(s$Date,format='%d-%b-%Y) <= end,]
    sprime <- s[as.Date(s$Date,format='%d-%b-%Y') >= start & as.Date(s$Date,format='%d-%b-%Y') <= end,]
    
    if(d == 1)
        plotter(sprime[,'X1GU'],sprime[,'X2GU'],sprime[,'X1GT'],sprime[,'X2GT'],'Goals',input$plotType)
    else if(d == 2)
        plotter(s[,'X1ShU'],s[,'X2ShU'],sprime[,'X1ShT'],sprime[,'X2ShT'],'Shots',input$plotType)
    else if(d == 3)
        plotter(sprime[,'X1SaU'],sprime[,'X2SaU'],sprime[,'X1SaT'],sprime[,'X2SaT'],'Saves',input$plotType)
    else 
        plotter(sprime[,'X1CU'],sprime[,'X2CU'],sprime[,'X1CT'],sprime[,'X2CT'],'Corners',input$plotType)
    })

    output$text <- renderPrint({
        d <- input$checkGroup

        summarizeIt <- function(offset1,offset2,name) {
            start <- input$daterange[1]
            end <- input$daterange[2]
            sprime <- s[as.Date(s$Date,format='%d-%b-%Y') >= start & as.Date(s$Date,format='%d-%b-%Y') <= end,]
            q <- sprime[offset1:offset2]
            q$TU <- q[,1] + q[,3]
            q$TT <- q[,2] + q[,4]
            
            names(q) <- c(paste('First Half ',name,'(Us)',sep=''),
                          paste('First Half ',name,'(Them)',sep=''),
                          paste('Second Half ',name,'(Us)',sep=''),
                          paste('Second Half ',name,'(Them)',sep=''),
                          paste('Total ',name,'(Us)',sep=''),
                          paste('Total ',name,'(Them)',sep=''))
            summary(q)
        }
        if(d == 1)
            summarizeIt(6,9,'Goals')
        else if(d == 2)
            summarizeIt(10,13,'Shots')
        else if(d == 3)
            summarizeIt(18,21,'Saves')
        else
            summarizeIt(14,17,'Corners')
    })
}

ui <- fluidPage(
  titlePanel('WFA Soccer statistics'),
  sidebarLayout(
      sidebarPanel(radioButtons("plotType",label=h3("Select display type:"),
                       choices=list("Histogram" = 1,"Boxplot" = 2,'Game plots' = 3,
                                    "Summary Stats" = 4),
                       selected=1),
                   radioButtons("checkGroup",label=h3("Select metric to display:"),
                       choices=list("Goals" = 1,'Shots' = 2,'Saves' = 3,'Corners' = 4),
                       selected=1),
                   dateRangeInput('daterange','Date range:',start=startDate,end=endDate)),
      mainPanel(
          plotOutput("plots"),
          verbatimTextOutput("text")))
)

shinyApp(ui = ui, server = server)
