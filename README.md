# roboshop-aws-shell

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i /home/ec2-user/roboshop_pem.pem ec2-user@${component}.naresh-training.online "sudo dnf install -y git && rm -rf roboshop-aws-shell && git clone https://github.com/nareshgantala/roboshop-aws-shell.git && cd roboshop-aws-shell && sudo bash ${component}.sh ${component}"