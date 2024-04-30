#!/bin/bash

ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

#Declaring MONGODB_HOST Variable and calling throght it.
MONGODB_HOST=mongodb.darshanshop.online

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
        echo -e "$2 .. $G SUCCESS $N"
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

# Installation of CATALOGUE

dnf module disable nodejs -y &>> $LOGFILE
VALIDATE $? 'Disabling Current NodeJS' 

#Installing NodeJS version 18
dnf module enable nodejs:18 -y &>> $LOGFILE
VALIDATE $? 'Enabling NodeJS18' 

dnf install nodejs -y &>> $LOGFILE
VALIDATE $? 'Installing NOodeJS-18' 

# For Roboshop user, creating If condition

id roboshop #if roboshop user does not exist, then it is failure
if [ $? -ne 0 ]
then
    useradd roboshop
    VALIDATE $? "roboshop user creation"
else
    echo -e "roboshop user already exist $Y SKIPPING $N"
fi

#We keep application in one standard location. So Create a /app directory
#Using -p it won't throw any error if /app dir exists

mkdir -p /app &>> $LOGFILE
VALIDATE $? "Creating app Directory" 

#Download the application code to created app directory.

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE
VALIDATE $? "Downloading the Catalogue Application Code"

cd /app 
#VALIDATE $? "Entering into /app Directory" &>> $LOGFILE

unzip -o /tmp/catalogue.zip &>> $LOGFILE # o --> overwrite
VALIDATE $? "Unzipping Catalogue"

#Lets download the dependencies.

npm install &>> $LOGFILE
VALIDATE $? "Installing Dependencied of NodeJS" 

#We need to setup a new service in systemd so systemctl can manage this service
#So, we are copying it. Use Absolute Path, Because catalogue path exist there.

cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service &>> $LOGFILE
VALIDATE $? "Copying Catalogue Service File"

systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "Catalogue Daemon Reload"

systemctl enable catalogue &>> $LOGFILE
VALIDATE $? "Enable Catalogue"

systemctl start catalogue &>> $LOGFILE
VALIDATE $? "Start Catalogue"

# We need to Load Schema in DB, so Install MySQL Client i.e. mongo.repo

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE
VALIDATE $? "Copying mongodbrepo" 

dnf install mongodb-org-shell -y &>> $LOGFILE
VALIDATE $? "Installing MongoDB Client"

#Load Schema

mongo --host $MONGODB_HOST </app/schema/catalogue.js &>> $LOGFILE
VALIDATE $? "Loading Catalogue Data into MongoDB"
