#!/bin/bash
# This is for creating new Security groups update with inbound rules in aws


mysql-sg="sg-0f7150e0131efa770"
redis-sg="sg-0432aa3e07739b38d"
catalogue-sg="sg-06862356cb315985c"
frontend-sg="sg-06a86884d2a9de796"
dispatch-sg="sg-05f34277487186fad"
cart-sg="sg-0122ed046e399c5e0"
payment-sg="sg-09c7bf5cd25b21aca"
robbitmq-sg="sg-0e305ab87769aea17"
shipping-sg="sg-083c984d59946dbf7"
user-sg="sg-047e6faff5e30b726"
mongodb-sg="sg-057ba51c678120834"

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
    --group-id ${mongodb-sg} \
    --protocol tcp \
    --port ${mongodb_port} \
    --source-group ${catalogue-sg} ${user-sg} 
    

    aws ec2 authorize-security-group-ingress \
    --group-id ${mongodb-sg} \
    --protocol tcp \
    --port ${mongodb_port} \
    --source-group ${user-sg}
    validate "Mongodb"

#Redis
 aws ec2 authorize-security-group-ingress \
    --group-id ${redis-sg} \
    --protocol tcp \
    --port ${redis_port} \
    --source-group ${user-sg}

   aws ec2 authorize-security-group-ingress \
    --group-id ${redis-sg} \
    --protocol tcp \
    --port ${redis_port} \
    --source-group ${cart-sg}  
    validate "Redis"    

#Mysql
 aws ec2 authorize-security-group-ingress \
    --group-id ${mysql-sg} \
    --protocol tcp \
    --port ${mysql_port} \
    --source-group ${shipping-sg}
    validate "Mysql"

#rabbitmq
    aws ec2 authorize-security-group-ingress \
    --group-id ${rabbitmq-sg} \
    --protocol tcp \
    --port ${rabbitmq_port} \
    --source-group ${payment-sg}

    aws ec2 authorize-security-group-ingress \
    --group-id ${rabbitmq-sg} \
    --protocol tcp \
    --port ${rabbitmq_port} \
    --source-group ${dispatch-sg}

     aws ec2 authorize-security-group-ingress \
    --group-id ${rabbitmq-sg} \
    --protocol tcp \
    --port ${rabbitmq_ADMIN_port} \
    --source-group ${user-sg}

validate "RabbitMQ"
#Catalogue
    aws ec2 authorize-security-group-ingress \
    --group-id ${catalogue-sg} \
    --protocol tcp \
    --port ${service_port} \
    --source-group ${frontend-sg}

    aws ec2 authorize-security-group-ingress \
    --group-id ${catalogue-sg} \
    --protocol tcp \
    --port ${service_port} \
    --source-group ${cart-sg}

   validate "Catalogue"
#User
    aws ec2 authorize-security-group-ingress \
        --group-id ${user-sg} \
        --protocol tcp \
        --port ${service_port} \
        --source-group ${frontend-sg}

        aws ec2 authorize-security-group-ingress \
        --group-id ${user-sg} \
        --protocol tcp \
        --port ${service_port} \
        --source-group ${user-sg}  

        validate "User"  

#Cart
    aws ec2 authorize-security-group-ingress \
        --group-id ${cart-sg} \
        --protocol tcp \
        --port ${service_port} \
        --source-group ${frontend-sg}

    aws ec2 authorize-security-group-ingress \
        --group-id ${cart-sg} \
        --protocol tcp \
        --port ${service_port} \
        --source-group ${shipping-sg}    

     aws ec2 authorize-security-group-ingress \
        --group-id ${cart-sg} \
        --protocol tcp \
        --port ${service_port} \
        --source-group ${user-sg}    

    validate "Cart"    
   
#Shipping
   aws ec2 authorize-security-group-ingress \
        --group-id ${shipping-sg} \
        --protocol tcp \
        --port ${service_port} \
        --source-group ${frontend-sg}   

     validate "Shipping"   

#Payment
   aws ec2 authorize-security-group-ingress \
        --group-id ${payment-sg} \
        --protocol tcp \
        --port ${service_port} \
        --source-group ${frontend-sg} 
     validate "Payment"   

#frontend
   aws ec2 authorize-security-group-ingress \
        --group-id ${frontend-sg} \
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