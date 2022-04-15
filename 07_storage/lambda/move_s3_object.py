import os

import boto3


def lambda_handler(event, context):
    s3 = boto3.resource('s3')
    print(event)
    s3_object_key = event['Records'][0]['s3']['object']['key']
    print("S3 object key = " + s3_object_key)
    copy_source = {
        'Bucket': os.getenv('SOURCE_BUCKET_NAME'),
        'Key': s3_object_key
    }

    target_bucket = s3.Bucket(os.getenv('TARGET_BUCKET_NAME'))
    target_bucket.copy(copy_source, s3_object_key)
