# Olist E-commerce Customer Segmentation

## Tên project:
Olist E-commerce Customer Segmentation using Machine Learning

## Business problem:
- Olist có lượng khách hàng lớn nhưng tỷ lệ giữ chân khách hàng (retention rate) cần cải thiện.
- Các chiến dịch marketing "one-size-fits-all" dẫn đến lãng phí ngân sách.
- Đánh giá 1 sao xuất hiện thường xuyên, nhưng nguyên nhân gốc rễ (Shipping vs. Product Quality) bị lẫn lộn và không rõ ràng.
- **Mục tiêu:** Khám phá insight dựa trên dữ liệu để tối ưu ROI marketing & hiệu quả vận hành.

## Dataset:
- **Nguồn:** Olist Brazilian E-Commerce Public Dataset (Kaggle)
- **Quy mô:** ~99,441 đơn hàng, ~96,096 khách hàng duy nhất, 93,350 khách hàng sẵn sàng cho clustering
- **Gồm 9 bảng dữ liệu:**
  - `olist_customers_dataset` — Thông tin khách hàng (ID, thành phố, bang)
  - `olist_geolocation_dataset` — Tọa độ địa lý
  - `olist_order_items_dataset` — Chi tiết sản phẩm trong đơn hàng (giá, phí vận chuyển)
  - `olist_order_payments_dataset` — Thông tin thanh toán
  - `olist_order_reviews_dataset` — Đánh giá đơn hàng (điểm 1–5)
  - `olist_orders_dataset` — Thông tin đơn hàng (trạng thái, timestamp)
  - `olist_products_dataset` — Thông tin sản phẩm (danh mục, kích thước, trọng lượng)
  - `olist_sellers_dataset` — Thông tin người bán
  - `product_category_name_translation` — Bảng dịch tên danh mục sản phẩm (Bồ Đào Nha → Anh)

## Bạn đã làm gì:
1. **Data Loading & Exploration:** Load 9 bảng CSV, kiểm tra cấu trúc, null values, duplicates, và tính nhất quán dữ liệu.
2. **Data Cleaning & Processing:**
   - Xử lý missing values: fill null bằng median/mode, drop inconsistent rows.
   - Standardization & Formatting: chuyển đổi timestamp sang datetime, normalize text (lowercase, strip whitespace), dịch danh mục sản phẩm sang tiếng Anh.
   - Deduplication: xóa 261,831 bản ghi trùng lặp trong bảng geolocation, group by zip code lấy mean tọa độ.
   - Outlier handling: phát hiện và xử lý outlier bằng IQR method (Winsorization) cho price và payment_value.
   - Cross-table consistency check: kiểm tra tính nhất quán tài chính giữa order items và payments; kiểm tra logic thời gian delivery.
3. **Feature Engineering (Heavy lifting by SQL):**
   - Sử dụng **SQL** (CTEs - Common Table Expressions) để thực hiện Data Transformation và Feature Engineering mạnh mẽ ngay tại tầng database, giúp tối ưu hóa hiệu suất và giảm thiểu tải xử lý cho Python.
   - Trực tiếp tạo bảng `master_segmentation_features` gom nhóm các metrics phức tạp từ nhiều bảng (`orders`, `order_items`, `reviews`, `customers`) thành 7 features cốt lõi: `frequency`, `monetary_value`, `avg_order_value`, `avg_delivery_time`, `max_delay_days`, `avg_freight_ratio`, `customer_review_score`.
   - Tính toán các KPIs vận hành bằng logic SQL phức tạp như: logic giao hàng trễ (`max_delay_days`) và độ nhạy cảm phí ship (`avg_freight_ratio`) để vượt ra ngoài mô hình RFM truyền thống.
   - Log-transformation cho `monetary_value` và `avg_order_value` để chuẩn hóa phân phối.
4. **Data Export:** Xuất dữ liệu đã xử lý lên MySQL (Clever Cloud) qua SQLAlchemy.
5. **Customer Segmentation:** Áp dụng K-Means clustering để phân khúc khách hàng.
6. **Dashboard:** Xây dựng dashboard tương tác trên Power BI.

## Phương pháp/model:
- **Thuật toán:** K-Means Clustering
- **Xác định K tối ưu:** Kết hợp Elbow Method (Inertia/WCSS) + Silhouette Analysis
  - Đánh giá K từ 2 đến 9
  - **K = 6** được chọn — cân bằng tối ưu giữa độ chính xác toán học và giá trị kinh doanh thực tế
- **Preprocessing:** StandardScaler (mean=0, std=1) để chuẩn hóa các features có đơn vị khác nhau
- **Features cho clustering:** `frequency`, `monetary_value_log`, `avg_delivery_time`, `max_delay_days`, `avg_freight_ratio`, `customer_review_score`

## Tools:
| Tool | Mục đích |
|------|----------|
| **Python** (pandas, numpy, scikit-learn, matplotlib, seaborn) | EDA, Log-transformation, Scaling, K-Means clustering (Elbow + Silhouette) |
| **SQL / MySQL** | Đóng vai trò hạt nhân trong Data Transformation & Feature Engineering. Xử lý phần lớn logic nghiệp vụ phức tạp (joining 4+ bảng, aggregation, CTEs tính toán metrics logistics & RFM), tạo ra bảng master_features tinh gọn, chuẩn bị dữ liệu sạch sẽ trước khi đưa vào Python |
| **SQLAlchemy + PyMySQL** | Kết nối Python ↔ MySQL (Clever Cloud) |
| **Power BI** | Xây dựng dashboard tương tác, báo cáo tự động |
| **Google Colab** | Môi trường phát triển notebook |

## Kết quả định lượng hoặc insight nổi bật:

### Kết quả K-Means (K=2→9):
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

→ **K = 6** cho Silhouette Score cao nhất (0.3193), chứng tỏ các cluster phân tách tốt nhất.

### 6 Customer Personas:

#### 🟢 High-Value Segments:
| Segment | Frequency | Avg Order Value | Delivery Time | Delay | Freight Ratio | Rating |
|---------|-----------|----------------|---------------|-------|---------------|--------|
| **Loyal Champions** | 2.12 lần | 309.41 BRL | — | 0.69 ngày | — | 4.23 ⭐ |
| **Potential High-Value** | 1 lần | 226.82 BRL | 10.8 ngày | 0 ngày | 13% | 4.70 ⭐ |
| **Mass Market** | 1 lần | 59.08 BRL | 10.95 ngày | — | 32% | 4.61 ⭐ |

#### 🔴 At-Risk Segments:
| Segment | Avg Order Value | Delivery Time | Delay | Rating | Root Cause |
|---------|----------------|---------------|-------|--------|------------|
| **Churned by Delay** | 190.95 BRL | 43.56 ngày | 17.14 ngày | 1.69 ⭐ | Shipping quá chậm |
| **Product Issues** | — | 15.05 ngày | 0.69 ngày | 1.77 ⭐ | Sản phẩm lỗi/giả/sai hàng |
| **Logistics Nightmare** | 240.53 BRL | 135.65 ngày | 107.81 ngày | 2.97 ⭐ | "Ghost orders" — đơn mắc kẹt trong chuỗi cung ứng |

### Key Insights:
- **Potential High-Value** chiếm tỷ trọng cao nhất cả về số lượng lẫn doanh thu.
- **Logistics Nightmare** là nhóm tệ nhất cả về số lượng lẫn doanh thu.
- K-Means tách biệt thành công nguyên nhân 1-star review: **Churned by Delay** (do shipping chậm) vs. **Product Issues** (do chất lượng sản phẩm) — giải quyết đúng bài toán business đặt ra ban đầu.
- Outlier analysis: 7.48% đơn hàng là outlier về giá nhưng đóng góp **35.61%** tổng doanh thu — cho thấy tầm quan trọng của phân khúc Luxury.

### Strategic Recommendations (6 chiến lược cho 6 phân khúc):
- **Loyal Champions:** Triển khai chương trình VIP, thẻ membership, free shipping codes.
- **Potential High-Value:** Remarketing (Email/Push) với upsell/cross-sell + discount code cho đơn thứ 2.
- **Mass Market:** Tối ưu AOV bằng combo deals (Buy 2 Pay 1, mua thêm để free ship).
- **Churned by Delay:** Chủ động gọi/email xin lỗi + voucher bồi thường; review đối tác vận chuyển.
- **Product Issues:** Audit seller chất lượng + chính sách hoàn trả nhanh.
- **Logistics Nightmare:** Đối soát ngay với 3PLs, yêu cầu bồi thường, xử lý bottleneck.

## GitHub/Portfolio link nếu có:
- **Email:** lyminhkhanght2005@gmail.com
- **GitHub:** [https://github.com/khanglm845](https://github.com/khanglm845)
- **LinkedIn:** [https://www.linkedin.com/in/khang-lý-bb50492b5/](https://www.linkedin.com/in/khang-l%C3%BD-bb50492b5/)
