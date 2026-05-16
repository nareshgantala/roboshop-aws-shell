echo "$YELLOW>>>>>>> Install Erlang <<<<<<<<<$RESET"
cat > /etc/yum.repos.d/rabbitmq_erlang.repo << 'EOF'
[rabbitmq_erlang]
name=rabbitmq_erlang
baseurl=https://packagecloud.io/rabbitmq/erlang/el/9/$basearch
gpgcheck=0
enabled=1
EOF
dnf install -y erlang

echo "$YELLOW>>>>>>> Add the RabbitMQ Repository and Install <<<<<<<<<$RESET"
cat > /etc/yum.repos.d/rabbitmq_rabbitmq-server.repo << 'EOF'
[rabbitmq_rabbitmq-server]
name=rabbitmq_rabbitmq-server
baseurl=https://packagecloud.io/rabbitmq/rabbitmq-server/el/9/$basearch
gpgcheck=0
enabled=1
EOF

dnf install -y rabbitmq-server

echo "$YELLOW>>>>>>> Enable and Start <<<<<<<<<$RESET"
systemctl enable rabbitmq-server
systemctl start rabbitmq-server

echo "$YELLOW>>>>>>> create dedicated rabbitmq user <<<<<<<<<$RESET"
rabbitmqctl add_user roboshop RoboShop@1
rabbitmqctl set_user_tags roboshop administrator
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"

systemctl restart rabbitmq-server

