# data "archive_file" "utils_layer" {
#   output_path = "files/utils-layer.zip"
#   type        = "zip"
#   source_dir  = "${local.layers_path}/utils"
# }

# resource "aws_lambda_layer_version" "utils" {
#   layer_name          = "utils-layer"
#   description         = "Utils for response and event normalization"
#   filename            = data.archive_file.utils_layer.output_path
#   source_code_hash    = data.archive_file.utils_layer.output_base64sha256
#   compatible_runtimes = ["python3.9"]
# }

data "archive_file" "todos" {
  for_each = local.lambdas

  output_path = "files/${each.key}-todo-artefact.zip"
  type        = "zip"
  source_file = "${local.lambdas_path}/todos/${each.key}.py"
}

resource "aws_lambda_function" "todos" {
  for_each = local.lambdas

  function_name = "python-${each.key}-test"
  handler       = "${each.key}.handler"
  description   = each.value["description"]
  role          = aws_iam_role.rest_api_role.arn
  runtime       = "python3.9"

  filename         = data.archive_file.todos[each.key].output_path
  source_code_hash = data.archive_file.todos[each.key].output_base64sha256

  timeout     = each.value["timeout"]
  memory_size = each.value["memory"]

  # layers = [aws_lambda_layer_version.utils.arn]

  tracing_config {
    mode = "Active"
  }

  environment {
    variables = {
      // TABLE = aws_ssm_parameter.dynamodb_table.name
      DEBUG         = var.env
      SNS_TOPIC_ARN = aws_sns_topic.user_updates.arn
    }
  }
}

resource "aws_lambda_permission" "api" {
  for_each = {
    for k, v in local.lambdas : k => v if v.trigger == "api"
  }

  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.todos[each.key].arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:*/*"
}

resource "aws_lambda_permission" "allow_bucket" {
  for_each = {
    for k, v in local.lambdas : k => v if v.trigger == "s3"
  }
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.todos[each.key].arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.s3-bucket.arn
}

resource "aws_lambda_permission" "allow_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.todos["sns_s3_publish"].arn
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.user_updates.arn
}