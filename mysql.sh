echo "$YELLOW>>>>>>>Install the MySQL server package<<<<<<<<<$RESET"
dnf install -y mysql8.4-server
systemctl enable mysqld
systemctl start mysqld

echo "$YELLOW>>>>>>>Set Root Password<<<<<<<<<$RESET"
mysql -u root -e "
  CREATE USER 'root'@'%' IDENTIFIED BY 'RoboShop@1';
  GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
  ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1';
  FLUSH PRIVILEGES;
"

