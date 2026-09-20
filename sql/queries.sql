-- ==============================================================================
-- OLIST E-COMMERCE PERFORMANCE & LOGISTICS ANALYSIS
-- Author: Andrés Aiffil
-- Environment / Engine: DB Browser for SQLite
-- Description: Core analytical queries used for data extraction, cohort 
--              analysis, Pareto classifications, CSAT SLAs, and geospatial mapping.
-- ==============================================================================

-- ==============================================================================
-- 1. GMV, AOV, PAYMENT METHODS & CUMULATIVE LTV THROUGH TIME
-- ==============================================================================
WITH GMV_AOV AS (
	SELECT 
		strftime('%Y-%m-01', orders.order_purchase_timestamp) AS Year_Month,
		SUM(order_items.price) AS Total_Amount_Products,
		SUM(order_items.price + order_items.freight_value) AS Total_Income_Per_Order,
		SUM(order_items.price + order_items.freight_value) / COUNT(DISTINCT order_items.order_id) AS Average_Order_Price_AOV,
		COUNT(DISTINCT customers.customer_unique_id) AS Monthly_Customers,
		COUNT(DISTINCT order_items.seller_id) AS Monthly_Sellers
	FROM order_items
	JOIN orders
		ON order_items.order_id = orders.order_id
	JOIN customers
		ON orders.customer_id = customers.customer_id
	WHERE orders.order_status NOT IN ('canceled','created','processing','unavailable')
	GROUP BY Year_Month
	ORDER BY Year_Month ASC
),

NET_INCOME AS (
	SELECT
		strftime('%Y-%m-01', orders.order_purchase_timestamp) AS Year_Month,
		SUM(order_payments.payment_value) AS Net_Income,
		-- Income by Payment Type
		SUM(CASE WHEN order_payments.payment_type = 'credit_card' THEN order_payments.payment_value ELSE 0 END) AS Credit_Card_Payments,
		SUM(CASE WHEN order_payments.payment_type = 'boleto' THEN order_payments.payment_value ELSE 0 END) AS Boleto_Payments,
		SUM(CASE WHEN order_payments.payment_type = 'debit_card' THEN order_payments.payment_value ELSE 0 END) AS Debit_Card_Payments,
		SUM(CASE WHEN order_payments.payment_type = 'not_defined' THEN order_payments.payment_value ELSE 0 END) AS Not_Defined_Method_Payments,
		SUM(CASE WHEN order_payments.payment_type = 'voucher' THEN order_payments.payment_value ELSE 0 END) AS Voucher_Payments,
		-- Credit Installments Breakdown (1 to 24)
		SUM(CASE WHEN order_payments.payment_installments = 1 AND order_payments.payment_type = 'credit_card' THEN order_payments.payment_value ELSE 0 END) AS Installments_Payment_1,
		SUM(CASE WHEN order_payments.payment_installments = 2 AND order_payments.payment_type = 'credit_card' THEN order_payments.payment_value ELSE 0 END) AS Installments_Payment_2,
		SUM(CASE WHEN order_payments.payment_installments = 3 AND order_payments.payment_type = 'credit_card' THEN order_payments.payment_value ELSE 0 END) AS Installments_Payment_3,
		SUM(CASE WHEN order_payments.payment_installments = 4 AND order_payments.payment_type = 'credit_card' THEN order_payments.payment_value ELSE 0 END) AS Installments_Payment_4,
		SUM(CASE WHEN order_payments.payment_installments = 5 AND order_payments.payment_type = 'credit_card' THEN order_payments.payment_value ELSE 0 END) AS Installments_Payment_5,
		SUM(CASE WHEN order_payments.payment_installments = 6 AND order_payments.payment_type = 'credit_card' THEN order_payments.payment_value ELSE 0 END) AS Installments_Payment_6,
		SUM(CASE WHEN order_payments.payment_installments = 7 AND order_payments.payment_type = 'credit_card' THEN order_payments.payment_value ELSE 0 END) AS Installments_Payment_7,
		SUM(CASE WHEN order_payments.payment_installments = 8 AND order_payments.payment_type = 'credit_card' THEN order_payments.payment_value ELSE 0 END) AS Installments_Payment_8,
		SUM(CASE WHEN order_payments.payment_installments = 9 AND order_payments.payment_type = 'credit_card' THEN order_payments.payment_value ELSE 0 END) AS Installments_Payment_9,
		SUM(CASE WHEN order_payments.payment_installments = 10 AND order_payments.payment_type = 'credit_card' THEN order_payments.payment_value ELSE 0 END) AS Installments_Payment_10,
		SUM(CASE WHEN order_payments.payment_installments = 11 AND order_payments.payment_type = 'credit_card' THEN order_payments.payment_value ELSE 0 END) AS Installments_Payment_11,
		SUM(CASE WHEN order_payments.payment_installments = 12 AND order_payments.payment_type = 'credit_card' THEN order_payments.payment_value ELSE 0 END) AS Installments_Payment_12,
		SUM(CASE WHEN order_payments.payment_installments = 13 AND order_payments.payment_type = 'credit_card' THEN order_payments.payment_value ELSE 0 END) AS Installments_Payment_13,
		SUM(CASE WHEN order_payments.payment_installments = 14 AND order_payments.payment_type = 'credit_card' THEN order_payments.payment_value ELSE 0 END) AS Installments_Payment_14,
		SUM(CASE WHEN order_payments.payment_installments = 15 AND order_payments.payment_type = 'credit_card' THEN order_payments.payment_value ELSE 0 END) AS Installments_Payment_15,
		SUM(CASE WHEN order_payments.payment_installments = 16 AND order_payments.payment_type = 'credit_card' THEN order_payments.payment_value ELSE 0 END) AS Installments_Payment_16,
		SUM(CASE WHEN order_payments.payment_installments = 17 AND order_payments.payment_type = 'credit_card' THEN order_payments.payment_value ELSE 0 END) AS Installments_Payment_17,
		SUM(CASE WHEN order_payments.payment_installments = 18 AND order_payments.payment_type = 'credit_card' THEN order_payments.payment_value ELSE 0 END) AS Installments_Payment_18,
		SUM(CASE WHEN order_payments.payment_installments = 19 AND order_payments.payment_type = 'credit_card' THEN order_payments.payment_value ELSE 0 END) AS Installments_Payment_19,
		SUM(CASE WHEN order_payments.payment_installments = 20 AND order_payments.payment_type = 'credit_card' THEN order_payments.payment_value ELSE 0 END) AS Installments_Payment_20,
		SUM(CASE WHEN order_payments.payment_installments = 21 AND order_payments.payment_type = 'credit_card' THEN order_payments.payment_value ELSE 0 END) AS Installments_Payment_21,
		SUM(CASE WHEN order_payments.payment_installments = 22 AND order_payments.payment_type = 'credit_card' THEN order_payments.payment_value ELSE 0 END) AS Installments_Payment_22,
		SUM(CASE WHEN order_payments.payment_installments = 23 AND order_payments.payment_type = 'credit_card' THEN order_payments.payment_value ELSE 0 END) AS Installments_Payment_23,
		SUM(CASE WHEN order_payments.payment_installments = 24 AND order_payments.payment_type = 'credit_card' THEN order_payments.payment_value ELSE 0 END) AS Installments_Payment_24
	FROM order_payments
	JOIN orders
		ON order_payments.order_id = orders.order_id
	WHERE orders.order_status NOT IN ('canceled','created','processing','unavailable')
	GROUP BY Year_Month
	ORDER BY Year_Month ASC
),

FIRST_CUSTOMER_PURCHASE AS (
	SELECT
		Buy_Date AS Year_Month,
		COUNT(Unique_ID) AS Sum_Of_New_Customer
	FROM (
		SELECT
			strftime('%Y-%m-01', MIN(orders.order_purchase_timestamp)) AS Buy_Date,
			customers.customer_unique_id AS Unique_ID
		FROM order_items
		JOIN orders ON order_items.order_id = orders.order_id
		JOIN customers ON orders.customer_id = customers.customer_id
		WHERE orders.order_status NOT IN ('canceled','created','processing','unavailable')
		GROUP BY customers.customer_unique_id
	)
	GROUP BY Year_Month
	ORDER BY Year_Month ASC
),

FIRST_SELLER_ORDER AS (
	SELECT
		Buy_Date AS Year_Month,
		COUNT(Seller_ID) AS Sum_Of_New_Seller
	FROM (
		SELECT
			strftime('%Y-%m-01', MIN(orders.order_purchase_timestamp)) AS Buy_Date,
			order_items.seller_id AS Seller_ID
		FROM order_items
		JOIN orders ON order_items.order_id = orders.order_id
		WHERE orders.order_status NOT IN ('canceled','created','processing','unavailable')
		GROUP BY order_items.seller_id
	)
	GROUP BY Year_Month
	ORDER BY Year_Month ASC
),

EXCHANGE_RATES AS (
    SELECT '2016-09-01' AS Year_Month, 3.26 AS Usd_Rate UNION ALL
    SELECT '2016-10-01', 3.18 UNION ALL
    SELECT '2016-11-01', 3.34 UNION ALL
    SELECT '2016-12-01', 3.35 UNION ALL
    SELECT '2017-01-01', 3.20 UNION ALL
    SELECT '2017-02-01', 3.10 UNION ALL
    SELECT '2017-03-01', 3.13 UNION ALL
    SELECT '2017-04-01', 3.13 UNION ALL
    SELECT '2017-05-01', 3.26 UNION ALL
    SELECT '2017-06-01', 3.30 UNION ALL
    SELECT '2017-07-01', 3.21 UNION ALL
    SELECT '2017-08-01', 3.15 UNION ALL
    SELECT '2017-09-01', 3.13 UNION ALL
    SELECT '2017-10-01', 3.19 UNION ALL
    SELECT '2017-11-01', 3.26 UNION ALL
    SELECT '2017-12-01', 3.29 UNION ALL
    SELECT '2018-01-01', 3.21 UNION ALL
    SELECT '2018-02-01', 3.24 UNION ALL
    SELECT '2018-03-01', 3.28 UNION ALL
    SELECT '2018-04-01', 3.41 UNION ALL
    SELECT '2018-05-01', 3.63 UNION ALL
    SELECT '2018-06-01', 3.77 UNION ALL
    SELECT '2018-07-01', 3.83 UNION ALL
    SELECT '2018-08-01', 3.93 UNION ALL
    SELECT '2018-09-01', 4.12 UNION ALL
    SELECT '2018-10-01', 3.76
)

SELECT 
	GMV_AOV.Total_Income_Per_Order AS GMV_THROUGH_TIME,
	GMV_AOV.Total_Amount_Products AS GMV_THROUGH_TIME_No_Freight,
	GMV_AOV.Average_Order_Price_AOV AS AOV_THROUGH_TIME,
	EXCHANGE_RATES.Usd_Rate AS USD_RATES,
	NET_INCOME.Net_Income AS NET_INCOME,
	NET_INCOME.Credit_Card_Payments AS CREDIT_CARD,
	NET_INCOME.Boleto_Payments AS BOLETO,
	NET_INCOME.Debit_Card_Payments AS DEBIT_CARD,
	NET_INCOME.Not_Defined_Method_Payments AS NOT_DEFINED,
	NET_INCOME.Voucher_Payments AS VOUCHER,
	NET_INCOME.Installments_Payment_1 AS PAYMENTS_1,
	NET_INCOME.Installments_Payment_2 AS PAYMENTS_2,
	NET_INCOME.Installments_Payment_3 AS PAYMENTS_3,
	NET_INCOME.Installments_Payment_4 AS PAYMENTS_4,
	NET_INCOME.Installments_Payment_5 AS PAYMENTS_5,
	NET_INCOME.Installments_Payment_6 AS PAYMENTS_6,
	NET_INCOME.Installments_Payment_7 AS PAYMENTS_7,
	NET_INCOME.Installments_Payment_8 AS PAYMENTS_8,
	NET_INCOME.Installments_Payment_9 AS PAYMENTS_9,
	NET_INCOME.Installments_Payment_10 AS PAYMENTS_10,
	NET_INCOME.Installments_Payment_11 AS PAYMENTS_11,
	NET_INCOME.Installments_Payment_12 AS PAYMENTS_12,
	NET_INCOME.Installments_Payment_13 AS PAYMENTS_13,
	NET_INCOME.Installments_Payment_14 AS PAYMENTS_14,
	NET_INCOME.Installments_Payment_15 AS PAYMENTS_15,
	NET_INCOME.Installments_Payment_16 AS PAYMENTS_16,
	NET_INCOME.Installments_Payment_17 AS PAYMENTS_17,
	NET_INCOME.Installments_Payment_18 AS PAYMENTS_18,
	NET_INCOME.Installments_Payment_19 AS PAYMENTS_19,
	NET_INCOME.Installments_Payment_20 AS PAYMENTS_20,
	NET_INCOME.Installments_Payment_21 AS PAYMENTS_21,
	NET_INCOME.Installments_Payment_22 AS PAYMENTS_22,
	NET_INCOME.Installments_Payment_23 AS PAYMENTS_23,
	NET_INCOME.Installments_Payment_24 AS PAYMENTS_24,
	strftime('%Y-%m-01', FIRST_CUSTOMER_PURCHASE.Year_Month) AS Year_Month_Final,
	SUM(SUM(GMV_AOV.Total_Amount_Products)) OVER (ORDER BY GMV_AOV.Year_Month ASC) AS Revenue_Acumulado,
	SUM(SUM(FIRST_CUSTOMER_PURCHASE.Sum_Of_New_Customer)) OVER (ORDER BY FIRST_CUSTOMER_PURCHASE.Year_Month ASC) AS New_Customer_Acumulado,
	SUM(SUM(GMV_AOV.Total_Amount_Products)) OVER (ORDER BY GMV_AOV.Year_Month ASC) / SUM(SUM(FIRST_CUSTOMER_PURCHASE.Sum_Of_New_Customer)) OVER (ORDER BY FIRST_CUSTOMER_PURCHASE.Year_Month ASC) AS Customer_LTV_Through_Time,
	SUM(SUM(FIRST_SELLER_ORDER.Sum_Of_New_Seller)) OVER (ORDER BY FIRST_SELLER_ORDER.Year_Month ASC) AS New_Sellers_Acumulado,
	SUM(SUM(GMV_AOV.Total_Amount_Products)) OVER (ORDER BY GMV_AOV.Year_Month ASC) / SUM(SUM(FIRST_SELLER_ORDER.Sum_Of_New_Seller)) OVER (ORDER BY FIRST_SELLER_ORDER.Year_Month ASC) AS Sellers_LTV_Through_Time
FROM GMV_AOV
JOIN NET_INCOME ON GMV_AOV.Year_Month = NET_INCOME.Year_Month
JOIN FIRST_CUSTOMER_PURCHASE ON GMV_AOV.Year_Month = FIRST_CUSTOMER_PURCHASE.Year_Month
JOIN FIRST_SELLER_ORDER ON GMV_AOV.Year_Month = FIRST_SELLER_ORDER.Year_Month
JOIN EXCHANGE_RATES ON GMV_AOV.Year_Month = EXCHANGE_RATES.Year_Month
GROUP BY Year_Month_Final
ORDER BY Year_Month_Final ASC;


-- ==============================================================================
-- 2. SELLER PARETO ABC ANALYSIS (REVENUE & ORDER VOLUME)
-- ==============================================================================
WITH SELLER_SUMMARY AS (
	SELECT
		order_items.seller_id AS List_Of_Sellers,
		SUM(order_items.price) AS Income_Per_Seller,
		COUNT(DISTINCT order_items.order_id) AS Orders_Per_Seller
	FROM order_items
	JOIN orders ON order_items.order_id = orders.order_id
	WHERE orders.order_status NOT IN ('canceled','created','processing','unavailable')
	GROUP BY order_items.seller_id
),

SELLER_CUMULATIVE AS (
	SELECT
		List_Of_Sellers,
		Income_Per_Seller,
		Orders_Per_Seller,
		100.0 * (SUM(Income_Per_Seller) OVER (ORDER BY Income_Per_Seller DESC)) / (SUM(Income_Per_Seller) OVER ()) AS Running_PCT_Revenue,
		100.0 * (SUM(Orders_Per_Seller) OVER (ORDER BY Orders_Per_Seller DESC)) / (SUM(Orders_Per_Seller) OVER ()) AS Running_PCT_Orders
	FROM SELLER_SUMMARY
)

SELECT
	List_Of_Sellers,
	Income_Per_Seller,
	Orders_Per_Seller,
	CASE 
		WHEN SELLER_CUMULATIVE.Running_PCT_Revenue <= 50.0 THEN 'Class A'
		WHEN SELLER_CUMULATIVE.Running_PCT_Revenue <= 80.0 THEN 'Class B'
		ELSE 'Class C' 
	END AS Class_Revenue,
	CASE 
		WHEN SELLER_CUMULATIVE.Running_PCT_Orders <= 50.0 THEN 'Class A'
		WHEN SELLER_CUMULATIVE.Running_PCT_Orders <= 80.0 THEN 'Class B'
		ELSE 'Class C' 
	END AS Class_Orders
FROM SELLER_CUMULATIVE
ORDER BY Income_Per_Seller DESC;


-- ==============================================================================
-- 3. CSAT REVIEW SCORE DISTRIBUTION
-- ==============================================================================
SELECT
	AVG(order_reviews.review_score) AS AVG_Score,
	COUNT(CASE WHEN order_reviews.review_score = 5 THEN orders.order_id END) AS NO_5,
	COUNT(CASE WHEN order_reviews.review_score = 4 THEN orders.order_id END) AS NO_4,
	COUNT(CASE WHEN order_reviews.review_score = 3 THEN orders.order_id END) AS NO_3,
	COUNT(CASE WHEN order_reviews.review_score = 2 THEN orders.order_id END) AS NO_2,
	COUNT(CASE WHEN order_reviews.review_score = 1 THEN orders.order_id END) AS NO_1,
	COUNT(orders.order_id) AS Total_Orders
FROM orders
JOIN order_reviews ON orders.order_id = order_reviews.order_id
WHERE orders.order_status NOT IN ('canceled','created','processing','unavailable');


-- ==============================================================================
-- 4. LOGISTICS SLA & DELAY BREAKDOWN BY CSAT SCORE
-- ==============================================================================
WITH DETAIL AS (
	SELECT 
		order_reviews.review_score AS Score,
		orders.order_id AS CodeOrders,
		ROUND(julianday(orders.order_delivered_customer_date) - julianday(orders.order_estimated_delivery_date), 2) AS Delay_On_Delivery_Time,
		ROUND(julianday(orders.order_delivered_customer_date) - julianday(orders.order_purchase_timestamp), 2) AS Delivery_Time,
		ROUND(julianday(orders.order_delivered_carrier_date) - julianday(orders.order_purchase_timestamp), 2) AS Seller_To_Carrier_Time,
		ROUND(julianday(orders.order_delivered_customer_date) - julianday(orders.order_delivered_carrier_date), 2) AS Carrier_To_Customer_Time
	FROM orders
	JOIN order_reviews ON orders.order_id = order_reviews.order_id
	WHERE orders.order_status = 'delivered'
		AND orders.order_delivered_carrier_date IS NOT NULL
		AND orders.order_delivered_customer_date IS NOT NULL
	GROUP BY orders.order_id
),

AVERAGE AS (
	SELECT
		DETAIL.Score AS Score,
		COUNT(DISTINCT DETAIL.CodeOrders) AS Qty_Of_Orders,
		AVG(DETAIL.Delay_On_Delivery_Time) AS AVG_Delay,
		AVG(DETAIL.Delivery_Time) AS AVG_Delivery_Time,
		AVG(DETAIL.Seller_To_Carrier_Time) AS AVG_Seller_To_Carrier_Time,
		AVG(DETAIL.Carrier_To_Customer_Time) AS AVG_Carrier_To_Customer
	FROM DETAIL
	GROUP BY DETAIL.Score
)

SELECT
	DETAIL.Score,
	AVERAGE.Qty_Of_Orders,
	ROUND(100.00 * SUM(CASE WHEN DETAIL.Delay_On_Delivery_Time > AVERAGE.AVG_Delay THEN 1 ELSE 0 END) / AVERAGE.Qty_Of_Orders, 2) AS Orders_Delay_Above_AVG,
	AVERAGE.AVG_Delay,
	ROUND(100.00 * SUM(CASE WHEN DETAIL.Delivery_Time > AVERAGE.AVG_Delivery_Time THEN 1 ELSE 0 END) / AVERAGE.Qty_Of_Orders, 2) AS Orders_Delivery_Time_Above_AVG,
	AVERAGE.AVG_Delivery_Time,
	ROUND(100.00 * SUM(CASE WHEN DETAIL.Seller_To_Carrier_Time > AVERAGE.AVG_Seller_To_Carrier_Time THEN 1 ELSE 0 END) / AVERAGE.Qty_Of_Orders, 2) AS Orders_Seller_To_Carrier_Time_Above_AVG,
	AVERAGE.AVG_Seller_To_Carrier_Time,
	ROUND(100.00 * SUM(CASE WHEN DETAIL.Carrier_To_Customer_Time > AVERAGE.AVG_Carrier_To_Customer THEN 1 ELSE 0 END) / AVERAGE.Qty_Of_Orders, 2) AS Orders_Carrier_To_Customer_Time_Above_AVG,	
	AVERAGE.AVG_Carrier_To_Customer
FROM DETAIL
JOIN AVERAGE ON DETAIL.Score = AVERAGE.Score
GROUP BY DETAIL.Score
ORDER BY DETAIL.Score DESC;


-- ==============================================================================
-- 5. LOGISTICS ROUTE PARETO ABC ANALYSIS (ORIGIN TO DESTINATION)
-- ==============================================================================
WITH ROUTE_TOTALS AS (
	SELECT
		sellers.seller_state || ' -> ' || customers.customer_state AS Route,
		sellers.seller_state AS Seller_State,
		customers.customer_state AS Customer_State,
		COUNT(DISTINCT orders.order_id) AS Orders_Per_Route,
		SUM(order_items.price) AS GMV_Per_Route,
		ROUND(AVG(order_reviews.review_score), 2) AS AVG_Score,
		ROUND(AVG(julianday(orders.order_delivered_customer_date) - julianday(orders.order_delivered_carrier_date)), 2) AS Carrier_To_Customer_Days_AVG,
		COUNT(DISTINCT CASE WHEN order_reviews.review_score = 5 THEN orders.order_id END) AS Score_5,
		COUNT(DISTINCT CASE WHEN order_reviews.review_score = 4 THEN orders.order_id END) AS Score_4,
		COUNT(DISTINCT CASE WHEN order_reviews.review_score = 3 THEN orders.order_id END) AS Score_3,
		COUNT(DISTINCT CASE WHEN order_reviews.review_score = 2 THEN orders.order_id END) AS Score_2,
		COUNT(DISTINCT CASE WHEN order_reviews.review_score = 1 THEN orders.order_id END) AS Score_1
	FROM order_items
	LEFT JOIN orders ON order_items.order_id = orders.order_id
	LEFT JOIN customers ON orders.customer_id = customers.customer_id
	LEFT JOIN sellers ON order_items.seller_id = sellers.seller_id
	LEFT JOIN order_reviews ON orders.order_id = order_reviews.order_id
	WHERE orders.order_status = 'delivered'
	GROUP BY Route
	ORDER BY GMV_Per_Route DESC
),

ROUTE_CUMULATIVE AS (
	SELECT
		ROUTE_TOTALS.Route AS Route,
		100.0 * SUM(ROUTE_TOTALS.GMV_Per_Route) OVER (ORDER BY ROUTE_TOTALS.GMV_Per_Route DESC) / (SUM(ROUTE_TOTALS.GMV_Per_Route) OVER ()) AS PCT_Running_GMV_Per_Route
	FROM ROUTE_TOTALS
	GROUP BY ROUTE_TOTALS.Route
)

SELECT
	ROUTE_TOTALS.Route,
	ROUTE_TOTALS.Seller_State,
	ROUTE_TOTALS.Customer_State,
	ROUTE_TOTALS.GMV_Per_Route,
	ROUTE_TOTALS.AVG_Score,
	ROUTE_TOTALS.Carrier_To_Customer_Days_AVG,
	ROUTE_TOTALS.Score_5,
	ROUTE_TOTALS.Score_4,
	ROUTE_TOTALS.Score_3,
	ROUTE_TOTALS.Score_2,
	ROUTE_TOTALS.Score_1,
	CASE 
		WHEN ROUTE_CUMULATIVE.PCT_Running_GMV_Per_Route <= 80.0 THEN 'CLASS A'
		WHEN ROUTE_CUMULATIVE.PCT_Running_GMV_Per_Route <= 95.0 THEN 'CLASS B'
		ELSE 'CLASS C'
	END AS Pareto_Class
FROM ROUTE_TOTALS
JOIN ROUTE_CUMULATIVE ON ROUTE_TOTALS.Route = ROUTE_CUMULATIVE.Route
GROUP BY ROUTE_TOTALS.Route
ORDER BY ROUTE_TOTALS.GMV_Per_Route DESC;


-- ==============================================================================
-- 6. GEOSPATIAL HEATMAP BY ZIP CODE (SELLER VS CUSTOMER GMV DENSITY)
-- ==============================================================================
WITH GEO_CLEAN AS (
	SELECT
		geolocation.geolocation_zip_code_prefix AS Zip_Code,
		AVG(geolocation.geolocation_lat) AS Latitude,
		AVG(geolocation.geolocation_lng) AS Longitude
	FROM geolocation
	GROUP BY Zip_Code
),

SELLER_GMV AS (
	SELECT
		sellers.seller_zip_code_prefix AS Zip_Code,
		SUM(order_items.price) AS GMV
	FROM order_items
	JOIN sellers ON order_items.seller_id = sellers.seller_id
	JOIN orders ON order_items.order_id = orders.order_id
	WHERE orders.order_status NOT IN ('canceled','created','processing','unavailable')
	GROUP BY Zip_Code
),

CUSTOMER_GMV AS (
	SELECT 
		customers.customer_zip_code_prefix AS Zip_Code,
		SUM(order_items.price) AS GMV
	FROM order_items
	JOIN orders ON order_items.order_id = orders.order_id
	JOIN customers ON orders.customer_id = customers.customer_id
	WHERE orders.order_status NOT IN ('canceled','created','processing','unavailable')
	GROUP BY Zip_Code
)

SELECT
	SELLER_GMV.Zip_Code AS Zip_Code,
	GEO_CLEAN.Latitude AS Latitude,
	GEO_CLEAN.Longitude AS Longitude,
	'Seller' AS Entity_Type,
	SELLER_GMV.GMV AS GMV
FROM SELLER_GMV
LEFT JOIN GEO_CLEAN ON SELLER_GMV.Zip_Code = GEO_CLEAN.Zip_Code

UNION ALL 

SELECT
	CUSTOMER_GMV.Zip_Code AS Zip_Code,
	GEO_CLEAN.Latitude AS Latitude,
	GEO_CLEAN.Longitude AS Longitude,
	'Customer' AS Entity_Type,
	CUSTOMER_GMV.GMV AS GMV
FROM CUSTOMER_GMV
LEFT JOIN GEO_CLEAN ON CUSTOMER_GMV.Zip_Code = GEO_CLEAN.Zip_Code
WHERE Latitude IS NOT NULL AND Longitude IS NOT NULL;


-- ==============================================================================
-- 7. GEOSPATIAL HEATMAP BY STATE (SELLER VS CUSTOMER DISTRIBUTION)
-- ==============================================================================
WITH SELLER_STATE AS (
	SELECT
		sellers.seller_state AS State,
		SUM(order_items.price) AS GMV
	FROM order_items
	LEFT JOIN sellers ON order_items.seller_id = sellers.seller_id
	LEFT JOIN orders ON order_items.order_id = orders.order_id
	WHERE orders.order_status NOT IN ('canceled','created','processing','unavailable')
	GROUP BY State
),

CUSTOMER_STATE AS (
	SELECT
		customers.customer_state AS State,
		SUM(order_items.price) AS GMV
	FROM order_items
	LEFT JOIN orders ON order_items.order_id = orders.order_id
	LEFT JOIN customers ON orders.customer_id = customers.customer_id
	WHERE orders.order_status NOT IN ('canceled','created','processing','unavailable')
	GROUP BY State
)

SELECT 
	State AS State,
	GMV AS GMV,
	'Seller' AS Entity_Type
FROM SELLER_STATE

UNION ALL

SELECT
	State AS State,
	GMV AS GMV,
	'Customer' AS Entity_Type
FROM CUSTOMER_STATE;


-- ==============================================================================
-- 8. CUSTOMER SALES DENSITY BY ZIP CODE
-- ==============================================================================
SELECT
	geo_limpia.zip_code AS Zip_Code,
	geo_limpia.latitud AS Latitude,
	geo_limpia.longitud AS Longitude,
	SUM(order_items.price) AS GMV
FROM order_items
JOIN sellers ON order_items.seller_id = sellers.seller_id
JOIN orders ON order_items.order_id = orders.order_id
JOIN customers ON orders.customer_id = customers.customer_id
JOIN (
	SELECT
		geolocation.geolocation_zip_code_prefix AS zip_code,
		AVG(geolocation.geolocation_lat) AS latitud,
		AVG(geolocation.geolocation_lng) AS longitud
	FROM geolocation
	GROUP BY geolocation.geolocation_zip_code_prefix
) AS geo_limpia ON customers.customer_zip_code_prefix = geo_limpia.zip_code
WHERE orders.order_status NOT IN ('canceled','created','processing','unavailable')
GROUP BY geo_limpia.zip_code
ORDER BY GMV DESC;


-- ==============================================================================
-- 9. PRODUCT CATEGORY PERFORMANCE & PARETO ABC ANALYSIS
-- ==============================================================================
WITH CATEGORIES AS (
	SELECT 
		SUM(order_items.price) AS GMV_Per_Category,
		COUNT(order_items.order_item_id) AS Nu_Of_Items_Per_Category,
		AVG(order_items.price) AS AVG_Ticket,
		product_category_name_translation.product_category_name_english AS Categories
	FROM order_items 
	LEFT JOIN products ON order_items.product_id = products.product_id
	LEFT JOIN orders ON order_items.order_id = orders.order_id
	LEFT JOIN product_category_name_translation ON products.product_category_name = product_category_name_translation.product_category_name
	WHERE orders.order_status NOT IN ('canceled','created','processing','unavailable')
	GROUP BY products.product_category_name
	ORDER BY GMV_per_CATEGORY DESC
),

CATEGORIES_CUMULATIVE AS (
	SELECT
		CATEGORIES.Categories AS Categories,
		100.0 * SUM(CATEGORIES.GMV_Per_Category) OVER (ORDER BY CATEGORIES.GMV_Per_Category DESC) / (SUM(CATEGORIES.GMV_Per_Category) OVER ()) AS PCT_Running_GMV_Per_Category
	FROM CATEGORIES
	GROUP BY CATEGORIES.Categories
)

SELECT
	CATEGORIES.Categories AS Category,
	CATEGORIES.GMV_Per_Category AS GMV,
	CASE
		WHEN CATEGORIES_CUMULATIVE.PCT_Running_GMV_Per_Category <= 75.0 THEN 'Class A'
		WHEN CATEGORIES_CUMULATIVE.PCT_Running_GMV_Per_Category <= 95.0 THEN 'Class B'
		ELSE 'Class C'
	END AS Pareto_Class
FROM CATEGORIES
LEFT JOIN CATEGORIES_CUMULATIVE ON CATEGORIES.Categories = CATEGORIES_CUMULATIVE.Categories
GROUP BY Category
ORDER BY GMV DESC;
