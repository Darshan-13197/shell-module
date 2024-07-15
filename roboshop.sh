#!/bin/bash

#replace the AMI, SG_ID, ZONE_ID, Domain
AMI=ami-0b4f379183e5706b9
SG_ID=sg-0dfadc3db09f8f96d
ZONE_ID=Z01824442MLFHOL5P289V
DOMAIN_NAME="darshanshop.online"

# Creating as an Array
INSTANCES=("mongodb" "mysql" "redis" "rabbitmq" "web" "cart" "user" "catalogue" "shipping" "payment" "dispatch")

#using for loop
for i in "${INSTANCES[@]}" #looping all instances
do
    #echo "Instance is: $i"
    if [ $i == "mongodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ] 
    then 
        INSTANCE_TYPE="t3.small"
    else
        INSTANCE_TYPE="t2.micro"
    fi

    #The command of creating the EC2 Instances
    #IP_ADDRESS=$(aws ec2 run-instances --image-id ami-0f3c7d07486cad139 --instance-type $INSTANCE_TYPE --security-group-ids sg-0dfadc3db09f8f96d --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query 'Instances[0].PrivateIpAddress' --output text) #Instances[0] like an array
    IP_ADDRESS=$(aws ec2 run-instances --image-id $AMI --instance-type $INSTANCE_TYPE --security-group-ids $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query 'Instances[0].PrivateIpAddress' --output text) #Instances[0] like an array



    echo "$i: $IP_ADDRESS" #will get to know the IP address of the Instances

    #create R53 record, make sure you delete existing record
    aws route53 change-resource-record-sets \
    --hosted-zone-id $ZONE_ID \
    --change-batch '
    {
        "Comment": "Creating a record set for cognito endpoint"
        ,"Changes": [{
        "Action"              : "UPSERT"
        ,"ResourceRecordSet"  : {
            "Name"              : "'$i'.'$DOMAIN_NAME'"
            ,"Type"             : "A" 
            ,"TTL"              : 1
            ,"ResourceRecords"  : [{
                "Value"         : "'$IP_ADDRESS'"
            }]
        }
        }]
    }
    '

done





