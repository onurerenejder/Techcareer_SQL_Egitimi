CREATE DATABASE ILISKILER 

/*
ONE-TO-ONE (Bire Bir İlişki)
Tanım: Bir tablodaki her kayıt, diğer tablodaki sadece bir kayıtla eşleşir.

Özellikler:
- Her iki yönde de tek kayıt
- Genellikle performans için büyük tabloları bölerken kullanılır
- Foreign Key'de UNIQUE constraint gerekir
*/

CREATE TABLE Kullanıcılar (
    kullanici_id INT IDENTITY(1,1) PRIMARY KEY, 
    kullanici_adi VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    kayit_tarihi DATETIME DEFAULT GETDATE() 
);
--DEFAULT: Eğer kullanıcı bu sütuna değer girmezse, otomatik olarak atanacak varsayılan değeri belirler
--GETDATE()`: MSSQL'de bugünün tarihini ve saatini temsil eder

CREATE TABLE KullanıcıProfilleri (
    profil_id INT IDENTITY(1,1) PRIMARY KEY, 
    kullanici_id INT UNIQUE, -- ONE-TO-ONE için UNIQUE
    ad VARCHAR(50),
    soyad VARCHAR(50),
    telefon VARCHAR(20),
    dogum_tarihi DATE,
    FOREIGN KEY (kullanici_id) REFERENCES Kullanıcılar(kullanici_id)
);

/* 
FOREIGN KEY :
Bu, tablodaki bir sütunun başka bir tabloya bağımlı (ilişkili) olduğunu belirtir.
Yani bu sütunun değerleri başka bir tablodaki sütundan alınmak zorunda.
(kullanici_id):
Bu, mevcut tablodaki sütundur.
Yani: "Benim tablomda kullanici_id var, ama bu değerleri kafama göre giremiyorum. Bunlar başka tablodaki kimliklere bağlı olacak."
REFERENCES:
"Şuraya bak, oradan veri kontrol et" demek.
Yani bu foreign key hangi tabloya bağlanacaksa REFERENCES ile o tabloyu gösteriyoruz.
Kullanıcılar(kullanici_id):
Bu, hedef tabloyu ve sütunu gösteriyor.
Diyor ki: “Benim tablomdaki kullanici_id, Kullanıcılar tablosundaki kullanici_id değerleriyle eşleşmek zorunda.”
Eğer Kullanıcılar tablosunda olmayan bir kullanici_id girersen, SQL Server buna izin verme
*/

INSERT INTO Kullanıcılar (kullanici_adi, email) VALUES ('ahmet123', 'ahmet@email.com');

INSERT INTO KullanıcıProfilleri (kullanici_id, ad, soyad, telefon, dogum_tarihi) 
VALUES (1, 'Ahmet', 'Yılmaz', '05551234567', '1990-05-20');
/*
profil_id yazmadık çünkü bu da IDENTITY. SQL Server otomatik 1’den başlayarak artacak.
kullanici_id burada FOREIGN KEY → Yani yalnızca Kullanıcılar tablosunda gerçekten var olan bir kullanıcıya bağlanabilirsin.
Ayrıca kullanici_id UNIQUE olduğu için aynı kullanıcıya 2. profil açılamaz.
*/


/*
ONE-TO-MANY (Bire Çok İlişki)
Tanım: Bir tablodaki bir kayıt, diğer tablodaki birden fazla kayıtla eşleşebilir.

Özellikler:
- En yaygın ilişki türü
- "Parent-Child" ilişkisi
- Foreign Key "Many" tarafında bulunur

*/
CREATE TABLE Müşteriler (
    müşteri_id INT IDENTITY(1,1) PRIMARY KEY, 
    müşteri_adi VARCHAR(100) NOT NULL,
    telefon VARCHAR(20),
    email VARCHAR(100),
    adres NVARCHAR(MAX)  
);


CREATE TABLE Siparişler (
    sipariş_id INT IDENTITY(1,1) PRIMARY KEY,  
    müşteri_id INT, -- Foreign Key (Many tarafında)
    sipariş_tarihi DATETIME DEFAULT GETDATE(),  
    toplam_tutar DECIMAL(10,2), 
    durum VARCHAR(20) DEFAULT 'Beklemede',
    FOREIGN KEY (müşteri_id) REFERENCES Müşteriler(müşteri_id)
);

INSERT INTO Müşteriler (müşteri_adi, telefon, email, adres) VALUES 
('Ali Veli', '05551234567', 'ali@email.com', 'İstanbul'),
('Ayşe Kaya', '05559876543', 'ayse@email.com', 'Ankara'),
('Mehmet Can', '05553456789', 'mehmet@email.com', 'İzmir'),
('Fatma Yıldız', '05552345678', 'fatma@email.com', 'Bursa'),
('Ahmet Demir', '05551239876', 'ahmet@email.com', 'Antalya');
 

INSERT INTO Siparişler (müşteri_id, sipariş_tarihi, toplam_tutar, durum) VALUES 
-- Ali Veli'nin siparişleri
(1, '2025-01-15', 150.50, 'Tamamlandı'),
(1, '2025-01-20', 75.25, 'Kargoda'),
(1, '2025-02-05', 200.00, 'Tamamlandı'),

-- Ayşe Kaya'nın siparişleri
(2, '2025-01-18', 200.00, 'Hazırlanıyor'),
(2, '2025-02-10', 120.50, 'Kargoda'),

-- Mehmet Can'ın siparişleri
(3, '2025-02-01', 300.75, 'Tamamlandı'),
(3, '2025-02-12', 180.00, 'Beklemede'),

-- Fatma Yıldız'ın siparişleri
(4, '2025-02-03', 250.00, 'Tamamlandı'),
(4, '2025-02-15', 95.50, 'Kargoda'),

-- Ahmet Demir'in siparişleri
(5, '2025-02-07', 400.00, 'Hazırlanıyor'),
(5, '2025-02-18', 150.25, 'Beklemede');

 

 /*
MANY-TO-MANY (Çok Çok İlişki)
Tanım: Bir tablodaki kayıtlar, diğer tablodaki birden fazla kayıtla eşleşebilir.

Özellikler:
- Ara tablo (Junction Table) gerektirir
- İki Foreign Key içerir
- Ek bilgiler ara tabloda saklanabilir
 */

CREATE TABLE Öğrenciler (
    öğrenci_id INT IDENTITY(1,1) PRIMARY KEY,  
    öğrenci_adi VARCHAR(100) NOT NULL,
    numara VARCHAR(20) UNIQUE,
    bölüm VARCHAR(50)
);

CREATE TABLE Dersler (
    ders_id INT IDENTITY(1,1) PRIMARY KEY,  
    ders_adi VARCHAR(100) NOT NULL,
    kredi INT,
    öğretmen VARCHAR(100)
);

CREATE TABLE ÖğrenciDersleri (
    ogrenci_ders_id INT IDENTITY(1,1) PRIMARY KEY, 
    öğrenci_id INT,
    ders_id INT,
    notu DECIMAL(5,2),  
    dönem VARCHAR(20),
    FOREIGN KEY (öğrenci_id) REFERENCES Öğrenciler(öğrenci_id),
    FOREIGN KEY (ders_id) REFERENCES Dersler(ders_id)
);


INSERT INTO Öğrenciler (öğrenci_adi, numara, bölüm) VALUES 
('Mehmet Ali', '2024001', 'Bilgisayar Mühendisliği'),
('Fatma Demir', '2024002', 'Matematik'),
('Can Özkan', '2024003', 'Bilgisayar Mühendisliği');


INSERT INTO Dersler (ders_adi, kredi, öğretmen) VALUES 
('Veritabanı Yönetimi', 3, 'Dr. Ahmet Yılmaz'),
('Algoritma', 4, 'Dr. Ayşe Kaya'),
('Matematik', 3, 'Dr. Mehmet Demir');



INSERT INTO ÖğrenciDersleri (öğrenci_id, ders_id, notu, dönem) VALUES 
(1, 1, 85.5, '2025 Bahar'),
(1, 2, 78.0, '2025 Bahar'),
(2, 1, 92.0, '2025 Bahar'),
(2, 3, 88.5, '2025 Bahar'),
(3, 1, 76.5, '2025 Bahar'),
(3, 2, 82.0, '2025 Bahar');
select * from ÖğrenciDersleri

/* 
INNER JOIN
Tanım: Sadece her iki tabloda da eşleşen kayıtları getirir.

Kullanım Alanları:
- Ortak verileri görmek
- İlişkili kayıtları birleştirmek
- En yaygın kullanılan JOIN türü
*/

-- Müşteriler ve siparişlerini getir (sadece siparişi olan müşteriler)
SELECT m.müşteri_adi, s.sipariş_tarihi, s.toplam_tutar, s.durum
FROM Müşteriler m  
INNER JOIN Siparişler s ON m.müşteri_id = s.müşteri_id
ORDER BY s.sipariş_tarihi DESC;

/*
- SELECT kısmı
m.müşteri_adi → Müşteriler tablosundan müşteri adı sütununu seçiyoruz.
s.sipariş_tarihi, s.toplam_tutar, s.durum → Siparişler tablosundan sipariş bilgilerini seçiyoruz.
Bu sayede iki tabloyu birleştirip her siparişin hangi müşteriye ait olduğunu görebiliyoruz.
- FROM Müşteriler m
Müşteriler tablosunu kullanıyoruz ve ona kısaca m takma adı verdik.
Takma ad (alias) kullanmak, tabloları kısa ve okunabilir yazmak için idealdir.
- INNER JOIN Siparişler s ON m.müşteri_id = s.müşteri_id
INNER JOIN → iki tabloyu birleştirir ve eşleşen kayıtları getirir.
Siparişler tablosuna s takma adını verdik.
ON m.müşteri_id = s.müşteri_id → Müşteriler tablosundaki müşteri_id ile Siparişler tablosundaki müşteri_id eşleşen kayıtlar seçilir.
Yani sadece sipariş vermiş müşteriler listelenir.

Özet Mantık
Müşteriler ve Siparişler tabloları müşteri_id üzerinden birleştirilir.
Her siparişin müşterisiyle birlikte bilgisi alınır.
Sonuç, sipariş tarihine göre en yeni siparişler üstte olacak şekilde sıralanır.
*/


-- Öğrenciler ve aldıkları dersleri getir
SELECT o.öğrenci_adi, d.ders_adi, od.notu, od.dönem
FROM Öğrenciler o
INNER JOIN ÖğrenciDersleri od ON o.öğrenci_id = od.öğrenci_id
INNER JOIN Dersler d ON  d.ders_id = od.ders_id
WHERE od.notu >= 80;
/*
-Neden 2 tane INNER JOIN var?
Çünkü 3 tabloyu birleştiriyorsun:
Öğrenciler
ÖğrenciDersleri (ara tablo)
Dersler
İlk INNER JOIN → Öğrenciler ile ÖğrenciDersleri tablosunu bağlar.
    o.öğrenci_id = od.öğrenci_id
Yani hangi öğrenci hangi dersi almış, öğrenci bilgisi + notları eşleşir.
İkinci INNER JOIN → ÖğrenciDersleri ile Dersler tablosunu bağlar.
    od.ders_id = d.ders_id
Yani alınan dersin adı, kredisi vs. ders tablosundan eklenir.

Özet:
İlk JOIN: Öğrenciler ↔ ÖğrenciDersleri
İkinci JOIN: ÖğrenciDersleri ↔ Dersler
İkisini de kullanmazsan eksik bilgi olurdu.
*/


/*
LEFT JOIN (LEFT OUTER JOIN)
Tanım: Sol tablodaki tüm kayıtları getirir, sağ tabloda eşleşme yoksa NULL değerler döner.

Kullanım Alanları:
- Sol tablodaki tüm verileri korumak
- Eksik verileri tespit etmek
- Raporlama işlemleri
*/

-- Tüm müşterileri getir (siparişi olmasa bile)
SELECT m.müşteri_adi, 
       COALESCE(s.sipariş_tarihi, 'Sipariş yok') as sipariş_tarihi,
       COALESCE(s.toplam_tutar, 0) as toplam_tutar
FROM Müşteriler m
LEFT JOIN Siparişler s ON m.müşteri_id = s.müşteri_id;

/*
Müşteriler tablosu ana tablo (alias olarak m verdik).
LEFT JOIN demek: Müşteriler tablosundaki tüm satırları al, eğer Siparişler tablosunda eşleşen müşteri varsa onu getir, yoksa NULL doldur.
ON m.müşteri_id = s.müşteri_id → hangi sütuna göre eşleştireceğimizi söylüyor.

COALESCE() fonksiyonu NULL değerler yerine başka bir değer döndürmek için kullanılır.
Örnek: Eğer bir müşterinin siparişi yoksa s.sipariş_tarihi NULL olur.
COALESCE(s.sipariş_tarihi, 'Sipariş yok') → NULL ise 'Sipariş yok' yazar.
Benzer şekilde toplam_tutar NULL ise 0 gösterir.

LEFT JOIN → Tüm ana tablo satırlarını al, eşleşen varsa getirecek, yoksa NULL.
COALESCE → NULL’ları istediğimiz değerle değiştirir.
Bu sorgu tüm müşterileri gösterir, siparişleri varsa detaylarını, yoksa varsayılan değerleri.
*/



/*
RIGHT JOIN (RIGHT OUTER JOIN)
Tanım: Sağ tablodaki tüm kayıtları getirir, sol tabloda eşleşme yoksa NULL değerler döner.

Kullanım Alanları:
- Sağ tablodaki tüm verileri korumak
- Veri bütünlüğü kontrolü
- Eksik referansları tespit etmek
*/

-- Tüm siparişleri getir (müşteri bilgisi olmasa bile)
SELECT COALESCE(m.müşteri_adi, 'Bilinmeyen Müşteri') as müşteri_adi,
       s.sipariş_tarihi, s.toplam_tutar
FROM Müşteriler m
RIGHT JOIN Siparişler s ON m.müşteri_id = s.müşteri_id;


/*
FULL OUTER JOIN
Tanım: Her iki tablodaki tüm kayıtları getirir, eşleşmeyen yerlerde NULL değerler döner.

Kullanım Alanları:
- Her iki tablodaki tüm verileri görmek
- Veri analizi
- Eksik verileri tespit etmek
*/

-- Tüm müşteriler ve tüm siparişler
SELECT m.müşteri_adi, s.sipariş_tarihi, s.toplam_tutar
FROM Müşteriler m
FULL OUTER JOIN Siparişler s ON m.müşteri_id = s.müşteri_id;
/*
| Durum                    | Dönen Satır                   |
| ------------------------ | ----------------------------- |
| Müşteri var, sipariş yok | sipariş sütunları NULL        |
| Müşteri yok, sipariş var | müşteri sütunları NULL        |
| Müşteri ve sipariş var   | Her iki tablonun verisi gelir |
*/

 /*
CROSS JOIN
Tanım: İki tablonun kartezyen çarpımı (her satır her satırla eşleşir).

Kullanım Alanları:
- Tüm kombinasyonları görmek
- Test verisi oluşturmak
- Dikkatli kullanılmalı (çok büyük sonuç setleri)
*/
-- Tüm müşteri-sipariş kombinasyonları

SELECT m.müşteri_adi, s.sipariş_tarihi
FROM Müşteriler m
CROSS JOIN Siparişler s;


------ Alt Sorgular (Subqueries)


-- Ortalamadan yüksek not alan öğrenciler
SELECT o.öğrenci_adi, od.notu
FROM Öğrenciler o
JOIN ÖğrenciDersleri od ON o.öğrenci_id = od.öğrenci_id
WHERE od.notu > (  
    SELECT AVG(notu) 
    FROM ÖğrenciDersleri
);


-- En pahalı siparişi veren müşteri
SELECT müşteri_adi
FROM Müşteriler
WHERE müşteri_id = (
    SELECT müşteri_id 
    FROM Siparişler 
    WHERE toplam_tutar = (SELECT MAX(toplam_tutar) FROM Siparişler)
);

-- Belirli bir tutardan fazla sipariş veren müşteriler
SELECT müşteri_adi, telefon
FROM Müşteriler
WHERE müşteri_id IN (
    SELECT müşteri_id 
    FROM Siparişler 
    WHERE toplam_tutar > 200
);




------ -- MSSQL'de metin işlemleri

SELECT 
    LEN('Merhaba Dünya') as uzunluk,           -- Karakter sayısı
    LEFT('Merhaba', 3) as soldan_3,            -- Soldan 3 karakter
    RIGHT('Merhaba', 3) as sağdan_3,           -- Sağdan 3 karakter
    SUBSTRING('Merhaba Dünya', 1, 7) as alt_metin, -- Alt metin
    UPPER('merhaba') as büyük_harf,            -- Büyük harf
    LOWER('MERHABA') as küçük_harf,            -- Küçük harf
    LTRIM('  Merhaba  ') as sol_trim,          -- Sol boşlukları temizle
    RTRIM('  Merhaba  ') as sağ_trim,          -- Sağ boşlukları temizle
    REPLACE('Merhaba Dünya', 'Dünya', 'SQL') as değiştir; -- Metin değiştir



------ MSSQL'de tarih işlemleri

    SELECT 
    GETDATE() as şu_an,                    -- Mevcut tarih ve saat
    GETUTCDATE() as utc_tarih,             -- UTC tarih
    YEAR(GETDATE()) as yıl,                -- Yıl
    MONTH(GETDATE()) as ay,                -- Ay
    DAY(GETDATE()) as gün,                 -- Gün
    DATEPART(WEEKDAY, GETDATE()) as haftanın_günü, -- Haftanın günü
    DATEADD(DAY, 7, GETDATE()) as bir_hafta_sonra,  -- 7 gün ekle
    DATEDIFF(DAY, '2024-01-01', GETDATE()) as gün_farkı; -- Gün farkı  