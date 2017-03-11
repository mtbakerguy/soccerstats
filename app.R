require('RCurl')
s <- read.csv(text=getURL('https://raw.githubusercontent.com/mtbakerguy/soccerstats/master/soccerstats.csv'))

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
  output$value <- renderPlot({
    d <- input$checkGroup
    if(d == 1)
        plotter(s[,'X1GU'],s[,'X2GU'],s[,'X1GT'],s[,'X2GT'],'Goals',input$plotType)
    else if(d == 2)
        plotter(s[,'X1ShU'],s[,'X2ShU'],s[,'X1ShT'],s[,'X2ShT'],'Shots',input$plotType)
    else if(d == 3)
        plotter(s[,'X1SaU'],s[,'X2SaU'],s[,'X1SaT'],s[,'X2SaT'],'Saves',input$plotType)
    else 
        plotter(s[,'X1CU'],s[,'X2CU'],s[,'X1CT'],s[,'X2CT'],'Corners',input$plotType)
  })
}

ui <- fluidPage(
  titlePanel('WFA Soccer statistics'),
  sidebarLayout(
      sidebarPanel(radioButtons("plotType",label=h3("Select display type:"),
                       choices=list("Histogram" = 1,"Boxplot" = 2,'Game plots' = 3),
                       selected=1),
                   radioButtons("checkGroup",label=h3("Select metric to display:"),
                       choices=list("Goals" = 1,'Shots' = 2,'Saves' = 3,'Corners' = 4),
                       selected=1)),
  mainPanel(plotOutput("value")))
)

shinyApp(ui = ui, server = server)
