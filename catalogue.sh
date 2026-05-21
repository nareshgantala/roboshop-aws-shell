component=catalogue
source "$(dirname "${component}.sh")/common.sh"
go_call
schema=mysql
schema_type="db/schema.sql db/app-user.sql db/master-data.sql"
schema_load
