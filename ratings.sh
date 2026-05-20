component=$1
source "$(dirname "${component}.sh")/common.sh"

pre_req
echo "$YELLOW>>>>>>> Install Python 3 <<<<<<<<<$RESET"

dnf install -y python3 python3-pip mysql8.4


mysql -h mysql.naresh-training.online -u root -pRoboShop@1 < db/schema.sql
mysql -h mysql.naresh-training.online -u root -pRoboShop@1 < db/app-user.sql

echo "$YELLOW>>>>>>>Deploy Application <<<<<<<<<$RESET"

pip3 install -r /app/requirements.txt cryptography


systemd_call