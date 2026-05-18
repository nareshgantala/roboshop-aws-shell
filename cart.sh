source=dir {component}

echo_line "InstallNodeJs"

curl -fsSL https://rpm.nodesource.com/setup_20.x | bash - &> /dev/null
dnf install -y nodejs

echo "$YELLOW>>>>>>>Add Application User and Create Directory<<<<<<<<<$RESET"
userdel appuser
rm -rf /app
useradd -r -s /bin/false appuser
mkdir -p /app


echo "$YELLOW>>>>>>>Download and Install App Code<<<<<<<<<$RESET"
curl -L -o /tmp/cart.zip https://raw.githubusercontent.com/raghudevopsb89/roboshop-microservices/main/artifacts/cart.zip
cd /app
unzip /tmp/cart.zip
npm install --production
chown -R appuser:appuser /app
chmod o-rwx /app -R

echo "$YELLOW>>>>>>>Configure Systemd Service<<<<<<<<<$RESET"
cp cart.service /etc/systemd/system/cart.service

echo "$YELLOW>>>>>>>Start and Verify<<<<<<<<<$RESET"
systemctl daemon-reload
systemctl enable cart
systemctl start cart