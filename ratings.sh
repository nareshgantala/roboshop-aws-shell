echo "$YELLOW>>>>>>> Install Python 3 <<<<<<<<<$RESET"

dnf install -y python3 python3-pip mysql8.4

echo "$YELLOW>>>>>>> Setup Database <<<<<<<<<$RESET"
curl -L -o /tmp/ratings.zip https://raw.githubusercontent.com/raghudevopsb89/roboshop-microservices/main/artifacts/ratings.zip
rm -rf /app
userdel appuser
mkdir -p /app && cd /app
unzip /tmp/ratings.zip
mysql -h <MYSQL-SERVER-IP> -u root -pRoboShop@1 < db/schema.sql
mysql -h <MYSQL-SERVER-IP> -u root -pRoboShop@1 < db/app-user.sql

echo "$YELLOW>>>>>>>Deploy Application <<<<<<<<<$RESET"
useradd -r -s /bin/false appuser
mkdir -p /app
pip3 install -r /app/requirements.txt cryptography
chown -R appuser:appuser /app
chmod o-rwx /app -R

echo "$YELLOW>>>>>>>Configure Systemd Service<<<<<<<<<$RESET"
cp ratings.service /etc/systemd/system/ratings.service

echo "$YELLOW>>>>>>>Enable and Start<<<<<<<<<$RESET"
systemctl daemon-reload
systemctl enable ratings
systemctl start ratings