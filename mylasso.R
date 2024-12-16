mylasso <- function (x, y,
                     nlambda = 25,
                     nfolds = 10) {
  # Perform cross-validation to find the optimal lambda
  cv_lasso <- cv.glmnet(x = as.matrix(x), y = y,
                        family = "binomial",
                        type.measure = "deviance",
                        nfolds = nfolds)
  best_lambda <- cv_lasso$lambda.min
  lasso_best <- glmnet(x = as.matrix(x), y = y,
                       family = "binomial",
                       alpha = 1,
                       lambda = best_lambda
                       )
  lasso_model <- list(model = lasso_best)
  class(lasso_model) <- "mylasso"
  return(lasso_model)
}

predict.mylasso <- function(object, data) {
  glmnet_pred <- predict(object = object$model,
                         newx = as.matrix(data),
                         type = "response",
                         # type = "class",
                         s = object$model$lambda)
  return(as.vector(glmnet_pred))
}

myglm <- function (x, y) {
  y = as.integer(y == 2)
  data <- as.data.frame(x)
  data$y <- y
  # print(head(data))
  glm_model <- glm(y ~ ., data = data, family = binomial())
  glm_model <- list(model = glm_model)
  class(glm_model) <- "myglm"
  return(glm_model)
}

predict.myglm <- function(object, data) {
  tmp <- predict(object = object$model, newdata = as.data.frame(data), type = "response")
  return(as.vector(tmp))
}
