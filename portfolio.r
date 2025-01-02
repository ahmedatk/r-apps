library(shiny)

# Define UI
ui <- fluidPage(
  titlePanel("Personal Portfolio Builder"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("name", "Name", value = "Your Name"),
      textInput("title", "Portfolio Title", value = "Welcome to My Portfolio"),
      textareaInput("about_me", "About Me", value = "Write a brief description about yourself here.", rows = 5),
      
      h4("Add Projects"),
      numericInput("num_projects", "Number of Projects:", min = 1, max = 10, value = 3),
      uiOutput("project_inputs"),
      
      h4("Contact Information"),
      textInput("email", "Email Address", value = "you@example.com"),
      textInput("linkedin", "LinkedIn URL", value = "https://linkedin.com/in/yourprofile"),
      textInput("github", "GitHub URL", value = "https://github.com/yourusername"),
      
      downloadButton("download_html", "Download Portfolio HTML")
    ),
    
    mainPanel(
      h4("Portfolio Preview"),
      uiOutput("portfolio_preview")
    )
  )
)

# Define Server
server <- function(input, output, session) {
  
  # Render project inputs dynamically
  output$project_inputs <- renderUI({
    num_projects <- input$num_projects
    lapply(1:num_projects, function(i) {
      textInput(paste0("project_", i), paste("Project", i, "Title"), value = paste("Project", i))
    })
  })
  
  # Generate HTML for the portfolio
  portfolio_html <- reactive({
    req(input$name, input$title, input$about_me, input$email)
    projects <- lapply(1:input$num_projects, function(i) {
      project_title <- input[[paste0("project_", i)]]
      paste0("<li>", project_title, "</li>")
    }) %>% unlist()
    
    html_content <- paste0(
      "<!DOCTYPE html>
      <html lang='en'>
      <head>
        <meta charset='UTF-8'>
        <meta name='viewport' content='width=device-width, initial-scale=1.0'>
        <title>", input$title, "</title>
        <style>
          body { font-family: Arial, sans-serif; margin: 20px; }
          h1 { color: #3498db; }
          ul { list-style-type: none; padding: 0; }
          ul li { margin: 5px 0; }
        </style>
      </head>
      <body>
        <h1>", input$name, "</h1>
        <h2>", input$title, "</h2>
        <section>
          <h3>About Me</h3>
          <p>", input$about_me, "</p>
        </section>
        <section>
          <h3>Projects</h3>
          <ul>", paste(projects, collapse = ""), "</ul>
        </section>
        <section>
          <h3>Contact</h3>
          <p>Email: <a href='mailto:", input$email, "'>", input$email, "</a></p>
          <p>LinkedIn: <a href='", input$linkedin, "' target='_blank'>", input$linkedin, "</a></p>
          <p>GitHub: <a href='", input$github, "' target='_blank'>", input$github, "</a></p>
        </section>
      </body>
      </html>"
    )
    return(html_content)
  })
  
  # Render portfolio preview
  output$portfolio_preview <- renderUI({
    HTML(portfolio_html())
  })
  
  # Download portfolio HTML
  output$download_html <- downloadHandler(
    filename = function() {
      paste("portfolio-", Sys.Date(), ".html", sep = "")
    },
    content = function(file) {
      writeLines(portfolio_html(), file)
    }
  )
}

# Run the app
shinyApp(ui = ui, server = server)