# E-commerce Customer & Experience Analytics — Olist

A business-oriented customer analytics case study combining **SQL, Python, K-Means, and Power BI** to profile customer value and delivery experience across the Olist marketplace.

The objective is not to treat clustering as an answer by itself. The project uses segmentation to identify **different customer value/experience patterns**, surface operational questions, and propose measurable follow-up actions.

> **Dataset:** Olist Brazilian E-Commerce Public Dataset  
> **Source tables:** 9 relational datasets  
> **Orders:** 99,441 raw orders  
> **Unique customers:** 96,096  
> **Customers in segmentation table:** 93,350 delivered-order customers  
> **Tools:** SQL / MySQL · Python · scikit-learn · Power BI

📊 [Project presentation](Olist%20E-commerce%20Customer%20Segmentation%20using%20Machine%20Learning..pdf)  
📓 [Analysis notebook](customer_segmentation.ipynb)  
🧩 [SQL feature pipeline](master_table.sql)  
📈 [Power BI file](cus_seg.pbix)

> **Artifact note:** the original PBIX/PDF were created before this documentation rebuild and may retain earlier working labels such as “Churned (Delay)” or “Product Issues.” The rebuilt documentation uses evidence-based labels that avoid implying churn or causal root causes that are not directly observed in the data.

---

## Executive Snapshot

The analysis produced three main business signals:

1. **Customer value is highly heterogeneous.** A large high-value single-order segment averages about **226.82 BRL per order**, while a large low-value segment averages about **59.08 BRL** and carries a much higher freight share.
2. **Poor customer ratings appear under different delivery conditions.** One low-rating segment experiences substantial delays, while another has similarly poor ratings despite relatively low recorded delay. The latter indicates that delivery delay alone does not explain the experience problem.
3. **Extreme delivery failures exist but are highly concentrated.** The most severe delivery-delay cluster contains only **77 customers (~0.08%)**, so it should be handled as an operational exception segment rather than generalized to the full customer base.

The segmentation therefore supports a more useful question than “Which cluster is best?”:

> **Which customer groups deserve retention, value-growth, logistics-recovery, or further diagnostic attention—and what evidence should be collected next?**

---

## Business Questions

The rebuilt project focuses on five questions:

1. Which customer groups differ meaningfully in value, repeat behavior, delivery experience, freight burden, and satisfaction?
2. Where do high-value customers show strong versus weak experience signals?
3. Are poor ratings consistently associated with delivery delays, or do different low-rating patterns exist?
4. Which groups are large enough to justify scaled actions versus case-level operational investigation?
5. What additional data would be required before making causal or lifecycle claims?

---

## Segment Profile

K-Means generated six clusters. The model outputs cluster IDs; the labels below are **human-assigned descriptive interpretations** based on observed profile averages.

| Evidence-based segment | Customers | Share | Frequency | Avg Order Value | Avg Delivery | Max Delay | Freight Share | Avg Rating |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| **High-Value Single-Order** | 43,635 | 46.7% | 1.00 | 226.82 BRL | 10.80 d | 0.06 d | 13% | 4.70 |
| **Low-Value / High-Freight-Share** | 31,153 | 33.4% | 1.00 | 59.08 BRL | 10.95 d | 0.07 d | 32% | 4.61 |
| **Low-Rating / Low-Delay** | 13,087 | 14.0% | 1.00 | 176.05 BRL | 15.05 d | 0.69 d | 20% | 1.77 |
| **Repeat High-Value** | 2,763 | 3.0% | 2.12 | 146.18 BRL | 11.88 d | 0.69 d | 22% | 4.23 |
| **Severe Delay / Low-Rating** | 2,635 | 2.8% | 1.01 | 189.19 BRL | 43.56 d | 17.14 d | 22% | 1.69 |
| **Extreme Delivery Delay** | 77 | 0.08% | 1.00 | 240.53 BRL | 135.65 d | 107.81 d | 18% | 2.97 |

### How to interpret these labels

- **Repeat High-Value** is descriptive, not a proven loyalty state.
- **High-Value Single-Order** has strong value and rating signals, but the data does not prove future conversion or retention.
- **Low-Rating / Low-Delay** should **not** be labeled “Product Issues” without supporting product/seller/review-text evidence.
- **Severe Delay / Low-Rating** shows a strong delay-associated profile, but clustering does not prove delay caused the rating.
- **Extreme Delivery Delay** is operationally important but very small, so its averages should not be generalized.

---

## Key Findings

### 1. High-value customers are not one homogeneous group

The largest segment contains **43,635 customers (46.7%)** with an average order value of **226.82 BRL**, average delivery time of **10.8 days**, and average review score of **4.70**.

A separate **Repeat High-Value** segment is much smaller—**2,763 customers (3.0%)**—but averages **2.12 delivered orders** and **309.41 BRL total customer value**.

**Business implication:** acquisition/value and repeat behavior should be monitored separately rather than treating all high-spend customers as one lifecycle segment.

---

### 2. Low ratings split into different operational patterns

The **Severe Delay / Low-Rating** segment averages:

- **43.56 days** delivery time
- **17.14 days** maximum delay
- **1.69 / 5** review score

By contrast, the **Low-Rating / Low-Delay** segment averages:

- **15.05 days** delivery time
- **0.69 days** maximum delay
- **1.77 / 5** review score

Both groups have poor ratings, but their recorded delay profiles are very different.

**Business implication:** it would be misleading to attribute all poor reviews to delivery delay. Review text, seller, product category, return/refund, and order-quality data should be investigated before assigning a root cause to the Low-Rating / Low-Delay group.

---

### 3. The low-value segment carries the highest freight burden

The **Low-Value / High-Freight-Share** group has:

- **59.08 BRL** average order value
- **32%** average freight share of total order value
- **4.61 / 5** average review score

The metric is a **freight-share ratio**, not a direct measure of customer “shipping sensitivity.”

**Business implication:** this group is a good candidate for testing basket-building, shipping-threshold, or bundle strategies while monitoring contribution margin and conversion.

---

### 4. Extreme delivery failure is a small exception segment

Only **77 customers (~0.08%)** fall into the Extreme Delivery Delay cluster, with average delivery time of **135.65 days** and average maximum delay of **107.81 days**.

This is an extreme profile, but its very small size matters.

**Business implication:** prioritize case-level operational audit and data-quality review before designing a broad customer strategy around this segment.

---

### 5. High-value observations should not automatically be treated as data errors

An IQR-based capping experiment found that:

- **7.48%** of item-price rows were above the IQR upper bound
- those rows represented **35.61%** of raw item-price value
- applying aggressive IQR capping would reduce reported item-price value by approximately **18.41%**

The project therefore preserved the original monetary values and used log transformation/scaling for modeling rather than overwriting economically meaningful high-value observations.

This does **not** imply every extreme value is valid; it separates data-quality validation from statistical convenience.

---

## Data Quality & Validation

Before segmentation, the project audited the relational source data rather than immediately joining all tables.

### Key checks

- Detected **261,831 exact duplicate rows** in the geolocation dataset
- Reduced geolocation to **19,015 zip-code prefixes** after deduplication and coordinate aggregation
- Confirmed order_id uniqueness in the raw orders table
- Distinguished customer_id from customer_unique_id
- Flagged **259 orders** where item-price + freight totals differed from payment totals by more than 0.1 BRL
- Flagged timestamp anomalies including:
  - **166** carrier timestamps before purchase
  - **23** delivered timestamps before carrier handoff
- Evaluated monetary outliers before deciding not to overwrite high-value observations

These checks are diagnostic. Flagged records require investigation rather than automatic deletion.

---

## Analytical Pipeline

~~~text
9 raw Olist tables
        ↓
Data-quality audit & cleaning
        ↓
MySQL relational layer
        ↓
SQL CTE feature pipeline
        ↓
Customer-level feature table
        ↓
Log transform + StandardScaler
        ↓
K-Means (K = 2…9 evaluated)
        ↓
6 descriptive customer profiles
        ↓
Power BI reporting & business interpretation
~~~

### SQL feature layer

master_table.sql restricts the segmentation table to **delivered orders with a recorded delivery date** and aggregates customer-level features:

- frequency
- monetary_value
- avg_order_value
- avg_delivery_time
- max_delay_days
- avg_freight_ratio
- customer_review_score

monetary_value and avg_order_value include item price plus freight in the SQL feature table.

> avg_freight_ratio describes **freight as a share of order value**. It should not be interpreted as observed willingness-to-pay or behavioral price sensitivity.

---

## Clustering Method

### Features used in K-Means

The final clustering model uses:

- frequency
- monetary_value_log
- avg_delivery_time
- max_delay_days
- avg_freight_ratio
- customer_review_score

avg_order_value is used for profiling but is not one of the final K-Means input features.

### Preprocessing

- monetary_value is transformed with log1p to reduce right-skew and compress the long tail
- clustering features are standardized with StandardScaler
- K-Means uses random_state=42 and n_init=10

This is **not a classical RFM model** because Recency is not included. It is better described as a **customer value + delivery-experience segmentation**.

---

## Choosing K

Candidate values from **K=2 to K=9** were compared using inertia and silhouette score.

| K | Inertia | Sampled Silhouette |
| ---: | ---: | ---: |
| 2 | 462,006 | 0.2304 |
| 3 | 373,272 | 0.2589 |
| 4 | 298,588 | 0.2915 |
| 5 | 246,218 | 0.3174 |
| **6** | **214,075** | **0.3193** |
| 7 | 187,892 | 0.2657 |
| 8 | 173,633 | 0.2711 |
| 9 | 161,368 | 0.2527 |

K=6 produced the highest silhouette score **among the tested candidates**. Silhouette was estimated on a reproducible **15,000-row sample** for computational efficiency.

A score of **0.3193** indicates moderate—not strong—cluster separation. K=6 is therefore treated as a practical descriptive segmentation, not proof of natural or objectively correct customer classes.

---

## Action Hypotheses

| Segment | Evidence | Directional action | What to measure |
| --- | --- | --- | --- |
| Repeat High-Value | highest frequency and high customer value | retention / recognition experiments | repeat rate, incremental margin, redemption |
| High-Value Single-Order | large group, high AOV, strong ratings | test second-purchase conversion | 30/60/90-day repeat rate, CAC/payback |
| Low-Value / High-Freight-Share | low AOV, 32% freight share | basket-building / shipping-threshold tests | AOV, conversion, margin, freight/order |
| Low-Rating / Low-Delay | rating 1.77 without material recorded delay | investigate review text, seller/category, return/refund signals | issue mix, seller/category concentration |
| Severe Delay / Low-Rating | long delivery + low rating | logistics recovery / carrier diagnostics | late rate, delivery days, post-recovery rating |
| Extreme Delivery Delay | 77 highly delayed customers | case-level operational audit | anomaly validity, fulfillment stage, carrier path |

These are **testable hypotheses**, not guaranteed business outcomes.

---

## Analytical Limitations

### 1. No churn target

The dataset does not contain a confirmed churn label. A one-order customer should not automatically be called “churned.”

### 2. No causal root-cause identification

K-Means identifies similarity in observed features. It does not prove that delivery, product quality, sellers, or another factor caused a review score.

### 3. Review-score imputation

The current reproducible model fills **603 missing customer review scores** with the observed median of **5.0** before clustering.

This is a material limitation because missing review behavior is not equivalent to a five-star rating. A stronger future design would preserve a missing-review indicator or model reviewed/non-reviewed customers separately.

### 4. Delivered-order selection

The SQL feature table only includes delivered orders with a recorded customer delivery date. Cancellations and other non-delivered experiences are therefore outside the segmentation.

### 5. K-Means assumptions

K-Means uses Euclidean distance and favors relatively compact cluster geometry. Segment boundaries should be treated as descriptive, not as immutable customer classes.

### 6. Historical context

The Olist dataset represents historical Brazilian marketplace transactions. The results demonstrate analytical methodology and patterns in this dataset; they are not direct evidence of current Vietnamese e-commerce behavior.

---

## Reproducibility & Security

Database credentials are loaded from environment variables—never from hard-coded notebook values.

### Local setup

~~~bash
pip install -r requirements.txt
cp .env.example .env
~~~

Populate .env locally:

~~~text
DB_USER=...
DB_PASSWORD=...
DB_HOST=...
DB_PORT=3306
DB_NAME=...
~~~

.env is excluded through .gitignore.

> If a credential has ever been committed publicly, removing it from the latest notebook is not enough. The credential should be rotated/revoked because Git history may still contain the old value.

---

## Repository Structure

~~~text
customer_segmentation/
├── README.md
├── customer_segmentation.ipynb
├── master_table.sql
├── cus_seg.pbix
├── Olist E-commerce Customer Segmentation using Machine Learning..pdf
├── requirements.txt
├── .env.example
├── .gitignore
└── data/
    ├── raw/
    └── processed/
~~~

---

## Skills Demonstrated

**Business Analytics**
- customer value and experience profiling
- e-commerce KPI interpretation
- operational diagnostics
- evidence-to-action framing
- analytical limitation management

**Data & BI**
- multi-table data validation
- SQL CTEs and customer-level feature engineering
- MySQL / SQLAlchemy
- Python / pandas
- K-Means and silhouette analysis
- feature scaling / log transformation
- Power BI reporting
- reproducible environment configuration
