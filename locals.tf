locals {
  namespaced_service_name = "${var.service_name}-${var.env}"

  lambdas_path = "${path.module}/lambdas"
  #layers_path  = "${local.lambdas_path}/layers"

  lambdas = {
    root_square = {
      description = "Test own function"
      memory      = 128
      timeout     = 5
      trigger     = "api"
      http_type   = "GET"
    }
    upload_object_to_s3 = {
      description = "Test own function"
      memory      = 128
      timeout     = 5
      trigger     = "api"
      http_type   = "POST"
    }
    sns_s3_publish = {
      description = "Test own function"
      memory      = 128
      timeout     = 5
      trigger     = "s3"
    }
  }
}