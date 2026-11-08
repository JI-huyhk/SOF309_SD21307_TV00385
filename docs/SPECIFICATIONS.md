# ĐẶC TẢ YÊU CẦU NGHIỆP VỤ HỆ THỐNG (SPECIFICATIONS)
> Dự án: Hệ Thống Quản Lý Đặt Phòng Khách Sạn (Verdelle Hotel)
> Ngữ cảnh kỹ thuật: Java 17, Jakarta Servlet / JSP, SQL Server, Hibernate/JPA, Maven

---

## 1. THÔNG TIN DỰ ÁN
* **Tên đề tài:** Hệ Thống Quản Lý Đặt Phòng Khách Sạn Verdelle Hotel
* **Kiến trúc:** Mô hình MVC (Model - View - Controller), kết nối SQL Server qua JDBC/JPA
* **URL chạy local:** `http://localhost:8080`
* **Cơ sở dữ liệu:** `HotelManagementNEW` (Gồm 17 bảng quan hệ: Users, Rooms, Bookings, Invoices, Services, Vouchers,...)

---

## 2. PHÂN QUYỀN HỆ THỐNG (ROLE-BASED ACCESS CONTROL - RBAC)
Hệ thống quản lý truy cập nghiêm ngặt dựa trên 3 vai trò (Actors):
1. **Khách hàng (Customer / Guest):** Tìm kiếm phòng, đặt phòng trực tuyến (Booking), quét mã QR thanh toán/cọc, xem điểm tích lũy (LoyaltyPoints) và hủy/đổi phòng.
2. **Quản lý khách sạn (Hotel Manager / Lễ tân):** Quản lý tình trạng phòng (Clean/Dirty/UnderRepair), thực hiện quy trình Check-in (nhận phòng) và Check-out (trả phòng), nhập phụ phí dịch vụ/hư hỏng nội thất, xuất hóa đơn cuối cùng.
3. **Quản trị viên (Admin):** Quản lý tài khoản (CRUD, xóa mềm IsActive = 0), quản trị Voucher khuyến mãi và xem báo cáo thống kê doanh thu.

---

## 3. QUY TẮC NGHIỆP VỤ CỐT LÕI (BUSINESS RULES)

### 3.1. Phân hệ Xác thực & Tài khoản (Authentication)
* **Quy cách đăng nhập:** Người dùng đăng nhập bằng **Số điện thoại (PhoneNumber)** và **Mật khẩu (Password)** (được mã hóa SHA-256 kèm chuỗi Salt bí mật `Verdelle Hotel_Mint Sweet 2026`).
* **BR-AUTH-01 (Đăng nhập hợp lệ):**
  * SĐT `090333444` (Customer) -> Chuyển hướng về Trang chủ (`home.jsp`).
  * SĐT `090222333` (Hotel Manager) -> Chuyển hướng sang Trang tiếp tân/lễ tân.
  * SĐT `090111222` (Admin) -> Chuyển hướng sang Bảng điều khiển quản trị (`dashboard.jsp`).
* **BR-AUTH-02 (Dữ liệu rỗng):** Bỏ trống Số điện thoại hoặc Mật khẩu -> Giữ nguyên form, hiển thị thông báo lỗi "Thông tin không chính xác".
* **BR-AUTH-03 (Sai thông tin):** Nhập sai SĐT hoặc mật khẩu không khớp -> Báo lỗi xác thực, từ chối cấp session đăng nhập.

### 3.2. Phân hệ Tra cứu & Đặt phòng (Booking Logic)
* **BR-BOOK-01 (Kiểm tra ngày lưu trú):** Ngày nhận phòng (`CheckInDate`) và ngày trả phòng (`CheckOutDate`) phải là ngày hiện tại hoặc tương lai; hệ thống chặn không cho chọn ngày trong quá khứ.
* **BR-BOOK-02 (Chống kẹt/Trùng lịch - Anti-Overbooking):** Khi đơn đặt phòng được thanh toán thành công (chuyển sang `Confirmed`), trạng thái phòng tương ứng trong bảng `Rooms` lập tức chuyển từ `Available` sang `Booked`. Khách hàng khác gửi yêu cầu trong cùng khoảng thời gian sẽ bị từ chối ngay lập tức.
* **BR-BOOK-03 (Tích điểm thưởng):** Khách hàng sau khi hoàn tất thanh toán hoặc check-in sẽ được tích lũy điểm thưởng thành viên (`LoyaltyPoints` và `CheckIn_Points`).

### 3.3. Phân hệ Lễ tân: Check-in, Check-out & Tính phụ phí (CheckOutAction)
* **BR-CHECKIN-01:** Lễ tân tiếp nhận đơn đặt phòng hợp lệ (`BK-XXXX`), chuyển trạng thái booking sang `CheckedIn`, phòng chuyển sang `Occupied`, tự động cộng +10 điểm vào `CheckIn_Points`.
* **BR-CHECKOUT-01 (Tính tổng hóa đơn):**
  * Khi trả phòng, `BookingDAO` và `ServiceDAO` tính toán:
    $$\text{FinalAmountDue} = (\text{Tiền phòng gốc} + \text{Phụ phí dịch vụ} + \text{Phí hư hỏng nội thất} - \text{Giảm giá Voucher} - \text{Tiền cọc}) + \text{VAT (10\%)}$$
  * Sau khi checkout thành công, booking chuyển trạng thái `Completed`, phòng trả về `Available` nhưng tình trạng vệ sinh (`Condition`) chuyển sang `Dirty` (Chờ dọn).