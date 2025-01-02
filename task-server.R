library(dplyr)

server <- function(input, output, session) {
  task_list <- reactiveVal(data.frame(
    Task = character(),
    Deadline = as.Date(character()),
    Importance = character(),
    stringsAsFactors = FALSE
  ))
  
  # Add Task to the Task List
  observeEvent(input$add, {
    new_task <- data.frame(
      Task = input$task,
      Deadline = input$deadline,
      Importance = input$importance,
      stringsAsFactors = FALSE
    )
    task_list(rbind(task_list(), new_task))
  })
  
  # Clear All Tasks
  observeEvent(input$clear, {
    task_list(data.frame(
      Task = character(),
      Deadline = as.Date(character()),
      Importance = character(),
      stringsAsFactors = FALSE
    ))
  })
  
  # Prioritize the Tasks
  output$task_table <- renderDT({
    tasks <- task_list()
    
    tasks <- tasks %>%
      arrange(Deadline, desc(Importance)) # Sort by deadline and importance
    datatable(tasks)
  })
  
  # Show the next task to focus on
  output$next_task <- renderText({
    tasks <- task_list()
    if (nrow(tasks) == 0) {
      return("No tasks available.")
    } else {
      tasks <- tasks %>% arrange(Deadline, desc(Importance))
      paste("Next Task:", tasks$Task[1], " | Deadline:", tasks$Deadline[1], " | Importance:", tasks$Importance[1])
    }
  })
  
  # Plot the distribution of tasks over time
  output$schedule_plot <- renderPlot({
    tasks <- task_list()
    
    if (nrow(tasks) > 0) {
      hist(as.numeric(difftime(tasks$Deadline, Sys.Date(), units = "days")),
           main = "Tasks Deadline Distribution", xlab = "Days Until Deadline", col = "lightblue")
    }
  })
}
