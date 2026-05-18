component=$1
source "$(dirname "${component}.sh")/common.sh"
java_call
echo "$YELLOW>>>>>>> Configure Systemd Service<<<<<<<<<$RESET"
cp orders.service /etc/systemd/system/orders.service
systemd_call
