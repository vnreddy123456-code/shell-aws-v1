#!/bin/bash
# This is for creating new SG in aws
source ./tmp-common.v2.sh

check_root_user

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
