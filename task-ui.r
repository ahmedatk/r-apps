library(shiny)
library(DT)

ui <- fluidPage(
  titlePanel("Task Prioritizer"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("task", "Task", ""),
      dateInput("deadline", "Deadline"),
      selectInput("importance", "Importance", choices = c("Low", "Medium", "High")),
      actionButton("add", "Add Task"),
      actionButton("clear", "Clear Tasks"),
      br(),
      br(),
      h4("Prioritized Tasks"),
      DTOutput("task_table")
    ),
    
    mainPanel(
      h3("Optimal Task Schedule"),
      textOutput("next_task"),
      plotOutput("schedule_plot")
    )
  )
)

