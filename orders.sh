echo "$YELLOW>>>>>>> Install Java 21<<<<<<<<<$RESET"
dnf install -y java-21-openjdk java-21-openjdk-devel maven

echo "$YELLOW>>>>>>> Add User, Download, Build, and Deploy<<<<<<<<<$RESET"
useradd -r -s /bin/false appuser
mkdir -p /app
curl -L -o /tmp/orders.zip https://raw.githubusercontent.com/raghudevopsb89/roboshop-microservices/main/artifacts/orders.zip
mkdir -p /app && cd /app
unzip /tmp/orders.zip
mvn clean package -DskipTests
cp target/orders.jar /app/orders.jar
chown -R appuser:appuser /app
chmod o-rwx /app -R

echo "$YELLOW>>>>>>> Configure Systemd Service<<<<<<<<<$RESET"
cp orders.service /etc/systemd/system/orders.service

echo "$YELLOW>>>>>>> Enable and Start<<<<<<<<<$RESET"
systemctl daemon-reload
systemctl enable orders
systemctl start orders

