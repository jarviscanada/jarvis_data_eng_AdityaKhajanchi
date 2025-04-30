# Linux Cluster Monitoring Agent - MVP

## Introduction

This project is developed to support the Linux Cluster Administration (LCA) team in monitoring and managing a cluster of servers running Rocky Linux. As per the LCA team's requirements, the solution records hardware specifications and real-time resource usage metrics from each node into a relational database (RDBMS).

This tailored solution fulfills the required objectives and serves as a monitoring tool that records data in real time. The LCA team can use the stored data to analyze server performance, generate reports, and make informed decisions for future capacity planningsuch as scaling the cluster by adding or removing nodes, or upgrading certain hardware.

The script uses core Linux technologies and open-source tools, including:

- **Bash scripting** for automation and data collection
- **PostgreSQL** as a RDBMS for persistent storage
- **Docker** for containerized database deployment
- **Git and GitHub** for version control
- **Crontab** for automated continuous data collection

This project demonstrates practical knowledge of system administration and database integration, along with scripting and DevOps fundamentals like version control with Git, containerization using Docker, scheduled automation using crontab, and data persistence through PostgreSQL.

## Quick Start

Follow the steps below to quickly set up and run the project.

1. **Start|Stop|Create the PostgreSQL container using Docker**

   *Command to start/stop/create (if it doesn't exist) a docker container*
   ```
   ./scripts/psql_docker.sh start|stop|create [db_username] [db_password] 
   ```

2. **Create the database tables**

   *Executes ```ddl.sql``` script that creates ```host_info``` and ```host_usage``` tables in a PSQL DB (if they don't exist) with necessary columns and constraints*
      ```
      psql -h [host_name] -U [db_username] -d [db_name] -f sql/ddl.sql
      ```

3. **Collect and insert hardware specifications (one-time setup)**

   *Executes ```host_info.sh``` script that captures node hardware specs and stores them into ```host_usage``` table in a PSQL DB*
   ```
   ./scripts/host_info.sh [host_name] [port Default:5432] [db_name] [db_username] [db_password]
   ```
   > [NOTE]
   >  ```hostname``` has to be unique, hence the current script can only run once per node

4. **Collect and insert real-time resource usage data (runs periodically)**

   *Executes ```host_usage.sh``` script that captures system usage of the node and inserts into PSQL DB*
      ```
      ./scripts/host_usage.sh [host_name] [port Default:5432] [db_name] [db_username] [db_password]
      ```

5. **Schedule resource usage collection with `crontab`**

   Open the crontab editor:
   ```
   crontab -e
   ```

   Add the following line to run `host_usage.sh` every minute:

   ```
   * * * * * bash /dir_name/dir_name/host_usage.sh [host_name] [port Default:5432] [db_name] [db_username] [db_password] &> /tmp/host_usage.log 2>&1
   ```
   Creates a log file under [user/tmp/], that is overwritten with exit code and status, every time the process runs

## Implementation

The project is implemented in a Rocky Linux 9 VM instance on Google Cloud Platform. This following section explains the project design and how the components work together to meet the monitoring requirements.

### Architecture

The architecture is designed to handle multiple Linux nodes, each running two Bash scripts (`host_info.sh` and `host_usage.sh`). These scripts collect data and insert it into a PostgreSQL database that runs inside a Docker container. All scripts are scheduled using `cron` for automation.

![Linux Cluster Monitoring Agent Diagram](https://raw.githubusercontent.com/jarviscanada/jarvis_data_eng_AdityaKhajanchi/refs/heads/feature/readme/assets/LCM_Diagram.png)

### Scripts

Below is a list of the key scripts used in this project and their functionalities:

#### 1. `psql_docker.sh`

This script starts a PostgreSQL container using Docker.

- Accepts three arguments from user: start|stop|create; database username, database password  
- The script passes these static values: docker container name, port, postgres version to install, postgres internal directory location

```
./scripts/psql_docker.sh start|stop|create [db_username] [db_password]
```

#### 2. `host_info.sh`

This script collects static hardware information such as CPU specs, memory size, and hostname. It runs only once per node during installation.

```
./scripts/host_info.sh [host_name] [port Default:5432] [db_name] [db_username] [db_password]
```

#### 3. `host_usage.sh`

This script collects real-time usage data including CPU and memory usage. It is scheduled to run automatically, every minute using `cron`.

```
./scripts/host_usage.sh [host_name] [port Default:5432] [db_name] [db_username] [db_password]
```

#### 4. `crontab`

Used to schedule `host_usage.sh` so that resource usage is logged every minute.

Example crontab entry:

```
* * * * * * bash /home/user/filepath/to/host_usage.sh [host_name] [port Default:5432] [db_name] [db_username] [db_password] &> /tmp/host_usage.log
```

#### 5. `queries.sql`

This SQL file contains business queries that help the LCA team make informed decisions. 

Examples include:
- Top 5 nodes with the highest CPU usage in the last 10 minutes
- Show average memory usage of nodes, sort descending

## Database Modeling

The database includes two key tables: `host_info` and `host_usage`.

### `host_info` Table

| Column Name        | Data Type | Constraints                        | Description                          |
|--------------------|-----------|------------------------------------|--------------------------------------|
| id                 | SERIAL    | Primary Key, NOT NULL              | Unique ID for each host              |
| hostname           | VARCHAR   | UNIQUE, NOT NULL                   | Fully qualified hostname             |
| cpu_number         | INT2      | NOT NULL                           | Number of CPU cores                  |
| cpu_architecture   | VARCHAR   | NOT NULL                           | CPU architecture (e.g., x86_64)      |
| cpu_model          | VARCHAR   | NOT NULL                           | Model name of the CPU                |
| cpu_mhz            | FLOAT8    | NOT NULL                           | Clock speed of CPU in MHz            |
| l2_cache           | INT4      | NOT NULL                           | L2 cache size in KB                  |
| total_mem          | INT4      | NULL                               | Total memory in KB                   |
| timestamp          | TIMESTAMP | NULL                               | Time of data entry in UTC            |

---

### `host_usage` Table

| Column Name    | Data Type | Constraints                            | Description                            |
|----------------|-----------|----------------------------------------|----------------------------------------|
| timestamp      | TIMESTAMP | NOT NULL                               | Time of resource usage recording (UTC) |
| host_id        | SERIAL    | NOT NULL, Foreign Key `host_info(id)`  | Linked to host_info table id record    |
| memory_free    | INT4      | NOT NULL                               | Free memory in MB                      |
| cpu_idle       | INT2      | NOT NULL                               | % of CPU that is idle                  |
| cpu_kernel     | INT2      | NOT NULL                               | % of CPU used by the kernel            |
| disk_io        | INT4      | NOT NULL                               | Number of disk I/O operations          |
| disk_available | INT4      | NOT NULL                               | Available disk space in MB (root dir)  |

# Test

- Manually tested bash scripts on a Rocky Linux VM
- Debugged scripts using `bash -x` to trace execution line by line
- Printed exit codes after each critical step to check for pass/fail
- Logged script status and exit codes to a cron log file
- Checked that scripts collected correct data (CPU, memory, etc.)
- Verified data was stored in the PostgreSQL tables
- Used `\dt` and `SELECT` queries to confirm table creation and data insertion
- Tested crontab to make sure data was collected every minute
- All tests passed without errors

# Deployment

- Pushed project files to **GitHub** for version control.
- Used Docker to run **PostgreSQL** in a container.
- Ran `psql_docker.sh` to create/start the database.
- Used `ddl.sql` to set up the database schema.
- Set up **crontab** on each server to run the monitoring script every minute.

# Improvements

- Print a timestamp in the log file to show when the last execution ran
- Handle hardware upgrades like RAM or disk size changes
- Trigger alerts or actions when resource usage is high
- Add a cron job to delete `host_usage` entries older than 3 days
