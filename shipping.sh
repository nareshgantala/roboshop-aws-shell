echo "$YELLOW>>>>>>> Install Java 21 <<<<<<<<<$RESET"

dnf install -y java-21-openjdk java-21-openjdk-devel maven mysql8.4
java -version


echo "$YELLOW>>>>>>> Setup Database <<<<<<<<<$RESET"
userdel appuser
rm -rf /app
curl -L -o /tmp/shipping.zip https://raw.githubusercontent.com/raghudevopsb89/roboshop-microservices/main/artifacts/shipping.zip
mkdir -p /app
cd /app
unzip /tmp/shipping.zip
mysql -h <MYSQL-SERVER-IP> -u root -pRoboShop@1 < db/schema.sql
mysql -h <MYSQL-SERVER-IP> -u root -pRoboShop@1 < db/app-user.sql

echo "$YELLOW>>>>>>> Build and Deploy <<<<<<<<<$RESET"
useradd -r -s /bin/false appuser
cd /app
mvn clean package -DskipTests
cp target/shipping.jar /app/shipping.jar
chown -R appuser:appuser /app
chmod o-rwx /app -R

echo "$YELLOW>>>>>>>  Start and Verify <<<<<<<<<$RESET"
cp shipping.service /etc/systemd/system/shipping.service

echo "$YELLOW>>>>>>>  Start and Verify <<<<<<<<<$RESET"
systemctl daemon-reload
systemctl enable shipping
systemctl start shipping