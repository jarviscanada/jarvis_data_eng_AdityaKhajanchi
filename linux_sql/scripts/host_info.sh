#!/bin/bash

# Assigning CLI arguments to variables
psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_pass=$5

# Checking number of arguments passed

if [ "$#" -ne 5 ]; then
  echo "Arguments missing. Please check."
  exit 1
fi

# Saving host hardware specs to variables
lscpu_out=$(lscpu)

# Retrieving host hardware info and assigning it to variables
# id: passing DEFAULT in psql insert statement as it is set as auto increment in the psql database
hostname=$(hostname -f)
cpu_number=$(echo "$lscpu_out" | egrep "^CPU\(s\):" | awk '{print $2}' | xargs)
cpu_architecture=$(echo "$lscpu_out" | egrep "^Architecture:" | awk '{print $2}' | xargs)
cpu_model=$(echo "$lscpu_out" | egrep "Model name:" | awk -F: '{print $2}' | xargs)
cpu_mhz=$(echo "$lscpu_out" | egrep "Model name:" | awk -F@ '{print $2}' | awk '{print $1*1000}' | xargs)
L2_cache=$(echo "$lscpu_out" | egrep "L2 cache:" | awk '{print $3}' | xargs)
total_mem=$(free | awk '/Mem:/ {print $2}')
# timestamp: passing NOW() expression in psql insert statement
# timestamp=$(date "+%F %T") # System time in UTC YYYY-MM-DD HH:MM:SS format

# INSERT statement to insert the hardware specs variables in psql host_agent DB > host_info table

insert_stmt="INSERT INTO host_info VALUES(DEFAULT,'$hostname', '$cpu_number', '$cpu_architecture', '$cpu_model', '$cpu_mhz', '$L2_cache', NOW(), '$total_mem')"

# Setting up env var for psql cmd
export PGPASSWORD=$psql_pass

# Executing INSERT statement into psql DB
psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"
echo $?
exit $?