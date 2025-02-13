Creating the Task Definition for ECS
======================================

- **Command**
```shell
aws ecs register-task-definition --cli-input-json file://task_definition.json
```

- **Output response**
```json
{
  "taskDefinition": {
    "taskDefinitionArn": "arn:aws:ecs:us-east-1:277123456678:task-definition/segmentation_task_defn:1",
    "containerDefinitions": [
      {
        "name": "semantic_seg",
        "image": "277123456678.dkr.ecr.us-east-1.amazonaws.com/semantic_seg:lambda_cpu",
        "cpu": 0,
        "portMappings": [
          {
            "containerPort": 80,
            "hostPort": 80,
            "protocol": "tcp",
            "name": "semantic_seg-80-tcp",
            "appProtocol": "http"
          }
        ],
        "essential": true,
        "environment": [],
        "environmentFiles": [],
        "mountPoints": [],
        "volumesFrom": [],
        "ulimits": [],
        "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
            "awslogs-group": "/ecs/segmentation_task_defn",
            "awslogs-create-group": "true",
            "awslogs-region": "us-east-1",
            "awslogs-stream-prefix": "ecs"
          },
          "secretOptions": []
        },
        "systemControls": []
      }
    ],
    "family": "segmentation_task_defn",
    "taskRoleArn": "arn:aws:iam::277123456678:role/ml-access-for-ec2",
    "executionRoleArn": "arn:aws:iam::277123456678:role/ml-access-for-ec2",
    "revision": 1,
    "volumes": [],
    "status": "ACTIVE",
    "requiresAttributes": [
      {
        "name": "com.amazonaws.ecs.capability.logging-driver.awslogs"
      },
      {
        "name": "ecs.capability.execution-role-awslogs"
      },
      {
        "name": "com.amazonaws.ecs.capability.ecr-auth"
      },
      {
        "name": "com.amazonaws.ecs.capability.docker-remote-api.1.19"
      },
      {
        "name": "com.amazonaws.ecs.capability.task-iam-role"
      },
      {
        "name": "ecs.capability.execution-role-ecr-pull"
      },
      {
        "name": "com.amazonaws.ecs.capability.docker-remote-api.1.18"
      },
      {
        "name": "ecs.capability.task-eni"
      },
      {
        "name": "com.amazonaws.ecs.capability.docker-remote-api.1.29"
      }
    ],
    "placementConstraints": [],
    "compatibilities": [
      "EC2",
      "FARGATE"
    ],
    "runtimePlatform": {
      "cpuArchitecture": "X86_64",
      "operatingSystemFamily": "LINUX"
    },
    "requiresCompatibilities": [
      "EC2"
    ],
    "cpu": "4096",
    "memory": "8192",
    "registeredAt": "2024-06-19T11:52:03.444000+05:30",
    "registeredBy": "arn:aws:sts::277123456678:assumed-role/AWSReservedSSO_PowerUserAccess_ac801b7fdd05827c/ayush.nema@domainname.com"
  },
  "tags": [
    {
      "key": "project",
      "value": "visual_sonar"
    }
  ]
}
```

# Deregister task definition
```shell
aws ecs deregister-task-definition --task-definition segmentation_task_defn:1
```
Note: Produces _similar_ JSON as output as the `create` command

# Delete task definition
```shell
aws ecs delete-task-definitions \
    --task-definition segmentation_task_defn:1
```
Note: Produces _similar_ JSON as output as the `create` command


# Create an ECS service
```json
{
  "cluster": "segmentation",
  "serviceName": "segmentation-service",
  "taskDefinition": "segmentation_fargate",
  "desiredCount": 1,
  "launchType": "FARGATE",
  "networkConfiguration": {
    "awsvpcConfiguration": {
      "subnets": [
        "subnet-029...98d", 
        "subnet-046...668"
      ],
      "securityGroups": [
        "sg-065...1f3"
      ],
      "assignPublicIp": "ENABLED"
    }
  }
}
```

Response
```json
{
  "service": {
    "serviceArn": "arn:aws:ecs:us-east-1:277123456678:service/segmentation/segmentation-service",
    "serviceName": "segmentation-service",
    "clusterArn": "arn:aws:ecs:us-east-1:277123456678:cluster/segmentation",
    "loadBalancers": [],
    "serviceRegistries": [],
    "status": "ACTIVE",
    "desiredCount": 1,
    "runningCount": 0,
    "pendingCount": 0,
    "launchType": "FARGATE",
    "platformVersion": "LATEST",
    "platformFamily": "Linux",
    "taskDefinition": "arn:aws:ecs:us-east-1:277123456678:task-definition/segmentation_fargate:1",
    "deploymentConfiguration": {
      "deploymentCircuitBreaker": {
        "enable": false,
        "rollback": false
      },
      "maximumPercent": 200,
      "minimumHealthyPercent": 100
    },
    "deployments": [
      {
        "id": "ecs-svc/1364003910942610182",
        "status": "PRIMARY",
        "taskDefinition": "arn:aws:ecs:us-east-1:277123456678:task-definition/segmentation_fargate:1",
        "desiredCount": 0,
        "pendingCount": 0,
        "runningCount": 0,
        "failedTasks": 0,
        "createdAt": "2024-06-21T14:13:29.898000+05:30",
        "updatedAt": "2024-06-21T14:13:29.898000+05:30",
        "launchType": "FARGATE",
        "platformVersion": "1.4.0",
        "platformFamily": "Linux",
        "networkConfiguration": {
          "awsvpcConfiguration": {
            "subnets": [
              "subnet-029...98d",
              "subnet-046...668"
            ],
            "securityGroups": [
              "sg-065...1f3"
            ],
            "assignPublicIp": "ENABLED"
          }
        },
        "rolloutState": "IN_PROGRESS",
        "rolloutStateReason": "ECS deployment ecs-svc/1364003910942610182 in progress."
      }
    ],
    "roleArn": "arn:aws:iam::277123456678:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS",
    "events": [],
    "createdAt": "2024-06-21T14:13:29.898000+05:30",
    "placementConstraints": [],
    "placementStrategy": [],
    "networkConfiguration": {
      "awsvpcConfiguration": {
        "subnets": [
          "subnet-029...98d",
          "subnet-046...668"
        ],
        "securityGroups": [
          "sg-065...1f3"
        ],
        "assignPublicIp": "ENABLED"
      }
    },
    "schedulingStrategy": "REPLICA",
    "deploymentController": {
      "type": "ECS"
    },
    "createdBy": "arn:aws:iam::277123456678:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_PowerUserAccess_ac801b7fdd05827c",
    "enableECSManagedTags": false,
    "propagateTags": "NONE",
    "enableExecuteCommand": false
  }
}
```

# Update Service to have 0 tasks running by-default
```shell
aws ecs update-service --cluster segmentation --service segmentation-service --desired-count 0
```

# View service in detail
```shell
aws ecs describe-services --cluster segmentation --services segmentation-service
```