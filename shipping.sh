component=shipping
source "$(dirname "${component}.sh")/common.sh"

schema=mysql
schema_type="schema.sql app-user.sql"


java_call
schema_load


