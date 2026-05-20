component=$1
source "$(dirname "${component}.sh")/common.sh"

pre_req
echo "${YELLOW}>>>>>>> Install Python 3 <<<<<<<<<${RESET}"
pyth_call

dnf install -y mysql8.4
status_check "install mysql"

echo "$YELLOW>>>>>>>Deploy Application <<<<<<<<<$RESET"
pip3 install -r /app/requirements.txt cryptography


mysql -h mysql.naresh-training.online -u root -pRoboShop@1 < db/schema.sql
status_check "db schema"
mysql -h mysql.naresh-training.online -u root -pRoboShop@1 < db/app-user.sql
status_check "app user db schema
"



systemd_call