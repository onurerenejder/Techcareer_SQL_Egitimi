/*
View Nedir? Basit View Oluşturma ve Raporlamada Kullanımı
View: Bir veya daha fazla tablodan seçilen verileri sanal bir tablo gibi sunan, sunucu tarafında saklanan SELECT ifadesidir.
Veri kopyalamaz, sadece sorguyu saklar.

"Neden kullanırız?"
- Tekrar eden kompleks sorguları tek bir isim altında toplamak
- Raporlama katmanını standartlaştırmak ve basitleştirmek
- Güvenlik ile belirli kolon/satırlara erişimi kısıtlamak (tablolara doğrudan yetki vermeden)
- Uygulamalarda sorgu değişikliklerini view içinde yapmak (uygulama kodunu dokunmadan)

*/

--Basit View Oluşturma
CREATE VIEW dbo.vw_MusteriSonSiparis -- View adı ve şeması (dbo) verilir
AS
SELECT 
    m.müşteri_id,                    -- Join ve raporlamada kullanılacak anahtar
    m.müşteri_adi,                   -- Görsel rapor çıktısı için müşteri adı
    MAX(s.sipariş_tarihi) AS son_sipariş_tarihi, -- Müşterinin en son sipariş tarihi
    COUNT(s.sipariş_id)   AS sipariş_sayısı,     -- Toplam sipariş sayısı
    SUM(s.toplam_tutar)   AS toplam_harcama      -- Toplam harcama
FROM dbo.Müşteriler AS m               -- Ana tablo: tüm müşteriler
LEFT JOIN dbo.Siparişler AS s          -- LEFT JOIN: siparişi olmayanı da göster
    ON s.müşteri_id = m.müşteri_id
GROUP BY m.müşteri_id, m.müşteri_adi;  -- Agregasyonlar için zorunlu gruplama




-- Parametre taklidi: View sonucunu dışarıdan filtrele
SELECT müşteri_adi, toplam_harcama
FROM dbo.vw_MusteriSonSiparis
WHERE toplam_harcama > 100; -- 100tl üstü harcayan müşteriler


-- View üzerinden JOIN: ek detayları sipariş tablosundan al (son 365 günde sipariş yoksa sonuç boş gelebilir)
SELECT v.müşteri_adi, s.sipariş_id, s.toplam_tutar
FROM dbo.vw_MusteriSonSiparis AS v
JOIN dbo.Siparişler AS s 
    ON s.müşteri_id = v.müşteri_id
WHERE s.sipariş_tarihi >= DATEADD(DAY, -365, GETDATE()); -- Son 1 yıl

/*
Özellikleri
JOIN yapıyor → vw_MusteriSonSiparis (müşteri bilgileri + son sipariş) ile Siparişler tablosunu birleştiriyor.
Filtre: s.sipariş_tarihi >= DATEADD(DAY, -365, GETDATE())
→ Yani son 365 gün içinde verilmiş tüm siparişleri getiriyor.
Çıktı:
müşteri_adi (view’den geliyor),
sipariş_id, toplam_tutar (Siparişler’den geliyor).
 Yani bu sorgu, son 1 yıl içindeki bütün siparişleri müşteri bazında listeler. Bir müşteri 10 sipariş verdiyse, hepsi ayrı satır olur.
*/

/*
DATEADD → SQL Server fonksiyonu; bir tarihe belirtilen miktarda birim ekler (veya negatif değerse çıkarır).
DAY → datepart: hangi zaman birimiyle işlem yapılacağını belirler (gün). DAY yerine YEAR, MONTH, HOUR vb. de kullanabilirsin.
-365 → number: eklenen (veya çıkarılan) birim sayısı. Burada -365 olduğu için 365 gün geriye gidiliyor. Pozitif olsaydı ileri giderdi.
GETDATE() → üçüncü argüman: başlangıç tarihi (SQL Server sunucusunun o anki tarih + saat değeri). DATEADD bu tarihe -365 gün uygular.
*/



-- View Güncelleme ve Silme
    -- Mevcut view'ı yeni kolonlar ile güncelle
ALTER VIEW dbo.vw_MusteriSonSiparis
AS
SELECT 
    m.müşteri_id,
    m.müşteri_adi,
    MAX(s.sipariş_tarihi) AS son_sipariş_tarihi,
    COUNT(s.sipariş_id)   AS sipariş_sayısı,
    SUM(s.toplam_tutar)   AS toplam_harcama,
    MIN(s.sipariş_tarihi) AS ilk_sipariş_tarihi -- Yeni eklenen metrik
FROM dbo.Müşteriler AS m
LEFT JOIN dbo.Siparişler AS s ON s.müşteri_id = m.müşteri_id
GROUP BY m.müşteri_id, m.müşteri_adi;
    

-- View sil: varsa kaldır, yoksa hata verme
DROP VIEW IF EXISTS dbo.vw_MusteriSonSiparis;


/*
Index Nedir? Ne İşe Yarar?
Index, tabloda arama/sıralama işlemlerini hızlandıran veri yapılarıdır. Okuma performansını artırır; yazma (INSERT/UPDATE/DELETE)
maliyetini bir miktar yükseltir.

"Ne zaman eklemeliyiz?"
- Sorgularınız sık sık belirli kolonlarda filtre yapıyorsa (`WHERE müşteri_id = ?`)
- JOIN yapılan kolonlar
- Sık sıralanan (`ORDER BY tarih DESC`) veya gruplanan kolonlar

"Ne zaman eklememeliyiz?"
- Çok düşük seçicilikli kolonlar (örn. `durum` sadece 3-4 değer içeriyor ve tablo küçükse)
- Çok sık güncellenen kolonlar (update maliyeti)

Faydalar
- WHERE, JOIN, ORDER BY, GROUP BY performansını ciddi biçimde artırır
- Selektif (cardinality yüksek) sütunlarda daha etkilidir

Maliyetler
- Ek depolama alanı
- Yazma ve bakım maliyeti (rebuild/reorganize)
*/


/*
Clustered vs Non-Clustered Index

- Clustered Index: Tablo verisinin fiziksel sırasını belirler. Her tabloda en fazla 1 adet olabilir. Genellikle birincil anahtar üzerinde olur.
- Non-Clustered Index: Veri kopyalanmaz; ana tabloya işaret eden ayrı bir yapıdadır. Bir tabloda birçok nonclustered index olabilir.

"Clustered key nasıl seçilir?"
- Sık artan, dar (küçük boyutlu), değişmeyen bir kolon tercih edilir (örn. IDENTITY)
- Geniş ve sık değişen kolonları clustered key yapmayın (parçalanma ve güncelleme maliyeti artar)
*/

-- Clustered index (genelde PK ile gelir) örneği
CREATE TABLE dbo.Siparişler (
    sipariş_id INT IDENTITY(1,1) PRIMARY KEY, -- Sık artan clustered key
    müşteri_id INT NOT NULL,                   -- JOIN/filtre kolonu
    sipariş_tarihi DATETIME NOT NULL DEFAULT GETDATE(), -- Aralık sorguları için
    toplam_tutar DECIMAL(10,2) NOT NULL        -- Miktar
);


-- Nonclustered index
CREATE NONCLUSTERED INDEX IX_Siparisler_Musteri_Tarih
ON dbo.Siparişler(müşteri_id, sipariş_tarihi); -- Key sırası: müşteri → tarih

/*
Siparişler tablosu üzerinde bir nonclustered index oluşturduk.
İndeksin adı: IX_Siparisler_Musteri_Tarih
İndeksin tuttuğu sütunlar: müşteri_id, sipariş_tarihi
Bu şu demek: SQL Server artık Siparişler tablosunda müşteri_id ve sipariş_tarihi üzerinden hızlı arama yapabilecek bir yapı oluşturdu.
*/


 /*
Açıklama
- `IDENTITY(1,1)`: Sık artan, dar ve değişmeyen bir anahtar üretir; clustered index için idealdir.
- `PRIMARY KEY`: Varsayılan olarak clustered index oluşturur (tablo başına bir tane). Fiziksel sıralamayı belirler.
- `CREATE NONCLUSTERED INDEX ... (müşteri_id, sipariş_tarihi)`: En çok filtrelenen/sıralanan kolonları key'e alır. 
Aralık sorgularında (`BETWEEN`) tarih ikinci kolonda olduğu için etkili tarama yapılır.
 */


-- Kullanım Demosu (Execution Plan ile doğrulayın)
 
-- IX_Musteriler_Email kullanımı: e-posta ile arama
-- Actual Execution Plan'i açın ve SEEK bekleyin
SELECT müşteri_id, müşteri_adi, email
FROM dbo.Müşteriler
WHERE email = 'ali@email.com';


--bunun çalışması için "IX_Musteriler_Email"  bunun oluşması lazım
-- Aynı sorguyu index ipucu ile zorlayarak çalıştırma (karşılaştırma için)

SELECT müşteri_id, müşteri_adi, email
FROM dbo.Müşteriler WITH (INDEX(IX_Musteriler_Email))
WHERE email = 'ali@email.com';


-- 2) IX_Siparisler_Musteri_Tarih kullanımı: müşteri + tarih aralığı
SELECT sipariş_id, müşteri_id, sipariş_tarihi, toplam_tutar
FROM dbo.Siparişler
WHERE müşteri_id = 1
  AND sipariş_tarihi BETWEEN '2025-01-01' AND '2025-12-31'
ORDER BY sipariş_tarihi DESC;

-- Index sil: varsa kaldır
DROP INDEX IF EXISTS IX_Siparisler_Musteri_Tarih ON dbo.Siparişler;



-- Index Kullanımını Analiz Etme

SELECT 
    DB_NAME(database_id) AS veritabani_adi,    -- Veritabanı adı
    OBJECT_NAME(s.object_id) AS tablo_adi,     -- Tablo adı
    i.name AS indeks_adi,                      -- İndeks adı
    user_seeks AS kullanim_arama,              -- Index Seek (arama sayısı)
    user_scans AS kullanim_tarama,             -- Index Scan (tam tarama sayısı)
    user_lookups AS kullanim_lookup,           -- Key Lookup (ek okuma sayısı)
    user_updates AS kullanim_guncelleme        -- Index Update (güncelleme sayısı)
FROM sys.dm_db_index_usage_stats AS s
JOIN sys.indexes AS i 
    ON i.object_id = s.object_id 
   AND i.index_id = s.index_id
WHERE s.database_id = DB_ID();



--TRUNCATE vs DELETE

/*
-TRUNCATE TABLE
- Tüm satırları çok hızlı siler (sayfa bazlı boşaltma)
- WHERE desteklemez
- Identity sayacını sıfırlar
- DML trigger tetiklemez
- Yabancı anahtar ile referans edilen tablolarda kullanılamaz


*/
-- Tüm satırları hızlıca sil ve identity'yi sıfırla (FK yoksa)
TRUNCATE TABLE dbo.GeciciLog; -- Hızlı, minimal log, identity reset
/*
Açıklama
- TRUNCATE, sayfa bazlı boşaltmayla çok hızlı çalışır ve minimal log yazar.
- Identity tohumunu (seed) başlangıca çeker; yeni eklenen kayıtlar kimliği baştan alır.
- WHERE desteklemez; tüm tabloyu boşaltır. FK kısıtı varsa çalışmaz.

DELETE
- Satır satır siler; WHERE ile kısmi silme yapılabilir
- Identity sayacını sıfırlamaz
- Trigger çalışır
- Daha fazla log üretir, yavaştır (büyük veri setlerinde)
*/



 

--Senaryo : Haftalık Satış Raporu View'ı
 
CREATE VIEW dbo.vw_HaftalikSatis
AS
SELECT 
    CONVERT(date, s.sipariş_tarihi) AS tarih,
    DATEPART(ISO_WEEK, s.sipariş_tarihi) AS hafta,
    m.müşteri_adi,
    SUM(s.toplam_tutar) AS toplam_harcama,
    COUNT(*) AS sipariş_sayısı
FROM dbo.Siparişler AS s
JOIN dbo.Müşteriler AS m ON m.müşteri_id = s.müşteri_id
GROUP BY CONVERT(date, s.sipariş_tarihi), DATEPART(ISO_WEEK, s.sipariş_tarihi), m.müşteri_adi;
GO

-- Rapor kullanımı
SELECT TOP 10 * FROM dbo.vw_HaftalikSatis ORDER BY toplam_harcama DESC;