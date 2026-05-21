component=frontend

source "$(dirname "${component}.sh")/common.sh"

echo_line "Install Nginx 1.26"
dnf install -y nginx unzip &>>${log_file}
status_check "Install Nginx 1.26"

echo_line "Configure Nginx" &>>${log_file}
cp nginx.conf /etc/nginx/nginx.conf &>>${log_file}
status_check "copy nginx.conf"

systemctl enable nginx &>>${log_file}
systemctl start nginx &>>${log_file}
status_check "start nginx service"

curl -fsSL https://rpm.nodesource.com/setup_20.x | bash -
dnf install -y nodejs
status_check "Install Nodejs"

echo_line "Download, Build, and Deploy"
curl -L -o /tmp/frontend.zip https://raw.githubusercontent.com/raghudevopsb89/roboshop-microservices/main/artifacts/frontend.zip
status_check "download code"

mkdir -p /tmp/frontend && cd /tmp/frontend &>>${log_file}


unzip /tmp/frontend.zip &>>${log_file}
status_check "unzip code"

npm install &>>${log_file}
status_check "npm install"

npm run build &>>${log_file}
status_check "npm build"

rm -rf /usr/share/nginx/html/* &>>${log_file}
cp -r out/* /usr/share/nginx/html/ &>>${log_file}
status_check "copy compiled code to html folder"

systemctl restart nginx &>>${log_file}


