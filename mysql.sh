component=$1
source "$(dirname "${component}.sh")/common.sh"

echo "$YELLOW>>>>>>>Install the MySQL server package<<<<<<<<<$RESET" | tee -a ${log_file}
dnf install -y mysql8.4-server &>>${log_file}
systemctl enable mysqld &>>${log_file}
systemctl start mysqld &>>${log_file}

echo "$YELLOW>>>>>>>Set Root Password<<<<<<<<<$RESET"
mysql -u root -e "
  CREATE USER 'root'@'%' IDENTIFIED BY 'RoboShop@1';
  GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
  ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1';
  FLUSH PRIVILEGES;
" &>>${log_file}

