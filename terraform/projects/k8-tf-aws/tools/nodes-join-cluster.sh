#!/bin/env bash
#set -x

# Get a list of instances
INSTANCE_IDS=$(aws autoscaling   describe-auto-scaling-groups --auto-scaling-group-names k8-cluster-node-asg --region eu-west-2 --query 'AutoScalingGroups[*].Instances[*].InstanceId' | jq '.[]|.[]')

# Get the Private DNS name
for i in ${INSTANCE_IDS[@]}
 do
  instanceID=$(echo $i | sed 's/"//g')
  aws ec2 describe-instances --instance-ids $instanceID --region eu-west-2 --query 'Reservations[*].Instances[*].PrivateDnsName'| jq '.[]|.[]'
 done
