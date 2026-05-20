component=$1
source "$(dirname "${component}.sh")/common.sh"
pre_req
go_call

echo "$YELLOW>>>>>>>Setup Database<<<<<<<<<$RESET"

mysql -h mysql.naresh-training.online -u root -pRoboShop@1 < db/schema.sql
mysql -h mysql.naresh-training.online -u root -pRoboShop@1 < db/app-user.sql
mysql -h mysql.naresh-training.online -u root -pRoboShop@1 catalogue < db/master-data.sql



echo "$YELLOW>>>>>>>Configure Systemd Service<<<<<<<<<$RESET"
cp catalogue.service /etc/systemd/system/catalogue.service

systemd_call