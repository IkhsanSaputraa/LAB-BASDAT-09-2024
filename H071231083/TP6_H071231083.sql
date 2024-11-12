-- Nomor 1
SELECT 
		c.customerName, 
		CONCAT(e.firstName, ' ', e.lastName) AS salesRep,
		(c.creditLimit - SUM(py.amount)) AS remainingCredit -- Menghitung sisa kredit dgn mengurangi total pembayaran SUM dari batas kredit pelanggan
FROM customers AS c
JOIN employees AS e
ON c.salesRepEmployeeNumber = e.employeeNumber
JOIN payments AS py
USING(customerNumber)
GROUP BY c.customerName 
HAVING remainingCredit >= 0 
ORDER BY c.customerName;

-- Nomor 2
SELECT 
		p.productName AS 'Nama Produk',
		GROUP_CONCAT(DISTINCT c.customerName) AS 'Nama Customer',
		COUNT(DISTINCT c.customerName) AS 'Jumlah Customer',
		SUM(od.quantityOrdered) AS 'Total Quantitas' -- menjumlahkan total kuantitas produk yg telah dipesan dari tabel od
FROM products AS p
JOIN orderdetails AS od
USING(productCode)
JOIN orders AS o
USING(orderNumber)
JOIN customers AS c
USING(customerNumber)
GROUP BY p.productName

-- Nomor 3
SELECT
		CONCAT(e.firstName, ' ', e.lastName) AS employeeName,
		COUNT(c.customerName) AS totalCustomers
FROM employees AS e
JOIN customers AS c
ON e.employeeNumber = c.salesRepEmployeeNumber 
GROUP BY employeeName
ORDER BY totalCustomers DESC;

-- Nomor 4
SELECT 
		CONCAT(e.firstName, ' ', e.lastName) AS 'Nama Karyawan',
		(p.productName) AS 'Nama Produk',
		SUM(od.quantityOrdered) AS 'Jumlah Pesanan' -- Total jumlah pesanan
FROM products AS p
JOIN orderdetails AS od
USING(productCode)
JOIN orders AS o
USING(orderNumber)
JOIN customers AS c
USING(customerNumber)
RIGHT JOIN employees AS e -- Karyawan australia yg mungkin tdk emmiliki pelanggan/pesanan tetap akan muncul
ON c.salesRepEmployeeNumber = e.employeeNumber
JOIN offices AS oc
USING(officeCode)
WHERE oc.country = 'Australia'
GROUP BY p.productName, e.employeeNumber
ORDER BY 'Jumlah Pesanan' DESC;

-- Nomor 5
SELECT 
    c.customerName AS 'Nama Pelanggan',
    GROUP_CONCAT(DISTINCT p.productName ORDER BY p.productName SEPARATOR ', ') AS 'Nama Produk',
    COUNT(DISTINCT p.productName) AS 'Banyak Jenis Produk'
FROM customers AS c
JOIN orders AS o
ON c.customerNumber = o.customerNumber
JOIN orderdetails AS od
ON o.orderNumber = od.orderNumber
JOIN products AS p
ON od.productCode = p.productCode
WHERE o.shippedDate IS NULL
GROUP BY c.customerName
ORDER BY c.customerName;

