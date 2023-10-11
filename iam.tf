data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "rest_api_role" {
  name               = "${local.namespaced_service_name}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

data "aws_iam_policy_document" "create_logs_cloudwatch" {
  statement {
    sid       = "AllowCreatingLogGroups"
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:*"]
    actions   = ["logs:CreateLogGroup"]
  }

  statement {
    sid       = "AllowWritingLogs"
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:log-group:/aws/lambda/*:*"]

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }

  # statement {
  #   effect    = "Allow"
  #   resources = ["*"]
  #   actions = [
  #     "dynamodb:ListTables",
  #     "ssm:DescribeParameters",
  #     "xray:PutTraceSegments"
  #   ]
  # }

  # statement {
  #   effect    = "Allow"
  #   resources = ["*"] //["arn:aws:dynamodb:${var.aws_region}:${var.aws_account_id}:table/${aws_dynamodb_table.this.name}"]
  #   actions = [
  #     "dynamodb:PutItem",
  #     "dynamodb:DescribeTable",
  #     "dynamodb:DeleteItem",
  #     "dynamodb:GetItem",
  #     "dynamodb:Scan",
  #     "dynamodb:Query",
  #     "dynamodb:CreateTable",
  #     "dynamodb:UpdateItem"
  #   ]
  # }

  # statement {
  #   effect    = "Allow"
  #   resources = ["*"] // ["arn:aws:ssm:${var.aws_region}:${var.aws_account_id}:parameter/${aws_ssm_parameter.dynamodb_table.name}"]
  #   actions = [
  #     "ssm:GetParameters",
  #     "ssm:GetParameter",
  #   ]
  # }
}

resource "aws_iam_policy" "create_logs_cloudwatch" {
  name   = "${local.namespaced_service_name}-policy"
  policy = data.aws_iam_policy_document.create_logs_cloudwatch.json
}

resource "aws_iam_role_policy_attachment" "cat_api_cloudwatch" {
  policy_arn = aws_iam_policy.create_logs_cloudwatch.arn
  role       = aws_iam_role.rest_api_role.name
}


data "aws_iam_policy_document" "grant_s3" {

  statement {
    effect    = "Allow"
    resources = ["arn:aws:s3:::s3humbertopeluso/*"]
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:DeleteObject",
      "s3:PutBucketNotificationConfiguration"
    ]
  }
}

resource "aws_iam_policy" "grant_s3" {
  name   = "${local.namespaced_service_name}-s3-policy"
  policy = data.aws_iam_policy_document.grant_s3.json
}

resource "aws_iam_role_policy_attachment" "grant_s3" {
  policy_arn = aws_iam_policy.grant_s3.arn
  role       = aws_iam_role.rest_api_role.name
}

data "aws_iam_policy_document" "grant_sns" {

  statement {
    effect    = "Allow"
    resources = [aws_sns_topic.user_updates.arn]
    actions = [
      "sns:Publish"
    ]
  }
}

resource "aws_iam_policy" "grant_sns" {
  name   = "${local.namespaced_service_name}-sns-policy"
  policy = data.aws_iam_policy_document.grant_sns.json
}

resource "aws_iam_role_policy_attachment" "grant_sns" {
  policy_arn = aws_iam_policy.grant_sns.arn
  role       = aws_iam_role.rest_api_role.name
}