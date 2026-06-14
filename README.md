This project is using SQL to perform an analysis on non-moving inventory for a chain of liqour stores.
I have experience doing non-moving analysis on raw materials for my current employer, however I was able to use my ERP and physcially verify the inventory.
I wanted to practice what I learned in SQL courses and put myself as an Inventory Analyst for the liqour store chain.
This dataset comes from Kaggle.

Before Starting
I wanted to go through and do some data cleaning, and validation. The first thing I did was review the data type in PstgreseSQL once importing the dataset. My findings show that some numeric data types such as "on-hand" and "sales quantity" were stored as text. For proper analysis I needed to make sure these were CAST as numeric. These will show in the SQL code. 
