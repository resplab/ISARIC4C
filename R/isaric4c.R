#' ISARIC mortality probability and deterioration risk model
#'
#' @param age a vector of patient's age, male (1) or female(0)
#' @param sex a vector of patient's gender
#' @param num_comorbidities number of comorbidities (Chronic cardiac disease; chronic respiratory disease (
#' excluding asthma); chronic renal disease (estimated glomerular filtration rate ≤30); mild-to-severe liver disease;
#' dementia; chronic neurological conditions; connective tissue disease; diabetes mellitus (diet, tablet or
#' insulin-controlled); HIV/AIDS; malignancy; clinician-defined obesity.)
#' @param respiratory_rate respiratory rate in breaths per minute
#' @param admission_oxygen_saturation peripheral oxygen saturation on room air (%)
#' @param glasgow_coma_scale a vector of Glasgow coma scale score
#' @param urea urea concentration in mmol/L
#' @param crp CRP in mg/L
#' @param nosocomial symptom onset or first positive SARS-CoV-2 PCR more than 7 days after admission. yes as 1, no as 0
#' @param radiographic_chest_infiltrates radiographic chest infiltrates, yes as 1, no as 0
#' @param receiving_oxygen whether a patient is receiving oxygen when oxygen saturation measured
#' @param lymphocytes lymphocyte count (* 10^9/L)
#' @param func a vector of function specification: either mortality as 0 or deterioration as 1
#'
#' @return mortality probability or deterioration probability of a patient in %
#' @export
#'
#' @examples
#' isaric4c(age = 69, sex = 'male', num_comorbidities = 1, respiratory_rate = 25,
#' admission_oxygen_saturation = 90, glasgow_coma_scale = 10, urea = 10, crp = 70,
#' func = "mortality")
#'
#' isaric4c(nosocomial=1, sex=1, radiographic_chest_infiltrates=1,
#' receiving_oxygen=1, glasgow_coma_scale=15, age=23, respiratory_rate=50,
#' admission_oxygen_saturation=51,urea=21, crp=32, lymphocytes=32, func = "deterioration")

isaric4c <-
  function (age,
            sex,
            num_comorbidities,
            respiratory_rate,
            admission_oxygen_saturation,
            glasgow_coma_scale,
            urea,
            crp,
            nosocomial,
            radiographic_chest_infiltrates,
            receiving_oxygen,
            lymphocytes,
            func) {
    if (func == "mortality" | func == 0) {
      score_m <- 0
      if (age >= 50 & age <= 59) {
        score_m = score_m + 2
      } else if (age >= 50 & age <= 69) {
        score_m = score_m + 4
      } else if (age >= 70 & age <= 79) {
        score_m = score_m + 6
      } else if (age >= 80) {
        score_m = score_m + 7
      }

      if (sex == 'male' | sex == 1) {
        score_m = score_m + 1
      }

      if (num_comorbidities == 1) {
        score_m = score_m + 1
      } else if (num_comorbidities >= 2) {
        score_m = score_m + 2
      }

      if (respiratory_rate >= 20 & respiratory_rate <= 29) {
        score_m = score_m + 1
      } else if (respiratory_rate >= 30) {
        score_m = score_m + 2
      }

      if (admission_oxygen_saturation < 92) {
        score_m = score_m + 2
      }

      if (glasgow_coma_scale < 15) {
        score_m = score_m + 2
      }

      if (urea >= 7 & urea <= 14) {
        score_m = score_m + 1
      } else if (urea > 14) {
        score_m = score_m + 3
      }

      if (crp >= 50 & crp <= 99) {
        score_m = score_m + 1
      } else if (crp >= 100) {
        score_m = score_m + 2
      }

      x <-
        matrix(
          data = c(
            1,
            0.3,
            2,
            0.8,
            3,
            2.3,
            4,
            4.8,
            5,
            7.5,
            6,
            7.8,
            7,
            11.7,
            8,
            14.4,
            9,
            19.2,
            10,
            22.9,
            11,
            26.9,
            12,
            32.9,
            13,
            40.1,
            14,
            44.6,
            15,
            51.6,
            16,
            59.1,
            17,
            66.1,
            18,
            75.8,
            19,
            77.4,
            20,
            82.9,
            21,
            87.5
          ),
          21,
          2,
          byrow = TRUE
        )
      mortality_probability <- x[score_m, 2]
      results <- list()
      results$mortality_probability <- mortality_probability
      return(results)
  } else if (func == "deterioration" | func == 1) {

    probability_table$interval_min <-
      suppressWarnings(as.integer(probability_table$interval_min))
    probability_table$interval_max <-
      suppressWarnings(as.integer(probability_table$interval_max))

    score_d <- 0
    if (nosocomial == 1) {
      score_d = score_d + 39
    }

    if (sex == 'male' | sex == 1) {
      score_d = score_d + 35
    }

    if (radiographic_chest_infiltrates == 1) {
      score_d = score_d + 47
    }

    if (receiving_oxygen == 1) {
      score_d = score_d + 108
    }


    if (glasgow_coma_scale < 15) {
      score_d = score_d + 87
    }

    score_d = score_d + dplyr::filter(predictor, predictor == 'Age (years)', value ==
                                        age)$score
    score_d = score_d + dplyr::filter(predictor,
                                      predictor == 'Respiratory rate (per min)',
                                      value == respiratory_rate)$score
    score_d = score_d + dplyr::filter(predictor,
                                      predictor == 'SpO2 (%)',
                                      value == admission_oxygen_saturation)$score
    score_d = score_d + dplyr::filter(predictor, predictor == 'Urea (mmol/L)', value ==
                                        urea)$score
    score_d = score_d + dplyr::filter(predictor,
                                      predictor == 'C-reactive protein (mg/L)',
                                      value == crp)$score
    score_d = score_d + dplyr::filter(predictor,
                                      predictor == 'Lymphocytes (x10^9/L)',
                                      value == lymphocytes)$score

    deterioration_probability <-
      probability_table[probability_table$interval_min <= score_d &
                          probability_table$interval_max >= score_d, ]$probability * 100
    results <- list()
    results$deterioration_probability <- deterioration_probability
    return(results)
  }
  }
