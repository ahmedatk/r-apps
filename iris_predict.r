library(shiny)
library(neuralnet)
library(dplyr)

# Preprocess the data and train the model
data(iris)
iris$Setosa <- as.numeric(iris$Species == "setosa")
iris$Versicolor <- as.numeric(iris$Species == "versicolor")
iris$Virginica <- as.numeric(iris$Species == "virginica")

# Train-Test Split
set.seed(123)
train_index <- sample(1:nrow(iris), 0.8 * nrow(iris))
train_data <- iris[train_index, ]
test_data <- iris[-train_index, ]

# Train the ANN model
formula <- Setosa + Versicolor + Virginica ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width
nn_model <- neuralnet(formula, data = train_data, hidden = c(5), linear.output = FALSE)

# UI for the app
ui <- fluidPage(
  titlePanel("Iris Species Prediction using ANN"),
  sidebarLayout(
    sidebarPanel(
      numericInput("sepal_length", "Sepal Length:", value = 5.0, min = 4, max = 8),
      numericInput("sepal_width", "Sepal Width:", value = 3.0, min = 2, max = 5),
      numericInput("petal_length", "Petal Length:", value = 4.0, min = 1, max = 7),
      numericInput("petal_width", "Petal Width:", value = 1.0, min = 0.1, max = 3),
      actionButton("predict", "Predict")
    ),
    mainPanel(
      h3("Prediction Result"),
      textOutput("result")
    )
  )
)

# Server logic
# Server logic
server <- function(input, output) {
  predict_species <- eventReactive(input$predict, {
    # Input data for prediction
    input_data <- data.frame(
      Sepal.Length = as.numeric(input$sepal_length),
      Sepal.Width = as.numeric(input$sepal_width),
      Petal.Length = as.numeric(input$petal_length),
      Petal.Width = as.numeric(input$petal_width)
    )
    
    # Compute predictions using the trained ANN
    prediction <- neuralnet::compute(nn_model, input_data)
    
    # Extract probabilities and map to species
    prob <- as.numeric(prediction$net.result)
    species <- c("setosa", "versicolor", "virginica")
    predicted_species <- species[which.max(prob)]
    
    paste("The predicted species is:", predicted_species)
  })
  
  output$result <- renderText({
    predict_species()
  })
}


# Run the application
shinyApp(ui = ui, server = server)
