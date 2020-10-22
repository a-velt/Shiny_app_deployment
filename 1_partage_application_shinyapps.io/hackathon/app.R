#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel(textOutput("title")),
    
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            textInput("title",
                      "Main title :",
                      "Data visualization"),
            selectInput("data",
                        "Select data input :",
                        choices = c("Old Faithful Geyser Data" = "faithful",
                                    "Iris Data" = "iris",
                                    "Motor Trend Car Road Tests" = "mtcars",
                                    "Normally distributed random numbers" = "random",
                                    "My own data" = "upload")),
            conditionalPanel(
                condition = "input.data == 'upload'",
                fileInput("file",
                          "Choose CSV File",
                          accept = ".csv")
                ),
            uiOutput("dataVariables"),
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30),
            radioButtons("color",
                         "Color of bins:",
                         choices = c("Dark gray" = "darkgray",
                                     "Orange" = "coral",
                                     "Light green" = "lightgreen")),
            conditionalPanel(
                condition = "input.data == 'random'",
                numericInput("randomN",
                             "Number of observations :",
                             value = 100,
                             min = 1),
                numericInput("randomMean",
                             "Mean :",
                             value = 0),
                numericInput("randomSd",
                             "Standard deviation :",
                             value = 1)
                ),
            downloadButton("downloadPlot", "Download Plot")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(
                tabPanel(
                    "Histogram",
                    plotOutput("histogram"),
                    textOutput("textBins")
                ),
                tabPanel(
                    "Boxplot",
                    plotOutput("boxplot"),
                ),
                tabPanel(
                    "Table",
                    tableOutput("table"),
                )
            )
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    output$title <- renderText({
        input$title
    })
    
    datasetInput <- reactive({
        switch(input$data,
               "faithful" = faithful,
               "iris" = iris,
               "mtcars" = mtcars,
               "random" = data.frame("rnorm" = rnorm(n = input$randomN, mean = input$randomMean, sd = input$randomSd)),
               "upload" = read.csv(input$file$datapath, header = TRUE))
    })
    
    output$dataVariables <- renderUI({
        validate(
            need(input$data != "upload" || input$file != "", "")
        )
        
       varSelectInput("variable", 
                       "Select variable:", 
                       data = datasetInput())
    })
    
    output$histogram <- renderPlot({
        validate(
            need(input$data != "upload" || input$file != "","Change data input or upload CSV file!")
        )
        ggplot(data = datasetInput(), aes_string(x = input$variable)) + 
            geom_histogram(bins = input$bins, fill = input$color, color = "white")
    })
    
    output$textBins <- renderText({
        c("There are currently", input$bins, input$color, "bins.")
    })
    
    output$boxplot <- renderPlot({
        validate(
            need(input$data != "upload" || input$file != "","Change data input or upload CSV file!")
        )
        ggplot(data = datasetInput(), aes_string(y = input$variable)) + 
            geom_boxplot(fill = input$color)
    })
    
    output$table <- renderTable({
        validate(
            need(input$data != "upload" || input$file != "","Change data input or upload CSV file!")
        )
        
        datasetInput()
    })
    
    output$downloadPlot <- downloadHandler(
        filename = function() {
            paste(gsub("\\s", "_", input$title), ".png", sep="")
        },
        content = function(file) {
            ggsave(filename = file, plot = last_plot())
        }
    )
}

# Run the application 
shinyApp(ui = ui, server = server)
