# Load required libraries
library(shiny)
library(shinythemes)

# Define the GATE exam date
gate_exam_date <- as.Date("2025-02-01")

# Define the UI
ui <- fluidPage(
  theme = shinytheme("cyborg"),  # Use a sleek theme for a modern look
  titlePanel("Countdown to GATE 2025 Exam"),
  
  sidebarLayout(
    sidebarPanel(
      h3("Get Ready for GATE 2025!"),
      p("Examination Date: February 01, 2025"),
      br(),
      actionButton("refresh", "Refresh Countdown"),
      width = 3
    ),
    
    mainPanel(
      tags$head(
        tags$style(HTML("
                    .countdown-box {
                        text-align: center;
                        font-size: 3em;
                        color: #1ABC9C;
                        margin-top: 20px;
                    }
                    .motivational {
                        font-style: italic;
                        color: #F39C12;
                        font-size: 1.2em;
                        text-align: center;
                        margin-top: 20px;
                    }
                "))
      ),
      
      # Embedded countdown timer iframe
      tags$iframe(
        width = "100%",
        height = "450px",
        src = "https://www.watchisup.com/custom-timer/embed/gate-2025-2025-02-01-00-00-1?backgroundcolor=rgba(0%2C0%2C0%2C1)&color=%23ffffff",
        frameborder = "0",
        allowfullscreen = TRUE
      ),
      
      # Real-time countdown for days left
      div(class = "countdown-box",
          textOutput("days_left")
      ),
      
      # Motivational message below the countdown
      div(class = "motivational",
          textOutput("motivational_text")
      ),
      
      width = 9
    )
  )
)

# Define the server logic
server <- function(input, output, session) {
  # Reactive countdown for days remaining
  countdown_days <- reactive({
    as.numeric(difftime(gate_exam_date, Sys.Date(), units = "days")) - 1
  })
  
  # Display days left until the exam
  output$days_left <- renderText({
    paste0(countdown_days(), " Days Left")
  })
  
  # Show motivational messages based on the time remaining
  output$motivational_text <- renderText({
    days <- countdown_days()
    if (days > 100) {
      "You've got time! Build a solid foundation."
    } else if (days > 50) {
      "Keep up the momentum!"
    } else if (days > 20) {
      "Focus on refining your knowledge."
    } else if (days > 0) {
      "Final stretch! Stay focused!"
    } else {
      "Good luck! Believe in yourself!"
    }
  })
  
  # Refresh countdown on button click
  observeEvent(input$refresh, {
    output$days_left <- renderText({
      paste0(countdown_days(), " Days Left")
    })
  })
}


# Run the application 
shinyApp(ui = ui, server = server)
