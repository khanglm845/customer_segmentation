# Olist E-commerce Customer Segmentation

> 📊 **[View Project Presentation Slide (PDF Here)](Olist%20E-commerce%20Customer%20Segmentation%20using%20Machine%20Learning..pdf)**

## Project Name:
Olist E-commerce Customer Segmentation using Machine Learning

## Business Problem:
- Olist has a large customer base, but the customer retention rate needs improvement.
- "One-size-fits-all" marketing campaigns lead to budget waste.
- 1-star reviews occur frequently, but the root causes (Shipping vs. Product Quality) are mixed up and unclear.
- **Objective:** Discover data-driven insights to optimize marketing ROI & operational efficiency.

## Dataset:
- **Source:** Olist Brazilian E-Commerce Public Dataset (Kaggle)
- **Scale:** ~99,441 orders, ~96,096 unique customers, 93,350 customers ready for clustering
- **Consists of 9 data tables:**
  - `olist_customers_dataset` — Customer information (ID, city, state)
  - `olist_geolocation_dataset` — Geographic coordinates
  - `olist_order_items_dataset` — Product details in orders (price, freight value)
  - `olist_order_payments_dataset` — Payment information
  - `olist_order_reviews_dataset` — Order reviews (scores 1–5)
  - `olist_orders_dataset` — Order information (status, timestamp)
  - `olist_products_dataset` — Product information (category, size, weight)
  - `olist_sellers_dataset` — Seller information
  - `product_category_name_translation` — Product category name translation table (Portuguese → English)

## Methodology / Workflow:
1. **Data Loading & Exploration:** Loaded 9 CSV tables, checked structure, null values, duplicates, and data consistency.
2. **Data Cleaning & Processing:**
   - Handled missing values: filled nulls with median/mode, dropped inconsistent rows.
   - Standardization & Formatting: converted timestamps to datetime, normalized text (lowercase, strip whitespace), translated product categories to English.
   - Deduplication: removed 261,831 duplicate records in the geolocation table, grouped by zip code to get mean coordinates.
   - Outlier handling: detected and handled outliers using the IQR method (Winsorization) for price and payment_value.
   - Cross-table consistency check: checked financial consistency between order items and payments; checked delivery time logic.
3. **Feature Engineering (Heavy lifting by SQL):**
   - Utilized **SQL** (CTEs - Common Table Expressions) to perform powerful Data Transformation and Feature Engineering right at the database layer, optimizing performance and minimizing processing load for Python.
   - Directly created the `master_segmentation_features` table, aggregating complex metrics from multiple tables (`orders`, `order_items`, `reviews`, `customers`) into 7 core features: `frequency`, `monetary_value`, `avg_order_value`, `avg_delivery_time`, `max_delay_days`, `avg_freight_ratio`, `customer_review_score`.
   - Calculated operational KPIs using complex SQL logic such as delayed delivery logic (`max_delay_days`) and shipping fee sensitivity (`avg_freight_ratio`) to go beyond the traditional RFM model.
   - Log-transformation for `monetary_value` and `avg_order_value` to normalize distribution.
4. **Data Export:** Exported the processed data to MySQL (Clever Cloud) via SQLAlchemy.
5. **Customer Segmentation:** Applied K-Means clustering to segment customers.
6. **Dashboard:** Built an interactive dashboard on Power BI.

## Methods / Models:
- **Algorithm:** K-Means Clustering
- **Determining Optimal K:** Combined Elbow Method (Inertia/WCSS) + Silhouette Analysis
  - Evaluated K from 2 to 9
  - **K = 6** was chosen — the optimal balance between mathematical accuracy and practical business value.
- **Preprocessing:** StandardScaler (mean=0, std=1) to normalize features with different units.
- **Features for clustering:** `frequency`, `monetary_value_log`, `avg_delivery_time`, `max_delay_days`, `avg_freight_ratio`, `customer_review_score`

## Tools:
| Tool | Purpose |
|------|----------|
| **Python** (pandas, numpy, scikit-learn, matplotlib, seaborn) | EDA, Log-transformation, Scaling, K-Means clustering (Elbow + Silhouette) |
| **SQL / MySQL** | Plays a core role in Data Transformation & Feature Engineering. Handles most of the complex business logic (joining 4+ tables, aggregation, CTEs calculating logistics & RFM metrics), creating a streamlined master_features table, preparing clean data before feeding into Python. |
| **SQLAlchemy + PyMySQL** | Connecting Python ↔ MySQL (Clever Cloud) |
| **Power BI** | Building interactive dashboards, automated reporting |
| **Google Colab** | Notebook development environment |

## Quantitative Results & Key Insights:

### K-Means Results (K=2→9):
| K | Inertia | Silhouette Score |
|---|---------|-----------------|
| 2 | 462,006 | 0.2304 |
| 3 | 373,272 | 0.2589 |
| 4 | 298,588 | 0.2915 |
| 5 | 246,218 | 0.3174 |
| **6** | **214,075** | **0.3193** |
| 7 | 187,892 | 0.2657 |
| 8 | 173,633 | 0.2711 |
| 9 | 161,368 | 0.2527 |

→ **K = 6** gives the highest Silhouette Score (0.3193), proving the clusters are best separated.

### 6 Customer Personas:

#### 🟢 High-Value Segments:
| Segment | Frequency | Avg Order Value | Delivery Time | Delay | Freight Ratio | Rating |
|---------|-----------|----------------|---------------|-------|---------------|--------|
| **Loyal Champions** | 2.12 times | 309.41 BRL | — | 0.69 days | — | 4.23 ⭐ |
| **Potential High-Value** | 1 time | 226.82 BRL | 10.8 days | 0 days | 13% | 4.70 ⭐ |
| **Mass Market** | 1 time | 59.08 BRL | 10.95 days | — | 32% | 4.61 ⭐ |

#### 🔴 At-Risk Segments:
| Segment | Avg Order Value | Delivery Time | Delay | Rating | Root Cause |
|---------|----------------|---------------|-------|--------|------------|
| **Churned by Delay** | 190.95 BRL | 43.56 days | 17.14 days | 1.69 ⭐ | Shipping is too slow |
| **Product Issues** | — | 15.05 days | 0.69 days | 1.77 ⭐ | Defective/fake/wrong products |
| **Logistics Nightmare** | 240.53 BRL | 135.65 days | 107.81 days | 2.97 ⭐ | "Ghost orders" — stuck in the supply chain |

### Key Insights:
- **Potential High-Value** accounts for the highest proportion in both quantity and revenue.
- **Logistics Nightmare** is the worst group in both quantity and revenue.
- K-Means successfully separated the root causes of 1-star reviews: **Churned by Delay** (due to slow shipping) vs. **Product Issues** (due to product quality) — directly solving the initial business problem.
- Outlier analysis: 7.48% of orders are price outliers but contribute **35.61%** of total revenue — indicating the importance of the Luxury segment.

### Strategic Recommendations (6 strategies for 6 segments):
- **Loyal Champions:** Implement VIP programs, membership cards, free shipping codes.
- **Potential High-Value:** Remarketing (Email/Push) with upsell/cross-sell + discount code for the 2nd order.
- **Mass Market:** Optimize AOV using combo deals (Buy 2 Pay 1, add more items for free shipping).
- **Churned by Delay:** Proactive apology call/email + compensation vouchers; review shipping partners.
- **Product Issues:** Audit seller quality + fast return policy.
- **Logistics Nightmare:** Reconcile with 3PLs immediately, claim compensation, handle bottlenecks.

## Contact Information:
- **Email:** lyminhkhanght2005@gmail.com
- **GitHub:** [https://github.com/khanglm845](https://github.com/khanglm845)
- **LinkedIn:** [https://www.linkedin.com/in/khang-lý-bb50492b5/](https://www.linkedin.com/in/khang-l%C3%BD-bb50492b5/)
