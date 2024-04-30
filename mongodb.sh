#!/bin/bash

ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "Script Started Executing at $TIMESTAMP" &>> $LOGFILE

#Creating Funcition
VALIDATE() { 
    if [ $1 -ne 0 ]
    then 
        echo -e "$2 .. $R FAILED $N"
        exit 1
    else
        echo -e "$1 .. $G SUCCESS $N"
    fi 
}

# To check the Root user
if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:: Please run the script with root access $N"
    exit 1
else
    echo "You are ROOT USER"
fi # fi means reverse of if, indicating condition end


#Installing MONGODB

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE
VALIDATE $? "Copied MongoDB Repo" 

dnf install mongodb-org -y &>> $LOGFILE
VALIDATE $? "Installing MongDB" 

systemctl enable mongod &>> $LOGFILE
VALIDATE $? "Enabling MongoDB" 

systemctl start mongod &>> $LOGFILE
VALIDATE $? "Starting MongoDB" 

#vim /etc/mongod.conf &>> $LOGFILE

#Using SED Editor - To update/changes the Lines in the Background.
# Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf

sed -i 's/127.0.0.0/0.0.0.0/g' /etc/mongod.conf &>> $LOGFILE
VALIDATE $? 'Remote Access to MongoDB' 

systemctl restart mongod &>> $LOGFILE
VALIDATE $? "Restarting MongoDB" 

#NOTE -- We can reduce this VALIDATE option, will Discuss later.