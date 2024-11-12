CREATE DATABASE manajemen_tim_sepakbola;

CREATE TABLE IF NOT EXISTS klub (
	id INT AUTO_INCREMENT PRIMARY KEY,
	nama_klub VARCHAR(50) NOT NULL,
	kota_asal VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS pemain (
	id INT AUTO_INCREMENT PRIMARY KEY,
	nama_pemain VARCHAR(50) NOT NULL,
	posisi VARCHAR(20) NOT NULL,
	id_klub INT,
	FOREIGN KEY(id_klub) REFERENCES klub(id)
);

CREATE TABLE IF NOT EXISTS pertandingan (
	id INT AUTO_INCREMENT PRIMARY KEY,
	tanggal_pertandingan DATE NOT NULL,
	skor_tuan_rumah INT DEFAULT 0,
	skor_tamu INT DEFAULT 0,
	id_klub_tuan_rumah INT,
	id_klub_tamu INT,
	FOREIGN KEY(id_klub_tuan_rumah) REFERENCES klub(id),
	FOREIGN KEY(id_klub_tamu) REFERENCES klub(id)
);
CREATE INDEX index_posisi ON pemain (posisi);
CREATE INDEX index_kota_asal ON klub (kota_asal);

#Nomor 2
SELECT 
		customerName,
		country,
		SUM(amount) AS TotalPayment,
		COUNT(orderNumber) AS orderCount,
		MAX(paymentDate) AS LastPaymentDate,
		case
			when SUM(amount) > 100000 then 'VIP'
			when SUM(amount) BETWEEN 5000 AND 100000 then 'Loyal'
			ELSE 'New'
		END AS status
FROM customers
LEFT JOIN orders
USING(customerNumber)
LEFT JOIN payments
USING(customerNumber)
GROUP BY customerName, country
ORDER BY customerName


#Nomro 3
SELECT 
    customerNumber,
    customerName,
    SUM(quantityOrdered) AS total_quantity,
    CASE
        WHEN SUM(quantityOrdered) > (
            SELECT AVG(total_quantity)
            FROM (
                SELECT customerNumber, SUM(quantityOrdered) AS total_quantity
                FROM customers
                JOIN orders USING(customerNumber)
                JOIN orderdetails USING(orderNumber)
                GROUP BY customerNumber
            ) AS t
        ) THEN 'di atas rata-rata'
        ELSE 'di bawah rata-rata'
    END AS kategori_pembelian
FROM customers
JOIN orders USING(customerNumber)
JOIN orderdetails USING(orderNumber)
GROUP BY customerNumber, customerName
ORDER BY total_quantity DESC;
