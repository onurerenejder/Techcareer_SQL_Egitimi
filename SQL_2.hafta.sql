/*
===============================================================================
                    SQL DERS NOTLARI 
                    Otomobil Fiyatları Veritabanı Üzerinden
===============================================================================

İçindekiler:
1. Veritabanı Kullanımı ve Temel SELECT
2. WHERE Koşulları ve Karşılaştırma Operatörleri
3. Mantıksal Operatörler (AND, OR, NOT)
4. BETWEEN Operatörü
5. IN Operatörü
6. LIKE Operatörü ve Metin Arama
7. Aggregate Fonksiyonları (COUNT, SUM, AVG, MIN, MAX)
8. GROUP BY ile Gruplama
9. HAVING ile Grup Filtreleme
10. WHERE, GROUP BY ve HAVING Birlikte Kullanımı
11. ORDER BY ile Sıralama
12. Pratik Alıştırmalar

===============================================================================
*/

                

-- Veritabanını seç
USE otomobilFiyatlari;

/*
===============================================================================
1. VERİTABANI KULLANIMI VE TEMEL SELECT
===============================================================================
*/

-- Tüm verileri görüntüle
SELECT * FROM otomobil_fiyatlari;

-- Belirli sütunları seç
SELECT marka, model, fiyat FROM otomobil_fiyatlari;

-- İlk 10 kaydı görüntüle
SELECT TOP 10 * FROM otomobil_fiyatlari;

-- Sütunlara takma ad ver
SELECT 
    marka AS 'Araç Markası',
    model AS 'Model Adı',
    fiyat AS 'Satış Fiyatı',
    yakit AS 'Yakıt Türü'
FROM otomobil_fiyatlari;

/*
===============================================================================
2. WHERE KOŞULLARI VE KARŞILAŞTIRMA OPERATÖRLERİ
===============================================================================

Karşılaştırma Operatörleri:
=   → Eşittir
>   → Büyüktür  
<   → Küçüktür
>=  → Büyük eşittir
<=  → Küçük eşittir
<>  → Eşit değildir (!=de kullanılabilir)
*/

-- Motor hacmi 2000'den büyük araçlar
SELECT * FROM otomobil_fiyatlari
WHERE motor > 2000;

-- Fiyatı tam 100.000 TL olan araçlar
SELECT * FROM otomobil_fiyatlari
WHERE fiyat = 100000;

-- Fiyatı 100.000 TL'den büyük araçlar
SELECT * FROM otomobil_fiyatlari
WHERE fiyat > 100000;

-- Fiyatı 500.000 TL'den küçük araçlar
SELECT * FROM otomobil_fiyatlari
WHERE fiyat < 500000;

-- Fiyatı 200.000 TL ve üstü araçlar
SELECT * FROM otomobil_fiyatlari
WHERE fiyat >= 200000;

-- Motor hacmi 1600 cc ve altı araçlar
SELECT * FROM otomobil_fiyatlari
WHERE motor <= 1600;

-- Fiyatı 1.500.000 TL olmayan araçlar
SELECT * FROM otomobil_fiyatlari
WHERE fiyat <> 1500000;

-- String karşılaştırma - Tam eşleşme
SELECT * FROM otomobil_fiyatlari
WHERE marka = 'BMW';

-- String karşılaştırma - Eşit değil
SELECT * FROM otomobil_fiyatlari
WHERE yakit <> 'Benzin';

/*
ÖNEMLİ NOT: String değerler tek tırnak içinde yazılır!
Sayısal değerler ise tırnak olmadan yazılır.
*/

-- String olarak yazılan sayı (çalışır ama önerilmez)
SELECT * FROM otomobil_fiyatlari
WHERE fiyat > '100000';

-- Hatalı kullanım - sayı formatında olmayan string
 SELECT * FROM otomobil_fiyatlari
 WHERE fiyat > '100K';  -- Bu hata verir!

/*
===============================================================================
3. MANTIKSAL OPERATÖRLER (AND, OR, NOT)
===============================================================================
*/

-- AND Operatörü - TÜM koşullar doğru olmalı
-- Fiyatı 500.000üç'den kük VE yakıtı Dizel olan araçlar
SELECT * FROM otomobil_fiyatlari
WHERE fiyat < 500000 AND yakit = 'Dizel';

-- Fiyat 300.000'den büyük VE yakıt Benzin VE vites Otomatik
SELECT * FROM otomobil_fiyatlari
WHERE fiyat > 300000 AND yakit = 'Benzin' AND vites = 'Otomatik';

-- Motor hacmi 2000 cc üstü VE fiyat 1.000.000 altı VE marka BMW
SELECT * FROM otomobil_fiyatlari
WHERE motor > 2000 AND fiyat < 1000000 AND marka = 'BMW';

-- OR Operatörü - EN AZ BİR koşul doğru olsun yeter
-- Yakıtı Benzin VEYA Dizel olan araçlar
SELECT * FROM otomobil_fiyatlari
WHERE yakit = 'Benzin' OR yakit = 'Dizel';

-- Fiyatı 100.000'den küçük VEYA 1.000.000'den büyük araçlar
SELECT * FROM otomobil_fiyatlari
WHERE fiyat < 100000 OR fiyat > 1000000;

-- Marka BMW VEYA Mercedes VEYA Audi olan araçlar
SELECT * FROM otomobil_fiyatlari
WHERE marka = 'BMW' OR marka = 'Mercedes' OR marka = 'Audi';

-- NOT Operatörü - Koşulun tersini alır
-- Benzinli OLMAYAN tüm araçlar
SELECT * FROM otomobil_fiyatlari
WHERE NOT yakit = 'Benzin';

-- Yukarıdakiyle aynı sonuç
SELECT * FROM otomobil_fiyatlari
WHERE yakit <> 'Benzin';

-- Otomatik vitesli OLMAYAN araçlar
SELECT * FROM otomobil_fiyatlari
WHERE NOT vites = 'Otomatik';

-- Karmaşık mantıksal ifadeler - Parantez kullanımı
-- (Benzinli VEYA Dizel) VE (Otomatik vitesli) VE (fiyat 500.000 üstü)
SELECT * FROM otomobil_fiyatlari
WHERE (yakit = 'Benzin' OR yakit = 'Dizel') 
  AND vites = 'Otomatik' 
  AND fiyat > 500000;

-- BMW VEYA Mercedes markası VE fiyat 200.000-800.000 arası
SELECT * FROM otomobil_fiyatlari
WHERE (marka = 'BMW' OR marka = 'Mercedes') 
  AND fiyat >= 200000 
  AND fiyat <= 800000;

/*
===============================================================================
4. BETWEEN OPERATÖRÜ - Aralık Belirleme
===============================================================================
BETWEEN: Belirtilen aralıktaki değerleri seçer (başlangıç ve bitiş dahil)
*/

-- Fiyatı 200.000 ile 500.000 arasında olan araçlar
SELECT * FROM otomobil_fiyatlari
WHERE fiyat BETWEEN 200000 AND 500000;

-- Yukarıdakiyle aynı sonuç (uzun yol)
SELECT * FROM otomobil_fiyatlari
WHERE fiyat >= 200000 AND fiyat <= 500000;

-- Motor hacmi 1400 ile 2000 cc arasında olan araçlar
SELECT * FROM otomobil_fiyatlari
WHERE motor BETWEEN 1400 AND 2000;

-- Fiyatı 100.000 ile 300.000 arasında olan BMW'ler
SELECT * FROM otomobil_fiyatlari
WHERE fiyat BETWEEN 100000 AND 300000 AND marka = 'BMW';

-- NOT BETWEEN - Belirtilen aralık DIŞINDA olan değerler
-- Fiyatı 200.000-800.000 arasında OLMAYAN araçlar
SELECT * FROM otomobil_fiyatlari
WHERE fiyat NOT BETWEEN 200000 AND 800000;

-- Motor hacmi 1500-2500 cc arasında olmayan araçlar
SELECT * FROM otomobil_fiyatlari
WHERE motor NOT BETWEEN 1500 AND 2500;

-- Çoklu BETWEEN kullanımı
-- Fiyat 100K-300K arası VEYA 800K-1.2M arası olan araçlar
SELECT * FROM otomobil_fiyatlari
WHERE (fiyat BETWEEN 100000 AND 300000) 
   OR (fiyat BETWEEN 800000 AND 1200000);

/*
===============================================================================
5. IN OPERATÖRÜ - Liste İçinden Seçim
===============================================================================
IN: Belirtilen listeden herhangi birine eşit olan değerleri seçer
*/

-- Yakıtı Benzin veya Dizel olan araçlar
SELECT * FROM otomobil_fiyatlari
WHERE yakit IN ('Benzin', 'Dizel');

-- Yukarıdakiyle aynı sonuç (uzun yol)
SELECT * FROM otomobil_fiyatlari
WHERE yakit = 'Benzin' OR yakit = 'Dizel';

-- Belirli markaları seç
SELECT * FROM otomobil_fiyatlari
WHERE marka IN ('BMW', 'Mercedes', 'Audi', 'Volkswagen');

-- Belirli motor hacimlerini seç
SELECT * FROM otomobil_fiyatlari
WHERE motor IN (1400, 1600, 2000, 2500);

-- Belirli fiyat aralıklarını seç
SELECT * FROM otomobil_fiyatlari
WHERE fiyat IN (150000, 200000, 250000, 300000);

-- NOT IN - Listede OLMAYAN değerleri seç
-- Yakıtı Benzin veya Dizel OLMAYAN araçlar (Hibrit, Elektrik vs.)
SELECT * FROM otomobil_fiyatlari
WHERE yakit NOT IN ('Benzin', 'Dizel');

-- BMW, Mercedes, Audi OLMAYAN markalar
SELECT * FROM otomobil_fiyatlari
WHERE marka NOT IN ('BMW', 'Mercedes', 'Audi');

-- Belirli motor hacimleri OLMAYAN araçlar
SELECT * FROM otomobil_fiyatlari
WHERE motor NOT IN (1400, 1600, 2000);

-- IN ve BETWEEN birlikte kullanımı
-- Fiyat 200K-600K arası VE yakıt Benzin/Dizel olan araçlar
SELECT * FROM otomobil_fiyatlari
WHERE fiyat BETWEEN 200000 AND 600000
  AND yakit IN ('Benzin', 'Dizel');

-- Belirli markalar VE motor hacmi 1500-2500 arası
SELECT * FROM otomobil_fiyatlari
WHERE marka IN ('BMW', 'Mercedes', 'Audi')
  AND motor BETWEEN 1500 AND 2500;

/*
===============================================================================
6. LIKE OPERATÖRÜ - Metin Arama ve Desen Eşleştirme
===============================================================================
LIKE: Metin sütunlarında desen arama yapar
Wildcards (Joker Karakterler):
% → Sıfır veya daha fazla karakter
_ → Tam olarak bir karakter
*/

-- Modeli 'A' harfi ile BAŞLAYAN araçlar
SELECT * FROM otomobil_fiyatlari
WHERE model LIKE 'A%';

-- Modeli 'o' harfi ile BİTEN araçlar  
SELECT * FROM otomobil_fiyatlari
WHERE model LIKE '%o';

-- Modelin İÇİNDE 'Sport' geçen araçlar
SELECT * FROM otomobil_fiyatlari
WHERE model LIKE '%Sport%';

-- Modelin İÇİNDE 'OR' geçen araçlar
SELECT * FROM otomobil_fiyatlari
WHERE model LIKE '%OR%';

-- Modeli tam 5 karakter olan araçlar
SELECT * FROM otomobil_fiyatlari
WHERE model LIKE '_____';

-- Modelin İKİNCİ harfi 'u' olan araçlar
SELECT * FROM otomobil_fiyatlari
WHERE model LIKE '_u%';

-- Modelin ÜÇÜNCÜ harfi 'r' olan araçlar
SELECT * FROM otomobil_fiyatlari
WHERE model LIKE '__r%';

-- Modeli 'C' ile başlayıp 's' ile biten araçlar
SELECT * FROM otomobil_fiyatlari
WHERE model LIKE 'C%s';

-- Marka adında 'er' geçen markalar
SELECT * FROM otomobil_fiyatlari
WHERE marka LIKE '%er%';

-- NOT LIKE - Desen EŞLEŞMEYENleri seç
-- Modeli 'Sport' içermeyen araçlar
SELECT * FROM otomobil_fiyatlari
WHERE model NOT LIKE '%Sport%';

-- Modeli 'A' ile başlamayan araçlar
SELECT * FROM otomobil_fiyatlari
WHERE model NOT LIKE 'A%';

-- Marka adında 'BMW' geçmeyen araçlar
SELECT * FROM otomobil_fiyatlari
WHERE marka NOT LIKE '%BMW%';

-- Karmaşık LIKE kullanımları
-- Modeli 'C' veya 'S' ile başlayan araçlar
SELECT * FROM otomobil_fiyatlari
WHERE model LIKE 'C%' OR model LIKE 'S%';

-- Modeli sayı ile biten araçlar (son karakter 0-9)
SELECT * FROM otomobil_fiyatlari
WHERE model LIKE '%[0-9]';

/*
===============================================================================
7. AGGREGATE FONKSİYONLARI - Toplulaştırma İşlemleri
===============================================================================
COUNT() → Satır sayısı
SUM()   → Toplam
AVG()   → Ortalama
MIN()   → Minimum değer
MAX()   → Maksimum değer
*/

-- COUNT - Satır Sayısı
-- Toplam araç sayısı
SELECT COUNT(*) AS toplam_arac_sayisi
FROM otomobil_fiyatlari;

-- NULL olmayan fiyat kayıtları sayısı
SELECT COUNT(fiyat) AS fiyat_kayit_sayisi
FROM otomobil_fiyatlari;

-- Benzinli araç sayısı
SELECT COUNT(*) AS benzinli_arac_sayisi
FROM otomobil_fiyatlari
WHERE yakit = 'Benzin';

-- Motor hacmi 2000'den büyük araç sayısı
SELECT COUNT(*) AS buyuk_motor_arac_sayisi
FROM otomobil_fiyatlari
WHERE motor > 2000;

-- Fiyatı 500.000'den pahalı araç sayısı
SELECT COUNT(*) AS pahali_arac_sayisi
FROM otomobil_fiyatlari
WHERE fiyat > 500000;

-- SUM - Toplam
-- Tüm araçların toplam değeri
SELECT SUM(fiyat) AS toplam_fiyat --aşırı yükleme 
FROM otomobil_fiyatlari;

SELECT SUM(CAST(fiyat AS BIGINT)) AS toplam_fiyat
FROM otomobil_fiyatlari;

-- Benzinli araçların toplam değeri
SELECT SUM(CAST(fiyat AS BIGINT)) AS benzinli_toplam_fiyat
FROM otomobil_fiyatlari
WHERE yakit = 'Benzin';

-- BMW araçlarının toplam değeri
SELECT SUM(CAST(fiyat AS BIGINT)) AS bmw_toplam_fiyat
FROM otomobil_fiyatlari
WHERE marka = 'BMW';

-- AVG - Ortalama
-- Genel ortalama fiyat
SELECT AVG(CAST(fiyat AS FLOAT)) AS ortalama_fiyat
FROM otomobil_fiyatlari;

-- Dizel araçların ortalama fiyatı
SELECT AVG(CAST(fiyat AS FLOAT)) AS dizel_ortalama_fiyat
FROM otomobil_fiyatlari
WHERE yakit = 'Dizel';

-- Otomatik vitesli araçların ortalama fiyatı
SELECT AVG(CAST(fiyat AS FLOAT)) AS otomatik_ortalama_fiyat
FROM otomobil_fiyatlari
WHERE vites = 'Otomatik';

-- Ortalama motor hacmi
SELECT AVG(CAST(motor AS FLOAT)) AS ortalama_motor_hacmi
FROM otomobil_fiyatlari;

-- MIN ve MAX - En küçük ve en büyük değerler
-- En ucuz ve en pahalı araç fiyatı
SELECT 
    MIN(fiyat) AS en_ucuz_fiyat,
    MAX(fiyat) AS en_pahali_fiyat
FROM otomobil_fiyatlari;

-- En küçük ve en büyük motor hacmi
SELECT 
    MIN(motor) AS en_kucuk_motor,
    MAX(motor) AS en_buyuk_motor
FROM otomobil_fiyatlari;

-- BMW'lerin en ucuz ve en pahalısı
SELECT 
    MIN(fiyat) AS bmw_en_ucuz,
    MAX(fiyat) AS bmw_en_pahali
FROM otomobil_fiyatlari
WHERE marka = 'BMW';

-- Çoklu aggregate fonksiyon kullanımı
SELECT 
    COUNT(*) AS toplam_arac,
    AVG(CAST(fiyat AS FLOAT)) AS ortalama_fiyat,
    MIN(fiyat) AS en_ucuz,
    MAX(fiyat) AS en_pahali,
    SUM(CAST(fiyat AS BIGINT)) AS toplam_deger
FROM otomobil_fiyatlari;

-- Koşullu aggregate
-- Fiyatı 1.000.000 üstü araçların istatistikleri
SELECT 
    COUNT(*) AS pahali_arac_sayisi,
    AVG(CAST(fiyat AS FLOAT)) AS pahali_ortalama,
    MIN(fiyat) AS pahali_en_ucuz,
    MAX(fiyat) AS pahali_en_pahali
FROM otomobil_fiyatlari
WHERE fiyat > 1000000;

/*
===============================================================================
8. GROUP BY - Gruplama İşlemleri
===============================================================================
GROUP BY: Satırları belirli sütunlara göre gruplar ve 
her grup için aggregate fonksiyonları çalıştırır
*/

-- Yakıt türüne göre araç sayısı
SELECT 
    yakit,
    COUNT(*) AS arac_sayisi
FROM otomobil_fiyatlari
GROUP BY yakit;

-- Markaya göre araç sayısı
SELECT 
    marka,
    COUNT(*) AS arac_sayisi
FROM otomobil_fiyatlari
GROUP BY marka
ORDER BY arac_sayisi DESC;

-- Vites türüne göre araç sayısı
SELECT 
    vites,
    COUNT(*) AS arac_sayisi
FROM otomobil_fiyatlari
GROUP BY vites;

-- Yakıt türüne göre ortalama fiyat
SELECT 
    yakit,
    AVG(CAST(fiyat AS FLOAT)) AS ortalama_fiyat,
    COUNT(*) AS arac_sayisi
FROM otomobil_fiyatlari
GROUP BY yakit
ORDER BY ortalama_fiyat DESC;

-- Markalara göre fiyat istatistikleri
SELECT 
    marka,
    COUNT(*) AS arac_sayisi,
    AVG(CAST(fiyat AS FLOAT)) AS ortalama_fiyat,
    MIN(fiyat) AS en_ucuz,
    MAX(fiyat) AS en_pahali
FROM otomobil_fiyatlari
GROUP BY marka
ORDER BY ortalama_fiyat DESC;

/*
CASE → Koşullu bloğun başladığını gösterir.
WHEN → Kontrol etmek istediğin koşulu yazarız.
THEN → Koşul doğruysa döndürülecek değeri yazarız.
ELSE → Hiçbir koşul doğru değilse dönecek varsayılan değeri belirtir (opsiyonel).
END → CASE bloğunu kapatır.
*/

-- Motor hacim aralıklarına göre gruplama

SELECT 
    -- CASE ifadesi ile motor hacmini kategorilere ayırıyoruz
    CASE 
        WHEN motor <= 1400 THEN '1400cc ve altı'        -- motor 1400 veya altındaysa bu kategoriye
        WHEN motor <= 2000 THEN '1401-2000cc'          -- motor 1401-2000 aralığında ise bu kategoriye
        WHEN motor <= 2500 THEN '2001-2500cc'          -- motor 2001-2500 aralığında ise bu kategoriye
        ELSE '2500cc üstü'                             -- diğer tüm motorlar bu kategoriye
    END AS motor_kategorisi,                           -- çıktı tablosunda bu kategori sütunu 'motor_kategorisi' adıyla görünecek

    -- Her kategoride kaç araç olduğunu sayıyoruz
    COUNT(*) AS arac_sayisi,

    -- Her kategorideki araçların ortalama fiyatını hesaplıyoruz
    -- Fiyat INT olduğu için FLOAT'a çeviriyoruz, böylece ondalıklı ortalama alabiliriz
    AVG(CAST(fiyat AS FLOAT)) AS ortalama_fiyat

FROM otomobil_fiyatlari  -- verileri otomobil_fiyatlari tablosundan alıyoruz

-- Gruplama: motor_kategorisine göre satırları grupluyoruz
GROUP BY 
    CASE 
        WHEN motor <= 1400 THEN '1400cc ve altı'
        WHEN motor <= 2000 THEN '1401-2000cc'
        WHEN motor <= 2500 THEN '2001-2500cc'
        ELSE '2500cc üstü'
    END

-- Sonuçları ortalama_fiyata göre küçükten büyüğe sıralıyoruz
ORDER BY ortalama_fiyat;

-- Çoklu sütun ile gruplama
-- Marka ve yakıt türüne göre gruplama
SELECT 
    marka,
    yakit,
    COUNT(*) AS arac_sayisi,
    AVG(CAST(fiyat AS FLOAT)) AS ortalama_fiyat
FROM otomobil_fiyatlari
GROUP BY marka, yakit
ORDER BY marka, yakit;

-- Marka, yakıt ve vites türüne göre gruplama
SELECT 
    marka,
    yakit,
    vites,
    COUNT(*) AS arac_sayisi,
    AVG(CAST(fiyat AS FLOAT)) AS ortalama_fiyat
FROM otomobil_fiyatlari
GROUP BY marka, yakit, vites
ORDER BY marka, yakit, vites;

 

/*
===============================================================================
9. HAVING - Grup Filtreleme
===============================================================================
HAVING: GROUP BY ile oluşturulan grupları filtreler
WHERE  → satırları filtreler (gruplama öncesi)
HAVING → grupları filtreler (gruplama sonrası)
*/

-- 50'den fazla aracı olan yakıt türleri
SELECT 
    yakit,
    COUNT(*) AS arac_sayisi
FROM otomobil_fiyatlari
GROUP BY yakit
HAVING COUNT(*) > 50
ORDER BY arac_sayisi DESC;

-- Ortalama fiyatı 400.000 TL'nin üzerinde olan markalar
SELECT 
    marka,
    COUNT(*) AS arac_sayisi,
    AVG(CAST(fiyat AS FLOAT)) AS ortalama_fiyat
FROM otomobil_fiyatlari
GROUP BY marka
HAVING AVG(CAST(fiyat AS FLOAT)) > 400000
ORDER BY ortalama_fiyat DESC;

-- En az 20 aracı olan ve ortalama fiyatı 300.000'in üstünde olan markalar
SELECT 
    marka,
    COUNT(*) AS arac_sayisi,
    AVG(CAST(fiyat AS FLOAT)) AS ortalama_fiyat,
    MIN(fiyat) AS en_ucuz,
    MAX(fiyat) AS en_pahali
FROM otomobil_fiyatlari
GROUP BY marka
HAVING COUNT(*) >= 20 AND AVG(CAST(fiyat AS FLOAT)) > 300000
ORDER BY ortalama_fiyat DESC;

-- Toplam değeri 10 milyon TL'nin üzerinde olan yakıt türleri
SELECT 
    yakit,
    COUNT(*) AS arac_sayisi,
    SUM(CAST(fiyat AS BIGINT)) AS toplam_deger,
    AVG(CAST(fiyat AS FLOAT)) AS ortalama_fiyat
FROM otomobil_fiyatlari
GROUP BY yakit
HAVING SUM(CAST(fiyat AS BIGINT)) > 10000000
ORDER BY toplam_deger DESC;

-- En pahalı aracı 1 milyon TL'nin üzerinde olan markalar
SELECT 
    marka,
    COUNT(*) AS arac_sayisi,
    MAX(fiyat) AS en_pahali_arac,
    AVG(CAST(fiyat AS FLOAT)) AS ortalama_fiyat
FROM otomobil_fiyatlari
GROUP BY marka
HAVING MAX(fiyat) > 1000000
ORDER BY en_pahali_arac DESC;

-- Çoklu koşullu HAVING
-- En az 10 aracı olan, ortalama fiyatı 200K-800K arası olan markalar
SELECT 
    marka,
    COUNT(*) AS arac_sayisi,
    AVG(CAST(fiyat AS FLOAT)) AS ortalama_fiyat,
    MIN(fiyat) AS en_ucuz,
    MAX(fiyat) AS en_pahali
FROM otomobil_fiyatlari
GROUP BY marka
HAVING COUNT(*) >= 10 
   AND AVG(CAST(fiyat AS FLOAT)) BETWEEN 200000 AND 800000
ORDER BY ortalama_fiyat DESC;

/*
===============================================================================
10. WHERE, GROUP BY VE HAVING BİRLİKTE KULLANIMI
===============================================================================
Çalışma Sırası: WHERE → GROUP BY → HAVING → ORDER BY
*/

-- Fiyatı 150.000 TL'den büyük araçları seç, markaya göre grupla, 
-- 5'ten fazla aracı olan markaları göster
SELECT 
    marka,
    COUNT(*) AS arac_sayisi,
    AVG(CAST(fiyat AS FLOAT)) AS ortalama_fiyat,
    MIN(fiyat) AS en_ucuz,
    MAX(fiyat) AS en_pahali
FROM otomobil_fiyatlari
WHERE fiyat > 150000                    -- Satır filtreleme
GROUP BY marka                          -- Gruplama
HAVING COUNT(*) > 5                     -- Grup filtreleme
ORDER BY ortalama_fiyat DESC;           -- Sıralama

-- Benzinli ve Dizel araçları seç, yakıt türüne göre grupla,
-- ortalama fiyatı 300.000'in üstünde olanları göster
SELECT 
    yakit,
    COUNT(*) AS arac_sayisi,
    AVG(CAST(fiyat AS FLOAT)) AS ortalama_fiyat,
    SUM(CAST(fiyat AS BIGINT)) AS toplam_deger
FROM otomobil_fiyatlari
WHERE yakit IN ('Benzin', 'Dizel')      -- Satır filtreleme
GROUP BY yakit                          -- Gruplama
HAVING AVG(CAST(fiyat AS FLOAT)) > 300000 -- Grup filtreleme
ORDER BY ortalama_fiyat DESC;

-- Motor hacmi 1500 cc üstü araçları seç, marka ve yakıt türüne göre grupla,
-- en az 3 aracı olan grupları göster
SELECT 
    marka,
    yakit,
    COUNT(*) AS arac_sayisi,
    AVG(CAST(fiyat AS FLOAT)) AS ortalama_fiyat,
    AVG(CAST(motor AS FLOAT)) AS ortalama_motor
FROM otomobil_fiyatlari
WHERE motor > 1500                      -- Satır filtreleme
GROUP BY marka, yakit                   -- Çoklu gruplama
HAVING COUNT(*) >= 3                    -- Grup filtreleme
ORDER BY marka, ortalama_fiyat DESC;

-- Karmaşık örnek: Otomatik vitesli, fiyatı 200K-1M arası araçları seç,
-- markaya göre grupla, ortalama motor hacmi 2000cc üstü olanları göster
SELECT 
    marka,
    COUNT(*) AS arac_sayisi,
    AVG(CAST(fiyat AS FLOAT)) AS ortalama_fiyat,
    AVG(CAST(motor AS FLOAT)) AS ortalama_motor,
    MIN(fiyat) AS en_ucuz,
    MAX(fiyat) AS en_pahali
FROM otomobil_fiyatlari
WHERE vites = 'Otomatik'                    -- Satır filtreleme
  AND fiyat BETWEEN 200000 AND 1000000     -- Satır filtreleme
GROUP BY marka                              -- Gruplama
HAVING AVG(CAST(motor AS FLOAT)) > 2000     -- Grup filtreleme
   AND COUNT(*) >= 5                        -- Grup filtreleme
ORDER BY ortalama_fiyat DESC;

/*
===============================================================================
11. ORDER BY - Sıralama İşlemleri
===============================================================================
ASC  → Artan sıralama (varsayılan)
DESC → Azalan sıralama
*/

-- Fiyata göre artan sıralama
SELECT marka, model, fiyat
FROM otomobil_fiyatlari
ORDER BY fiyat ASC;

-- Fiyata göre azalan sıralama
SELECT marka, model, fiyat
FROM otomobil_fiyatlari
ORDER BY fiyat DESC;

-- İlk önce markaya, sonra fiyata göre sıralama
SELECT marka, model, fiyat
FROM otomobil_fiyatlari
ORDER BY marka ASC, fiyat DESC;

-- Motor hacmine göre azalan, fiyata göre artan sıralama
SELECT marka, model, motor, fiyat
FROM otomobil_fiyatlari
ORDER BY motor DESC, fiyat ASC;

-- Gruplama ile birlikte sıralama
SELECT 
    marka,
    COUNT(*) AS arac_sayisi,
    AVG(CAST(fiyat AS FLOAT)) AS ortalama_fiyat
FROM otomobil_fiyatlari
GROUP BY marka
ORDER BY arac_sayisi DESC, ortalama_fiyat DESC;

/*
===============================================================================
12. KAPSAMLI ÖRNEKLER VE PRATİK UYGULAMALAR
===============================================================================
*/

-- ÖRNEK 1: En popüler 5 marka ve özellikleri
SELECT TOP 5
    marka,
    COUNT(*) AS arac_sayisi,
    AVG(CAST(fiyat AS FLOAT)) AS ortalama_fiyat,
    MIN(fiyat) AS en_ucuz_model,
    MAX(fiyat) AS en_pahali_model,
    AVG(CAST(motor AS FLOAT)) AS ortalama_motor
FROM otomobil_fiyatlari
GROUP BY marka
ORDER BY arac_sayisi DESC;

-- ÖRNEK 2: Yakıt türü ve vites kombinasyonları analizi
SELECT 
    yakit,
    vites,
    COUNT(*) AS arac_sayisi,
    AVG(CAST(fiyat AS FLOAT)) AS ortalama_fiyat,
    ROUND(AVG(CAST(fiyat AS FLOAT)), 0) AS yuvarlanmis_ortalama
FROM otomobil_fiyatlari
GROUP BY yakit, vites
HAVING COUNT(*) >= 10
ORDER BY ortalama_fiyat DESC;

-- Fiyat segmentlerine göre analiz
SELECT 
    CASE 
        WHEN fiyat < 200000 THEN 'Ekonomik (200K altı)'
        WHEN fiyat < 500000 THEN 'Orta Segment (200K-500K)'
        WHEN fiyat < 1000000 THEN 'Lüks (500K-1M)'
        ELSE 'Premium (1M üstü)'
    END AS segment,
    COUNT(*) AS arac_sayisi,
    ROUND(AVG(CAST(motor AS FLOAT)), 0) AS ortalama_motor,
    COUNT(CASE WHEN yakit = 'Benzin' THEN 1 END) AS benzinli_sayisi,
    COUNT(CASE WHEN yakit = 'Dizel' THEN 1 END) AS dizel_sayisi,
    COUNT(CASE WHEN vites = 'Otomatik' THEN 1 END) AS otomatik_sayisi,
    ROUND(AVG(CAST(fiyat AS FLOAT)), 0) AS ortalama_fiyat
FROM otomobil_fiyatlari
GROUP BY 
    CASE 
        WHEN fiyat < 200000 THEN 'Ekonomik (200K altı)'
        WHEN fiyat < 500000 THEN 'Orta Segment (200K-500K)'
        WHEN fiyat < 1000000 THEN 'Lüks (500K-1M)'
        ELSE 'Premium (1M üstü)'
    END
ORDER BY ortalama_fiyat;

-- ÖRNEK 4: Marka bazında detaylı karşılaştırma
SELECT 
    marka,
    COUNT(*) AS toplam_model,
    
    -- Fiyat istatistikleri
    MIN(fiyat) AS en_ucuz,
    MAX(fiyat) AS en_pahali,
    AVG(CAST(fiyat AS FLOAT)) AS ortalama_fiyat,
    
    -- Motor istatistikleri
    MIN(motor) AS en_kucuk_motor,
    MAX(motor) AS en_buyuk_motor,
    AVG(CAST(motor AS FLOAT)) AS ortalama_motor,
    
    -- Yakıt türü dağılımı
    SUM(CASE WHEN yakit = 'Benzin' THEN 1 ELSE 0 END) AS benzinli_adet,
    SUM(CASE WHEN yakit = 'Dizel' THEN 1 ELSE 0 END) AS dizel_adet,
    SUM(CASE WHEN yakit NOT IN ('Benzin', 'Dizel') THEN 1 ELSE 0 END) AS diger_yakit,

    --CASE WHEN ... THEN 1 ELSE 0 END → satır bazlı koşul kontrolü yapar.Eğer koşul doğruysa 1, yanlışsa 0 döner.
--SUM(...) → Bu 1’leri toplar, yani koşulu sağlayan satırların sayısını verir.
    
    -- Vites türü dağılımı
    SUM(CASE WHEN vites = 'Otomatik' THEN 1 ELSE 0 END) AS otomatik_adet,
    SUM(CASE WHEN vites = 'Manuel' THEN 1 ELSE 0 END) AS manuel_adet
FROM otomobil_fiyatlari
GROUP BY marka
HAVING COUNT(*) >= 10  -- En az 10 modeli olan markalar
ORDER BY toplam_model DESC;

-- ÖRNEK 5: En değerli araç kategorileri
SELECT TOP 10
    marka + ' ' + model AS arac_adi,
    fiyat,
    motor,
    yakit,
    vites,
    -- Fiyat kategorisi
    CASE 
        WHEN fiyat >= 2000000 THEN 'Ultra Lüks'
        WHEN fiyat >= 1000000 THEN 'Lüks'
        WHEN fiyat >= 500000 THEN 'Premium'
        ELSE 'Standart'
    END AS kategori,
    -- Motor gücü kategorisi
    CASE 
        WHEN motor >= 3000 THEN 'Yüksek Performans'
        WHEN motor >= 2000 THEN 'Orta Performans'
        ELSE 'Standart Performans'
    END AS performans_kategorisi
FROM otomobil_fiyatlari
WHERE fiyat IS NOT NULL AND motor IS NOT NULL
ORDER BY fiyat DESC;

/*
===============================================================================
13. PRATİK ALIŞTIRMALAR
===============================================================================
Aşağıdaki soruları çözmeye çalışın:
*/

-- ALIŞTIRMA 1: Fiyatı 300.000-700.000 TL arasında olan Benzinli araçların 
-- marka bazında sayısını ve ortalama motor hacmini bulun.

-- ALIŞTIRMA 2: Otomatik vitesli araçlar arasında, motor hacmi 2000cc'nin 
-- üzerinde olan araçların marka ve model bilgilerini fiyata göre sıralayın.
 
-- ALIŞTIRMA 3: Yakıt türü ve vites kombinasyonlarına göre, 
-- en ucuz ve en pahalı araç fiyatlarını bulun.

/*
===============================================================================
14. ÇÖZÜMLER
===============================================================================
*/

-- ÇÖZÜM 1:
SELECT 
    marka,
    COUNT(*) AS arac_sayisi,
    AVG(CAST(motor AS FLOAT)) AS ortalama_motor
FROM otomobil_fiyatlari
WHERE fiyat BETWEEN 300000 AND 700000 
  AND yakit = 'Benzin'
GROUP BY marka
ORDER BY arac_sayisi DESC;


-- ÇÖZÜM 2:
SELECT marka, model, fiyat, motor
FROM otomobil_fiyatlari
WHERE vites = 'Otomatik' 
  AND motor > 2000
ORDER BY fiyat DESC;


-- ÇÖZÜM 3:
SELECT 
    yakit,
    vites,
    MIN(fiyat) AS en_ucuz,
    MAX(fiyat) AS en_pahali,
    COUNT(*) AS arac_sayisi
FROM otomobil_fiyatlari
GROUP BY yakit, vites
ORDER BY yakit, vites;

 

/*
===============================================================================
SON NOTLAR
===============================================================================
- SQL komutları büyük/küçük harf duyarsızdır ama okunabilirlik için 
  büyük harf kullanılması önerilir
- String değerler tek tırnak (') içinde yazılır
- Karmaşık sorgularda parantez kullanarak öncelik sırası belirleyin
- Her zaman veri tipine uygun karşılaştırma yapın
- Performans için gereksiz * kullanmaktan kaçının
- WHERE koşullarını mümkün olduğunca spesifik yazın
*/
