CREATE DATABASE QL_MUAHANG
GO
USE QL_MUAHANG
GO
CREATE TABLE CUSTOMER
(
MaKH NVARCHAR(10) ,
hoten NVARCHAR(100),
email NVARCHAR(100),
sdt NVARCHAR(15),
diachi NVARCHAR(100)
CONSTRAINT ctm
PRIMARY KEY (MaKH)
)
GO
CREATE TABLE PAYMENT
(
MaTT NVARCHAR(10),
tenPTTT NVARCHAR(100),
phiTT MONEY
CONSTRAINT pm
PRIMARY KEY (MaTT)
)
GO
CREATE TABLE ORDERS
(
MaDH NVARCHAR(10),
ngaydat date,
trangthai varchar(10),
tongtien money,
MaKH NVARCHAR(10),
MaTT NVARCHAR(10)
CONSTRAINT od
PRIMARY KEY (MaDH),
FOREIGN KEY (MaKH)REFERENCES CUSTOMER,
FOREIGN KEY (MaTT)REFERENCES PAYMENT
)
GO
CREATE TABLE PRODUCT
(
MaSP NVARCHAR(10),
tenSP NVARCHAR(100),
mota NVARCHAR(100),
giaSP money,
soluongSP INT
CONSTRAINT prd
PRIMARY KEY (MaSP)
)
GO
CREATE TABLE ORDER_DETAILS
(
MaCTSP NVARCHAR(10),
soluongmua int,
gia money,
thanhtien money,
MaDH NVARCHAR(10),
MaSP NVARCHAR(10)
CONSTRAINT ord
PRIMARY KEY(MaCTSP)
FOREIGN KEY (MaDH) references ORDERS,
FOREIGN KEY (MaSP) references PRODUCT
)
GO
INSERT INTO CUSTOMER
(
	MaKH,
	hoten,
	email,
	sdt,
	diachi
)
VALUES

('KH1','tran dinh quy','quy@gmail.com','0816832749','quang ngai'),
('KH2','tran thi hoang my','my@gmail.com','0816832748','hue'),
('KH3','nguyen thi bich phuong','phuong@gmail.com','0816832742','da nang'),
('KH4','nguyen thi xuan loc','loc@gmail.com','0816532746','da nang'),
('KH5','uong minh thanh','thanh@gmail.com','08168232745','da nang'),
('KH6','nguyen thao nhi','nhi@gmail.com','0816832714','ha tinh'),
('KH7','pham thi nhung','nhung@gmail.com','0816832743','Da Nang')
GO
INSERT INTO PAYMENT
(
	MaTT,
	tenPTTT,
	phiTT
)
VALUES
('MaTT01',    'MOMO',        10000),
('MaTT02',    'ATM',         5000)
GO
INSERT INTO ORDERS
(
	MaDH,
	ngaydat,
	trangthai,
	tongtien,
	MaKH,
	MaTT
)
VALUES
('ORD1',    '2021/2/20',    'Cho Xu Ly',   7500000,     'KH1','MaTT01'),
('ORD2',    '2021/1/19',    'Cho Xu Ly',   9050000,     'KH2','MaTT01'),
('ORD3',    '2021/5/09',    'Da Xu Ly',    6500000,     'KH1','MaTT01'),
('ORD4',    '2021/9/20',    'Cho Xu Ly',   5000000,     'KH1','MaTT02'),
('ORD5',    '2021/10/19',    'Da Xu Ly',    905000,     'KH3','MaTT01'),
('ORD6',    '2022/3/09',    'Cho Xu Ly',   300000,     'KH3','MaTT02'),
('ORD7',    '2022/9/21',    'Cho Xu Ly',   500000,     'KH4','MaTT01'),
('ORD8',    '2021/6/19',    'Da Xu Ly',    600000,     'KH5','MaTT01'),
('ORD9',    '2020/3/09',    'Da Xu Ly',    500000,     'KH6','MaTT01')
GO
INSERT INTO PRODUCT
(
	MaSP,
	tenSP,
	mota,
	giaSP,
	soluongSP
)
VALUES
('SP008','samsung A50','android 9.0',4490000,10),
('SP001','samsung',                     'android 9.0',    6000000,    10),
('SP002','oppo',                        'android 8.0',    7000000,    20),
('SP003','vivo',                        'android 7.0',    9000000,    100),
('SP004','op lung samsung a50',         'nho gon',        300000,     50),
('SP005','tai nghe airport',            'chat luong cao', 200000,     30),
('SP006','chuot khong day gamming',     'muot ma',        150000,     200)
GO
INSERT INTO ORDER_DETAILS
(
	MaCTSP,
	soluongmua,
	gia,
	thanhtien,
	MaDH,
	MaSP
)
VALUES
('CT011',1,4490000,4500000,'ORD4','SP008'),
('CT01',1,600000,6010000,'ORD3','SP001'),
('CT02',2,700000,7010000,'ORD1','SP002'),
('CT03',5,900000,9010000,'ORD2','SP003'),
('CT04',1,200000,2010000,'ORD7','SP005'),
('CT05',3,300000,910000,'ORD5','SP004'),
('CT06',1,150000,155000,'ORD9','SP006')
GO
---YÊU CÂU 2: TRUY VẤN NÂNG CAO
---câu 1 : liệt kê 3 mặt hàng được khách hàng ưa chuộng nhất (nhung)
SELECT*FROM PRODUCT WHERE MaSP in(SELECT TOP 3 MaSP FROM ORDER_DETAILS GROUP BY MaSP,soluongmua ORDER BY SUM(soluongmua) DESC)

---Câu 2: Liệt kê thông tin kiểu thanh toán được dùng nhiều nhất (nhung)
SELECT*FROM PAYMENT WHERE MaTT in( SELECT TOP 1 MaTT FROM ORDERS GROUP BY MaTT ORDER BY COUNT(MaTT) DESC)


---Yêu cầu 3: VIEW
--câu 1: tạo một khung nhìn có tên là V_MUAHANG để lấy thông tin của người mua hàng có đơn đặt hàng  và địa chỉ là "đà nẵng"(quý)
CREATE VIEW DC_MUAHANG
AS
SELECT c.hoten,o.MaKH,c.diachi FROM ORDERS AS o JOIN CUSTOMER AS c ON c.MaKH = o.MaKH WHERE c.diachi='da nang'

SELECT*FROM  DC_MUAHANG

--câu 2: tạo một khung nhìn có tên là V_PTTT để lấy ra thông tin khách hàng có phương thức thanh toán là "MoMo" và trạng thái đang "chờ xử lý" (mỹ)
CREATE VIEW V_PTTT
AS
SELECT C.hoten,o.MaKH,p.MaTT,p.tenPTTT
  FROM CUSTOMER AS c JOIN PAYMENT AS p JOIN ORDERS AS o ON o.MaTT = p.MaTT ON o.MaKH = c.MaKH 
WHERE o.trangthai='Cho Xu Ly' AND p.tenPTTT='MOMO'
  
  SELECT*FROM V_PTTT
  --Câu 3: Tạo view để xem 3 mặt hàng được khách ưa chuộng (Nhung)
CREATE VIEW Top_3_SP_favorit AS
  SELECT*FROM PRODUCT WHERE MaSP in(  SELECT TOP 3 MaSP FROM ORDER_DETAILS GROUP BY MaSP,soluongmua ORDER BY SUM(soluongmua)DESC )
GO
SELECT*FROM Top_3_SP_favorit



--Yêu cầu 4 : PROC
-- Câu 1: Tạo Procedure để xóa thông tin của một Product nào đó với Mã sản phẩm là một tham số truyền vào(phương)
CREATE PROCEDURE delete_Product (@MaSP NVARCHAR(10))
AS
BEGIN
	DELETE FROM PRODUCT WHERE PRODUCT.MaSP=@MaSP
END
EXECUTE delete_Product 'SP001'
SELECT*FROM  PRODUCT

--Câu 2:  Tạo Procedure để thêm một phương thức thanh toán(lộc)
SELECT*FROM PAYMENT 
GO
CREATE PROC add_PAYMENT @MaTT NVARCHAR(10), @tenPTTT NVARCHAR(100),@phiTT MONEY
AS
BEGIN
	
	IF EXISTS (SELECT MaTT FROM PAYMENT WHERE MaTT= @MaTT)
		BEGIN
			PRINT N'Vui lòng nhập mã thanh toán khác'
			RETURN
		END
	IF EXISTS (SELECT*FROM PAYMENT WHERE tenPTTT= @tenPTTT)
		BEGIN
			PRINT N'Vui lòng nhập tên thanh toán khác'
			RETURN
		END
	INSERT INTO PAYMENT VALUES(@MaTT,@tenPTTT,@phiTT)
END
GO
EXEC add_PAYMENT 'MaTT07','Zalo',20000
GO

SELECT *FROM PAYMENT	
GO



-- Yêu cầu 5: FUNCTION
-- Câu 1: Tạo Function có tên là T_TongTien. Khi truyền vào MaKH hiển thị ra số tiền mà khách hàng đã mua.(thành)
CREATE FUNCTION T_Tongtien(@MaKH NVARCHAR(10))
RETURNS bigint
AS
BEGIN
	DECLARE @TongTien bigint
	SELECT @TongTien = SUM(tongtien)
	FROM ORDERS
	WHERE MaKH=@MaKH
	RETURN @TongTien
END
GO

SELECT dbo.T_TongTien ('KH1') TongTien

-- Câu 2: Tạo function để hiển thị top 3 thông tin soluongSP tăng dần(nhi)
CREATE FUNCTION PRODUCTION_SORT_ASC()
RETURNS TABLE 
AS RETURN
SELECT TOP 3 * FROM PRODUCT ORDER BY soluongSP ASC

SELECT * FROM PRODUCTION_SORT_ASC()

 --Câu 3: tạo một table function trả về danh sách các sản phẩm bao gồm tên sản phẩm, giá sản phẩm đã mua (mỹ)
  CREATE FUNCTION spproduct
  (@MaSP NVARCHAR (10))
  RETURNS TABLE
  AS
  RETURN
  SELECT p.MaSP,p.tenSP,od.thanhtien,od.soluongmua
    FROM PRODUCT AS p JOIN ORDER_DETAILS AS od ON od.MaSP = p.MaSP
  WHERE od.MaSP LIKE @MaSP
  
  SELECT*FROM spproduct('SP002')
  

