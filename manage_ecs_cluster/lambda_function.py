"""
Lambda function for triggering ECS task
"""

import json

import boto3

ecs = boto3.client('ecs')


def lambda_handler(event, context):
    task_params = {
        'cluster': 'segmentation',
        'launchType': 'FARGATE',
        'taskDefinition': 'segmentation_fargate',
        'overrides': {
            'containerOverrides': [{
                'name': 'semantic_seg',
                'environment': [
                    {
                        'name': 'INPUT_BUCKET',
                        'value': event['INPUT_BUCKET']
                    },
                    {
                        'name': 'INPUT_DIR',
                        'value': event['INPUT_DIR']
                    },
                    {
                        'name': 'INPUT_FILE_PATH',
                        'value': event['INPUT_FILE_PATH']
                    },
                    {
                        'name': 'MASK_BUCKET',
                        'value': event['MASK_BUCKET']
                    },
                    {
                        'name': 'MASK_FILE_PATH',
                        'value': event['MASK_FILE_PATH']
                    },
                    {
                        'name': 'OUTPUT_BUCKET',
                        'value': event['OUTPUT_BUCKET']
                    },
                    {
                        'name': 'OUTPUT_DIR',
                        'value': event['OUTPUT_DIR']
                    }
                ]
            }]
        },
        'networkConfiguration': {
            'awsvpcConfiguration': {
                'subnets': [
                    'subnet-0a2...e28',
                    'subnet-09b...a29'
                ],
                'securityGroups': [
                    'sg-033...948'
                ],
                'assignPublicIp': 'ENABLED'
            }
        }
    }

    ecs.run_task(**task_params)

    output = {
        'task': task_params
    }

    print(json.dumps(output))
    return {"statusCode": 200, "job": json.dumps(output)}
