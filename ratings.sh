component=ratings
source "$(dirname "${component}.sh")/common.sh"

dnf install -y mysql8.4
status_check "install mysql"

extra_pip_packages=cryptography
schema=mysql
schema_type="db/schema.sql db/app-user.sql"



pyth_call
schema_load
