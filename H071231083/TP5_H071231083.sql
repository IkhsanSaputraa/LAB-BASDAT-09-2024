USE classicmodels;

SELECT DISTINCT
    c.customerName AS namaKustomer,
    p.productName AS namaProduk,
    p.productDescription AS textDescription
FROM
    customers c
JOIN orders o ON c.customerNumber = o.customerNumber
JOIN orderdetails od ON o.orderNumber = od.orderNumber
JOIN products p ON od.productCode = p.productCode
WHERE
    p.productName LIKE '%Titanic%'
ORDER BY
    c.customerName ASC;

-- Nomor 2
SELECT
    customers.customerName,
    products.productName,
    orders.status,
    orders.shippedDate
FROM
    orders
INNER JOIN customers 
USING (customerNumber)
INNER JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber
INNER JOIN products ON orderdetails.productCode = products.productCode
WHERE
    products.productName LIKE '%Ferrari%'
    AND orders.status = 'Shipped'
    AND orders.shippedDate BETWEEN '2003-10-01' AND '2004-09-30'
ORDER BY
    orders.shippedDate DESC;

-- Nomor 3
SELECT 
    'Gerard' AS Supervisor,
    e.firstName AS Karyawan
FROM 
    employees e
JOIN 
    employees m ON e.reportsTo = m.employeeNumber -- kolom reportsTo dari karyawan e harus sama dengan employeeNumber dari supervisor m
WHERE 
    m.firstName = 'Gerard'
ORDER BY 
    e.firstName;
    
-- Nomor 4
## a
SELECT c.customerName, 
		p.paymentDate, 
		e.firstName AS employeeName, 
		p.amount	
FROM payments AS p
JOIN customers AS c
USING(customerNumber)
JOIN employees AS e
ON c.salesRepEmployeeNumber = e.employeeNumber
WHERE p.paymentDate LIKE '%-11-%'

-- b
SELECT c.customerName, 
		p.paymentDate, 
		e.firstName AS employeeName, 
		p.amount	
FROM payments AS p
JOIN customers AS c
USING(customerNumber)
JOIN employees AS e
ON c.salesRepEmployeeNumber = e.employeeNumber
WHERE p.paymentDate LIKE '%-11-%'   
ORDER BY amount DESC
LIMIT 1;

-- c
SELECT c.customerName, p.productName
FROM customers AS c
JOIN orders AS o ON c.customerNumber = o.customerNumber
JOIN orderdetails AS od ON o.orderNumber = od.orderNumber
JOIN products AS p ON od.productCode = p.productCode
JOIN payments AS py ON c.customerNumber = py.customerNumber
WHERE c.customerName = 'Corporate Gift Ideas Co.'
  AND py.paymentDate LIKE '%-11-%';