-- Drop the table if it already exists to prevent errors during multiple runs (Idempotent run)
DROP TABLE IF EXISTS master_segmentation_features;

-- Create a new Master Feature table based on the query
CREATE TABLE master_segmentation_features AS
WITH 

-- 1. Order_Base: Retrieve valid orders and calculate delivery time metrics
Order_Base AS (
    SELECT
        order_id,
        customer_id,
        order_purchase_timestamp,
        order_delivered_customer_date,
        order_estimated_delivery_date,
        -- Calculate the number of days from purchase to delivery (Delivery Time)
        DATEDIFF(order_delivered_customer_date, order_purchase_timestamp) AS delivery_time_days,
        -- Calculate the number of delay days; if delivered early or on time, set to 0
        CASE
            WHEN order_delivered_customer_date > order_estimated_delivery_date
            THEN DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date)
            ELSE 0
        END AS delay_days
    FROM olist_orders_dataset
    WHERE order_status = 'delivered' 
      AND order_delivered_customer_date IS NOT NULL
),

-- 2. Order_Financials: Calculate total value and freight ratio for each order
Order_Financials AS (
    SELECT
        order_id,
        SUM(price) AS total_price,
        SUM(freight_value) AS total_freight,
        SUM(price) + SUM(freight_value) AS total_order_value,
        -- Calculate the ratio of freight / total order value (Shipping Sensitivity)
        CASE
            WHEN (SUM(price) + SUM(freight_value)) = 0 THEN 0
            ELSE SUM(freight_value) / (SUM(price) + SUM(freight_value))
        END AS freight_ratio
    FROM olist_order_items_dataset
    GROUP BY order_id
),

-- 3. Review_Data: Obtain the average review score for each order
Review_Data AS (
    SELECT
        order_id,
        AVG(review_score) AS avg_review_score
    FROM olist_order_reviews_dataset
    GROUP BY order_id
),

-- 4. Customer_Order_Join: Join data from the blocks above with the Customers table
Customer_Order_Join AS (
    SELECT
        c.customer_unique_id,
        o.order_id,
        o.delivery_time_days,
        o.delay_days,
        f.total_price,
        f.total_freight,
        f.total_order_value,
        f.freight_ratio,
        r.avg_review_score
    FROM Order_Base o
    JOIN olist_customers_dataset c 
        ON o.customer_id = c.customer_id
    LEFT JOIN Order_Financials f 
        ON o.order_id = f.order_id
    LEFT JOIN Review_Data r 
        ON o.order_id = r.order_id
)

-- 5. FINAL SELECT: Aggregate by customer_unique_id to generate Features
SELECT
    customer_unique_id,
    
    -- Feature 1: Purchase frequency (Can act as the F variable in RFM)
    COUNT(DISTINCT order_id) AS frequency, 
    
    -- Feature 2: Customer lifetime total value (Monetary / Total Value)
    SUM(total_order_value) AS monetary_value, 
    
    -- Feature 3: Average value per order (AOV)
    AVG(total_order_value) AS avg_order_value, 
    
    -- Feature 4: Waiting time experience (Average Delivery Time)
    AVG(delivery_time_days) AS avg_delivery_time, 
    
    -- Feature 5: Worst experience of delayed delivery (Max Delay)
    MAX(delay_days) AS max_delay_days, 
    
    -- Feature 6: Willingness to pay for shipping (Shipping Sensitivity)
    AVG(freight_ratio) AS avg_freight_ratio, 
    
    -- Feature 7: Level of customer satisfaction (Customer Satisfaction)
    AVG(avg_review_score) AS customer_review_score

FROM Customer_Order_Join
GROUP BY customer_unique_id;

-- Create an index on the customer_unique_id column to speed up future retrieval
ALTER TABLE master_segmentation_features 
ADD PRIMARY KEY (customer_unique_id(255));