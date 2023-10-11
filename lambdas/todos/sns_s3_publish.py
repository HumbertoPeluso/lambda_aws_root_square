import boto3
import base64
import json
import os

def handler(event, context):
    topic = boto3.client('sns')
    message = "Hi, An object has been uploaded"

    try:
        resp = topic.publish(
            TargetArn=os.environ['SNS_TOPIC_ARN'],
            Message=json.dumps({'default': message}),
            MessageStructure='json')
        print("Published message successfully")
        return resp
    except Exception as error:
        print("Couldn't publish message: {}".format(error))
        return error