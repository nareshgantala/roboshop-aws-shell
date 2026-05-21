component=catalogue
source "$(dirname "${component}.sh")/common.sh"
go_call
schema=mysql
schema_type="schema.sql app-user.sql master-data.sql"
schema_load
