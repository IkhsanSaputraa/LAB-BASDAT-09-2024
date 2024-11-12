-- Tugas Praktikum 8 --
USE classicmodels;

#Nomor 1
-- Memilih nama produk, total pendapatan, dan kategori pendapatan 'Pendapatan Tinggi'
(SELECT 
		productName,  -- Memilih kolom nama produk dari tabel products
		SUM(priceEach * quantityOrdered) AS TotalRevenue,  -- Menghitung total pendapatan untuk setiap produk
		'Pendapatan Tinggi' AS 'Pendapatan'  -- Memberikan label 'Pendapatan Tinggi' pada hasil seleksi ini
FROM products
JOIN orderdetails USING(productCode)  -- Menggabungkan tabel products dan orderdetails berdasarkan kolom productCode
JOIN orders USING(orderNumber)  -- Menggabungkan tabel orderdetails dan orders berdasarkan kolom orderNumber
WHERE MONTH(orderDate) = 9  -- Mengambil data yang hanya terjadi pada bulan ke-9 (September)
GROUP BY productName  -- Mengelompokkan data berdasarkan nama produk untuk menghitung pendapatan per produk
ORDER BY TotalRevenue DESC  -- Mengurutkan hasil berdasarkan TotalRevenue dari yang tertinggi
LIMIT 5)  -- Membatasi hasil hanya pada 5 produk dengan pendapatan tertinggi

UNION #2 query digabung dengan union sehingga mendapatkan hasil pendapatan tertinggi dan terendah pada bulan tersebut

-- Memilih nama produk, total pendapatan, dan kategori pendapatan 'Pendapatan Pendek (kayak kamu)'
(SELECT 
		productName,  -- Memilih kolom nama produk dari tabel products
		SUM(priceEach * quantityOrdered) AS TotalRevenue,  -- Menghitung total pendapatan untuk setiap produk
		'Pendapatan Pendek (kayak kamu)' AS 'Pendapatan'  -- Memberikan label 'Pendapatan Pendek (kayak kamu)' pada hasil seleksi ini
FROM products
JOIN orderdetails USING(productCode)  -- Menggabungkan tabel products dan orderdetails berdasarkan kolom productCode
JOIN orders USING(orderNumber)  -- Menggabungkan tabel orderdetails dan orders berdasarkan kolom orderNumber
WHERE MONTH(orderDate) = 9  -- Mengambil data yang hanya terjadi pada bulan ke-9 (September)
GROUP BY productName  -- Mengelompokkan data berdasarkan nama produk untuk menghitung pendapatan per produk
ORDER BY TotalRevenue ASC  -- Mengurutkan hasil berdasarkan TotalRevenue dari yang terendah
LIMIT 5);  -- Membatasi hasil hanya pada 5 produk dengan pendapatan terendah


#Nomor 2
SELECT productName  -- Memilih kolom productName dari tabel products
FROM products

EXCEPT  -- Menggunakan operator EXCEPT untuk menampilkan hasil dari query di atas yang tidak ada di hasil query di bawah ini

-- Query kedua: memilih nama produk yang dipesan oleh pelanggan tertentu
SELECT productName
FROM products p  -- Mengambil data dari tabel products dengan alias 'p'
JOIN orderdetails od USING(productCode)  -- Menggabungkan tabel products dengan orderdetails berdasarkan productCode
JOIN orders o USING(orderNumber)  -- Menggabungkan tabel orderdetails dengan orders berdasarkan orderNumber
WHERE o.customerNumber IN  -- Menentukan kondisi dimana customerNumber ada dalam hasil subquery berikutnya
    (SELECT customerNumber
     FROM orders
     GROUP BY customerNumber  -- Mengelompokkan data berdasarkan customerNumber untuk menghitung jumlah order
     HAVING COUNT(orderNumber) > 10)  -- Hanya memilih pelanggan yang memiliki lebih dari 10 order

-- Subquery kedua: hanya memilih customerNumber yang memenuhi kondisi harga rata-rata
AND o.customerNumber IN 
    (SELECT DISTINCT customerNumber  -- Memilih customerNumber unik dari hasil query berikut
     FROM products p  -- Mengambil data dari tabel products dengan alias 'p'
     JOIN orderdetails od USING(productCode)  -- Menggabungkan tabel products dengan orderdetails berdasarkan productCode
     WHERE priceEach >  -- Menentukan kondisi dimana priceEach harus lebih besar dari rata-rata
           (SELECT AVG(priceEach) FROM orderdetails))  -- Subquery untuk menghitung harga rata-rata per item pada orderdetails


# Nomor 3
-- Bagian Pertama: Memilih nama pelanggan dengan pembayaran total lebih dari dua kali rata-rata pembayaran total pelanggan lainnya

SELECT customerName  -- Memilih kolom customerName dari tabel customers
FROM customers
JOIN payments USING(customerNumber)  -- Menggabungkan tabel customers dengan tabel payments berdasarkan customerNumber
GROUP BY customerName  -- Mengelompokkan hasil berdasarkan nama pelanggan
HAVING SUM(amount) >  -- Memilih pelanggan yang total pembayarannya lebih besar dari dua kali rata-rata
    (SELECT AVG(totalPayment) * 2  -- Mengambil rata-rata dari total pembayaran semua pelanggan dan mengalikannya dengan 2
     FROM (
         SELECT customerNumber, SUM(amount) AS totalPayment  -- Menghitung total pembayaran per pelanggan
         FROM payments
         GROUP BY customerNumber  -- Mengelompokkan pembayaran berdasarkan customerNumber
     ) AS total)  -- Menamai hasil subquery sebagai "total"

-- INTERSECT digunakan untuk mendapatkan pelanggan yang memenuhi kedua kriteria dari dua bagian query berikut

INTERSECT

-- Bagian Kedua: Memilih pelanggan yang telah memesan produk dari kategori 'Planes' atau 'Trains' dengan nilai pesanan lebih dari $20,000

SELECT c.customerName  -- Memilih customerName dari tabel customers dengan alias 'c'
FROM customers c
JOIN orders o USING(customerNumber)  -- Menggabungkan tabel customers dengan tabel orders berdasarkan customerNumber
JOIN orderdetails od USING(orderNumber)  -- Menggabungkan tabel orders dengan tabel orderdetails berdasarkan orderNumber
JOIN products p USING(productCode)  -- Menggabungkan tabel orderdetails dengan tabel products berdasarkan productCode
WHERE p.productLine IN ('Planes', 'Trains')  -- Menyaring produk yang hanya berasal dari kategori 'Planes' atau 'Trains'
GROUP BY c.customerName  -- Mengelompokkan hasil berdasarkan nama pelanggan
HAVING SUM(od.quantityOrdered * od.priceEach) > 20000;  -- Memilih pelanggan yang nilai total pesanannya lebih dari $20,000


# Nomor 4
-- Bagian Pertama: Mengambil data pesanan yang memiliki pembayaran pada tanggal yang sama di bulan September 2003
SELECT 
    o.orderDate AS 'Tanggal',  -- Mengambil kolom orderDate dari tabel orders sebagai 'Tanggal'
    c.customerNumber AS 'CustomerNumber',  -- Mengambil kolom customerNumber dari tabel customers
    'Membayar Pesanan dan Memesan Barang' AS 'riwayat'  -- Memberikan label untuk data ini
FROM orders o
JOIN customers c USING (customerNumber)  -- Menggabungkan tabel orders dengan customers berdasarkan customerNumber
JOIN payments p ON o.orderDate = p.paymentDate  -- Menggabungkan tabel orders dengan payments jika tanggal pesanan sama dengan tanggal pembayaran
HAVING MONTH(Tanggal) = 09 AND YEAR(Tanggal) = 2003  -- Memfilter data yang berada pada bulan September tahun 2003

-- UNION digunakan untuk menggabungkan hasil dari berbagai query dengan kriteria berbeda

UNION

-- Bagian Kedua: Mengambil data pesanan yang tidak memiliki pembayaran pada tanggal tersebut di bulan September 2003
SELECT 
    orderDate,  -- Mengambil kolom orderDate dari tabel orders
    customerNumber,  -- Mengambil kolom customerNumber dari tabel orders
    'Memesan Barang'  -- Memberikan label bahwa pelanggan hanya memesan barang
FROM orders
WHERE MONTH(orderDate) = 09 AND YEAR(orderDate) = 2003  -- Memfilter data yang berada pada bulan September tahun 2003
AND orderDate NOT IN (  
    -- Subquery untuk menemukan tanggal pesanan yang juga memiliki pembayaran
	SELECT o.orderDate AS 'Tanggal'
	FROM orders o
	JOIN customers c USING (customerNumber)
	JOIN payments p ON o.orderDate = p.paymentDate
	HAVING MONTH(Tanggal) = 09 AND YEAR(Tanggal) = 2003
)

-- UNION lagi untuk menggabungkan hasil dari data pembayaran tanpa pesanan

UNION

-- Bagian Ketiga: Mengambil data pembayaran yang tidak memiliki pesanan pada tanggal tersebut di bulan September 2003
SELECT 
    paymentDate,  -- Mengambil kolom paymentDate dari tabel payments
    customerNumber,  -- Mengambil kolom customerNumber dari tabel payments
    'Membayar Pesanan'  -- Memberikan label bahwa pelanggan hanya membayar pesanan
FROM payments
WHERE MONTH(paymentDate) = 09 AND YEAR(paymentDate) = 2003  -- Memfilter data yang berada pada bulan September tahun 2003
AND paymentDate NOT IN (  
    -- Subquery untuk menemukan tanggal pembayaran yang juga memiliki pesanan
	SELECT p.paymentDate AS 'Tanggal'
	FROM orders o
	JOIN customers c USING (customerNumber)
	JOIN payments p ON o.orderDate = p.paymentDate
	HAVING MONTH(Tanggal) = 09 AND YEAR(Tanggal) = 2003
)

-- Mengurutkan hasil akhir berdasarkan kolom 'Tanggal'
ORDER BY Tanggal;


# Nomor 5
-- Bagian Pertama: Memilih productCode dari produk yang memenuhi kriteria tertentu
SELECT p.productCode  -- Mengambil kolom productCode dari tabel products
FROM products p
JOIN orderdetails od USING(productCode)  -- Menggabungkan tabel products dengan orderdetails berdasarkan productCode
WHERE od.priceEach > (  -- Memfilter produk yang harga per item-nya lebih tinggi dari rata-rata harga dalam subquery di bawah
    -- Subquery: Menghitung rata-rata harga per item dalam periode tertentu
    SELECT AVG(od2.priceEach)  -- Mengambil rata-rata priceEach dari tabel orderdetails
    FROM orderdetails od2
    JOIN orders o2 USING(orderNumber)  -- Menggabungkan orderdetails dengan orders berdasarkan orderNumber
    WHERE o2.orderDate BETWEEN '2001-01-01' AND '2004-03-31'  -- Membatasi tanggal pesanan antara 1 Januari 2001 dan 31 Maret 2004
) 
AND od.quantityOrdered > 48  -- Memfilter produk yang dipesan dengan kuantitas lebih dari 48
AND LEFT(p.productVendor, 1) IN ('a', 'i', 'u', 'e', 'o')  -- Memilih produk dari vendor yang namanya dimulai dengan huruf vokal

-- EXCEPT digunakan untuk mengecualikan produk tertentu berdasarkan kriteria di bawah

EXCEPT

-- Bagian Kedua: Memilih productCode dari produk yang dijual ke pelanggan di negara tertentu
SELECT p.productCode  -- Mengambil kolom productCode dari tabel products
FROM products p
JOIN orderdetails od USING(productCode)  -- Menggabungkan tabel products dengan orderdetails berdasarkan productCode
JOIN orders o USING(orderNumber)  -- Menggabungkan orderdetails dengan orders berdasarkan orderNumber
JOIN customers c USING(customerNumber)  -- Menggabungkan orders dengan customers berdasarkan customerNumber
WHERE c.country IN ('Japan', 'Germany', 'Italy');  -- Memilih produk yang dijual kepada pelanggan di Jepang, Jerman, atau Italia


