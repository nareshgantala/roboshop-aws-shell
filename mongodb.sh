component=$1
source "$(dirname "${component}.sh")/common.sh"

echo_line "Add the MongoDB 7.0" 
cp mongo.repo /etc/yum.repos.d/mongodb-org-7.0.repo &>>${log_file}
status_check "Add the MongoDB 7.0"

echo_line "Install the Package"
dnf install -y mongodb-org &>>${log_file} 
status_check "Install the Package"

echo_line "Enable and Start"
systemctl enable mongod &>>${log_file}
systemctl start mongod &>>${log_file}
status_check "start mongo"


sed -i "s/bindIp: 127.0.0.1/bindIp: 0.0.0.0/" /etc/mongod.conf &>>${log_file}
status_check "update bindip"

systemctl restart mongod &>>${log_file}
status_check "restart mongo"
