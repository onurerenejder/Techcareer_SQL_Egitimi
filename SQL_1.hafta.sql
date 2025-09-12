CREATE DATABASE PERSONEL --veri taban� olu�tur 


--tablo olu�tur , yani varl�k olu�tur 
CREATE TABLE KULLANICILAR (
id INT IDENTITY(1,1) PRIMARY KEY , --nitelik , int tipinde , oto artan ,pk
ad NVARCHAR(50)  ,  --nitelik , ad , nvarchar tipinde 
soyad NVARCHAR(50),
yas INT ,
);


select * from KULLANICILAR --t�m sorgular� getirir , * = hepsi , t�m� 

select ad from KULLANICILAR -- sadece ad s�t�n� getir

select ad , soyad from KULLANICILAR  -- sadece ad ve soyad s�t�n� getir


-- kullan�c�lar tablosuna veri ekleme 
INSERT INTO KULLANICILAR (ad,soyad,yas) values ('kemal','tas',36)


-- kullan�c�lar tablosunu g�ncelledim , 
UPDATE KULLANICILAR 
SET yas = 25  -- ya�� 25 olarak ayarla 
where ad = 'ayse' --ad� ayse olana g�re


-- kullan�c�lar tablosundan veri sildik 
DELETE FROM KULLANICILAR
where id=1  -- id si 1 olan kullan�c�y� sil 


select DISTINCT ad --e�siz de�erleri getir 
from KULLANICILAR


select top 2 ad   --se�ti�imiz adet kadar veri getirir 
from KULLANICILAR