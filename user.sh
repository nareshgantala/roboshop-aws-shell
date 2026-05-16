echo "$YELLOW>>>>>>> Install Node.js 20 <<<<<<<<<$RESET"

curl -fsSL https://rpm.nodesource.com/setup_20.x | bash -
dnf install -y nodejs

echo "$YELLOW>>>>>>> Add Application User and Create Directory <<<<<<<<<$RESET"

userdel appuser
rm -rf /app
useradd -r -s /bin/false appuser
mkdir -p /app

echo "$YELLOW>>>>>>>  Download and Install <<<<<<<<<$RESET"

curl -L -o /tmp/user.zip https://raw.githubusercontent.com/raghudevopsb89/roboshop-microservices/main/artifacts/user.zip
cd /app
unzip /tmp/user.zip
npm install --production
chown -R appuser:appuser /app
chmod o-rwx /app -R

echo "$YELLOW>>>>>>>  Configure Systemd Service <<<<<<<<<$RESET"
cp user.service /etc/systemd/system/user.service

echo "$YELLOW>>>>>>>  Start and Verify <<<<<<<<<$RESET"
systemctl daemon-reload
systemctl enable user
systemctl start user

