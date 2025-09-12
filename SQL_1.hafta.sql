CREATE DATABASE PERSONEL --veri tabaný oluþtur 


--tablo oluþtur , yani varlýk oluþtur 
CREATE TABLE KULLANICILAR (
id INT IDENTITY(1,1) PRIMARY KEY , --nitelik , int tipinde , oto artan ,pk
ad NVARCHAR(50)  ,  --nitelik , ad , nvarchar tipinde 
soyad NVARCHAR(50),
yas INT ,
);


select * from KULLANICILAR --tüm sorgularý getirir , * = hepsi , tümü 

select ad from KULLANICILAR -- sadece ad sütünü getir

select ad , soyad from KULLANICILAR  -- sadece ad ve soyad sütünü getir


-- kullanýcýlar tablosuna veri ekleme 
INSERT INTO KULLANICILAR (ad,soyad,yas) values ('kemal','tas',36)


-- kullanýcýlar tablosunu güncelledim , 
UPDATE KULLANICILAR 
SET yas = 25  -- yaþý 25 olarak ayarla 
where ad = 'ayse' --adý ayse olana göre


-- kullanýcýlar tablosundan veri sildik 
DELETE FROM KULLANICILAR
where id=1  -- id si 1 olan kullanýcýyý sil 


select DISTINCT ad --eþsiz deðerleri getir 
from KULLANICILAR


select top 2 ad   --seçtiðimiz adet kadar veri getirir 
from KULLANICILAR