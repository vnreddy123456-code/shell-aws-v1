#!/bin/bash
# This is for installing redis in aws
user_id=$(id -u)    
logs_folder="/var/log/shell-practice"
logs_file="${logs_folder}/${0}.log"
R="\e[31m"
G="\e[32m"
N="\e[0m" # No Color
Y="\e[33m"
vpc_id="vpc-05a34748a198812f0"
group_name="roboshop"

if [ $user_id -ne 0 ]; then
    echo -e "${R}Please run the script as root user${N}"
    exit 1
fi

mkdir -p $logs_folder

timestamp(){
    date "+%F %T" 
}

validate(){
    if [ $1 -ne 0 ]; then
        echo -e "$(timestamp) [ERROR] ${2}..${R}FAILED${N}" | tee -a $logs_file
        exit 1
    else
        echo -e "$(timestamp) [INFO] ${2}..${G}SUCCESS${N}" | tee -a $logs_file
    fi
}

echo "$(timestamp) [INFO] ==== Script started Execution =====" | tee -a $logs_file

dnf module disable redis -y &>> $logs_file
dnf module enable redis:7 -y &>> $logs_file
dnf install redis -y &>> $logs_file
validate $? "Installing Redis"

sed -i -e 's/^bind 127.0.0.1/bind 0.0.0.0/' -e 's/^protected-mode yes/protected-mode no/' /etc/redis/redis.conf
validate $? "Allowing remote connections to Redis"

systemctl enable redis &>> $logs_file
systemctl start redis
validate $? "Enable and start Redis"

echo "$(timestamp) [INFO] Script completed in $SECONDS seconds"
echo "$(timestamp) [INFO] ==== Script completed Execution =====" | tee -a $logs_file