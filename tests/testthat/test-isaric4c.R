library(testthat)

test_that('each condition gives the expected output', {
  expect_equal(isaric4c(age = 69,
                        sex = 'male',
                        num_comorbidities = 1,
                        respiratory_rate = 25,
                        admission_oxygen_saturation = 90,
                        glasgow_coma_scale = 10,
                        urea = 10,
                        crp = 70,
                        func = 0)$mortality_probability,
                        40.1)})

test_that('each condition gives the expected output', {
  expect_equal(isaric4c(nosocomial = 1,
                        sex = 1,
                        radiographic_chest_infiltrates = 1,
                        receiving_oxygen = 1,
                        glasgow_coma_scale = 15,
                        age = 23,
                        respiratory_rate = 50,
                        admission_oxygen_saturation = 51,
                        urea = 21,
                        crp = 32,
                        lymphocytes = 32,
                        func = 1)$deterioration_probability,
                        97.9)})
