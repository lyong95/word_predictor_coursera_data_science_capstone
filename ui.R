#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    theme = shinytheme("united"),

    # Application title
    titlePanel("Word Predictor"),
    
    navbarPage(title = "~make typing faster and easier",
    
        tabPanel ("App demo",           
            # allow user to input text
            mainPanel(
                h3("I'll predict your next word"),
                textInput("user_text", label = "type in some phrases",value = ""),
        
                # return predicted word with some html formatting    
                br(), 
                tags$hr(),
                h3("Most likely word"),
                h6 ("Please be patient!"),
                tags$span(style="color:darkred",
                  tags$strong(tags$h4(textOutput("pred")))),
        
                br(), 
                tags$hr(),
                h3("More suggestions"),
                h6 ("Please be patient!"),
                tags$span(style="color:darkred",
                tags$strong(tags$h4(textOutput("pred2")))),
                tags$span(style="color:darkred",
                tags$strong(tags$h4(textOutput("pred3"))))

        )),
        
        tabPanel("View dataset",
            fluidRow(
                column(8),
                h2("Explore the dataset used to build this app"),
                h4("The most common ngrams"),
                plotOutput("ngram_plot"),

                
                column(4),
                br(),
                h4("The most frequent words"),
                wordcloud2::wordcloud2Output("cloud"),
                br(),
                br()
        ))
    
    )
))

