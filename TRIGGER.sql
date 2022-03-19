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
--alter trigger CHECK_UPDATE_ORDERED on ORDER_DETAILS(NHUNG)
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