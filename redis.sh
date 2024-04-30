#!/bin/bash

ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
#In Script, whereever ECHO.ERROR statement comes, the & -> everything will comes and store it into LOGFILE.
#No need to CALL in Each and every ECHO/ERROR Line
exec &>$LOGFILE


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


#Installing REDIS

#Redis is offering the repo file as a rpm. Lets install it

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $LOGFILE
VALIDATE $? "Installing Remi Release" 

#Enable Redis 6.2 from package streams.

dnf module enable redis:remi-6.2 -y &>> $LOGFILE
VALIDATE$? "Enabling REDIS" 

dnf install redis -y &>> $LOGFILE
VALIDATE "Installing REDIS"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf &>> $LOGFILE
VALIDATE $? "allowing remote connections"

systemctl enable redis &>> $LOGFILE
VALIDATE $? "Enabled Redis"

systemctl start redis &>> $LOGFILE
VALIDATE $? "Started REDIS"