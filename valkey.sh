component=$1
source "$(dirname "${component}.sh")/common.sh"

echo_line "Install Valkey"
dnf install -y valkey &>>${log_file}
status_check "valkey installation"

systemctl enable valkey &>>${log_file}
systemctl start valkey &>>${log_file}
status_check "start valkey"

echo_line "configure valkey"
sed -i "s/bind 127.0.0.1/bind 0.0.0.0/" /etc/valkey/valkey.conf &>>${log_file}
sed -i "s/protected-mode yes/protected-mode no" /etc/valkey/valkey.conf &>>${log_file}
status_check "update bind ip, protected mode"

systemctl restart valkey &>>${log_file}
status_check "restart valkey"