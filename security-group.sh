#!/bin/bash
# This is for creating new SG in aws
logs_folder="/var/log/shell-practice"
logs_file="${logs_folder}/${0}.log"
R="\e[31m"
G="\e[32m"
N="\e[0m" # No Color
Y="\e[33m"
vpc_id="vpc-05a34748a198812f0"
group_name="roboshop"

mkdir -p $logs_folder

echo "Script started at $(date)" >> $logs_file
echo "SG Creation Start"


for package in $@
do
    echo "SG Creation Start $group_name"
    aws ec2 create-security-group \
        --group-name ${group_name}-${package} \
        --description "Security group for ${package}" \
        --vpc-id $vpc_id
    validate_input $? "${group_name}-${package}"
    echo "SG Created Done ${group_name}-${package}"
done



validate_input() {
    if [$1 -ne 0]; then
        echo -e "${2}..${R}FAILED.${N}" | tee -a $logs_file
    else
        echo -e "${2}..${G}SUCCESS${N}" | tee -a $logs_file
    fi
}