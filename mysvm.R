mysvm <- function (x, y,
                   type = 'C-classification',
                   kernel = 'radial',
                   probability = TRUE) {
  # Perform cross-validation to find the optimal lambda
  model <- svm(x = x, y = y,
               type = type,
               kernel = kernel,
               probability = probability)
  svm_model <- list(model = model)
  class(svm_model) <- "mysvm"
  return(svm_model)
}

predict.mysvm <- function(object, data) {
  svm_pred <- predict(object = object$model,
                      newdata = data,
                      probability = 1)
                      # probability = 0)
  svm_pred <- attr(svm_pred, "probabilities")
  return(svm_pred[ , 2L])
  # return(svm_pred)
}

