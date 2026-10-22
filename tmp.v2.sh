#!/bin/bash
# This is for creating new Security groups update with inbound rules in aws

source ./tmp-common.v2.sh

check_root_user

#mogodb
    add_update_sg "mongodb" ${catalogue_sg}
    add_update_sg "mongodb" ${user_sg}

#Redis
    add_update_sg "redis" ${user_sg}
    add_update_sg "redis" ${cart_sg}

#Mysql
    add_update_sg "mysql" ${shipping_sg}

#rabbitmq
    add_update_sg "rabbitmq" ${payment_sg} 
    add_update_sg "rabbitmq" ${dispatch_sg}

    #Special Case for RabbitMQ Admin port
    common_update_sg "rabbitmq" "rabbitmq_ADMIN"
#Catalogue
    add_update_sg "catalogue" ${cart_sg} 
    add_update_sg "catalogue" ${frontend_sg}
#User
    add_update_sg "user" ${payment_sg} 
    add_update_sg "user" ${frontend_sg}
#Cart
    add_update_sg "cart" ${shipping_sg} 
    add_update_sg "cart" ${frontend_sg}
    add_update_sg "cart" ${user_sg}
       
#Shipping
    add_update_sg "shipping" ${frontend_sg}
#Payment
    add_update_sg "payment" ${frontend_sg} 
#Frontend
    frontend_update_sg "frontend"   

#Optional...... Dispatch ...............
common_update_sg "dispatch" "ssh"

