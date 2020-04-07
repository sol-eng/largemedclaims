library(keras)
library(tfdatasets)
library(dplyr)
library(recipes)
library(pins)

board_register_rsconnect(
  name = "rsconnect",
  server = "https://colorado.rstudio.com/rsc",
  key = Sys.getenv("CONNECT_API_KEY")
)

claims_99 <- pin_get("claims_99", board = "rsconnect")

set.seed(123123)
small_data <- claims_99 %>% 
  sample_n(10000)
modeling_data <- small_data %>% 
  select(
    # claimant_id = CLAIMANT,
    relationship = RELATION,
    sex = PATSEX,
    birth_year = PATBRTYR,
    total_paid_charges = TOTPDCHG,
    primary_diagnosis = DIAG1,
    ppo = PPO
  ) %>% 
  mutate(
    age = 1999 - as.numeric(birth_year)
  ) %>% 
  select(-birth_year)

rec <- recipe(modeling_data, ~ .) %>%
  step_string2factor(relationship, sex, primary_diagnosis, ppo) %>%
  prep(modeling_data, strings_as_factors = FALSE, retain = TRUE)


predictors <- c("relationship", "sex", "primary_diagnosis", "ppo", "age")


feat_spec <- modeling_data %>% 
  feature_spec(x = predictors, y = "total_paid_charges") %>% 
  step_numeric_column(age,
                      normalizer_fn = scaler_standard()) %>% 
  step_categorical_column_with_vocabulary_list(
    relationship, sex, primary_diagnosis, ppo
  ) %>%
  step_indicator_column(relationship, sex, ppo) %>%
  step_embedding_column(primary_diagnosis) %>%
  fit()

toy_model <- keras_model_sequential(list(
  layer_dense_features(feature_columns = feat_spec$dense_features()),
  layer_dense(units = 64, activation = "relu"),
  layer_dense(units = 64, activation = "relu"),
  layer_dense(units = 1, activation = "linear")
))

toy_model %>% 
  compile(optimizer = optimizer_adam(lr = 0.1), loss = "mse", metric = "mse")

history <- toy_model %>% 
  fit(x = select(modeling_data, predictors), 
      y = modeling_data$total_paid_charges,
      batch_size = 1000, epochs = 1000
  )

save_model_tf(toy_model, "saved_model/toy-model", overwrite = TRUE)
tar("toy-model.tar.gz", "saved_model/toy-model")
pins::pin("toy-model.tar.gz", "med_claims_model", board = "rsconnect", access_type = "all")

