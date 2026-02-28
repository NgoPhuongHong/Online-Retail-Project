

ALTER TABLE [dbo].[online_retail] ALTER COLUMN invoice_num int;
ALTER TABLE [dbo].[online_retail] ALTER COLUMN stock_code int;
ALTER TABLE [dbo].[online_retail] ALTER COLUMN quantity int;
ALTER TABLE [dbo].[online_retail] ALTER COLUMN invoice_date datetime;
ALTER TABLE [dbo].[online_retail] ALTER COLUMN unit_price float;
ALTER TABLE [dbo].[online_retail] ALTER COLUMN cust_id int;
ALTER TABLE [dbo].[online_retail] ALTER COLUMN amount float;
ALTER TABLE [dbo].[online_retail] ALTER COLUMN day int;
ALTER TABLE [dbo].[online_retail] ALTER COLUMN month int;
ALTER TABLE [dbo].[online_retail] ALTER COLUMN hour int;

-- 1. How many monthly active user (MAU) each month?

SELECT o.year_month,
	COUNT (distinct o.cust_id) monthly_active_users
FROM [dbo].[online_retail] AS o
GROUP BY o.year_month
ORDER BY o.year_month 

--2. How are the number of orders and total order amount each month?

SELECT o.year_month,
	COUNT(distinct o.invoice_num) Total_order, 
	ROUND(SUM(o.amount),2) Total_amount
FROM [dbo].[online_retail] AS o
GROUP BY o.year_month
ORDER BY o.year_month 

-- 3. Analyze the number of customers by weekdays and by hour

DECLARE 
    @columns NVARCHAR(MAX),
    @result NVARCHAR(MAX);

-- lấy danh sách các giờ có giao dịch, theo thứ tự tăng dần
SELECT 
    @columns = STRING_AGG(QUOTENAME(hour), ',') -- nối chuỗi kết quả các giờ lại [1],[2]...
                  WITHIN GROUP (ORDER BY hour) 
FROM (
    SELECT DISTINCT hour
    FROM [dbo].[online_retail]
    --WHERE cust_id IS NOT NULL
) AS Hours;

-- pivot 
SET @result = '
SELECT week_days, ' + @columns + '
FROM (
    SELECT week_days, hour, COUNT(DISTINCT cust_id) AS CUST
    FROM [dbo].[online_retail]
    GROUP BY week_days, hour
) AS SourceTable
PIVOT (
    SUM(CUST)
    FOR hour IN (' + @columns + ')
) AS PivotTable
ORDER BY 
    CASE week_days
        WHEN ''Monday'' THEN 1
        WHEN ''Tuesday'' THEN 2
        WHEN ''Wednesday'' THEN 3
        WHEN ''Thursday'' THEN 4
        WHEN ''Friday'' THEN 5
        WHEN ''Saturday'' THEN 6
        WHEN ''Sunday'' THEN 7
        ELSE 8
    END;
';


PRINT @result;
EXEC sp_executesql @result;

---4 Top 10 Contries bring most sales for the company?

SELECT TOP 10 country, 
	ROUND(SUM(amount),2) AS Total_Amount
FROM [dbo].[online_retail]
GROUP BY country
ORDER BY Total_Amount DESC


---5 Countries with most AOV - Average Order Value:--
--------AOV = [Tổng giá trị đơn hàng]/[Số lượng đơn hàng]


SELECT TOP 10 
	country,
	ROUND(SUM(amount)/(count(distinct invoice_num)),2) AS AOV
FROM [dbo].[online_retail]
GROUP BY country
ORDER BY AOV DESC


---6 How many new and old customers do you have each month?

WITH FirstMonth AS (
    SELECT 
        cust_id, 
        MIN(year_month) AS first_month
    FROM [dbo].[online_retail]
    GROUP BY cust_id
),
CustomerWithType AS (
    SELECT 
        o.year_month,
        o.cust_id,
        CASE 
            WHEN o.year_month = f.first_month THEN 'New'
            ELSE 'Old'
        END AS Type_cust
    FROM [dbo].[online_retail] o
    JOIN FirstMonth f ON o.cust_id = f.cust_id
),
GroupedCounts AS (
    SELECT 
        year_month,
        Type_cust,
        COUNT(DISTINCT cust_id) AS cnt
    FROM CustomerWithType
    GROUP BY year_month, Type_cust
)

-- Pivot để ra cột New / Old
SELECT 
    year_month,
    ISNULL([New], 0) AS New,
    ISNULL([Old], 0) AS Old
FROM GroupedCounts
PIVOT (
    SUM(cnt)
    FOR Type_cust IN ([New], [Old])
) AS PivotResult
ORDER BY year_month;



---7. Considering the new customers of December 2010, what is the average transaction value of these customers in each month when they return?


-- Xác định tháng đầu tiên mua hàng của từng khách hàng
WITH FirstMonth AS (
    SELECT cust_id, MIN(year_month) AS first_month
    FROM [dbo].[online_retail]
    GROUP BY cust_id
),

-- Lấy danh sách khách hàng mới trong tháng 2010-12
NewCustomers201012 AS (
    SELECT cust_id
    FROM FirstMonth
    WHERE first_month = '2010-12'
),

-- Tính tổng amount cho từng khách hàng theo từng tháng 
CustomerMonthlyAmount AS (
    SELECT 
        o.year_month,
        o.cust_id,
        SUM(o.amount) AS total_amount
    FROM [dbo].[online_retail] o
    JOIN NewCustomers201012 nc ON o.cust_id = nc.cust_id
    GROUP BY o.year_month, o.cust_id
)

-- Tính trung bình total_amount theo từng tháng
SELECT 
    year_month,
    ROUND(AVG(total_amount), 2) AS avg_total_amount
FROM CustomerMonthlyAmount
GROUP BY year_month
ORDER BY year_month;



---8. **Customer Segmentation:**

-- frequency: số lần KH mua hàng trong 1 khoảng thời gian


DECLARE @max_invoice_date DATE = (SELECT MAX(invoice_date) FROM [dbo].[online_retail]);
WITH CustomerStats AS (
    SELECT 
        cust_id,
        MAX(invoice_date) AS last_invoice_date,
        SUM(amount) AS total_revenue,
        COUNT(DISTINCT invoice_num) AS frequency
    FROM [dbo].[online_retail]
    GROUP BY cust_id
),
CustomerScored as(
SELECT 
    cust_id,
    last_invoice_date,
    total_revenue,
    frequency,
    DATEDIFF(DAY, last_invoice_date, @max_invoice_date) AS recency,

CASE 
        WHEN DATEDIFF(DAY, last_invoice_date, @max_invoice_date) > 48 THEN 1
        WHEN DATEDIFF(DAY, last_invoice_date, @max_invoice_date) BETWEEN 15 AND 48 THEN 2
        WHEN DATEDIFF(DAY, last_invoice_date, @max_invoice_date) < 15 THEN 3
    END AS recency_score,
CASE 
        WHEN frequency = 1 THEN 1
        WHEN frequency BETWEEN 2 AND 5 THEN 2
        WHEN frequency > 5 THEN 3
    END AS frequency_score,
CASE 
        WHEN DATEDIFF(DAY, last_invoice_date, @max_invoice_date) > 48 AND frequency = 1 THEN 'Low value'
        WHEN DATEDIFF(DAY, last_invoice_date, @max_invoice_date) > 48 AND frequency BETWEEN 2 AND 5 THEN 'Losing potential loyal'
        WHEN DATEDIFF(DAY, last_invoice_date, @max_invoice_date) > 48 AND frequency > 5 THEN 'Lost loyal'

        WHEN DATEDIFF(DAY, last_invoice_date, @max_invoice_date) BETWEEN 15 AND 48 AND frequency = 1 THEN 'Low value'
        WHEN DATEDIFF(DAY, last_invoice_date, @max_invoice_date) BETWEEN 15 AND 48 AND frequency BETWEEN 2 AND 5 THEN 'Losing potential loyal'
        WHEN DATEDIFF(DAY, last_invoice_date, @max_invoice_date) BETWEEN 15 AND 48 AND frequency > 5 THEN 'Losing loyal'

        WHEN DATEDIFF(DAY, last_invoice_date, @max_invoice_date) < 15 AND frequency = 1 THEN 'New customer'
        WHEN DATEDIFF(DAY, last_invoice_date, @max_invoice_date) < 15 AND frequency BETWEEN 2 AND 5 THEN 'Potential loyal'
        WHEN DATEDIFF(DAY, last_invoice_date, @max_invoice_date) < 15 AND frequency > 5 THEN 'Loyal'
    END AS customer_segment

FROM CustomerStats
--ORDER BY cust_id
)
SELECT 
    customer_segment,
    COUNT(cust_id) AS customer_count,
    SUM(total_revenue) AS total_revenue
FROM CustomerScored
GROUP BY customer_segment
ORDER BY customer_segment


-- 9 - Customer Behavior Analysis Using Cohort Analysis

-- Tao cot first vào dataset 
ALTER TABLE online_retail
ADD first_order DATE

-- doi kieu du lieu date cho cot year_month 
UPDATE [dbo].[online_retail]
SET year_month =
    DATEFROMPARTS(
        LEFT(year_month,4),    -- year 
		RIGHT(year_month,2),   -- month 
        1                      -- day cố định là 1
    )

--- update firt_order vào

UPDATE o
SET first_order = x.first_order
FROM [dbo].[online_retail] o 
JOIN (
    SELECT 
        cust_id,
        MIN(year_month) AS first_order
    FROM [dbo].[online_retail] 
    GROUP BY cust_id
) x
ON o.cust_id = x.cust_id;

---- Customer Behavior Analysis Using Cohort Analysis

DECLARE @cols NVARCHAR(MAX);
DECLARE @sql NVARCHAR(MAX);

-- Lấy toàn bộ cohort_index có trong dữ liệu (đảm bảo đúng thứ tự)
SELECT @cols = STRING_AGG(QUOTENAME(cohort_index), ',')
               WITHIN GROUP (ORDER BY cohort_index)
FROM (
    SELECT DISTINCT 
        DATEDIFF(MONTH,
                 first_order,
                 year_month
        ) AS cohort_index
    FROM [dbo].[online_retail]
) x;


SET @sql = '
WITH Cohort_Data AS
(
    SELECT 
        cust_id,
        first_order,
        DATEDIFF(MONTH,
                 first_order,
                 year_month
        ) AS cohort_index
    FROM [dbo].[online_retail]
),

Cohort_Count AS
(
    SELECT 
        first_order,
        cohort_index,
        COUNT(DISTINCT cust_id) AS total_customers
    FROM Cohort_Data
    GROUP BY first_order, cohort_index
),

Cohort_Size AS
(
    SELECT 
        first_order,
        total_customers AS cohort_size
    FROM Cohort_Count
    WHERE cohort_index = 0 
),

Retention_Data AS
(
    SELECT 
        c.first_order,
        c.cohort_index,
        CAST(
            c.total_customers * 100.0 / s.cohort_size
        AS DECIMAL(5,1)) AS retention_pct
    FROM Cohort_Count c
    JOIN Cohort_Size s
        ON c.first_order = s.first_order
)

SELECT *
FROM Retention_Data
PIVOT
(
    MAX(retention_pct)
    FOR cohort_index IN (' + @cols + ')
) p
ORDER BY first_order;
'

EXEC sp_executesql @sql



--10: ABC Analysis 

WITH ProductRevenue AS
(
    SELECT 
        description,
        SUM(quantity) AS total_quantity,
        SUM(amount) AS total_revenue
    FROM [dbo].[online_retail]
    GROUP BY description
),
ABC_Base AS
(
    SELECT *,
        -- % revenue từng sản phẩm
        total_revenue * 100 
            / SUM(total_revenue) OVER() AS revenue_pct,

        -- cumulative revenue %
        SUM(total_revenue) OVER(
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) * 100
            / SUM(total_revenue) OVER() AS cumulative_pct
    FROM ProductRevenue
)

SELECT 
    ABC_group,
    COUNT(*) AS total_product,
    ROUND(SUM(total_revenue),2) AS total_revenue,
    ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER(),2) AS product_pct,
    ROUND(SUM(total_revenue) * 100 / SUM(SUM(total_revenue)) OVER(),2) AS revenue_pct
FROM
(
    SELECT *,
        CASE 
            WHEN cumulative_pct > 95 THEN 'C'
            WHEN cumulative_pct > 80 THEN 'B'
            ELSE 'A'
        END AS ABC_group
    FROM ABC_Base
) t
GROUP BY ABC_group
ORDER BY ABC_group





