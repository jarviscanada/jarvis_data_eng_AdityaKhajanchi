# Linux Cluster Monitoring Agent - MVP

## Introduction

This project is developed to support the Linux Cluster Administration (LCA) team in monitoring and managing a cluster of servers running Rocky Linux. As per the LCA team's requirements, the solution records hardware specifications and real-time resource usage metrics from each node into a relational database (RDBMS).

This custom-built solution fulfills the required objectives and serves as a monitoring tool that records data in real time. The LCA team can use the stored data to analyze server performance, generate reports, and make informed decisions for future capacity planningsuch as scaling the cluster by adding or removing nodes, or upgrading certain hardware.

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
   ./scripts/psql_docker.sh start|stop|create [db_username] [db_pass] 
   ```

2. **Create the database tables**

   *Executes ```ddl.sql``` script that creates ```host_info``` and ```host_usage``` tables in a PSQL DB (if they don't exist) with necessary columns and constraints*
      ```
      psql -h [host_name] -U [db_username] -d [db_name] -f sql/ddl.sql
      ```

3. **Collect and insert hardware specifications (one-time setup)**

   *Executes ```host_info.sh``` script that captures node hardware specs and stores them into ```host_usage``` table in a PSQL DB*
   ```
   ./scripts/host_info.sh [host_name] [port Default:5432] [db_name] [db_username] [db_pass]
   ```
   > [NOTE]
   >  ```hostname``` has to be unique, hence the current script can only run once per node

4. **Collect and insert real-time resource usage data (runs periodically)**

   *Executes ```host_usage.sh``` script that captures system usage of the node and inserts into PSQL DB*
      ```
      ./scripts/host_usage.sh [host_name] [port Default:5432] [db_name] [db_username] [db_pass]
      ```

5. **Schedule resource usage collection with `crontab`**

   Open the crontab editor:
   ```
   crontab -e
   ```

   Add the following line to run `host_usage.sh` every minute:

   ```
   * * * * * bash /dir_name/dir_name/host_usage.sh [host_name] [port Default:5432] [db_name] [db_username] [db_pass] &> /tmp/host_usage.log 2>&1
   ```
   Creates a log file under [user/tmp/], that is overwritten with exit code and status, every time the process runs

## Implementation

This section explains the project design and how the components work together to meet the monitoring requirements.

### Architecture

The architecture consists of multiple Linux nodes, each running two Bash scripts (`host_info.sh` and `host_usage.sh`). These scripts collect data and insert it into a PostgreSQL database that runs inside a Docker container. All scripts are scheduled using `cron` for automation.

![Linux Cluster Monitoring Agent Diagram]()

### Scripts

Below is a list of the key scripts used in this project and their roles:

#### `psql_docker.sh`

This script starts a PostgreSQL container using Docker.

```
./scripts/psql_docker.sh psql_host psql_port db_name db_user db_password
```

#### `host_info.sh`

This script collects static hardware information such as CPU specs, memory size, and hostname. It runs only once per node during installation.

```
./scripts/host_info.sh psql_host db_name db_user db_password
```

#### `host_usage.sh`

This script collects real-time usage data including CPU and memory usage. It is meant to run at regular intervals using `cron`.

```
./scripts/host_usage.sh psql_host db_name db_user db_password
```

#### `crontab`

Used to schedule `host_usage.sh` so that resource usage is logged every minute.

Example crontab entry:

```
* * * * * bash /path/to/host_usage.sh psql_host db_name db_user db_password > /tmp/host_usage.log 2>&1
```

#### `queries.sql`

This SQL file contains business queries that help the LCA team make informed decisions. Examples include:

- Show average memory usage per node over the last minute
- Compare CPU usage trends across nodes