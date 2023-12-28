-- selecting the database we want to work with
USE mintclassics;


SELECT *
FROM warehouses;

SELECT COUNT(*)
FROM products;

-- queries product name per unique product code
SELECT 
	DISTINCT(productCode), 
	productName
FROM products;

-- check how much product that the company sells
SELECT 
	COUNT(DISTINCT(productCode)) 
FROM products;

-- check if there are products that stored in multiple warehouse
SELECT 
	productCode, 
	COUNT(warehouseCode) AS warehouse
FROM products
GROUP BY productCode
HAVING COUNT(warehouseCode) > 1;

-- check for total product stock on each warehouse
SELECT
	w.warehouseName,
    SUM(p.quantityInStock) AS total_stock
FROM products AS p 
JOIN warehouses AS w ON p.warehouseCode = w.warehouseCode
GROUP BY w.warehouseName;

-- identify unique product count and their total stock on each warehouse 
SELECT 
	p.warehouseCode,
	w.warehouseName,
	COUNT(productCode) AS total_product, 
	SUM(p.quantityInStock) AS total_stock
FROM products AS p 
JOIN warehouses AS w ON p.warehouseCode = w.warehouseCode
GROUP BY w.warehouseCode, p.warehouseName;

SELECT 
	p.warehouseCode,
	w.warehouseName,
    p.productLine,
	COUNT(productCode) AS total_product, 
	SUM(p.quantityInStock) AS total_stock
FROM products AS p 
JOIN warehouses AS w ON p.warehouseCode = w.warehouseCode
GROUP BY w.warehouseCode, p.warehouseName, p.productLine;

-- see what type of order status 
SELECT
	DISTINCT(status)
FROM orders;

SELECT COUNT(*)
FROM orders;

SELECT min(orderDate), max(orderDate)
FROM orders;

-- create temporary table
-- the table will have one column show the diff between product stock and remaining stock after the product is Shipped and Resolved
-- also having another columns say if the products are overstock, well-stocked or understock
CREATE TEMPORARY TABLE inventory_summary AS(
	SELECT
		p.warehouseCode AS warehouseCode,
		p.productCode AS productCode,
        p.productName AS productName,
		p.quantityInStock AS quantityInStock,
		SUM(od.quantityOrdered) AS total_ordered,
		p.quantityInStock - SUM(od.quantityOrdered) AS remaining_stock,
		CASE 
			WHEN (p.quantityInStock - SUM(od.quantityOrdered)) > (2 * SUM(od.quantityOrdered)) THEN 'Overstocked'
			WHEN (p.quantityInStock - SUM(od.quantityOrdered)) < 650 THEN 'Understocked'
			ELSE 'Well-Stocked'
		END AS inventory_status
	FROM products AS p
	JOIN orderdetails AS od ON p.productCode = od.productCode
	JOIN orders o ON od.orderNumber = o.orderNumber
	WHERE o.status IN ('Shipped', 'Resolved')
	GROUP BY 
		p.warehouseCode,
		p.productCode,
		p.quantityInStock
);

SELECT *
FROM inventory_summary;

SELECT COUNT(*)
FROM inventory_summary;

-- querying product inventory status on each warehouse
SELECT
    warehouseCode,
    inventory_status,
    COUNT(*) AS product_count
FROM inventory_summary
GROUP BY warehouseCode, inventory_status
order by warehouseCode;

-- identified whic product that never been sold so we can drop it 
SELECT
    p.productCode,
    p.productName,
    p.quantityInStock,
    p.warehouseCode
FROM products AS p
LEFT JOIN inventory_summary AS isum ON p.productCode = isum.productCode
WHERE isum.productCode IS NULL;

-- identified overstocked product
SELECT
      productCode,
      productName,
      remaining_stock,
      warehouseCode
FROM inventory_summary
WHERE inventory_status = 'Overstocked'
ORDER BY warehouseCode, remaining_stock desc;

SELECT COUNT(*) as product_overstocked
FROM (SELECT
      productCode,
      productName,
      remaining_stock,
      warehouseCode
FROM inventory_summary
WHERE inventory_status = 'Overstocked'
ORDER BY warehouseCode, remaining_stock desc) AS os;

-- identify understocked product
SELECT
      productCode,
      productName,
      remaining_stock,
      warehouseCode
FROM inventory_summary
WHERE inventory_status = 'Understocked'
ORDER BY warehouseCode;

SELECT COUNT(*) as product_understocked
FROM (SELECT
      productCode,
      productName,
      remaining_stock,
      warehouseCode
FROM inventory_summary
WHERE inventory_status = 'Understocked'
ORDER BY warehouseCode) AS US;

DROP TEMPORARY TABLE IF EXISTS inventory_summary;