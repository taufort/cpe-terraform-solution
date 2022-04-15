data "archive_file" "move_s3_object_archive_file" {
  type        = "zip"
  source_file = "lambda/move_s3_object.py"
  output_path = "lambda/move_s3_object.zip"
}

locals {
  lambda_name = "move-s3-object-${var.project}"
}

data "aws_iam_role" "lab_role" {
  name = "LabRole"
}

resource "aws_lambda_function" "move_s3_object_lambda" {
  filename         = data.archive_file.move_s3_object_archive_file.output_path
  function_name    = local.lambda_name
  role             = data.aws_iam_role.lab_role.arn
  handler          = "move_s3_object.lambda_handler"
  source_code_hash = data.archive_file.move_s3_object_archive_file.output_base64sha256
  runtime          = "python3.9"

  environment {
    variables = {
      SOURCE_BUCKET_NAME = data.aws_s3_bucket.source_bucket.bucket
      TARGET_BUCKET_NAME = data.aws_s3_bucket.target_bucket.bucket
    }
  }

  tags = {
    Name = local.lambda_name
  }
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.move_s3_object_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = data.aws_s3_bucket.source_bucket.arn
}
