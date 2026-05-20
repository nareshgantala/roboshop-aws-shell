log_file=/tmp/roboshop.log

RED="\e[0;31m"
GREEN="\e[0;32m"
YELLOW="\e[0;33m"
RESET="\e[0m"

function echo_line(){
    echo -e "$YELLOW>>>>>>>$1<<<<<<<<<$RESET" | tee -a ${log_file}
}

function success(){
     echo -e "$GREEN>>>>>>>$1<<<<<<<<<$RESET" | tee -a ${log_file}
}

function failure(){
     echo -e "$RED>>>>>>>$1<<<<<<<<<$RESET" | tee -a ${log_file}
}

function status_check(){
    if [ $? -eq 0 ]
    then
        success "$1 step is successful"
    else
        failure "$1 step is failure"
    fi
}

function pre_req(){
    dnf install -y unzip
    if [ -e ${component}.service ]
    then
        echo_line "copy ${component}.service configuration file"
        cp ${component}.service /etc/systemd/system/${component}.service &>>${log_file}
        status_check "copy service file"
    fi


    id appuser
    if [ $? -eq 0 ]
    then
        success "app user alredy exists"
    else
        echo_line "Add Application User"
        useradd -r -s /bin/false appuser &>>${log_file}
        status_check "app user addition"
    fi

    echo_line "Create App directory"    
    rm -rf /app &>>${log_file}
    mkdir -p /app  &>>${log_file}
    status_check "app directory creation"

    echo_line "configure Application User permissions"
    chown -R appuser:appuser /app &>>${log_file}
    chmod o-rwx /app -R &>>${log_file}
    status_check "app permission configuration"

    echo_line "Download and Install App Code"
    curl -L -o /tmp/${component}.zip https://raw.githubusercontent.com/raghudevopsb89/roboshop-microservices/main/artifacts/${component}.zip &>>${log_file}
    status_check "Download and Install App Code"
    cd /app &>>${log_file}
    unzip /tmp/${component}.zip &>>${log_file}
    status_check "unzip Code"
}

function systemd_call(){
    echo_line "enable and restart systemd service"
    systemctl daemon-reload &>>${log_file}
    systemctl enable ${component} &>>${log_file}
    systemctl restart ${component} &>>${log_file}
    status_check "restart service"
}

function nodejs_call(){
    pre_req

    echo_line "InstallNodeJs"
    curl -fsSL https://rpm.nodesource.com/setup_20.x | bash - &>>${log_file}
    dnf install -y nodejs &>>${log_file}
    status_check "nodejs installation"

    echo "$YELLOW>>>>>>>Install App Code<<<<<<<<<$RESET"
    npm install --production &>>${log_file}
    status_check "nodejs installation"

    systemd_call
}

function go_call(){
    pre_req
    echo_line "Install Go 1.22"
    dnf install -y golang git mysql8.4 &>>${log_file}
    go version &>>${log_file}
    cd /app &>>${log_file}
    echo_line "Bild go app"
    go mod tidy &>>${log_file}
    CGO_ENABLED=0 go build -o /app/catalogue . &>>${log_file}
    systemd_call
}

function nginx_call(){
    echo_line "Install Nginx 1.26"
    dnf install -y nginx &>>${log_file}
    systemctl enable nginx &>>${log_file}
    systemctl start nginx &>>${log_file}
    echo_line "Download, Build, and Deploy"
    curl -L -o /tmp/frontend.zip https://raw.githubusercontent.com/raghudevopsb89/roboshop-microservices/main/artifacts/frontend.zip
    mkdir -p /tmp/frontend && cd /tmp/frontend &>>${log_file}
    unzip /tmp/frontend.zip &>>${log_file}
    npm install &>>${log_file}
    npm run build &>>${log_file}
    rm -rf /usr/share/nginx/html/* &>>${log_file}
    cp -r out/* /usr/share/nginx/html/ &>>${log_file}
    echo_line "Configure Nginx" &>>${log_file}
    cp nginx.conf /etc/nginx/nginx.conf &>>${log_file}
    systemctl restart nginx &>>${log_file}
}

function mongo_call(){
    echo_line "Add the MongoDB 7.0" 
    cp mongo.repo /etc/yum.repos.d/mongodb-org-7.0.repo &>>${log_file}
 
    echo_line "Install the Package"
    dnf install -y mongodb-org &>>${log_file} 

    echo_line "Enable and Start"
    systemctl enable mongod &>>${log_file}
    systemctl start mongod &>>${log_file}


    sed -i "s/bindIp: 127.0.0.1/bindIp: 0.0.0.0/" /etc/mongod.conf &>>${log_file}

    systemctl restart mongod &>>${log_file}
}

function java_call(){
    pre_req
    
    echo "Install Java 21"
    dnf install -y java-21-openjdk java-21-openjdk-devel maven &>>${log_file}
    mvn clean package -DskipTests &>>${log_file}
    cp target/${component}.jar /app/${component}.jar &>>${log_file}

    systemd_call
}

function pyth_call() {
    pre_req
    echo "Install Python 3"
    dnf install -y python3 python3-pip &>>${log_file}
    pip3 install -r requirements.txt &>>${log_file}
}
