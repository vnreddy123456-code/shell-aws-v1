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

shipping_sg="sg-0d55843faef6095cf"
payment_sg="sg-0f1b5da8ae2cb1b4c"
mongodb_sg="sg-09eabc9beac582d17"
dispatch_sg="sg-0ab67b1f94118f4cb"
cart_sg="sg-040851e4767933d74"
mysql_sg="sg-0a6eb820023260dd8"
user_sg="sg-03d34941e1db5097c"
redis_sg="sg-0d4deffe0397f7272"
frontend_sg="sg-0599893dba81ab3d1"
catalogue_sg="sg-06e71f5c101b4a86e"
rabbitmq_sg="sg-08b37a1d5b4506acc"

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

        gid="${1}_sg"
        port="${1}_port"
        echo "SG Update Start ${1} port: ${!port} and SG:${!gid}"
        aws ec2 authorize-security-group-ingress \
        --group-id ${!gid} \
        --protocol tcp \
        --port ${!port} \
        --source-group ${2} &>> $logs_file
        validate_input $? "${1}. port: ${!port} and SG:${!gid} added."
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
    gid='${1}_sg'
    port="${2}_port"
    aws ec2 authorize-security-group-ingress \
    --group-id ${gid} \
    --protocol tcp \
    --port ${port} \
    --source-group ${common_sg} &>> $logs_file
    validate_input $? "${1}"

} 