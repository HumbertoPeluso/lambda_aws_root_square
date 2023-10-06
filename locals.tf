locals {
  namespaced_service_name = "${var.service_name}-${var.env}"

  lambdas_path = "${path.module}/lambdas"
  #layers_path  = "${local.lambdas_path}/layers"

  lambdas = {
    root_square = {
      description = "Test own function"
      memory      = 128
      timeout     = 5
      http_type   = "GET"
    }
  }
}