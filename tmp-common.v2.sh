#!/bin/bash
# This script is for creating new Security groups common code in aws
user_id=$(id -u)
logs_folder="/var/log/shell-practice"
logs_file="${logs_folder}/${0}.log"
R="\e[31m"
G="\e[32m"
N="\e[0m" # No Color
Y="\e[33m"

mkdir -p $logs_folder

echo "Script started at $(date)" >> $logs_file

common_sg="sg-07305c208ea935c3c"

shipping_sg="sg-05bc51050dcbeb09d"
rabbitmq_sg="sg-0b3393785cfb2e60d"
mysql_sg="sg-07253ada680f235b1"
catalogue_sg="sg-09d345b3c43bf57d3"
payment_sg="sg-04cc2d77a056e5837"
redis_sg="sg-08bed77cc90da7e23"
mongodb_sg="sg-0e972ae8e2a509928"
dispatch_sg="sg-0d2dbb62fcb789e34"
frontend_sg="sg-08ed3145fe1019776"
user_sg="sg-0159ff3c69dd9d1fd"
cart_sg="sg-05005504261c049ce"

mysql_port="3306"
redis_port="6379"
mongodb_port="27017"
rabbitmq_port="5672"
rabbitmq_ADMIN_port="15672"
catalogue_port="8080"
payment_port="8080"
user_port="8080"
cart_port="8080"
shipping_port="8080"
frontend_port="80"
ssh_port="22"

check_root_user() {
    if [ $user_id -ne 0 ]; then
        echo -e "${R}You should be root user to run this script.${N}" | tee -a $logs_file
        exit 1
    fi
}

validate_input() {
    if [ $1 -eq 0 ]; then
        echo -e "${2}..${G}SUCCESS.${N}" | tee -a $logs_file
    elif [ $1 -eq 254 ]; then
        echo -e "${2}..${Y}Groupid not found OR port already exists... SKIPPED...${N}" | tee -a $logs_file    
    else
        echo -e "${2}..${R}ERROR:${1} .. FAILED.${N}" | tee -a $logs_file
    fi
} 


add_update_sg() {

        aws ec2 authorize-security-group-ingress \
        --group-id ${"${1}_sg"} \
        --protocol tcp \
        --port ${"${1}_port"} \
        --source-group ${2} &>> $logs_file
        validate_input $? "${1}. port: ${2} and SG:${1} added."
}


#frontend
frontend_update_sg() {
    #Special Case for Frontend port 80
   aws ec2 authorize-security-group-ingress \
        --group-id ${frontend_sg} \
        --protocol tcp \
        --port ${frontend_port} \
        --cidr "0.0.0.0/0" &>> $logs_file  
    validate_input $? "Frontend"   
}

#common SG update
common_update_sg() {
    aws ec2 authorize-security-group-ingress \
    --group-id ${"${1}_sg"} \
    --protocol tcp \
    --port ${"${2}_port"} \
    --source-group ${common_sg} &>> $logs_file
    validate_input $? "${1}"

} 