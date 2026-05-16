echo "$YELLOW>>>>>>>Install Nginx 1.26<<<<<<<<<$RESET"
dnf install -y nginx
systemctl enable nginx
systemctl start nginx

echo "$YELLOW>>>>>>>Install Node.js 20<<<<<<<<<$RESET"
curl -fsSL https://rpm.nodesource.com/setup_20.x | bash -
dnf install -y nodejs

echo "$YELLOW>>>>>>>Download, Build, and Deploy<<<<<<<<<$RESET"
curl -L -o /tmp/frontend.zip https://raw.githubusercontent.com/raghudevopsb89/roboshop-microservices/main/artifacts/frontend.zip
mkdir -p /tmp/frontend && cd /tmp/frontend
unzip /tmp/frontend.zip
npm install
npm run build
rm -rf /usr/share/nginx/html/*
cp -r out/* /usr/share/nginx/html/

echo "$YELLOW>>>>>>>Configure Nginx<<<<<<<<<$RESET"
cp nginx.conf /etc/nginx/nginx.conf


systemctl restart nginx
