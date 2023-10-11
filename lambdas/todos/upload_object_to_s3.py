import boto3
import base64
import json
import time

def handler(event, context):
     s3 = boto3.client('s3')
     base64_txtFile = event.get('body',{})
     image_data = base64.b64decode(base64_txtFile)
     bucket_name = "s3humbertopeluso"
     timestr = time.strftime("%Y%m%d-%H%M%S")
     key = "test_txt-"+timestr+".txt"
     
     s3.put_object(Bucket=bucket_name, Key=key, Body=image_data, ContentType='text/txt')

     return {
        'statusCode' : 200,
        'body': json.dumps("File Uploaded!")
    }

