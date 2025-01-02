# Install necessary packages
if (!require("shiny")) install.packages("shiny")
if (!require("shinyAce")) install.packages("shinyAce")
if (!require("plotly")) install.packages("plotly")

library(shiny)
library(shinyAce)
library(plotly)

# Define UI
ui <- fluidPage(
  titlePanel("Coding Playground"),
  
  sidebarLayout(
    sidebarPanel(
      h3("Welcome to the Coding Playground!"),
      p("Try solving coding challenges below. Write your R code and see the results!"),
      
      selectInput("challenge", "Choose a Challenge:", 
                  choices = list(
                    "Calculate the Sum of Two Numbers" = "sum",
                    "Create a Sequence of Numbers" = "sequence",
                    "Plot a Line Graph" = "plot"
                  )),
      
      h3("Write Your Code:"),
      aceEditor("code_input", mode = "r", value = "# Type your code here"),
      
      actionButton("run_code", "Run Code"),
      hr(),
      h4("Need Help?"),
      verbatimTextOutput("challenge_hint")
    ),
    
    mainPanel(
      h3("Output:"),
      verbatimTextOutput("code_output"),
      plotlyOutput("plot_output")
    )
  )
)

# Define Server
server <- function(input, output, session) {
  # Provide hints for challenges
  output$challenge_hint <- renderText({
    switch(input$challenge,
           "sum" = "Hint: Use the sum() function to add numbers. Example: sum(5, 10).",
           "sequence" = "Hint: Use the seq() function to create a sequence. Example: seq(1, 10, by = 2).",
           "plot" = "Hint: Use the plot() function to draw a graph. Example: plot(x, y).")
  })
  
  # Reactive expression for code execution
  code_result <- eventReactive(input$run_code, {
    tryCatch({
      # Evaluate user code
      eval(parse(text = input$code_input))
    }, error = function(e) {
      paste("Error:", e$message)
    })
  })
  
  # Display code output
  output$code_output <- renderText({
    result <- code_result()
    if (is.character(result)) {
      result
    } else if (is.numeric(result)) {
      paste("Result:", result)
    } else {
      "Output is not text-based."
    }
  })
  
  # Display plots (if any)
  output$plot_output <- renderPlotly({
    result <- code_result()
    if (inherits(result, "ggplot") || inherits(result, "plotly")) {
      ggplotly(result)
    } else if (inherits(result, "recordedplot")) {
      # Display base R plots
      plotly::ggplotly(plot(result))
    } else {
      NULL
    }
  })
}

# Run the App
shinyApp(ui = ui, server = server)