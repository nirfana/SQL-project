-- SQL Solutions
/* no. 1
Selama transaksi yang terjadi selama 2021, 
pada bulan apa total nilai transaksi (after_discount) paling besar? 
Gunakan is_valid = 1 untuk memfilter data transaksi.
Source table: order_detail 
*/ 
SELECT
    TO_CHAR(order_date, 'Month') AS month,
    ROUND(SUM(after_discount)) AS total_sum
FROM 
    order_detail
WHERE 
    order_date BETWEEN '2021-01-01' AND '2021-12-31'
    AND is_valid = 1
GROUP BY 
    TO_CHAR(order_date, 'Month')
ORDER BY 
    total_sum DESC
	
	
	
/*no. 2
Selama transaksi yang terjadi selama 2021, 
pada bulan apa total jumlah pelanggan (unique), 
total order (unique) dan total jumlah kuantitas produk paling banyak? 
Gunakan is_valid = 1 untuk memfilter data transaksi.
Source table: order_detail
*/
SELECT
    TO_CHAR(order_date, 'Month') AS month,
    COUNT(DISTINCT customer_id) AS total_customer,
    COUNT(DISTINCT id) AS total_order,
    SUM(qty_ordered) AS total_quantity
FROM 
    order_detail
WHERE 
    order_date BETWEEN '2021-01-01' AND '2021-12-31'
    AND is_valid = 1
GROUP BY 
    month
ORDER BY 
    2 DESC, 3 DESC, 3 DESC
	
	

/* no. 3
Selama transaksi yang terjadi selama 2022, 
kategori apa yang menghasilkan nilai transaksi paling besar? 
Gunakan is_valid = 1 untuk memfilter data transaksi.
Source table: order_detail, sku_detail
*/
SELECT
    category,
    ROUND(CAST(SUM(after_discount) AS numeric), 2) AS sales
FROM
    order_detail
JOIN
    sku_detail ON order_detail.sku_id = sku_detail.id
WHERE
    order_date BETWEEN '2022-01-01' AND '2022-12-31'
    AND is_valid = 1
GROUP BY
    category
ORDER BY 
	sales DESC



/* no. 4
Bandingkan nilai transaksi dari masing-masing kategori pada tahun 2021 dengan 2022. 
Sebutkan kategori apa saja yang mengalami peningkatan 
dan kategori apa yang mengalami penurunan nilai transaksi dari tahun 2021 ke 2022. 
Gunakan is_valid = 1 untuk memfilter data transaksi.
Source table: order_detail, sku_detail
*/
SELECT
    category,
    ROUND(CAST(SUM(CASE WHEN DATE_PART('year', order_date) = 2021 THEN after_discount ELSE 0 END) AS numeric), 2) AS sales_2021,
    ROUND(CAST(SUM(CASE WHEN DATE_PART('year', order_date) = 2022 THEN after_discount ELSE 0 END) AS numeric), 2) AS sales_2022,
    ROUND(CAST(SUM(CASE WHEN DATE_PART('year', order_date) = 2022 THEN after_discount ELSE 0 END) - 
        SUM(CASE WHEN DATE_PART('year', order_date) = 2021 THEN after_discount ELSE 0 END) AS numeric), 2) AS sales_growth
FROM
    order_detail
JOIN
    sku_detail ON order_detail.sku_id = sku_detail.id
WHERE
    is_valid = 1
GROUP BY
    category
ORDER BY
    sales_growth DESC
	
	
	
/* no. 5
Tampilkan Top 10 sku_name (beserta kategorinya) berdasarkan nilai transaksi yang terjadi selama tahun 2022. 
Tampilkan juga total jumlah pelanggan (unique), total order (unique) dan total jumlah kuantitas. 
Gunakan is_valid = 1 untuk memfilter data transaksi.
Source table: order_detail, sku_detail
*/
SELECT 
	sku_name,
	category,
	ROUND(sum(after_discount)) AS sales,
	COUNT(DISTINCT customer_id) AS total_customer,
	COUNT(DISTINCT order_detail.id) AS total_order,
	SUM(qty_ordered) AS quantity
FROM 
	order_detail
JOIN 
	sku_detail ON order_detail.sku_id = sku_detail.id
WHERE
	order_date BETWEEN '2022-01-01' AND '2022-12-31'
    AND is_valid = 1
GROUP BY
	sku_name, category
ORDER BY 
	sales DESC
LIMIT 10



/* no. 6
Tampilkan top 5 metode pembayaran yang paling populer digunakan selama 2022 (berdasarkan total unique order). 
Gunakan is_valid = 1 untuk memfilter data transaksi.
Source table: order_detail, payment_method
*/
SELECT
    payment_method,
	COUNT(DISTINCT order_detail.id) AS total_order
FROM
    order_detail
JOIN
    payment_detail ON order_detail.payment_id = payment_detail.id
WHERE
	order_date BETWEEN '2022-01-01' AND '2022-12-31'
    AND order_detail.is_valid = 1
GROUP BY
    payment_method
ORDER BY 
	total_order DESC
LIMIT 5



/*no. 7
Urutkan dari ke-5 produk ini berdasarkan nilai transaksinya. 
Samsung
Apple
Sony
Huawei
Lenovo
Gunakan is_valid = 1 untuk memfilter data transaksi.
Source table: order_detail, sku_detail
*/
SELECT 
	CASE
        WHEN LOWER(sku_detail.sku_name) LIKE '%samsung%' THEN 'Samsung'
        WHEN LOWER(sku_detail.sku_name) LIKE '%apple%' OR LOWER(sku_detail.sku_name) LIKE '%iphone%' OR LOWER(sku_detail.sku_name) LIKE '%ipad%' OR LOWER(sku_detail.sku_name) LIKE '%macbook%' THEN 'Apple'
        WHEN LOWER(sku_detail.sku_name) LIKE '%sony%' THEN 'Sony'
        WHEN LOWER(sku_detail.sku_name) LIKE '%huawei%' THEN 'Huawei'
        WHEN LOWER(sku_detail.sku_name) LIKE '%lenovo%' THEN 'Lenovo'
    END AS product_name,
	ROUND(SUM(after_discount)) AS sales
FROM
    order_detail
JOIN 
	sku_detail ON order_detail.sku_id = sku_detail.id
WHERE 
	(LOWER(sku_detail.sku_name) LIKE '%samsung%'
    OR LOWER(sku_detail.sku_name) LIKE '%apple%' OR LOWER(sku_detail.sku_name) LIKE '%iphone%' OR LOWER(sku_detail.sku_name) LIKE '%ipad%' OR LOWER(sku_detail.sku_name) LIKE '%macbook%'
    OR LOWER(sku_detail.sku_name) LIKE '%sony%'
    OR LOWER(sku_detail.sku_name) LIKE '%huawei%'
    OR LOWER(sku_detail.sku_name) LIKE '%lenovo%')
	AND is_valid = 1
	AND category = 'Mobiles & Tablets'
GROUP BY product_name
ORDER BY sales DESC



/*no. 8
Seperti pertanyaan no. 3, 
buatlah perbandingan dari nilai profit tahun 2021 dan 2022 pada tiap kategori. 
Kemudian buatlah selisih % perbedaan profit antara 2021 dengan 2022 (profit = after_discount - (cogs*qty_ordered))
Gunakan is_valid = 1 untuk memfilter data transaksi.
Source table: order_detail, sku_detail
*/
SELECT
    category,
    SUM(CASE WHEN DATE_PART('year', order_date) = 2021 THEN (after_discount - (cogs * qty_ordered))ELSE 0 END) AS profit_2021,
	SUM(CASE WHEN DATE_PART('year', order_date) = 2022 THEN (after_discount - (cogs * qty_ordered)) ELSE 0 END) AS profit_2022,
	ROUND(CAST(((SUM(CASE WHEN DATE_PART('year', order_date) = 2022 THEN (after_discount - (cogs * qty_ordered)) ELSE 0 END) - 
		SUM(CASE WHEN DATE_PART('year', order_date) = 2021 THEN (after_discount - (cogs * qty_ordered)) ELSE 0 END)) /
		SUM(CASE WHEN DATE_PART('year', order_date) = 2021 THEN (after_discount - (cogs * qty_ordered)) ELSE 0 END)) * 100 AS numeric), 2) AS growth_percentage
FROM
    order_detail
JOIN
    sku_detail ON order_detail.sku_id = sku_detail.id
WHERE
    is_valid = 1
GROUP BY
    category
ORDER BY
    growth_percentage DESC
	


/* no. 9
Tampilkan top 5 SKU dengan kontribusi profit paling tinggi di tahun 2022 
berdasarkan kategori paling besar pertumbuhan profit dari 2021 ke 2022 (berdasarkan hasil no 8).
Gunakan is_valid = 1 untuk memfilter data transaksi.
Source table: order_detail, sku_detail
*/
WITH 
top_category 
	AS (SELECT
			order_detail.id,
			sku_detail.category,
			sku_detail.sku_name,
			order_detail.after_discount - (sku_detail.cogs * order_detail.qty_ordered) AS profit
		FROM order_detail 
		JOIN sku_detail ON sku_detail.id = order_detail.sku_id
		WHERE is_valid = 1
		AND order_detail.order_date BETWEEN '2022-01-01' AND '2022-12-31'
		AND sku_detail.category = 'Women Fashion'
	   )
SELECT 
top_category.category,
top_category.sku_name,
SUM(top_category.profit) AS total_profit
FROM top_category
GROUP BY 1, 2
ORDER BY total_profit desc
LIMIT 5



/* no 10
Tampilkan jumlah unique order yang menggunakan top 5 metode pembayaran (soal no 6) berdasarkan kategori produk selama tahun 2022.
Gunakan is_valid = 1 untuk memfilter data transaksi.
Source table: order_detail, sku_detail
*/
SELECT
    sku_detail.category,
	COUNT(DISTINCT CASE WHEN  payment_detail.payment_method = 'cod' THEN order_detail.id END) cod,
	COUNT(DISTINCT CASE WHEN  payment_detail.payment_method = 'Easypay' THEN order_detail.id END) easypay,
	COUNT(DISTINCT CASE WHEN  payment_detail.payment_method = 'Payaxis' THEN order_detail.id END) payaxis,
	COUNT(DISTINCT CASE WHEN  payment_detail.payment_method = 'customercredit' THEN order_detail.id END) customercredit,
	COUNT(DISTINCT CASE WHEN  payment_detail.payment_method = 'jazzwallet' THEN order_detail.id END) jazzwallet
FROM order_detail
JOIN payment_detail ON payment_detail.id = order_detail.payment_id
JOIN sku_detail ON sku_detail.id = order_detail.sku_id
WHERE 
	is_valid = 1
	AND order_detail.order_date BETWEEN '2022-01-01' AND '2022-12-31'
GROUP BY 1
ORDER BY 2 DESC, 3 DESC, 4 DESC, 5 DESC, 6 DESC

