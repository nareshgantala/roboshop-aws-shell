component=$1
source "$(dirname "${component}.sh")/common.sh"

echo "${YELLOW}>>>>>>> Install Valkey <<<<<<<<<${RESET}" | tee -a ${log_file}

dnf install -y valkey &>>${log_file}
systemctl enable valkey &>>${log_file}
systemctl start valkey &>>${log_file}

echo "${YELLOW}>>>>>>> configure valkey <<<<<<<<<${RESET}" | tee -a ${log_file}

sed -i "s/bind 127.0.0.1/bind 0.0.0.0/" /etc/valkey/valkey.conf &>>${log_file}
sed -i "s/protected-mode yes/protected-mode no" /etc/valkey/valkey.conf &>>${log_file}

systemctl restart valkey &>>${log_file}