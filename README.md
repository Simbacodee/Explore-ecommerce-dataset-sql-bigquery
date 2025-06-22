# 📊 Explore Ecommerce Dataset | SQL, BigQuery 

![ChatGPT Image 15_17_32 22 thg 6, 2025](https://github.com/user-attachments/assets/c3229216-4711-472e-a44d-f43257134274)

**Author**: Duong Chi Tuan  
**Date**: March 2025  
**Tools Used**: SQL

---

## 📑 Table of Contents  
1. [📌 Background & Overview](#-background--overview)  
2. [📂 Dataset Description & Data Structure](#-dataset-description--data-structure)  
3. [🔎 Final Conclusion & Recommendations](#-final-conclusion--recommendations)

---

## 📌 Background & Overview  

### Objective:
### 📖 What is this project about? What Business Question will it solve?

This project explores an e-commerce dataset using SQL on BigQuery to answer specific business questions related to user behavior, traffic source performance, and product-level insights. 

- Analyze key engagement metrics (visit, pageviews, transactions) by month 

- Measure bounce rate and revenue breakdown by traffic source

- Compare purchasing behavior between user types and by session

- Uncover product recommendations based on purchase patterns

- Build a conversion funnel from product view → add to cart → purchase

### 👤 Who is this project for?  

- Data analysts & business intelligence professionals

- Marketing teams optimizing campaign performance

- Product managers and eCommerce decision-makers
 
---

## 📂 Dataset Description & Data Structure  

### 📌 Data Source  
- Source: The sample data is from Google Analytics 4 (GA4), exported to BigQuery, including user activity data from the Google Merchandise Store e-commerce website.  
- Size: ga4_obfuscated_sample_ecommerce

---

## ⚒️ Main Process

🔍 Calculate total visit, pageview, transaction for Jan, Feb and March 2017 (order by month)

⚡Queries

![image](https://github.com/user-attachments/assets/f1166d9a-6d9e-447d-81d2-ecf8742e4060)

💡 Queries result  

![image](https://github.com/user-attachments/assets/64503f79-f4a3-47eb-be5c-a779368c71fc)

🔍 Bounce rate per traffic source in July 2017 

⚡Queries

![image](https://github.com/user-attachments/assets/d870a107-5663-4f90-8d36-6416f1c49dd2)

💡 Queries result

![image](https://github.com/user-attachments/assets/50b14315-dba5-4ac7-9633-861dc172abf8)

🔍 Revenue by traffic source by week, by month in June 2017

⚡Queries

![image](https://github.com/user-attachments/assets/0ef81d6c-55d1-4467-97da-36535d65ac67)

💡 Queries result

![image](https://github.com/user-attachments/assets/b9740ada-2c20-468d-9a59-c24be96dc3a9)

🔍  Average number of pageviews by purchaser type (purchasers vs non-purchasers) in June, July 2017

⚡Queries

![image](https://github.com/user-attachments/assets/99fdb9ee-a8b8-4cce-960f-c2e5d10db408)

💡 Queries result

![image](https://github.com/user-attachments/assets/5c8a70d4-40e1-4771-9bd6-6612289227de)

🔍 Average number of transactions per user that made a purchase in July 2017

⚡Queries

![image](https://github.com/user-attachments/assets/47c084a6-5023-4dea-883d-fce11077785e)

💡 Queries result

![image](https://github.com/user-attachments/assets/5c8a70d4-40e1-4771-9bd6-6612289227de)

🔍 Average amount of money spent per session. Only include purchaser data in July 2017

⚡Queries

![image](https://github.com/user-attachments/assets/2f70597f-7cdf-4079-94da-bd39dd8a79c9)

💡 Queries result

![image](https://github.com/user-attachments/assets/9e61817d-1018-4836-85b4-2e2ee37ad20d)

🔍 Other products purchased by customers who purchased product "YouTube Men's Vintage Henley" in July 2017. Output should show product name and the quantity was ordered

⚡Queries

![image](https://github.com/user-attachments/assets/f6a39000-e02b-463a-912b-a848127e5b9a)

💡 Queries result

![image](https://github.com/user-attachments/assets/04d472d1-c1b0-4a30-99a7-42c2d3f4e992)

🔍Calculate cohort map from product view to addtocart to purchase in Jan, Feb and March 2017

⚡Queries

![image](https://github.com/user-attachments/assets/1672c27d-8cb2-49a0-9066-887de56fe57c)

💡 Queries result

![image](https://github.com/user-attachments/assets/1b0812ae-b308-4d11-9bcf-6e5eeba732e0)

---

## 🔎 Final Conclusion & Recommendations  

👉🏻 Based on the insights and findings above, we would recommend the [stakeholder team] to consider the following:  

📌 Key Takeaways:  
✔️ Recommendation 1  
✔️ Recommendation 2  
✔️ Recommendation 3
