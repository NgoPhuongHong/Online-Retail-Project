

ALTER TABLE [dbo].[cust] ALTER COLUMN invoice_num int;
ALTER TABLE [dbo].[cust] ALTER COLUMN stock_code int;
ALTER TABLE [dbo].[cust] ALTER COLUMN quantity int;
ALTER TABLE [dbo].[cust] ALTER COLUMN invoice_date datetime;
ALTER TABLE [dbo].[cust] ALTER COLUMN unit_price float;
ALTER TABLE [dbo].[cust] ALTER COLUMN cust_id int;
ALTER TABLE [dbo].[cust] ALTER COLUMN amount float;
ALTER TABLE [dbo].[cust] ALTER COLUMN day int;
ALTER TABLE [dbo].[cust] ALTER COLUMN month int;
ALTER TABLE [dbo].[cust] ALTER COLUMN hour int;

-- 1. How many monthly active user (MAU) each month?

SELECT c.year_month,
	COUNT (distinct c.cust_id) monthly_active_users
FROM [dbo].[cust] AS c
GROUP BY c.year_month
ORDER BY c.year_month 

--2. How are the number of orders and total order amount each month?
SELECT c.year_month,
	COUNT(distinct c.invoice_num) Total_order, 
	ROUND(SUM(c.amount),2) Total_amount
FROM [dbo].[cust] AS c
GROUP BY c.year_month
ORDER BY c.year_month 

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
    FROM [dbo].[cust]
    --WHERE cust_id IS NOT NULL
) AS Hours;

-- pivot 
SET @result = '
SELECT week_days, ' + @columns + '
FROM (
    SELECT week_days, hour, COUNT(DISTINCT cust_id) AS CUST
    FROM [dbo].[cust]
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
	SUM(amount) AS Total_Amount
FROM [dbo].[cust]
GROUP BY country
ORDER BY Total_Amount DESC


---5 Countries with most AOV - Average Order Value:--
--------AOV = [Tổng giá trị đơn hàng]/[Số lượng đơn hàng]


SELECT TOP 10 country,
	SUM(amount)/(count(distinct invoice_num)) AS AOV
FROM [dbo].[cust] 
GROUP BY country
ORDER BY AOV DESC


---6 How many new and old customers do you have each month?



----
WITH FirstMonth AS (
    SELECT 
        cust_id, 
        MIN(year_month) AS first_month
    FROM [dbo].[cust]
    GROUP BY cust_id
),
CustomerWithType AS (
    SELECT 
        c.year_month,
        c.cust_id,
        CASE 
            WHEN c.year_month = f.first_month THEN 'New'
            ELSE 'Old'
        END AS Type_cust
    FROM [dbo].[cust] c
    JOIN FirstMonth f ON c.cust_id = f.cust_id
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
    FROM [dbo].[cust]
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
        c.year_month,
        c.cust_id,
        SUM(c.amount) AS total_amount
    FROM [dbo].[cust] c
    JOIN NewCustomers201012 nc ON c.cust_id = nc.cust_id
    GROUP BY c.year_month, c.cust_id
)

-- Tính trung bình total_amount theo từng tháng
SELECT 
    year_month,
    ROUND(AVG(total_amount), 6) AS avg_total_amount
FROM CustomerMonthlyAmount
GROUP BY year_month
ORDER BY year_month;



---8. **Customer Segmentation:**

-- frequency: số lần KH mua hàng trong 1 khoảng thời gian


DECLARE @max_invoice_date DATE = (SELECT MAX(invoice_date) FROM [dbo].[cust]);
WITH CustomerStats AS (
    SELECT 
        cust_id,
        MAX(invoice_date) AS last_invoice_date,
        SUM(amount) AS total_revenue,
        COUNT(DISTINCT invoice_num) AS frequency
    FROM [dbo].[cust]
    GROUP BY cust_id
),
table2 as(
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
FROM table2
GROUP BY customer_segment
ORDER BY customer_segment

       
  








