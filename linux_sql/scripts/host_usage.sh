#!/bin/bash

# Check number of arguments passed
if [ "$#" -ne 5 ]; then
  echo "Arguments missing. Please check."
  exit 1
fi

# Assigning CLI arguments to variables
psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_pass=$5

# Save host usage info to variable
vmstat_out=$(vmstat --unit M)
hostname=$(hostname -f)
# Retrieve host usage info through vmstat and assigning it to variables

timestamp=$(date "+%F %T") # System time in UTC YYYY-MM-DD HH:MM:SS format # Applies DRY Principle
host_id="(SELECT id FROM host_info WHERE hostname='$hostname')"
memory_free=$(echo "$vmstat_out" | awk '{print $4}' | tail -n1 | xargs)
cpu_idle=$(echo "$vmstat_out" | awk '{print $15}' | tail -n1 | xargs)
cpu_kernel=$(echo "$vmstat_out" | awk '{print $14}' | tail -n1 | xargs)
disk_io=$(echo "`vmstat -d`" | awk '{print $10}' | tail -n1 | xargs)
disk_available=$(echo "`df -BM /`"| awk '{print $4*1}' | tail -n1 | xargs)

# INSERT statement
insert_stmt="INSERT INTO host_usage VALUES('$timestamp',$host_id,'$memory_free','$cpu_idle','$cpu_kernel','$disk_io','$disk_available')"

# Set password env variable for psql cmd
export PGPASSWORD=$psql_pass

# Execute insert statement
psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"
if [ $? -ne 0 ]; then
  echo "Failed to insert into database."
else
  echo "Records inserted successfully."
fi
exit $?