CLI commands for provisioning ECS infrastructure
==================================================

General note:  
Always double check that there is no space after the slash (`/\`) which is used for inserting new line in the CLI 
commands.
```
# ====== Incorrect
aws some_command \_         ← additional whitespace after the slash
    --arg1 val
    
# ====== Correct
aws some_command \          ← no space after the slash
    --arg1 val
```

# Create cluster
Ref link: https://docs.aws.amazon.com/cli/latest/reference/ecs/create-cluster.html

```shell
# without TAGS
aws ecs create-cluster \
    --cluster-name segmentation
```
Response
```json
{
    "cluster": {
        "clusterArn": "arn:aws:ecs:us-east-1:1234567890:cluster/segmentation",
        "clusterName": "segmentation",
        "status": "ACTIVE",
        "registeredContainerInstancesCount": 0,
        "runningTasksCount": 0,
        "pendingTasksCount": 0,
        "activeServicesCount": 0,
        "statistics": [],
        "tags": [],
        "settings": [
            {
                "name": "containerInsights",
                "value": "disabled"
            }
        ],
        "capacityProviders": [],
        "defaultCapacityProviderStrategy": []
    }
}
```


```shell
# with TAGS
aws ecs create-cluster \
    --cluster-name segmentation \
    --tags key=project,value=visual_sonar \
```

Response

```json
{
    "cluster": {
        "clusterArn": "arn:aws:ecs:us-east-1:277123456678:cluster/segmentation",
        "clusterName": "segmentation",
        "status": "ACTIVE",
        "registeredContainerInstancesCount": 0,
        "runningTasksCount": 0,
        "pendingTasksCount": 0,
        "activeServicesCount": 0,
        "statistics": [],
        "tags": [
            {
                "key": "project",
                "value": "visual_sonar"
            }
        ],
        "settings": [
            {
                "name": "containerInsights",
                "value": "disabled"
            }
        ],
        "capacityProviders": [],
        "defaultCapacityProviderStrategy": []
    }
}
```

## Delete ECS cluster
Ref: https://docs.aws.amazon.com/cli/latest/reference/ecs/delete-cluster.html

```shell
aws ecs delete-cluster --cluster segmentation
```

Response:
```json
{
    "cluster": {
        "clusterArn": "arn:aws:ecs:us-east-1:277123456678:cluster/segmentation",
        "clusterName": "segmentation",
        "status": "INACTIVE",
        "registeredContainerInstancesCount": 0,
        "runningTasksCount": 0,
        "pendingTasksCount": 0,
        "activeServicesCount": 0,
        "statistics": [],
        "tags": [],
        "settings": [
            {
                "name": "containerInsights",
                "value": "disabled"
            }
        ],
        "capacityProviders": [],
        "defaultCapacityProviderStrategy": []
    }
}
```

# Create launch template

```shell
aws ec2 create-launch-template \
  --launch-template-name ecs-launch-template \
  --version-description "ECS launch template for Visual Sonar- Segmentation" \
  --launch-template-data '{
      "ImageId":"ami-0a5...2d5",
      "InstanceType":"g4dn.xlarge",
      "NetworkInterfaces": [
          {
              "DeviceIndex": 0,
              "Groups": ["sg-065...1f3"]
          }
      ]
  }'
```

Response
```json
{
    "LaunchTemplate": {
        "LaunchTemplateId": "lt-0f4...3f6",
        "LaunchTemplateName": "ecs-launch-template",
        "CreateTime": "2024-06-11T10:21:36+00:00",
        "CreatedBy": "arn:aws:sts::1234567890:assumed-role/AWSReservedSSO_PowerUserAccess_4003202d854a45b1/ayush.nema@domainname.com",
        "DefaultVersionNumber": 1,
        "LatestVersionNumber": 1
    }
}
```

## Describing the launch templates
```shell
aws ec2 describe-launch-templates
```

Response
```json
{
    "LaunchTemplates": [
        {
            "LaunchTemplateId": "lt-055...6ef",
            "LaunchTemplateName": "Batch-lt-58d14df1-8de0-3d5e-8595-02ed82b25507",
            "CreateTime": "2024-06-04T21:18:06+00:00",
            "CreatedBy": "arn:aws:sts::277123456678:assumed-role/aws_batch_service_role/aws-batch",
            "DefaultVersionNumber": 1,
            "LatestVersionNumber": 1
        },
        {
            "LaunchTemplateId": "lt-0cd...07d",
            "LaunchTemplateName": "ecs-launch-template",
            "CreateTime": "2024-06-19T06:32:19+00:00",
            "CreatedBy": "arn:aws:sts::277123456678:assumed-role/AWSReservedSSO_PowerUserAccess_ac801b7fdd05827c/ayush.nema@domainname.com",
            "DefaultVersionNumber": 1,
            "LatestVersionNumber": 1
        }
    ]
}
```

## Delete launch template
```shell
aws ec2 delete-launch-template --launch-template-id lt-0f4...3f6
```

Response
```json
{
    "LaunchTemplate": {
        "LaunchTemplateId": "lt-0f4...3f6",
        "LaunchTemplateName": "ecs-launch-template",
        "CreateTime": "2024-06-12T06:57:30+00:00",
        "CreatedBy": "arn:aws:sts::277123456678:assumed-role/AWSReservedSSO_PowerUserAccess_ac801b7fdd05827c/ayush.nema@domainname.com",
        "DefaultVersionNumber": 1,
        "LatestVersionNumber": 1
    }
}
```


# Create auto-scaling group
Ref: https://docs.aws.amazon.com/cli/latest/reference/autoscaling/create-auto-scaling-group.html

- To get the name and ID (and other details) of launch template, run 
```shell
aws ec2 describe-launch-templates
```


```json
{
    "LaunchTemplates": [
        {
            "LaunchTemplateId": "lt-0f4...3f6",
            "LaunchTemplateName": "ecs-launch-template",
            "CreateTime": "2024-06-11T10:21:36+00:00",
            "CreatedBy": "arn:aws:sts::1234567890:assumed-role/AWSReservedSSO_PowerUserAccess_4003202d854a45b1/ayush.nema@domainname.com",
            "DefaultVersionNumber": 1,
            "LatestVersionNumber": 1
        }
      ]
}
```


```shell
aws autoscaling create-auto-scaling-group \
    --auto-scaling-group-name segment-asg \
    --launch-template LaunchTemplateId=lt-0f4...3f6 \
    --min-size 0 \
    --max-size 3 \
    --desired-capacity 0 \
    --default-cooldown 240 \
    --vpc-zone-identifier "subnet-029...98d,subnet-074...00f,subnet-046...668,subnet-04e...d0d"
```

Note: this does not return any output in the terminal.

## Delete auto-scaling group
```shell
aws autoscaling delete-auto-scaling-group \
    --auto-scaling-group-name segment-asg
```


# Create capacity provider
Ref: https://docs.aws.amazon.com/cli/latest/reference/ecs/create-capacity-provider.html

The command to create the capacity provider will require the ARN of auto-scaling group. For obtaining that, run the 
following command:
```shell
aws autoscaling describe-auto-scaling-groups \
    --auto-scaling-group-name segment-asg
```

Response
```json
{
    "AutoScalingGroups": [
        {
            "AutoScalingGroupName": "segment-asg",
            "AutoScalingGroupARN": "arn:aws:autoscaling:us-east-1:277123456678:autoScalingGroup:ef585aa2-cab9-4874-89cb-1ef0b25fb71f:autoScalingGroupName/segment-asg",
            "LaunchTemplate": {
                "LaunchTemplateId": "lt-007...018",
                "LaunchTemplateName": "ecs-launch-template"
            },
            "MinSize": 0,
            "MaxSize": 3,
            "DesiredCapacity": 0,
            "DefaultCooldown": 240,
            "AvailabilityZones": [
                "us-east-1a",
                "us-east-1b"
            ],
            "LoadBalancerNames": [],
            "TargetGroupARNs": [],
            "HealthCheckType": "EC2",
            "HealthCheckGracePeriod": 0,
            "Instances": [],
            "CreatedTime": "2024-06-13T14:12:23.634000+00:00",
            "SuspendedProcesses": [],
            "VPCZoneIdentifier": "subnet-029...98d,subnet-074...00f,subnet-046...668,subnet-04e...d0d",
            "EnabledMetrics": [],
            "Tags": [],
            "TerminationPolicies": [
                "Default"
            ],
            "NewInstancesProtectedFromScaleIn": false,
            "ServiceLinkedRoleARN": "arn:aws:iam::277123456678:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling",
            "TrafficSources": []
        }
    ]
}
```


```shell
aws ecs create-capacity-provider \
    --name segment-capacity-provider \
    --auto-scaling-group-provider '{
      "autoScalingGroupArn": "arn:aws:autoscaling:us-east-1:277123456678:autoScalingGroup:29f07fab-96bc-4601-b9fd-b74786b10392:autoScalingGroupName/segment-asg",
      "managedScaling": {
        "status": "ENABLED",
        "targetCapacity": 95,
        "minimumScalingStepSize": 1,
        "maximumScalingStepSize": 5,
        "instanceWarmupPeriod": 240
      }
}'
```

Response
```json
{
    "capacityProvider": {
        "capacityProviderArn": "arn:aws:ecs:us-east-1:277123456678:capacity-provider/segment-capacity-provider",
        "name": "segment-capacity-provider",
        "status": "ACTIVE",
        "autoScalingGroupProvider": {
            "autoScalingGroupArn": "arn:aws:autoscaling:us-east-1:277123456678:autoScalingGroup:29f07fab-96bc-4601-b9fd-b74786b10392:autoScalingGroupName/segment-asg",
            "managedScaling": {
                "status": "ENABLED",
                "targetCapacity": 95,
                "minimumScalingStepSize": 1,
                "maximumScalingStepSize": 5,
                "instanceWarmupPeriod": 240
            },
            "managedTerminationProtection": "DISABLED"
        },
        "tags": []
    }
}
```

## Describing capacity provider
```shell
aws ecs describe-capacity-providers
```

```json
{
    "capacityProviders": [
        {
            "capacityProviderArn": "arn:aws:ecs:us-east-1:277123456678:capacity-provider/FARGATE",
            "name": "FARGATE",
            "status": "ACTIVE",
            "tags": []
        },
        {
            "capacityProviderArn": "arn:aws:ecs:us-east-1:277123456678:capacity-provider/FARGATE_SPOT",
            "name": "FARGATE_SPOT",
            "status": "ACTIVE",
            "tags": []
        }
    ],
    "failures": []
}
```

## Delete capacity provider
```shell
aws ecs delete-capacity-provider \
    --capacity-provider segment-capacity-provider
```
Note: The command will work only when the capacity-provider is **not** attached or associated with the cluster. If 
already associated, it will throw the following error:
```
The capacity provider cannot be deleted because it is associated with cluster: segmentation. Remove the capacity provider from the cluster and try again.
```
Relevant read: https://repost.aws/knowledge-center/ecs-capacity-provider-error

To detach it from the cluster, run the following set of commands one-by-one:
```shell
aws ecs put-cluster-capacity-providers \
    --cluster segmentation \
    --capacity-providers "[]" \
    --default-capacity-provider-strategy "[]"
```
Response
```json
{
    "cluster": {
        "clusterArn": "arn:aws:ecs:us-east-1:277123456678:cluster/segmentation",
        "clusterName": "segmentation",
        "status": "ACTIVE",
        "registeredContainerInstancesCount": 0,
        "runningTasksCount": 0,
        "pendingTasksCount": 0,
        "activeServicesCount": 0,
        "statistics": [],
        "tags": [],
        "settings": [
            {
                "name": "containerInsights",
                "value": "disabled"
            }
        ],
        "capacityProviders": [],
        "defaultCapacityProviderStrategy": [],
        "attachments": [
            {
                "id": "928d538c-d1c5-49ed-8315-3d4265e95408",
                "type": "managed_draining",
                "status": "DELETING",
                "details": [
                    {
                        "name": "capacityProviderName",
                        "value": "segment-capacity-provider"
                    },
                    {
                        "name": "autoScalingLifecycleHookName",
                        "value": "ecs-managed-draining-termination-hook"
                    }
                ]
            },
            {
                "id": "e495f8aa-cdfd-4122-a314-cabe4e1b75a5",
                "type": "as_policy",
                "status": "DELETING",
                "details": [
                    {
                        "name": "capacityProviderName",
                        "value": "segment-capacity-provider"
},
                    {
                        "name": "scalingPolicyName",
                        "value": "ECSManagedAutoScalingPolicy-d511fb97-9824-49d5-96ba-b72d37a3724b"
                    }
                ]
            }
        ],
        "attachmentsStatus": "UPDATE_IN_PROGRESS"
    }
}
```


```shell
aws ecs describe-clusters --clusters segmentation
````
This presents the JSON as output, mentioning the name of capacity-provider under `defaultCapacityProviderStrategy.capacityProvider` 
field.

Response
```json
{
    "clusters": [
        {
            "clusterArn": "arn:aws:ecs:us-east-1:277123456678:cluster/segmentation",
            "clusterName": "segmentation",
            "status": "ACTIVE",
            "registeredContainerInstancesCount": 0,
            "runningTasksCount": 0,
            "pendingTasksCount": 0,
            "activeServicesCount": 0,
            "statistics": [],
            "tags": [],
            "settings": [],
            "capacityProviders": [],
            "defaultCapacityProviderStrategy": []
        }
    ],
    "failures": []
}
```
And then, execute the delete command.
```json
{
    "capacityProvider": {
        "capacityProviderArn": "arn:aws:ecs:us-east-1:277123456678:capacity-provider/segment-capacity-provider",
        "name": "segment-capacity-provider",
        "status": "INACTIVE",
        "autoScalingGroupProvider": {
            "autoScalingGroupArn": "arn:aws:autoscaling:us-east-1:277123456678:autoScalingGroup:e7e8c317-34b2-4abc-a48b-b2536111e521:autoScalingGroupName/segment-asg",
            "managedScaling": {
                "status": "ENABLED",
                "targetCapacity": 95,
                "minimumScalingStepSize": 1,
                "maximumScalingStepSize": 5,
                "instanceWarmupPeriod": 240
            },
            "managedTerminationProtection": "ENABLED"
        },
        "updateStatus": "DELETE_COMPLETE",
        "tags": []
    }
}
```


# Register capacity provider with cluster
```shell
aws ecs put-cluster-capacity-providers \
    --cluster segmentation \
    --capacity-providers segment-capacity-provider \
    --default-capacity-provider-strategy "capacityProvider=segment-capacity-provider,weight=1,base=1"
```

Response
```json
{
    "cluster": {
        "clusterArn": "arn:aws:ecs:us-east-1:277123456678:cluster/segmentation",
        "clusterName": "segmentation",
        "status": "ACTIVE",
        "registeredContainerInstancesCount": 0,
        "runningTasksCount": 0,
        "pendingTasksCount": 0,
        "activeServicesCount": 0,
        "statistics": [],
        "tags": [],
        "settings": [
            {
                "name": "containerInsights",
                "value": "disabled"
            }
        ],
        "capacityProviders": [
            "segment-capacity-provider"
        ],
        "defaultCapacityProviderStrategy": [
            {
                "capacityProvider": "segment-capacity-provider",
                "weight": 1,
                "base": 1
            }
        ],
        "attachments": [
            {
                "id": "e495f8aa-cdfd-4122-a314-cabe4e1b75a5",
                "type": "as_policy",
                "status": "PRECREATED",
                "details": [
                    {
                        "name": "capacityProviderName",
                        "value": "segment-capacity-provider"
                    },
                    {
                        "name": "scalingPolicyName",
                        "value": "ECSManagedAutoScalingPolicy-d511fb97-9824-49d5-96ba-b72d37a3724b"
                    }
                ]
            },
            {
                "id": "928d538c-d1c5-49ed-8315-3d4265e95408",
                "type": "managed_draining",
                "status": "PRECREATED",
                "details": [
                    {
                        "name": "capacityProviderName",
                        "value": "segment-capacity-provider"
                    },
                    {
                        "name": "autoScalingLifecycleHookName",
                        "value": "ecs-managed-draining-termination-hook"
                    }
                ]
            }
        ],
        "attachmentsStatus": "UPDATE_IN_PROGRESS"
    }
}
```

# Defining autoscaling properties
Ref: https://docs.aws.amazon.com/cli/latest/reference/autoscaling/put-scaling-policy.html
This tells the cluster (defining the metrics for scaling), when to scale up and down.  
Note: Run any one of these. If you try to run one and try another, the following error message will appear:
```
An error occurred (ValidationError) when calling the PutScalingPolicy operation: Only one TargetTrackingScaling policy for a given metric specification is allowed.
```

- Policy for **scaling-down** (reduce the number of instances)
```shell
aws autoscaling put-scaling-policy \
    --policy-name ScaleInPolicy \
    --auto-scaling-group-name segment-asg \
    --policy-type TargetTrackingScaling \
    --target-tracking-configuration '{
  "PredefinedMetricSpecification": {
    "PredefinedMetricType": "ASGAverageCPUUtilization"
  },
  "TargetValue": 20,
  "DisableScaleIn": false
}'
```
Response
```json
{
    "PolicyARN": "arn:aws:autoscaling:us-east-1:277123456678:scalingPolicy:01787356-3420-479a-ac03-7947ba5a1789:autoScalingGroupName/segment-asg:policyName/ScaleInPolicy",
    "Alarms": [
        {
            "AlarmName": "TargetTracking-segment-asg-AlarmHigh-edc2aee9-798c-4d9e-955c-4fda197d6995",
            "AlarmARN": "arn:aws:cloudwatch:us-east-1:277123456678:alarm:TargetTracking-segment-asg-AlarmHigh-edc2aee9-798c-4d9e-955c-4fda197d6995"
        },
        {
            "AlarmName": "TargetTracking-segment-asg-AlarmLow-2844dba1-6751-493f-80b9-d7b96763bfb6",
            "AlarmARN": "arn:aws:cloudwatch:us-east-1:277123456678:alarm:TargetTracking-segment-asg-AlarmLow-2844dba1-6751-493f-80b9-d7b96763bfb6"
        }
    ]
}
```

- Policy for **scaling-up** (adding more instances)
```shell
aws autoscaling put-scaling-policy \
    --policy-name ScaleOutPolicy \
    --auto-scaling-group-name segment-asg \
    --policy-type TargetTrackingScaling \
    --target-tracking-configuration '{
          "PredefinedMetricSpecification": {
            "PredefinedMetricType": "ASGAverageCPUUtilization"
          },
          "TargetValue": 90,
          "DisableScaleIn": false
}'
```

---

# Create a Load balancer
- To describe the subnets, use the following command:
```shell
aws ec2 describe-subnets --subnet-ids subnet-029...98d subnet-074...00f subnet-046...668 subnet-04e...d0d
```
Note: It generates a JSON response with details of above-mentioned subnets.


```shell
aws elbv2 create-load-balancer \
    --name segmentation-load-balancer \
    --subnets subnet-029...98d subnet-046...668 \
    --security-groups sg-065...1f3
```

Response:
```json
{
    "LoadBalancers": [
        {
            "LoadBalancerArn": "arn:aws:elasticloadbalancing:us-east-1:277123456678:loadbalancer/app/segmentation-load-balancer/fc3c3fd12a8c8322",
            "DNSName": "segmentation-load-balancer-2029600510.us-east-1.elb.amazonaws.com",
            "CanonicalHostedZoneId": "Z35SXDOTRQ7X7K",
            "CreatedTime": "2024-06-19T10:43:14.480000+00:00",
            "LoadBalancerName": "segmentation-load-balancer",
            "Scheme": "internet-facing",
            "VpcId": "vpc-0f9...465",
            "State": {
                "Code": "provisioning"
            },
            "Type": "application",
            "AvailabilityZones": [
                {
                    "ZoneName": "us-east-1b",
                    "SubnetId": "subnet-029...98d",
                    "LoadBalancerAddresses": []
                },
                {
                    "ZoneName": "us-east-1a",
                    "SubnetId": "subnet-046...668",
                    "LoadBalancerAddresses": []
                }
            ],
            "SecurityGroups": [
                "sg-065...1f3"
            ],
            "IpAddressType": "ipv4"
        }
    ]
}
```

## Delete load balancer
```shell
aws elbv2 delete-load-balancer \
    --load-balancer-arn arn:aws:elasticloadbalancing:us-east-1:277123456678:loadbalancer/app/segmentation-load-balancer/fc3c3fd12a8c8322
```
Note: This command does not produce any response.


# Create a Target Group
```shell
aws elbv2 create-target-group \
    --name segmentation-target-group \
    --protocol HTTP \
    --port 80 \
    --vpc-id vpc-0f9...465
```

Response:
```json
{
    "TargetGroups": [
        {
            "TargetGroupArn": "arn:aws:elasticloadbalancing:us-east-1:277123456678:targetgroup/segmentation-target-group/005adfd216d28e7f",
            "TargetGroupName": "segmentation-target-group",
            "Protocol": "HTTP",
            "Port": 80,
            "VpcId": "vpc-0f9...465",
            "HealthCheckProtocol": "HTTP",
            "HealthCheckPort": "traffic-port",
            "HealthCheckEnabled": true,
            "HealthCheckIntervalSeconds": 30,
            "HealthCheckTimeoutSeconds": 5,
            "HealthyThresholdCount": 5,
            "UnhealthyThresholdCount": 2,
            "HealthCheckPath": "/",
            "Matcher": {
                "HttpCode": "200"
            },
            "TargetType": "instance",
            "ProtocolVersion": "HTTP1",
            "IpAddressType": "ipv4"
        }
    ]
}
```

## Delete target group
```shell
aws elbv2 delete-target-group \
    --target-group-arn arn:aws:elasticloadbalancing:us-east-1:277123456678:targetgroup/segmentation-target-group/005adfd216d28e7f
```
Note: This command does not produce any response.


# Create a Listener
```shell
aws elbv2 create-listener \
    --load-balancer-arn arn:aws:elasticloadbalancing:us-east-1:277123456678:loadbalancer/app/segmentation-load-balancer/fc3c3fd12a8c8322 \
    --protocol HTTP \
    --port 80 \
    --default-actions Type=forward,TargetGroupArn=arn:aws:elasticloadbalancing:us-east-1:277123456678:targetgroup/segmentation-target-group/005adfd216d28e7f
```

Response:
```json
{
    "Listeners": [
        {
            "ListenerArn": "arn:aws:elasticloadbalancing:us-east-1:277123456678:listener/app/segmentation-load-balancer/fc3c3fd12a8c8322/0f0abb7c0b9411e3",
            "LoadBalancerArn": "arn:aws:elasticloadbalancing:us-east-1:277123456678:loadbalancer/app/segmentation-load-balancer/fc3c3fd12a8c8322",
            "Port": 80,
            "Protocol": "HTTP",
            "DefaultActions": [
                {
                    "Type": "forward",
                    "TargetGroupArn": "arn:aws:elasticloadbalancing:us-east-1:277123456678:targetgroup/segmentation-target-group/005adfd216d28e7f",
                    "ForwardConfig": {
                        "TargetGroups": [
                            {
                                "TargetGroupArn": "arn:aws:elasticloadbalancing:us-east-1:277123456678:targetgroup/segmentation-target-group/005adfd216d28e7f",
                                "Weight": 1
                            }
                        ],
                        "TargetGroupStickinessConfig": {
                            "Enabled": false
                        }
                    }
                }
            ]
        }
    ]
}
```

## Delete the listener
```shell
aws elbv2 delete-listener \
    --listener-arn arn:aws:elasticloadbalancing:us-east-1:277123456678:listener/app/segmentation-load-balancer/fc3c3fd12a8c8322/0f0abb7c0b9411e3
```
Note: This does not produce any output response.



# Create a service
```shell
aws ecs create-service \
    --cluster segmentation \
    --service-name segment-service \
    --task-definition segmentation_task_defn \
    --load-balancers targetGroupArn=arn:aws:elasticloadbalancing:us-east-1:277123456678:targetgroup/segmentation-target-group/005adfd216d28e7f,containerName=semantic_seg,containerPort=80 \
    --desired-count 0 \
    --launch-type EC2 \
```

Response:
```json
{
    "service": {
        "serviceArn": "arn:aws:ecs:us-east-1:277123456678:service/segmentation/segment-service",
        "serviceName": "segment-service",
        "clusterArn": "arn:aws:ecs:us-east-1:277123456678:cluster/segmentation",
        "loadBalancers": [
            {
                "targetGroupArn": "arn:aws:elasticloadbalancing:us-east-1:277123456678:targetgroup/segmentation-target-group/005adfd216d28e7f",
                "containerName": "semantic_seg",
                "containerPort": 80
            }
        ],
        "serviceRegistries": [],
        "status": "ACTIVE",
        "desiredCount": 0,
        "runningCount": 0,
        "pendingCount": 0,
        "launchType": "EC2",
        "taskDefinition": "arn:aws:ecs:us-east-1:277123456678:task-definition/segmentation_task_defn:2",
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
                "id": "ecs-svc/3801351585467015864",
                "status": "PRIMARY",
                "taskDefinition": "arn:aws:ecs:us-east-1:277123456678:task-definition/segmentation_task_defn:2",
                "desiredCount": 0,
                "pendingCount": 0,
                "runningCount": 0,
                "failedTasks": 0,
                "createdAt": "2024-06-19T16:47:40.303000+05:30",
                "updatedAt": "2024-06-19T16:47:40.303000+05:30",
                "launchType": "EC2",
                "rolloutState": "IN_PROGRESS",
                "rolloutStateReason": "ECS deployment ecs-svc/3801351585467015864 in progress."
            }
        ],
        "roleArn": "arn:aws:iam::277123456678:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS",
        "events": [],
        "createdAt": "2024-06-19T16:47:40.303000+05:30",
        "placementConstraints": [],
        "placementStrategy": [],
        "healthCheckGracePeriodSeconds": 0,
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

## List services linked attached with cluster
```shell
aws ecs list-services --cluster segmentation
```

## Delete a service
```shell
aws ecs delete-service --cluster segmentation --service segment-service --force
```