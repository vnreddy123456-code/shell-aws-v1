#!/bin/bash
# This is for installing mongodb in aws
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

echo "Script started execution at $(date +"%F %T")" &>> $logs_file

validate() {
    if [ $1 -ne 0 ]; then
        echo -e "${2}..${R}FAILED.${N}" | tee -a $logs_file
    else
        echo -e "${2}..${G}SUCCESS${N}" | tee -a $logs_file
    fi
}

cp mongo.repo /etc/yum.repos.d/mongo.repo
validate $? "Adding mongo repo"

dnf install mongodb-org -y &>> $logs_file
validate $? "Install MongDB"

systemctl enable mongod &>> $logs_file
systemctl start mongod &>> $logs_file
validate $? "Enable and start MongoDB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
validate $? "Updating remote connections to MongoDB"

systemctl restart mongod
validate $? "Restarting MongoDB"
echo "Script completed execution at $(date +"%F %T")" &>> $logs_file