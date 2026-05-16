echo "$YELLOW>>>>>>>Add the MongoDB 7.0 Repository<<<<<<<<<$RESET"
cp mongo.repo /etc/yum.repos.d/mongodb-org-7.0.repo

echo "$YELLOW>>>>>>>Install the Package<<<<<<<<<$RESET"
dnf install -y mongodb-org

echo "$YELLOW>>>>>>>Enable and Start<<<<<<<<<$RESET"
systemctl enable mongod
systemctl start mongod


sed -i "s/bindIp: 127.0.0.1/bindIp: 0.0.0.0/" /etc/mongod.conf

systemctl restart mongod