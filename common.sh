RED="\e[0;31m"
GREEN="\e[0;32m"
YELLOW="\e[0;33m"
RESET="\e[0m"

function echo_line(){
    echo -e "$YELLOW>>>>>>>$1<<<<<<<<<$RESET" 
}

function pre_req(){
    echo "$YELLOW>>>>>>>Add Application User and Create Directory<<<<<<<<<$RESET"
    userdel appuser
    rm -rf /app
    useradd -r -s /bin/false appuser
    mkdir -p /app 
    chown -R appuser:appuser /app
    chmod o-rwx /app -R

    echo "$YELLOW>>>>>>>Download and Install App Code<<<<<<<<<$RESET"
    curl -L -o /tmp/${component}.zip https://raw.githubusercontent.com/raghudevopsb89/roboshop-microservices/main/artifacts/${component}.zip
    cd /app
    unzip /tmp/${component}.zip
}
