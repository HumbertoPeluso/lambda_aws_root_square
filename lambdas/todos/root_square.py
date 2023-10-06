import boto3
import math
import json

def handler(event, context):
     print("TESTE!!!! ")
     #print(event.get('QueryStringParameters',{}).get('object','n/a'))
     print(event.get('body',{}))
     body = json.loads(event.get('body',{}))
     num1 = int(body['num1'])
     num2 = int(body['num2'])
     avg = (num1 + num2)/2

     result = math.sqrt(avg)
     return {
        'statusCode' : 200,
        'body': json.dumps(result)
    }