component=$1
source "$(dirname "${component}.sh")/common.sh"

java_call

echo_line "copy db schema, user to mysql server"
mysql -h mysql.naresh-training.online -u root -pRoboShop@1 < db/schema.sql &>>${log_file}
mysql -h mysql.naresh-training.online -u root -pRoboShop@1 < db/app-user.sql &>>${log_file}
status_check "copy db schema, user to mysql server"

