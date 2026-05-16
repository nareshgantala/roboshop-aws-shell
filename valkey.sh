echo "$YELLOW>>>>>>> Install Valkey <<<<<<<<<$RESET"

dnf install -y valkey
systemctl enable valkey
systemctl start valkey

echo "$YELLOW>>>>>>> configure valkey <<<<<<<<<$RESET"

sed -i "s/bind 127.0.0.1/bind 0.0.0.0/" /etc/valkey/valkey.conf
sed -i "s/protected-mode yes/protected-mode no" /etc/valkey/valkey.conf

systemctl restart valkey