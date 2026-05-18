component=$1
source "$(dirname "${component}.sh")/common.sh"

java_call

echo_line "copy db schema, user to mysql server"
mysql -h <MYSQL-SERVER-IP> -u root -pRoboShop@1 < db/schema.sql
mysql -h <MYSQL-SERVER-IP> -u root -pRoboShop@1 < db/app-user.sql
status_check "copy db schema, user to mysql server"

