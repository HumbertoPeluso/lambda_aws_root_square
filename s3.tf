resource "aws_s3_bucket" "s3-bucket" {
  bucket = "s3humbertopeluso"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_notification" "aws-lambda-trigger" {
  bucket = aws_s3_bucket.s3-bucket.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.todos["sns_s3_publish"].arn
    events              = ["s3:ObjectCreated:*"]

  }
}