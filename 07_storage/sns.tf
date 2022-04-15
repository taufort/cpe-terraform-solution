locals {
  topic_name = "s3-notification-${var.project}"
}

resource "aws_sns_topic" "s3_notification_topic" {
  name         = local.topic_name
  display_name = "S3 notification topic"
  policy = <<POLICY
{
    "Version":"2012-10-17",
    "Statement":[{
        "Effect": "Allow",
        "Principal": { "Service": "s3.amazonaws.com" },
        "Action": "SNS:Publish",
        "Resource": "${local.topic_name}",
        "Condition":{
            "ArnLike":{"aws:SourceArn":"${data.aws_s3_bucket.target_bucket.arn}"}
        }
    }]
}
POLICY
}
