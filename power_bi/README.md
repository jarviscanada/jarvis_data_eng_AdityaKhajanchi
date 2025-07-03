## 1. Beverages Dashboard

**Description**:  
This dashboard presents a high-level analysis of sales and profitability across various Coca-Cola beverages, including Coke, Diet Coke, Fanta, Dasani Water, Powerade, and Sprite. It provides a clear visual breakdown of sales metrics and profitability drivers.

**Use Case**:  
Designed for sales managers and executives to:
- Compare performance between beverage brands.
- Identify top-selling and most profitable products.
- Understand geographic sales distribution across the U.S.
- Analyze key drivers behind operating profit.

**Data Source**:  
A Static sales dataset with Coca-Cola beverage sales across U.S. states.

>[Coca-Cola Sales Dataset.xlsx](/Coca-cola_Sales_Dashboard/data/Coca-Cola_Sales.xlsx "Link to Coca-Cola Sales Dataset")

**Key Features**:
- **Sales Metrics Table**: Shows Total Sales, Units Sold, Average Price per Unit, Operating Profit, and Operating Margin by brand.
- **Interactive Product Filter**: Users can click on product images to filter all visuals.
- **Operating Profit Analysis**: Uses Power BI's *Key Influencers* visual and *Top Segments* to explain which beverage types contribute most to profitability.
- **Sales by States HeatMap**: Geographical breakdown of sales distribution across U.S. regions.

**Constraints**:
- Data is static and limited to a single year (Jan-Dec 2022).
- Operating Profit insights are based on limited attributes and may not include marketing or logistics variables.

**Future Improvements**:
- Connect to a real-time sales database for automatic refresh.
- Add time series analysis for monthly or quarterly trends.
- Add simple KPIs at the top like *Top-Selling Product*, *Most Profitable Brand*, so decision-makers get answers quickly.
- Use color coding more strategically, like green for growing sales and red for declines, to make trends stand out.
- Introduce drill-through pages for each product.
- Add a clear navigation flow with buttons like Home, Overview, Product Details, and Map View, so it feels like using a mini app.
- Create a mobile-friendly version so managers can check sales performance on their phone.

## 2. Data Professionals Survey Report

**Description**:  
This dashboard visualizes the results of a 2022 online survey involving 630 data professionals. The survey explored a wide range of career-related topics such as job roles, programming preferences, work-life balance, ease of breaking into the field, and more.

**Use Case**:  
The report is designed to help recruiters, HR professionals, and aspiring data professionals understand trends and sentiments across the data industry including which languages are popular, the average age of professionals, and perceptions around career entry and satisfaction.

**Data Source**:
- Excel-based dataset titled **Data Professional Survey**
- Transformed data using Power BI's Power Query Editor (e.g., blank rows removed, fields renamed, changed column data types)

> [Data Professionals Survey 2022.xlsx](power_bi/Data-Professionals-Survey-Dashboard/data/Data-Professionals-Survey-2022.xlsx "Link to Coca-Cola Sales Dataset")


**Key Features**:
- **Favorite Programming Languages** by gender and role
- **Country Breakdown** of survey participants shown as a treemap
- **Difficulty to Break into Data** shown via donut chart
- **Work-Life Balance vs Salary** by age - line/area graph to compare overall satisfaction
- **Demographic Insights** like gender count and average age

**Constraints**:
- The dataset is based on voluntary survey responses and may not represent the entire industry.
- Some key fields such as ethnicity or salary ranges were excluded or simplified to avoid clutter.

**Future Improvements**:
- Add a **page navigation flow** (e.g., Home > Tools > Career Path > Demographics).
- Let users **filter by job title or country** to personalize the insights.
- Include **ethnicity, education level, or industry type** to make the analysis more inclusive and deep.
- Highlight **key takeaways automatically** (e.g., Python is the top language across all roles).
- Make it **mobile-friendly** or optimized for viewing on smaller screens.
- Add simple icons or visuals to make the report more engaging.

## 3. Stocks Dashboard

**Description**:  
This dashboard offers a dynamic and interactive view of stock performance using live data from Alpha Vantage. It shows historical trends, key financial indicators, candlestick charts, analyst estimates, and financial ratios  all customizable by ticker and time range.

**Use Case**:  
Designed for individual investors, finance analysts, and portfolio managers who want a quick yet insightful overview of any listed stock's financial health and market performance. It can be extended into a lightweight investment monitoring tool.

**Data Sources**:
- Alpha Vantage API (`TIME_SERIES_DAILY`, `OVERVIEW`, and `EARNINGS_CALENDAR`)
- Real-time JSON data transformed via Power Query (M Language)
- Company logos dynamically loaded using the [Clearbit Logo API](https://clearbit.com/logo)

**Key Features**:
-  **Time Period Slicer** with custom logic and DAX measures to change the chart date range (1mo to 5yr, MAX)
-  **Candlestick Visual** from AppSource for technical stock charting
-  **Dynamic Parameters** to change stock tickers without rewriting the query
-  **Cards for Financial Indicators**: Analyst Target Price, 52-Week High/Low, Dividend Yield, P/E Ratio
-  **Stacked Column and Line Charts** for combined Volume and Price view
-  **Company Overview Section** with dynamic logo, description, and exchange info
-  **Financial Ratios Panel** with real-time data

**Constraints**:
- Free Alpha Vantage API has a **25-request/day limit** which may restrict usage across multiple tickers.
- Dashboard performance may lag slightly due to real-time API calls and transformations.
- Some financial indicators (like EPS, beta, or industry averages) are not yet included.

**Future Improvements**:
- Add **multi-stock comparison** on the same chart (e.g., MSFT vs AAPL).
- Introduce **alert indicators** (e.g., stock nearing 52-week low/high).
- Create a **bookmark-based navigation flow** (Home > Chart > Financials).
- Make it **mobile-responsive** for easier review on tablets or phones.
- Include **automated daily refresh** and scheduled snapshot sharing via email.
- Add **explanation tooltips** for key ratios so that even non-finance users understand them.

