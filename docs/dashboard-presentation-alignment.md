# Dashboard & Presentation Alignment
## E-commerce Customer & Experience Analytics — Olist

This checklist aligns the legacy Power BI / presentation artifacts with the rebuilt README and notebook.

> Scope: the PBIX and PDF are binary legacy artifacts. The repository tools available here cannot inspect their internal visual text directly, so this document maps every legacy claim/label confirmed from the notebook and original README to replacement wording that should be applied manually in Power BI and the presentation. After editing, re-export the PDF and re-check every title, segment label, insight sentence, and recommendation.

---

## 1. Global naming

### Project title

Replace:

> Olist E-commerce Customer Segmentation using Machine Learning

With:

> E-commerce Customer & Experience Analytics — Olist

Optional subtitle:

> Customer value, delivery experience, and descriptive segmentation using SQL, Python, K-Means, and Power BI

### Positioning sentence

Use:

> Customer segmentation is used as a descriptive decision-support layer, not as proof of churn states or causal root causes.

Avoid: “AI/ML discovers the root cause”, “K-Means proves customer behavior”, “Optimal segmentation”, and “Churned customers” unless a churn target is explicitly defined.

---

## 2. Segment label replacement map

| Legacy label | Replace with | Why |
| --- | --- | --- |
| Loyal Champions | **Repeat High-Value** | Observed repeat/value pattern; loyalty is not measured directly |
| Potential High-Value | **High-Value Single-Order** | High order value is observed; future value is not proven |
| Mass Market | **Low-Value / High-Freight-Share** | More descriptive of the actual profile |
| Product Issues | **Low-Rating / Low-Delay** | Product quality is not directly measured in clustering features |
| Churned (Delay) / Churned by Delay | **Severe Delay / Low-Rating** | No churn label exists; delay is associated, not causal |
| Logistics Nightmare | **Extreme Delivery Delay** | Neutral, evidence-based description |

Apply the same labels consistently in slicers, legends, charts, KPI cards, tooltips, tables, narrative text, and presentation charts.

---

## 3. Segment profile numbers to use

| Segment | Customers | Share | Frequency | Avg Order Value | Avg Delivery | Max Delay | Freight Share | Avg Rating |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| High-Value Single-Order | 43,635 | 46.7% | 1.00 | 226.82 BRL | 10.80 d | 0.06 d | 13% | 4.70 |
| Low-Value / High-Freight-Share | 31,153 | 33.4% | 1.00 | 59.08 BRL | 10.95 d | 0.07 d | 32% | 4.61 |
| Low-Rating / Low-Delay | 13,087 | 14.0% | 1.00 | 176.05 BRL | 15.05 d | 0.69 d | 20% | 1.77 |
| Repeat High-Value | 2,763 | 3.0% | 2.12 | 146.18 BRL | 11.88 d | 0.69 d | 22% | 4.23 |
| Severe Delay / Low-Rating | 2,635 | 2.8% | 1.01 | 189.19 BRL | 43.56 d | 17.14 d | 22% | 1.69 |
| Extreme Delivery Delay | 77 | 0.08% | 1.00 | 240.53 BRL | 135.65 d | 107.81 d | 18% | 2.97 |

Size warning: Extreme Delivery Delay has only 77 customers. Avoid giving it equal visual weight to a 43k-customer segment without showing segment size. Prefer bubble size = customer count or display customer count/share beside every segment.

---

## 4. Dashboard narrative structure

### Page 1 — Customer Portfolio Overview

Management question:

> What customer value and experience patterns exist in the delivered-order portfolio?

Recommended KPIs: 93,350 customers in the segmentation table; 6 descriptive profiles; share of Repeat High-Value; share of customers in low-rating profiles; average order value; average review score.

Recommended visuals: customer count/share by segment; Avg Order Value vs Avg Rating scatter; segment summary matrix; segment frequency/value comparison.

Top insight text:

> Nearly half of the delivered-order customer base falls into a high-value single-order profile, while repeat high-value customers represent only ~3%, suggesting that value and repeat behavior should be managed as separate dimensions.

Do not say: “Potential High-Value customers will become loyal customers.”

### Page 2 — Customer Experience & Delivery

Management question:

> Are poor ratings consistently associated with delivery delays?

Recommended visuals: Avg Delivery Time vs Avg Rating by segment; Max Delay by segment; customer count by low-rating segment; optional review-score distribution.

Top insight text:

> Low ratings appear under different delivery conditions: Severe Delay / Low-Rating averages 43.56 delivery days and a 1.69 rating, while Low-Rating / Low-Delay averages 15.05 days and a 1.77 rating. Delivery delay alone therefore does not explain all poor reviews.

Do not say: “Product quality is the root cause of the Low-Rating / Low-Delay segment.”

Use: “This segment requires further diagnosis using review text, seller, category, return/refund, or product-quality data.”

### Page 3 — Value & Freight Economics

Management question:

> Which customer profiles combine low order value with a high freight burden?

Recommended visuals: Avg Order Value by segment; Freight Share by segment; AOV vs Freight Share scatter; customer count/share.

Top insight text:

> The Low-Value / High-Freight-Share segment averages only 59.08 BRL per order while freight represents ~32% of total order value, making it a candidate for basket-building or shipping-threshold tests.

Do not label freight share as shipping sensitivity, willingness to pay, or price sensitivity unless new behavioral data supports those constructs.

### Page 4 — Segment Action Matrix

Management question:

> Which actions should be tested, and how should success be measured?

| Segment | Directional action | Primary metric |
| --- | --- | --- |
| Repeat High-Value | retention / recognition experiment | repeat rate, incremental margin |
| High-Value Single-Order | second-purchase conversion | 30/60/90-day repeat rate |
| Low-Value / High-Freight-Share | basket-building / shipping threshold | AOV, conversion, margin |
| Low-Rating / Low-Delay | diagnostic investigation | issue mix by seller/category/review text |
| Severe Delay / Low-Rating | logistics recovery | late rate, delivery days, post-recovery rating |
| Extreme Delivery Delay | case-level operations audit | anomaly validity, fulfillment stage |

Use the heading “Action hypotheses” instead of “Strategic recommendations guaranteed to improve ROI.”

---

## 5. K-Means / methodology slide alignment

Replace:

> K = 6 gives the highest Silhouette Score, proving the clusters are best separated.

With:

> Among K=2…9, K=6 produced the highest sampled silhouette score (0.3193) and was retained as a practical descriptive segmentation.

Add:

> A silhouette score of 0.3193 indicates moderate rather than strong separation; the segments should be treated as useful profiles, not natural customer classes.

Sampling disclosure:

> Silhouette score was estimated on a reproducible 15,000-row sample for computational efficiency.

Final K-Means features: frequency, monetary_value_log, avg_delivery_time, max_delay_days, avg_freight_ratio, customer_review_score.

Do not say avg_order_value was a final clustering feature; it is used for profiling.

Do not call this a full RFM model because Recency is not included. Use “customer value + delivery-experience segmentation.”

---

## 6. Data-quality slide alignment

Highlight these as evidence of data discipline:

- 261,831 exact duplicate geolocation rows identified
- geolocation aggregated to 19,015 zip-code prefixes
- 259 financial reconciliation mismatches flagged (>0.1 BRL)
- 166 carrier timestamps before purchase flagged
- 23 delivery timestamps before carrier handoff flagged
- 603 missing customer review scores in the segmentation feature table

Outlier wording:

Replace “Outliers represent the Luxury Segment / VIP customers” with:

> High-value observations are economically material and should not be automatically overwritten as statistical errors.

Evidence: 7.48% of item-price rows exceed the IQR upper bound; they represent 35.61% of raw item-price value; aggressive IQR capping would remove ~18.41% of item-price value.

---

## 7. Review-score limitation callout

Add a visible methodology footnote or appendix box:

> Limitation: 603 customers in the segmentation feature table have no observed review score. The current legacy model imputes these missing values with the median score of 5.0 before clustering. Missing review behavior is not equivalent to five-star satisfaction, so this treatment may affect the customer-experience dimension.

Future version: add has_review; preserve missingness; compare reviewed vs non-reviewed customers; sensitivity-test cluster stability.

---

## 8. Delivered-order scope

Add near the dataset / methodology section:

> The segmentation feature table is restricted to delivered orders with a recorded customer delivery date.

Implication:

> Cancellations, failed deliveries, and other non-delivered experiences are outside the segmentation population.

Do not describe the clusters as representing “all Olist customers.” Use “delivered-order customer profiles.”

---

## 9. Presentation structure — recommended 6-slide version

### Slide 1 — Business Question

Title: E-commerce Customer & Experience Analytics — Olist

Message: How can customer value and delivery-experience patterns support more targeted growth and operational decisions?

Keep technical tools small at the bottom.

### Slide 2 — Data & Analytical Integrity

Show: 9 relational tables; 99,441 orders; 96,096 unique customers; 93,350 segmentation customers; SQL customer feature pipeline.

Add 2–3 DQ checks, not every cleaning step.

Key message: Build a reliable customer-level analytical base before clustering.

### Slide 3 — Six Descriptive Customer Profiles

Use customer count/share as a primary visual.

Key message: Segment size and business relevance vary substantially; 77-customer exceptions should not be treated like 40k-customer groups.

### Slide 4 — The Strongest Experience Insight

Compare Severe Delay / Low-Rating vs Low-Rating / Low-Delay.

Key message: Poor ratings occur under materially different delivery conditions, so delivery delay alone does not explain the full customer-experience problem.

### Slide 5 — Growth / Operations Actions

Use three action lanes:

Grow value: High-Value Single-Order; Repeat High-Value; Low-Value / High-Freight-Share.

Recover experience: Severe Delay / Low-Rating.

Investigate before acting: Low-Rating / Low-Delay; Extreme Delivery Delay.

Attach one success metric to every action.

### Slide 6 — Methodology & Limitations

Show: StandardScaler; log1p monetary value; K=2…9; K=6 silhouette = 0.3193; 15k silhouette sample.

Then show limitations: no churn label; no causal root-cause inference; delivered-order-only scope; review-score imputation; historical Brazil context.

Close with:

> Segmentation narrows where to investigate and test; it does not replace causal analysis or experimentation.

---

## 10. Exact claim replacements

| Avoid | Use instead |
| --- | --- |
| “K=6 proves the best clusters” | “K=6 had the highest sampled silhouette among K=2…9” |
| “root cause of 1-star reviews” | “distinct low-rating profiles under different delivery conditions” |
| “churned customers” | “Severe Delay / Low-Rating” |
| “product issues segment” | “Low-Rating / Low-Delay; cause requires further diagnosis” |
| “shipping sensitivity” | “freight share of order value” |
| “VIP/luxury outliers” | “economically material high-value observations” |
| “loyal champions” | “Repeat High-Value” |
| “potential high-value” | “High-Value Single-Order” |
| “logistics nightmare” | “Extreme Delivery Delay” |
| “strategic recommendation” | “directional action / testable hypothesis” |

---

## 11. Final acceptance checklist

- [ ] Project title matches the rebuilt README
- [ ] All six segment labels use the evidence-based names
- [ ] Segment counts/shares are visible
- [ ] “root cause,” “churned,” “product issues,” “VIP,” and “shipping sensitivity” claims are removed
- [ ] K=6 wording says “highest among tested candidates,” not “proven optimal”
- [ ] Silhouette 0.3193 is described as moderate separation
- [ ] 15,000-row silhouette sampling is disclosed
- [ ] Review-score imputation limitation is disclosed
- [ ] Delivered-order-only population is disclosed
- [ ] Extreme Delivery Delay is clearly shown as a 77-customer exception segment
- [ ] Every recommendation has a metric to measure
- [ ] Dashboard/PDF use the same numbers and labels as README
- [ ] Re-export PDF after PBIX edits
- [ ] Rotate/revoke the previously exposed database credentials before considering the repository recruiter-ready
