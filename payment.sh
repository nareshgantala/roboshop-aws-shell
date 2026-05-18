component=$1
source "$(dirname "${component}.sh")/common.sh"
pyth_call

echo "$YELLOW>>>>>>> Configure Systemd Service <<<<<<<<<$RESET"
cp payment.service /etc/systemd/system/payment.service

systemd_call

