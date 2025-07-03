## Stocks Dashboard

**Description**:  
This dashboard offers a dynamic and interactive view of stock performance using live data from Alpha Vantage. It shows historical trends, key financial indicators, candlestick charts, analyst estimates, and financial ratios  all customizable by ticker and time range.

**Use Case**:  
Designed for individual investors, finance analysts, and portfolio managers who want a quick yet insightful overview of any listed stock's financial health and market performance. It can be extended into a lightweight investment monitoring tool.

**Data Sources**:
- Alpha Vantage API (`TIME_SERIES_DAILY`, `OVERVIEW`, and `EARNINGS_CALENDAR`)
- Real-time JSON data transformed via Power Query (M Language)
- Company logos dynamically loaded using the [Logo.dev API](https://www.logo.dev/)

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