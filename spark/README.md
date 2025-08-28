**Retail & WDI PySpark Evaluations (Databricks + Zeppelin)**

**Table of Contents**

1.  [Introduction](#introduction)
2.  [Databricks (Azure) Implementation](#databricks-azure-implementation)\
    2.1 [Dataset (Retail)](#dataset-retail)\
    2.2 [Work / Analytics](#work--analytics)\
    2.3 [Environment & Config](#environment--config)\
    2.4 [Project Architecture](#project-architecture)\
    2.5 [Architecture Diagram](#architecture-diagram)\
    2.6 [Notebook & Artifacts](#notebook--artifacts)
3.  [Zeppelin (Hadoop) Implementation](#zeppelin-hadoop-implementation)\
    3.1 [Dataset (WDI)](#dataset-wdi)\
    3.2 [Work / Analytics](#work--analytics-1)\
    3.3 [Environment & Config](#environment--config-1)\
    3.4 [Project Architecture](#project-architecture-1)\
    3.5 [Architecture Diagram](#architecture-diagram)\
    3.6 [Notebook & Artifacts](#notebook--artifacts-1)
4.  [Future Improvements](#future-improvements)

* * * * *

**Introduction**

This project re-architected and scaled a previous single-machine analytics solution for the London Gift Shop (LGS) marketing use-case into cluster-based Apache Spark implementations. The goal was to evaluate two Spark execution environments: Databricks on Azure and a Zeppelin front end on an HDFS/Hadoop stack, and to implement core retail and macroeconomic analytics workloads using PySpark and Spark Structured APIs. The work focused on practical, hands-on implementations: ingesting datasets, building DataFrame pipelines, answering business questions (including an RFM segmentation for retail), and exporting notebooks and artifacts for reproducibility.

* * * * *

**Databricks (Azure) Implementation**

**Dataset (Retail)**

| Column Name  | Data Type          | Nullable | Description                |

|--------------|--------------------|----------|----------------------------|

| Invoice      | string             | true     | Invoice number             |

| StockCode    | string             | true     | Product or item code       |

| Description  | string             | true     | Item description           |

| Quantity     | long               | true     | Quantity sold              |

| InvoiceDate  | timestamp          | true     | Date and time of invoice   |

| Price        | double             | true     | Price per unit             |

| CustomerID   | decimal(10, 0)     | true     | Unique ID of the customer  |

| Country      | string             | true     | Country of the customer    |

**Work / Analytics**

-   An Azure Databricks workspace and Spark cluster were provisioned to run retail analytics at scale.
-   The retail transactions CSV was uploaded to DBFS and registered as a Hive table (e.g., hive_metastore.default.retail) so Spark SQL and DataFrame APIs could query it via `spark.table('hive_metastore.default.retail')`.
-   Analysis tasks implemented in the Databricks notebook included:

1.  Total invoice amount distribution
2.  Monthly placed and canceled orders
3.  Monthly sales and monthly sales growth
4.  Monthly active users
5.  New vs existing users (cohort-style counts)
6.  RFM (Recency, Frequency, Monetary) score calculation
7.  RFM segmentation of customers

Notes:

-   Data was read and processed using Spark DataFrames and SQL. Transformations were kept as lazy operations; results were materialized with actions when needed (e.g., .write, .collect, .show).
-   Results and intermediate tables were stored in the Hive metastore for reproducibility within the workspace.

**Environment & Config**

-   Databricks runtime: **16.4 LTS** (Apache Spark 3.5.2, Scala 2.12)
-   Python: **3.12.3**
-   Cluster: interactive Spark cluster created inside the Databricks workspace.
-   Storage: DBFS (Databricks File System) for raw CSV and intermediate artifacts.
-   Notebook: Databricks notebook using PySpark / Spark SQL and exported as .ipynb / .dbc for version control.

**Project Architecture**

Components:

-   Azure Platform
-   Azure Databricks Workspace
-   DBFS (Databricks File System)
-   Spark Cluster (driver + executors)
-   Hive Metastore (table registrations)
-   Databricks Notebook (PySpark)
-   GitHub (exported notebooks / artifacts)

Flow (high level):

1.  User uploads retail CSV → DBFS
2.  Create Hive table from CSV → hive_metastore.default.retail
3.  Databricks notebook connected to Spark cluster reads table and runs analytics
4.  Final tables / results persisted to Hive / DBFS
5.  Notebook exported as .ipynb and .dbc and pushed to GitHub

**Architecture Diagram**

INSERT DATABRICKS ARCH HERE

**Notebook & Artifacts**

-   Databricks notebook (exported):

-   notebooks/databricks_retail_analysis.ipynb *(replace with actual GitHub URL)*
-   artifacts/databricks_retail_analysis.dbc *(exported DBC)*

* * * * *

**Zeppelin (Hadoop) Implementation**

**Dataset (WDI)**

| Column Name      | Data Type | Nullable | Description         |

|------------------|-----------|----------|---------------------|

| year             | integer   | true     | Year of the record  |

| countryname      | string    | true     | Name of the country |

| countrycode      | string    | true     | ISO country code    |

| indicatorname    | string    | true     | Name of the indicator |

| indicatorcode    | string    | true     | Code of the indicator |

| indicatorvalue   | float     | true     | Value of the indicator |

**Work / Analytics**

-   A World Development Indicators (WDI) parquet dataset (wdi_csv_parquet.tar.gz) was used to test PySpark on a Hadoop cluster with Zeppelin as an interactive notebook front end.
-   The tarball was extracted on a GCP VM and uploaded into HDFS. A Hive table (wdi_csv_parquet) was created (via beeline) to make the data available through the metastore.
-   Zeppelin notebooks connected to the Spark interpreter ran PySpark code (via %spark.pyspark) to answer business questions such as:

1.  Historical GDP for Canada
2.  GDP per country sorted chronologically
3.  Highest GDP (indicator) for each country

**Notes:**

-   The dataset was distributed on HDFS in blocks; Spark read it in parallel via the cluster's executors.
-   Results were exported from Zeppelin as .zpln and .ipynb for archival and GitHub.

**Environment & Config**

-   Cloud: Google Cloud Platform -- VM(s) & Dataproc for Hadoop/Spark
-   HDFS: storage of parquet directories in cluster HDFS
-   Hive Metastore: created/registered tables using beeline
-   Notebook: Apache Zeppelin with Spark interpreter (%spark.pyspark)
-   Tools/Commands used (examples):

-   Upload to HDFS:
-   hdfs dfs -mkdir -p /data/wdi
-   hdfs dfs -put wdi_csv_parquet /data/wdi/
-   Create Hive table (example with beeline):
-   CREATE EXTERNAL TABLE IF NOT EXISTS wdi_csv_parquet (...)
-   STORED AS PARQUET
-   LOCATION '/data/wdi/wdi_csv_parquet';
-   Zeppelin usage:

-   Use %spark.pyspark interpreter paragraphs to run PySpark code
-   Use DataFrame API and Spark SQL for analytics

**Project Architecture**

Components:

-   GCP (compute & storage)
-   Dataproc / Hadoop cluster (NameNode, DataNodes)
-   HDFS (data storage in blocks)
-   Hive Metastore (table registry via beeline)
-   Spark (cluster execution)
-   Zeppelin Notebook (interactive PySpark paragraphs)
-   GitHub (exported notebooks)

Flow (high level):

1.  wdi_csv_parquet.tar.gz downloaded on master node → extracted
2.  Parquet dir uploaded → HDFS /data/wdi
3.  External Hive table created via beeline
4.  Zeppelin notebook with Spark interpreter reads table, performs analytics
5.  Results exported and pushed to GitHub

**Architecture Diagram**

INSERT ZEPPELIN ARCH

**Notebook & Artifacts**

-   Zeppelin notebook (exported):

-   notebooks/zeppelin_wdi_analysis.zpln *(replace with actual GitHub URL)*
-   notebooks/zeppelin_wdi_analysis.ipynb *(exported IPython version)*

* * * * *

**Future Improvements**

Below are practical next steps that are appropriate for continuing to learn Spark while making the project more production-ready. These are intentionally approachable (not expert-only).

1.  **Automate ingestion & scheduling (batch)**

-   Add a simple scheduler (e.g., cron job, or Databricks Jobs) to automatically ingest new CSV/parquet files into DBFS/HDFS and refresh the Hive table. This removes manual uploads and helps simulate recurring data updates.

3.  **Adopt Delta Lake for the retail pipeline**

-   Convert the retail table to Delta format to gain ACID semantics, easier incremental updates, and built-in time travel for debugging historical views. Databricks supports Delta natively and it is straightforward to convert a parquet table.

5.  **Basic performance tuning (partitioning & caching)**

-   Add partitioning by InvoiceDate (year/month) for time-based queries and cache intermediate DataFrames that are reused. These are simple optimizations that significantly speed up interactive analysis.

7.  **Add simple data quality checks and logging**

-   Implement row-count checks, null checks for key columns (e.g., CustomerID), and write a small log summary after each run (records processed, runtime, any error counts). These can be printed in the notebook and written to a JSON log file.
