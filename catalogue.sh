RED=\e[0;31m
GREEN=\e[0;32m
YELLOW=\e[0;33m
RESET=\e[0m

echo "$YELLOW>>>>>>>Install Go 1.22<<<<<<<<<$RESET"
dnf install -y golang git mysql8.4
go version


echo "$YELLOW>>>>>>>Setup Database<<<<<<<<<$RESET"
userdel appuser
rm -rf /app
curl -L -o /tmp/catalogue.zip https://raw.githubusercontent.com/raghudevopsb89/roboshop-microservices/main/artifacts/catalogue.zip
mkdir -p /app
cd /app
unzip /tmp/catalogue.zip
mysql -h <MYSQL-SERVER-IP> -u root -pRoboShop@1 < db/schema.sql
mysql -h <MYSQL-SERVER-IP> -u root -pRoboShop@1 < db/app-user.sql
mysql -h <MYSQL-SERVER-IP> -u root -pRoboShop@1 catalogue < db/master-data.sql

echo "$YELLOW>>>>>>>Add Application User, Create Directory, and Build Binary<<<<<<<<<$RESET"
useradd -r -s /bin/false appuser
cd /app
go mod tidy
CGO_ENABLED=0 go build -o /app/catalogue .
chown -R appuser:appuser /app
chmod o-rwx /app -R

echo "$YELLOW>>>>>>>Configure Systemd Service<<<<<<<<<$RESET"
cp catalogue.service /etc/systemd/system/catalogue.service

echo "$YELLOW>>>>>>>Start and Verify<<<<<<<<<$RESET"
systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue