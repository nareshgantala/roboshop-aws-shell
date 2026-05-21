component=$1
source "$(dirname "${component}.sh")/common.sh"

echo_line "Install the MySQL server package"
dnf install -y mysql8.4-server &>>${log_file}
status_check "Install the MySQL server package"

systemctl enable mysqld &>>${log_file}
systemctl start mysqld &>>${log_file}
status_check "start mysqld"

echo_line "Set Root Password"
mysql -u root -e "
  CREATE USER 'root'@'%' IDENTIFIED BY 'RoboShop@1';
  GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
  ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1';
  FLUSH PRIVILEGES;
" &>>${log_file}
status_check "Set Root Password"

