
source "$(dirname "${component}.sh")/common.sh"

echo_line "Install Erlang"
cat > /etc/yum.repos.d/rabbitmq_erlang.repo << 'EOF' 
[rabbitmq_erlang]
name=rabbitmq_erlang
baseurl=https://packagecloud.io/rabbitmq/erlang/el/9/$basearch
gpgcheck=0
enabled=1
EOF 
dnf install -y erlang &>>${log_file}
status_check "install erlang"

echo_line "Add the RabbitMQ Repository and Install"
cat > /etc/yum.repos.d/rabbitmq_rabbitmq-server.repo << 'EOF' 
[rabbitmq_rabbitmq-server]
name=rabbitmq_rabbitmq-server
baseurl=https://packagecloud.io/rabbitmq/rabbitmq-server/el/9/$basearch
gpgcheck=0
enabled=1
EOF

dnf install -y rabbitmq-server &>>${log_file}
status_check "install rabbitmq server"

echo -e "${YELLOW}>>>>>>> Enable and Start <<<<<<<<<${RESET}" | tee -a ${log_file}
systemctl enable rabbitmq-server &>>${log_file}
systemctl start rabbitmq-server &>>${log_file}
status_check "start rabbitmq server"

echo_line "create dedicated rabbitmq user"
rabbitmqctl add_user roboshop RoboShop@1 &>>${log_file}
rabbitmqctl set_user_tags roboshop administrator &>>${log_file}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${log_file}
status_check "set permissions for rabbitmq user"


systemctl restart rabbitmq-server &>>${log_file}
status_check "restart rabbitmq user"