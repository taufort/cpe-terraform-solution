data "aws_s3_bucket" "source_bucket" {
  bucket = var.bucket_source
}

data "aws_s3_bucket" "target_bucket" {
  bucket = var.bucket_target
}

resource "aws_s3_bucket_notification" "source_bucket_lambda_notification" {
  bucket = data.aws_s3_bucket.source_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.move_s3_object_lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }
}

resource "aws_s3_bucket_notification" "target_bucket_sns_notification" {
  bucket = data.aws_s3_bucket.target_bucket.id

  topic {
    topic_arn     = aws_sns_topic.s3_notification_topic.arn
    events        = ["s3:ObjectCreated:*"]
  }
}
