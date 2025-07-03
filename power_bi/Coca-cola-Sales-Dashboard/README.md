## Beverages Dashboard

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

>[Coca-Cola Sales Dataset.xlsx](./data/Coca-Cola_Sales.xlsx "Link to Coca-Cola Sales Dataset")

**Key Features**:
- **Sales Metrics Table**: Shows Total Sales, Units Sold, Average Price per Unit, Operating Profit, and Operating Margin by brand.
- **Interactive Product Filter**: Users can click on product images to filter all visuals.
- **Operating Profit Analysis**: Uses Power BI's *Key Influencers* visual and *Top Segments* to explain which beverage types contribute most to profitability.
- **Sales by States HeatMap**: Geographical breakdown of sales distribution across U.S. regions.

**Constraints**:
- Data is static and limited to a single year (Jan–Dec 2022).
- Operating Profit insights are based on limited attributes and may not include marketing or logistics variables.

**Future Improvements**:
- Connect to a real-time sales database for automatic refresh.
- Add time series analysis for monthly or quarterly trends.
- Add simple KPIs at the top like *Top-Selling Product*, *Most Profitable Brand*, so decision-makers get answers quickly.
- Use color coding more strategically, like green for growing sales and red for declines, to make trends stand out.
- Introduce drill-through pages for each product.
- Add a clear navigation flow with buttons like Home, Overview, Product Details, and Map View, so it feels like using a mini app.
- Create a mobile-friendly version so managers can check sales performance on their phone.
