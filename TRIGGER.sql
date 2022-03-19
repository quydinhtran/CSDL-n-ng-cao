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
('ORD12',    '2023/6/19',    'Da Xu Ly',    35000,     'KH1','MaTT01'),
('ORD11',    '2022/4/21',    'chua xu ly',    700000,     'KH2','MaTT02'),
('ORD1',    '2021/2/20',    'Cho Xu Ly',   7500000,     'KH1','MaTT01'),
('ORD2',    '2021/1/19',    'Cho Xu Ly',   9050000,     'KH2','MaTT01'),
('ORD3',    '2021/5/09',    'Da Xu Ly',    6500000,     'KH1','MaTT01'),
('ORD4',    '2021/9/20',    'Cho Xu Ly',   5000000,     'KH1','MaTT02'),
('ORD5',    '2021/10/19',    'Da Xu Ly',    905000,     'KH3','MaTT01'),
('ORD6',    '2022/3/09',    'Cho Xu Ly',   300000,     'KH3','MaTT02'),
('ORD7',    '2022/9/21',    'Cho Xu Ly',   500000,     'KH4','MaTT01'),
('ORD8',    '2021/6/19',    'Da Xu Ly',    600000,     'KH5','MaTT01'),
('ORD9',    '2020/3/09',    'Da Xu Ly',    500000,     'KH6','MaTT01'),
GO
INSERT INTO PRODUCT
(
	MaSP,
	tenSP,
	mota,
	giaSP,
	soluongSP
)
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
('CT01',1,600000,6010000,'ORD3','SP001'),
('CT02',2,700000,7010000,'ORD1','SP002'),
('CT03',5,900000,9010000,'ORD2','SP003'),
('CT04',1,200000,2010000,'ORD7','SP005'),
('CT05',3,300000,910000,'ORD5','SP004'),
('CT06',1,150000,155000,'ORD9','SP006')
GO
--Trigger: Tg_TongChiTiet. Khi thực hiện xóa bảng ghi trong bảng ORDER_DETAILS thì hiển thị tổng số lượng bảng ghi còn lại.(THÀNH)

CREATE TRIGGER Tg_TongChiTiet ON ORDER_DETAILS FOR DELETE
AS
BEGIN
	DECLARE @Tong int
	SELECT @Tong = COUNT(*) FROM ORDER_DETAILS
	PRINT N'Tổng số bản ghi còn lại trong bảng ORDER_DETAILS là: ' + CAST(@Tong AS varchar(10))
END
GO

DELETE  FROM ORDER_DETAILS
  WHERE MaCTSP='CT01';
 --KHÔNG ĐƯỢC XÓA NHƯNG ĐƠN HÀNG CÓ NĂM ĐẶT HÀNG NHỎ HƠN 1(QUÝ)
CREATE TRIGGER [dbo].[XTTKH]
  ON [dbo].[ORDERS]
  FOR DELETE 
  AS
  BEGIN 
	DECLARE @COUNT INT=0
	SELECT @COUNT=COUNT(*) FROM deleted 
	WHERE YEAR(GETDATE()- YEAR(deleted.ngaydat))<1
	IF (@COUNT<1)
	BEGIN
	PRINT N'KHÔNG ĐƯỢC XÓA ĐƠN NÀY'
		ROLLBACK TRAN
	END
  END
  DELETE ORDERS WHERE MaDH='ORD7'
--Viết Trigger khi thêm PTTT thì kiểm tra nếu mã tt (lỘC)
--không có trong bảng PAYMENT thì không cho thêm và thông báo lỗi
CREATE TRIGGER add_PAYMENT
ON PAYMENT
AFTER INSERT
AS
     DECLARE @maTT varchar(10), @tenPTTT varchar(100),@phiTT money
    --Đọc dữ liệu trong bảng tạm inserted
    SELECT @maTT = maTT FROM inserted
    --Kiểm tra mã tt
    IF EXISTS(SELECT maTT FROM PAYMENT WHERE maTT = @maTT)
    BEGIN
        ROLLBACK
        RAISERROR(N'Mã tt không hợp lệ!', 16, 1 )
        RETURN
    END
GO
--Kiểm tra
INSERT PAYMENT VALUES ('MaTT07','Zalo',20000)

select * from PAYMENT	
go
--cập nhật số lượng SP trong PRODUCT sau khi mua hoặt cập nhật(PHƯƠNG)
CREATE TRIGGER trg_ORDER_DETAILS on ORDER_DETAILS FOR INSERT
AS
BEGIN
     UPDATE PRODUCT
	 SET soluongSP = soluongSP - (
	 SELECT soluongmua
	 FROM inserted
	 WHERE maSP = PRODUCT.maSP
	 )
	 FROM PRODUCT
	 JOIN inserted ON PRODUCT.maSP = inserted.maSP
END

INSERT INTO ORDER_DETAILS VALUES
('CT012',4,4490000,4500000,'ORD5','SP002')
-- Tạo TRIGGER để thêm mới sản phẩm mà giá sản phẩm phải > 200000, nếu sai sẽ trả về thông báo "giá sản phẩm phải > 200000"(NHI)
CREATE TRIGGER trigger_checksalary200000
ON PRODUCT
FOR INSERT, UPDATE
AS
IF (SELECT giaSP FROM INSERTED) < 200000
BEGIN
PRINT 'giaSP < 200000';
ROLLBACK TRANSACTION;
END;

SELECT * FROM PRODUCT

SELECT * FROM PRODUCT
-- 1: Tạo trigger để kiểm tra khi thêm một hóa đơn mới,(NHUNG)
-- kiểm tra xem số lượng mua nhỏ hơn so với số lượng trong bảng sản phẩm hay không, nếu nhỏ hơn thì
-- giảm số lượng sản phẩm trong kho
alter trigger CHECK_UPDATE_ORDERED on ORDER_DETAILS
for INSERT
as begin
	declare @soluongmua int
	declare @soluonghienco int
	select @soluongmua = soluongmua from inserted
	select @soluonghienco = soluongSP from PRODUCT where MaSP in(select MaSP from  inserted)
	if @soluonghienco < @soluongmua 
		begin
		print N'Vượt quá số lượng hiện có!, Số lượng mua phải nhỏ hơn '+convert(varchar(10),@soluonghienco)
		rollback transaction
		end
	update PRODUCT set soluongSP = @soluonghienco - @soluongmua where maSP in (select MaSP from  inserted)
end
go
-- 1: Tạo trigger để sau khi xóa một bản ghi trong bảng thanh toán thì hiển thị tên kiểu thanh toán đã xóa và(MỸ)
--    số bản ghi còn lại của bảng PAYMENT
GO
create trigger PAYMENT_AFTER_DEL on PAYMENT 
AFTER DELETE
as begin
	declare @SUM varchar(200)
	declare @tenTT varchar(100)
	select @SUM = count(maTT) from PAYMENT
	select @tenTT = tenPTTT from deleted
	print N'Đã xóa kiểu thanh toán:'+@tenTT
	print N'Số bản ghi còn lại trong bảng thanh toán là:'+@SUM
end
