#!/bin/bash

# Check number of arguments passed
if [ "$#" -ne 5 ]; then
  echo "Arguments missing. Please check."
  exit 1
fi

# Assign CLI arguments to variables
psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_pass=$5

# Save host hardware specs to variable
lscpu_out=$(lscpu)

# Retrieve host hardware info and assigning it to variables
# id: DEFAULT in psql insert statement as it is set as auto increment in the psql database
hostname=$(hostname -f)
cpu_number=$(echo "$lscpu_out" | grep -E "^CPU\(s\):" | awk '{print $2}' | xargs)
cpu_architecture=$(echo "$lscpu_out" | grep -E "^Architecture:" | awk '{print $2}' | xargs)
cpu_model=$(echo "$lscpu_out" | grep -E "Model name:" | awk -F: '{print $2}' | xargs)
cpu_mhz=$(echo "$lscpu_out" | grep -E "Model name:" | awk -F@ '{print $2}' | awk '{print $1*1000}' | xargs)
L2_cache=$(echo "$lscpu_out" | grep -E "L2 cache:" | awk '{print $3}' | xargs)
total_mem=$(free | awk '/Mem:/ {print $2}')
timestamp=$(date "+%F %T") # System time in UTC YYYY-MM-DD HH:MM:SS format

# INSERT statement to insert the hardware specs variables in psql host_agent DB > host_info table
insert_stmt="INSERT INTO host_info VALUES(DEFAULT,'$hostname', '$cpu_number', '$cpu_architecture', '$cpu_model', '$cpu_mhz', '$L2_cache', '$timestamp', '$total_mem')"

# Setup environment variable for psql cmd
export PGPASSWORD=$psql_pass

# Execute INSERT statement into psql DB
psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"
if [ $? -ne 0 ]; then
  echo "Failed to insert into database."
else
  echo "Records inserted successfully."
fi
exit $?