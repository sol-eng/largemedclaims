library(keras)
library(tensorflow)

m <- load_model_tf("saved_model/toy-model")

#* @apiTitle Claim Costs

#* Compute expected claim cost prediction.
#* @param relationship Relationship.
#* @param sex Sex.
#* @param primary_diagnosis Primary diagnosis code.
#* @param ppo PPO.
#* @param age Age.
#* @post /predict
function(relationship, sex, primary_diagnosis, ppo, age) {
  new_data <- data.frame(
    relationship = relationship,
    sex = sex,
    primary_diagnosis = primary_diagnosis,
    ppo = ppo,
    age = as.numeric(age),
    stringsAsFactors = FALSE
  )
  
  res <- predict(m, new_data)
  as.vector(res)
}
