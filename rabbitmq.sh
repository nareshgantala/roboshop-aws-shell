echo "${YELLOW}>>>>>>> Install Erlang <<<<<<<<<${RESET}" | tee -a ${log_file}
cat > /etc/yum.repos.d/rabbitmq_erlang.repo << 'EOF'
[rabbitmq_erlang]
name=rabbitmq_erlang
baseurl=https://packagecloud.io/rabbitmq/erlang/el/9/$basearch
gpgcheck=0
enabled=1
EOF &>>${log_file}
dnf install -y erlang &>>${log_file}

echo "${YELLOW}>>>>>>> Add the RabbitMQ Repository and Install <<<<<<<<<${RESET}" | tee -a ${log_file}
cat > /etc/yum.repos.d/rabbitmq_rabbitmq-server.repo << 'EOF'
[rabbitmq_rabbitmq-server]
name=rabbitmq_rabbitmq-server
baseurl=https://packagecloud.io/rabbitmq/rabbitmq-server/el/9/$basearch
gpgcheck=0
enabled=1
EOF &>>${log_file}

dnf install -y rabbitmq-server &>>${log_file}

echo "${YELLOW}>>>>>>> Enable and Start <<<<<<<<<${RESET}" | tee -a ${log_file}
systemctl enable rabbitmq-server &>>${log_file}
systemctl start rabbitmq-server &>>${log_file}

echo "${YELLOW}>>>>>>> create dedicated rabbitmq user <<<<<<<<<${RESET}" | tee -a ${log_file}
rabbitmqctl add_user roboshop RoboShop@1 &>>${log_file}
rabbitmqctl set_user_tags roboshop administrator &>>${log_file}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${log_file}

systemctl restart rabbitmq-server &>>${log_file}