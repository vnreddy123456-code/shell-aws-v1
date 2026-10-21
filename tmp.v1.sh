#!/bin/bash
# This is for creating new Security groups update with inbound rules in aws


mysql_sg="sg-0f7150e0131efa770"
redis_sg="sg-0432aa3e07739b38d"
catalogue_sg="sg-06862356cb315985c"
frontend_sg="sg-06a86884d2a9de796"
dispatch_sg="sg-05f34277487186fad"
cart_sg="sg-0122ed046e399c5e0"
payment_sg="sg-09c7bf5cd25b21aca"
rabbitmq_sg="sg-0e305ab87769aea17"
shipping_sg="sg-083c984d59946dbf7"
user_sg="sg-047e6faff5e30b726"
mongodb_sg="sg-057ba51c678120834"

mysql_port="3306"
redis_port="6379"
mongodb_port="27017"
rabbitmq_port="5672"
rabbitmq_ADMIN_port="15672"
service_port="8080"
server_http_port="80"

validate() {
   echo "${1} - Update Security group inbound rules ... SUCCESS"
}  

#mogodb
    aws ec2 authorize-security-group-ingress \
    --group-id ${mongodb_sg} \
    --protocol tcp \
    --port ${mongodb_port} \
    --source-group ${catalogue_sg} ${user_sg} 
    

    aws ec2 authorize-security-group-ingress \
    --group-id ${mongodb_sg} \
    --protocol tcp \
    --port ${mongodb_port} \
    --source-group ${user_sg}
    validate "Mongodb"

#Redis
 aws ec2 authorize-security-group-ingress \
    --group-id ${redis_sg} \
    --protocol tcp \
    --port ${redis_port} \
    --source-group ${user_sg}

   aws ec2 authorize-security-group-ingress \
    --group-id ${redis_sg} \
    --protocol tcp \
    --port ${redis_port} \
    --source-group ${cart_sg}  
    validate "Redis"    

#Mysql
 aws ec2 authorize-security-group-ingress \
    --group-id ${mysql_sg} \
    --protocol tcp \
    --port ${mysql_port} \
    --source-group ${shipping_sg}
    validate "Mysql"

#rabbitmq
    aws ec2 authorize-security-group-ingress \
    --group-id ${rabbitmq_sg} \
    --protocol tcp \
    --port ${rabbitmq_port} \
    --source-group ${payment_sg}

    aws ec2 authorize-security-group-ingress \
    --group-id ${rabbitmq_sg} \
    --protocol tcp \
    --port ${rabbitmq_port} \
    --source-group ${dispatch_sg}

     aws ec2 authorize-security-group-ingress \
    --group-id ${rabbitmq_sg} \
    --protocol tcp \
    --port ${rabbitmq_ADMIN_port} \
    --source-group ${user_sg}

validate "RabbitMQ"
#Catalogue
    aws ec2 authorize-security-group-ingress \
    --group-id ${catalogue_sg} \
    --protocol tcp \
    --port ${service_port} \
    --source-group ${frontend_sg}

    aws ec2 authorize-security-group-ingress \
    --group-id ${catalogue_sg} \
    --protocol tcp \
    --port ${service_port} \
    --source-group ${cart_sg}

   validate "Catalogue"
#User
    aws ec2 authorize-security-group-ingress \
        --group-id ${user_sg} \
        --protocol tcp \
        --port ${service_port} \
        --source-group ${frontend_sg}

        aws ec2 authorize-security-group-ingress \
        --group-id ${user_sg} \
        --protocol tcp \
        --port ${service_port} \
        --source-group ${user_sg}  

        validate "User"  

#Cart
    aws ec2 authorize-security-group-ingress \
        --group-id ${cart_sg} \
        --protocol tcp \
        --port ${service_port} \
        --source-group ${frontend_sg}

    aws ec2 authorize-security-group-ingress \
        --group-id ${cart_sg} \
        --protocol tcp \
        --port ${service_port} \
        --source-group ${shipping_sg}    

     aws ec2 authorize-security-group-ingress \
        --group-id ${cart_sg} \
        --protocol tcp \
        --port ${service_port} \
        --source-group ${user_sg}    

    validate "Cart"    
   
#Shipping
   aws ec2 authorize-security-group-ingress \
        --group-id ${shipping_sg} \
        --protocol tcp \
        --port ${service_port} \
        --source-group ${frontend_sg}   

     validate "Shipping"   

#Payment
   aws ec2 authorize-security-group-ingress \
        --group-id ${payment_sg} \
        --protocol tcp \
        --port ${service_port} \
        --source-group ${frontend_sg} 
     validate "Payment"   

#frontend
   aws ec2 authorize-security-group-ingress \
        --group-id ${frontend_sg} \
        --protocol tcp \
        --port ${server_http_port} \
        --cidr "0.0.0.0/0"  
    validate "Frontend"       

#Optional...... Dispatch ...............
#    aws ec2 authorize-security-group-ingress \
#        --group-id "${dispatch-sg}" \
#        --protocol tcp \
#        --port 22 \
#        --source-group "sg-07305c208ea935c3c"  
#    validate "Dispatch"                      