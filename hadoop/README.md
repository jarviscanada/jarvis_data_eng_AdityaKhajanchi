## Table of Contents
- [1 Introduction](#1-introduction)
  - [Purpose of this project](#purpose-of-this-project)
  - [Learning and evaluation](#learning-and-evaluation)
  - [Hadoop cluster, tools, and the Hive project](#hadoop-cluster-tools-and-the-hive-project)
- [2. Hadoop Cluster](#2-hadoop-cluster)
  - [Cluster architecture diagram](#cluster-architecture-diagram)
  - [Hardware Specifications](#hardware-specifications)
  - [Cluster Architecture (Master Node, Worker Nodes)](#cluster-architecture-master-node-worker-nodes)
  - [Core components from the Hadoop ecosystem](#core-components-from-the-hadoop-ecosystem)
  - [Big data tools](#big-data-tools)
- [3. Hive Project](#3-hive-project)
  - [Performance Tuning in Hive](#performance-tuning-in-hive)
  - [Zeppelin Notebook](#Zeppelin-notebook)
- [4. Improvements](#4-improvements)
  - [Key Improvements Implemented](#key-improvements-implemented)
  - [Future Improvements](#future-improvements)

## 1. Introduction
### Purpose of this project
This project evaluates `Apache Hadoop` as a scalable alternative to legacy data analytics platforms such as SAP and R. The project involves provisioning a `Hadoop cluster` on `Google Cloud Platform (GCP)`. It examines the functionality of key components such as `HDFS` for distributed storage, `YARN` for resource coordination, and `MapReduce` for batch processing. The project demonstrates how big data platforms can be configured to efficiently manage high-volume workloads and establishes a foundation for comparing performance, query strategies, and optimization techniques in distributed data environments.

### Learning and evaluation
The project evaluated the performance limits of single-node data processing, focusing on how hardware bottlenecks such as `HDD I/O latency` restrict scalability. Execution time was analyzed based on hardware throughput and data size, including a 1TB `CSV` of stock trades, to understand the relationship between storage performance and query efficiency.  
Various optimization strategies were explored, such as using `SSDs`, `RAID` configurations, and distributed computing, to overcome single-node limitations. The impact of parallel processing across multiple nodes in a `Hadoop-style architecture` was demonstrated, showing how execution time can be reduced from hours to minutes.  
The work also highlighted trade-offs between algorithmic approaches, such as `imperative` vs. `declarative SQL`, and emphasized the role of distributed systems in effectively handling big data workloads.

### Hadoop cluster, tools, and the Hive project
This project was executed on a `Hadoop cluster` provisioned via `Google Cloud Platform`, consisting of one master node and two worker nodes. `Hive` served as the primary query engine, with data sourced from both `Google Cloud Storage` buckets and `HDFS`. Data processing and parsing were performed using `HiveQL` queries to answer business questions, using `Tez` and `SerDes` within `Zeppelin Notebooks`. Monitoring and performance tracking were carried out through web interfaces such as `YARN Application Timeline`, `Tez UI`, `Spark/MapReduce`, and `HDFS NameNode`. `Git` was used for version control and notebook submissions.

## 2. Hadoop Cluster
### Cluster architecture diagram
[Cluster-architecture-diagram]()

### Hardware Specifications
The Hadoop cluster was provisioned in the `northamerica-northeast2-a` zone using image version `2.2.60-debian12`. It consisted of one master node and two worker nodes, all using the `custom-2-13312-ext` machine type (2 vCPUs, 13 GB memory). Each node was configured with a 100GB persistent disk of type `pd-standard` and no attached GPUs or local SSDs. Optional components included `Zeppelin`, and system-level features such as autoscaling, advanced execution, Google Cloud Storage caching, and confidential computing were disabled. Internal IPs were used exclusively, with network access set to default. The cluster used `Google-managed encryption` and was linked to a staging bucket at `dataproc-staging-northamerica-northeast2`.

### Cluster Architecture (Master Node, Worker Nodes)
The Hadoop cluster was provisioned on `Google Cloud Platform` with a total of three nodes: one master node and two worker nodes. The master node managed cluster-wide services, including the `HDFS NameNode` (for metadata management), `YARN ResourceManager` (for resource scheduling), `HiveServer2`, and the `Hive Metastore` (for SQL query execution and metadata).  
The two worker nodes were responsible for distributed data storage via `HDFS DataNodes` and for executing tasks across various processing engines such as `MapReduce`, `Tez`, and `Spark`. Each worker node also ran a `NodeManager`, enabling distributed task execution assigned by the `ResourceManager`.  
This architecture supports parallel processing, improved fault tolerance, and scalability, making it well-suited for high-volume analytics and complex query workloads. 

### Core components from the Hadoop ecosystem
The core components of the Hadoop ecosystem used in the project:

- **`HDFS (Hadoop Distributed File System):`** Provides reliable, distributed storage by splitting data into blocks stored across worker nodes, ensuring fault tolerance and high throughput for big data access.
- **`YARN (Yet Another Resource Negotiator):`** Manages and schedules cluster resources, allocating CPU and memory to various processing tasks such as `MapReduce` and `Tez` jobs.
- **`Zeppelin:`** A web-based notebook environment used for interactive data exploration, query development, and visualization. Zeppelin was the primary interface for running `HiveQL` queries, visualizing results, and documenting the analytical process.
- **`Hive:`** A data warehouse infrastructure that facilitates querying and managing large datasets stored in `HDFS` using a SQL-like language (`HiveQL`).
- **`HiveServer2:`** Serves as the query execution interface, handling client connections and query submissions.
- **`Hive Metastore:`** Stores metadata information about the datasets, tables, partitions, and schema in a relational database (`RDBMS`), enabling efficient query planning and optimization.
- **`RDBMS:`** The backend relational database (such as MySQL or PostgreSQL) used by `Hive Metastore` to persist metadata, providing consistency and fast access for `Hive` queries.

### Big data tools
The key big data tools evaluated during the project:

- **`MapReduce:`** Evaluated as the original batch processing engine of Hadoop, suitable for large-scale data processing but with higher latency compared to newer engines.
- **`YARN:`** Studied for its role as a resource manager, allowing multiple processing frameworks to share cluster resources efficiently.
- **`HDFS:`** Assessed for its distributed file storage capabilities, fault tolerance, and performance impact on query execution.
- **`Hive:`** Explored for simplifying big data querying through `HiveQL`, enabling SQL-like access to large datasets without deep programming knowledge.
- **`Zeppelin:`** Used as an interactive environment for query development, visualization, and collaboration, enhancing productivity and reproducibility.
- **`Tez:`** Investigated as an alternative execution engine to `MapReduce`, providing more efficient query execution and lower latency for `Hive` jobs.
- **`Spark (optional):`** Considered for its in-memory processing capabilities and versatility for both batch and streaming data analytics.

## 3. Hive Project
### Performance Tuning in Hive
At the start of the Hive project, queries were executed on data stored in `Google Storage (GS)` using a plain `CSV` table (`wdi_gs`). To improve efficiency, the data was copied into `HDFS` using the `wdi_csv_text` table. However, queries like `SELECT COUNT(countryName)` on this table still required full scans of the dataset and took ~28-36 seconds depending on caching. A comparison with `Bash` revealed that `Hive` was 20 seconds slower (`Hive: 37s` vs `Bash: 17s`) due to Hive's overhead: SQL parsing, metastore lookups, and job execution via `MapReduce` or `Tez`.

Initial queries also showed malformed values in the `indicatorCode` column. To debug, a single-column table (`wdi_gs_debug`) was created to inspect raw rows. This led to using `OpenCSVSerde` for better handling of quoted strings and delimiters, creating a new table `wdi_opencsv_gs`. While this resolved parsing problems, queries on `wdi_opencsv_text` (loaded into `HDFS`) were significantly slower (`1m 19s` vs `23s` on `wdi_csv_text`) because `OpenCSVSerde` introduces extra parsing overhead.

The query for 2015 GDP Growth (Canada) was slow because Hive scanned the entire dataset. To address this, a partitioned table (`wdi_opencsv_text_partitions`) was created with year-based partitions. This reduced query time from `1m 35s` to just `2s`, as Hive only scanned the relevant partition instead of the entire dataset.

To further enhance performance, data was stored in `Parquet` format (`wdi_csv_parquet`). `Parquet` reduced the dataset size from `1.7 GB (CSV)` to just `263 MB`, while also enabling column pruning and efficient compression. Queries on `Parquet` were 3-4x faster (e.g., `SELECT COUNT(countryName)` ran in `21s` on `Parquet` vs `1m 22s` on `CSV`).

For ranking GDP growth by country, `Window Functions` were used with Hive on `Parquet`, achieving a `27-second runtime` compared to `2.5 minutes` on the raw `CSV`. Switching to `Tez` as the execution engine significantly improved performance by reducing the overhead of job execution. `SparkSQL` was also tested for comparison, but `Hive on Parquet with Tez` proved efficient for most analytical queries.

**Key Results:**
- Partitioning and `Parquet` combined reduced query time for 2015 GDP Growth (Canada) from `1m 35s` ? `2s`.
- Data size reduction: `Parquet (263 MB)` vs `CSV (1.7 GB)` allowed faster reads.
- Optimized query paths using `Tez` and `HiveQL` led to stable and predictable performance even for complex queries.

### Zeppelin Notebook
[Zeppelin-notebook.ipynb]()

[Zeppelin-notebook-screenshot]()

## 4. Improvements
### Key Improvements Implemented
**Migration from Google Storage to HDFS**  
Initially, queries were executed directly on `Google Storage (GS)`, which caused high latency due to data transfer. By moving data into `HDFS` (`wdi_csv_text`), queries ran locally on the cluster, significantly improving performance and reducing query time.

**Partitioning by Year**  
Queries filtering by specific years (e.g., 2015 GDP Growth) previously scanned the entire dataset. Introducing year-based partitions in `wdi_opencsv_text_partitions` minimized data scanning and reduced query time from `1m 35s` to `2s`.

**Columnar Storage with Parquet**  
Converting data from raw `CSV` to `Parquet` format reduced file size from `1.7 GB` to `263 MB` and enabled faster reads by allowing column pruning and compression, resulting in 3-4x faster queries.

### Future Improvements
**Add Table Statistics (`ANALYZE TABLE`)**  
Computing statistics on tables (row count, column cardinality, data distribution) helps Hive's query optimizer choose efficient execution plans.

**Use ORC File Format (`ORC`)**  
`ORC` provides better compression and faster reads than `Parquet` or `CSV`, making queries significantly faster and reducing storage usage.

**Implement Cost-Based Optimization (`CBO`)**  
Enabling Hive's `CBO` allows the optimizer to use table statistics to evaluate query costs, improving join order, partition pruning, and overall performance.
