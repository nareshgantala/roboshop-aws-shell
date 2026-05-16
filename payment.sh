echo "$YELLOW>>>>>>> Install Python 3 <<<<<<<<<$RESET"
dnf install -y python3 python3-pip
python3 --version

echo "$YELLOW>>>>>>> Add Application User and Directory <<<<<<<<<$RESET"
userdel appuser
rm -rf /app
useradd -r -s /bin/false appuser
mkdir -p /app

echo "$YELLOW>>>>>>> Download and Install <<<<<<<<<$RESET"
curl -L -o /tmp/payment.zip https://raw.githubusercontent.com/raghudevopsb89/roboshop-microservices/main/artifacts/payment.zip
cd /app
unzip /tmp/payment.zip
pip3 install -r requirements.txt
chown -R appuser:appuser /app
chmod o-rwx /app -R

echo "$YELLOW>>>>>>> Configure Systemd Service <<<<<<<<<$RESET"
cp payment.service /etc/systemd/system/payment.service

echo "$YELLOW>>>>>>> Enable and Start <<<<<<<<<$RESET"
systemctl daemon-reload
systemctl enable payment
systemctl start payment

