#!/bin/bash
# This is for creating new Security groups update with inbound rules in aws

source ./tmp-common.v2.sh

check_root_user

#mogodb
    add_update_sg "mongodb" ${catalogue_sg}
    add_update_sg "mongodb" ${user_sg}

