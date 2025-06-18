# London Gift Shop (LGS) Customer Analytics Proof of Concept

## Table of Contents

1\. [Introduction](#introduction) 

2\. [Implementation](#implementation) 

   a\. [Project Architecture](#project-architecture) 

3\. [Data Analytics and Wrangling](#data-analytics-and-wrangling) 

4\. [Improvements](#improvements) 


## Introduction

London Gift Shop (LGS) is a UK-based online retailer specializing in giftware, with a significant portion of its customers being wholesalers. Although LGS has operated its e-commerce platform for over a decade, revenue growth has plateaued in recent years. The marketing team needs deeper insights into customer shopping behavior to design more effective campaigns like email promotions, targeted events, and personalized offers, that will attract both new and existing customers.

Jarvis Consulting was engaged to deliver a proof of concept (PoC). As the Data Engineer on the project, I extracted, transformed, and analyzed transactional data to uncover patterns and segment customers. The LGS marketing team will leverage these analytic results - recency, frequency, monetary (RFM) scores, monthly trends, and cohort analyses to:

- Prioritize high-value customer segments for loyalty programs. 

- Identify at-risk customers for win-back campaigns. 

- Tailor promotions by seasonality and buying frequency. 

The work was carried out in a Jupyter Notebook using Python libraries (Pandas, NumPy, SQLAlchemy) for ETL, Matplotlib and Seaborn for visualization, and Squarify for treemaps. A local PostgreSQL instance served as the data source for initial ingestion.


## Implementation

### Project Architecture

![LGS System Architecture Diagram](https://github.com/jarviscanada/jarvis_data_eng_AdityaKhajanchi/blob/c0f7971b65425ac06ed81ed9fc4980ffe8bb9356/assets/LGS-System-Archtiecture.png)

The PoC environment remains isolated from LGS's Azure setup. Data ingestion occurs via a dumped SQL file (retail.sql) or CSV export. All processing and visualization are executed within a Jupyter Notebook, and the final notebook is delivered via GitHub.


## **Data Analytics and Wrangling**

Refer notebook for code with full analysis and visualizations: [LGS - Data Analysis](https://github.com/jarviscanada/jarvis_data_eng_AdityaKhajanchi/blob/208a4db0398b19d8f99a1a134ad4e9015faa1950/python_data_analytics/python_data_wrangling/retail_data_analytics_wrangling.ipynb)

**Key steps and highlights:**

1. **Data Extraction (ETL)**
2. **Data Cleaning & Transformation**
3. **Exploratory Analysis & Visualization**
   - **Invoice Distribution:** 
     - Histograms, boxplots, density plots of invoice amounts (including and excluding refunds / outliers).
   - **Time Series Trends:**
     - Monthly orders vs. cancellations.
     - Monthly sales and month-over-month growth rates.
     - Monthly active users (unique customer_id counts). 
     - New vs. existing user counts by month.

4. **Customer Segmentation (RFM Analysis)**
   -   Computed Recency, Frequency, and Monetary metrics per customer.
   -   Scored each dimension into quintiles and combined into a three-digit RFM score.
   -   Mapped score patterns to named segments (e.g., "Champions," "At Risk," "Need Attention").
   -   Visualized segment distribution using bar charts and a treemap for high-level overview.

**By leveraging these analytics, the LGS marketing team can:**
-   Target "Champions" with VIP promotions to make them feel valued.
-   Re-engage "At Risk" customers with win-back emails and special promo-codes.
-   Design personalized campaigns based on purchase recency and frequency values.


## **Improvements**

Given more time and resources, the following enhancements would improve the solution:

1. **Interactive Dashboard Deployment**
   - Publish results through an interactive BI layer (Tableau, Power BI, or a Dash/Streamlit app) to allow non-technical stakeholders to filter and drill into segments in real time.

2. **Automated Data ETL**
   - Optimize the data handling process by implementing automated data ETL pipelines, with scheduled data refreshes.

3. **Machine Learning Models**
    - Build predictive models to forecast product sales, profit/loss trends, and country-wise performance, transitioning the project from diagnostic analysis to predictive analytics.   
