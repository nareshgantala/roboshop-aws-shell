RED="\e[0;31m"
GREEN="\e[0;32m"
YELLOW="\e[0;33m"
RESET="\e[0m"

function echo_line(){
    echo -e "$YELLOW>>>>>>>$1<<<<<<<<<$RESET" 
}

function success(){
     echo -e "$GREEN>>>>>>>$1<<<<<<<<<$RESET" 
}

function failure(){
     echo -e "$RED>>>>>>>$1<<<<<<<<<$RESET" 
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
    if [ -e ${component}.service ]
    then
        echo_line "copy ${component}.service configuration file"
        cp ${component}.service /etc/systemd/system/${component}.service
        status_check "copy service file"
    fi


    id appuser
    if [ $? -eq 0 ]
    then
        success "app user alredy exists"
    else
        echo_line "Add Application User"
        useradd -r -s /bin/false appuser
        status_check "app user addition"
    fi

    echo_line "Create App directory"    
    rm -rf /app
    mkdir -p /app 
    status_check "app directory creation"

    echo_line "configure Application User permissions"
    chown -R appuser:appuser /app
    chmod o-rwx /app -R
    status_check "app permission configuration"

    echo_line "Download and Install App Code"
    curl -L -o /tmp/${component}.zip https://raw.githubusercontent.com/raghudevopsb89/roboshop-microservices/main/artifacts/${component}.zip
    status_check "Download and Install App Code"
    cd /app
    unzip /tmp/${component}.zip
    status_check "unzip Code"
}

function systemd_call(){
    echo_line "enable and restart systemd service"
    systemctl daemon-reload
    systemctl enable cart
    systemctl restart cart
    status_check "restart service"
}

function nodejs_call(){
    pre_req

    echo_line "InstallNodeJs"
    curl -fsSL https://rpm.nodesource.com/setup_20.x | bash - &> /dev/null
    dnf install -y nodejs
    status_check "nodejs installation"

    echo "$YELLOW>>>>>>>Install App Code<<<<<<<<<$RESET"
    npm install --production
    status_check "nodejs installation"

    systemd_call
}

function go_call(){
    echo_line "Install Go 1.22"
    dnf install -y golang git mysql8.4
    go version
    cd /app
    echo_line "Bild go app"
    go mod tidy
    CGO_ENABLED=0 go build -o /app/catalogue .
}

function nginx_call(){
    echo_line "Install Nginx 1.26"
    dnf install -y nginx
    systemctl enable nginx
    systemctl start nginx
    echo_line "Download, Build, and Deploy"
    curl -L -o /tmp/frontend.zip https://raw.githubusercontent.com/raghudevopsb89/roboshop-microservices/main/artifacts/frontend.zip
    mkdir -p /tmp/frontend && cd /tmp/frontend
    unzip /tmp/frontend.zip
    npm install
    npm run build
    rm -rf /usr/share/nginx/html/*
    cp -r out/* /usr/share/nginx/html/
    echo_line "Configure Nginx"
    cp nginx.conf /etc/nginx/nginx.conf
    systemctl restart nginx
}

function mongo_call(){
    echo_line "Add the MongoDB 7.0"
    cp mongo.repo /etc/yum.repos.d/mongodb-org-7.0.repo

    echo_line "Install the Package"
    dnf install -y mongodb-org

    echo_line "Enable and Start"
    systemctl enable mongod
    systemctl start mongod


    sed -i "s/bindIp: 127.0.0.1/bindIp: 0.0.0.0/" /etc/mongod.conf

    systemctl restart mongod
}

function java_call(){
    pre_req
    
    echo "Install Java 21"
    dnf install -y java-21-openjdk java-21-openjdk-devel maven
    mvn clean package -DskipTests
    cp target/${component}.jar /app/${component}.jar

    systemd_call
}

function pyth_call() {
    pre_req
    echo "Install Python 3"
    dnf install -y python3 python3-pip
    pip3 install -r requirements.txt
}
