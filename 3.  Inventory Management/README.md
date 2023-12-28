# Analyze Data in a Model Car Database with MySQL Workbench

I worked on this project to demonstrate my skills in using SQL for effective inventory management. The goal was to show how I can analyze warehouse data, understand product inventory distribution, and provide practical suggestions for improving inventory management. Through this project, I aimed to showcase my ability to make smart decisions based on data, making inventory management more efficient and strategic.

The database can be build by running the `Mint.sql` file in MySQL Workbench on your local computer.

## Project Scenario

Mint Classics Company, a retailer of classic model cars and other vehicles, is looking at closing one of their storage facilities. 

To support a data-based business decision, they are looking for suggestions and recommendations for reorganizing or reducing inventory, while still maintaining timely service to their customers. For example, they would like to be able to ship a product to a customer within 24 hours of the order being placed.

As a data analyst, you have been asked to use MySQL Workbench to familiarize yourself with the general business by examining the current data. You will be provided with a data model and sample data tables to review. You will then need to isolate and identify those parts of the data that could be useful in deciding how to reduce inventory.

## Techniques Used
Achieving project objectives was realized through a meticulous application of SQL techniques:

1. **Data Exploration**: Utilized basic queries to comprehend the inventory dataset comprehensively.

2. **Product Analysis**: Employed SQL queries to analyze product distribution, identifying storage patterns and sales figures.

3. **Inventory Summary and Categorization**: Created the "inventory_summary" temporary table, using aggregation and joins to calculate remaining stock and categorize inventory status.

4. **Warehouse Stock Analysis**: Formulated queries to assess warehouse-wise stock levels and analyze inventory status, offering insights into distribution patterns.

5. **Identifying Unsold Products**: Implemented a query to identify stagnant inventory items, enhancing insights into low-demand products.

## Recommendation 
Recommendation to help the business maximise their inventory management based on the analysis:
1. **Product Line Optimisation** by considering to remove The 1985 Toyota Supra that has never been ordered for the past year, this could free some space in warehouse b. 

2. **Promotional Campaigns** to reduce the overstocked products, instead of returning the stock to the factory which can cause another cost. Launch targeted promotional campaigns to stimulate demand. Offer discounts, bundle deals, or special promotions to encourage customers to purchase the overstocked items. 

3. **Restock Understocked Product** to meet demand.

4. **Close Warehouse C / WEST & Redistribute The Inventory** to warehouse B / EAST since they are having similar product line category and if The 1985 Toyota Supra have been removed from warehouse B it could fit all the inventory from warehouse C. Another way is split the Inventory to Warehouse C and D since Warehouse D also having similar product line but larger (Trucks and Buses).

## 🔗 Links

Read the artcile at [Medium](https://medium.com/@devinirfana/looking-through-the-apps-store-data-1612792b6266) |
connect with me on [LinkedIn](https://www.linkedin.com/in/devinirfana/)
