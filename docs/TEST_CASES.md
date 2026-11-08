# BỘ KỊCH BẢN KIỂM THỬ HỆ THỐNG (TEST SUITE)
> Dự án: Hệ Thống Quản Lý Đặt Phòng Khách Sạn Verdelle Hotel
> Phạm vi: Ánh xạ 100% từ Báo cáo Kỹ thuật phần mềm (Chương 6: Test Case TC01 - TC05) và các Controller thực tế

---

## 1. Module 1: Xác thực & Phân quyền RBAC (LoginController / UserDAO)

| Test Case ID | Mục tiêu kiểm thử | Loại test | Các bước thực hiện | Dữ liệu đầu vào (Input) | Kết quả mong đợi (Expected Output) | Trạng thái |
| :--- | :--- | :---: | :--- | :--- | :--- | :---: |
| **TC01_AUTH_01** | Khách hàng đăng nhập thành công | Positive | 1. Mở trang đăng nhập<br>2. Nhập SĐT và mật khẩu của Customer<br>3. Bấm Đăng nhập | `phone: "090333444"`<br>`password: "123456"` | Đăng nhập thành công, điều hướng vào trang chủ `home.jsp` | Pass |
| **TC01_AUTH_02** | Lễ tân (Hotel Manager) đăng nhập thành công | Positive | 1. Mở trang đăng nhập<br>2. Nhập tài khoản Manager<br>3. Bấm Đăng nhập | `phone: "090222333"`<br>`password: "123456"` | Điều hướng vào trang tổng quan quầy tiếp tân / lễ tân | Pass |
| **TC01_AUTH_03** | Quản trị viên (Admin) đăng nhập thành công | Positive | 1. Mở trang đăng nhập<br>2. Nhập tài khoản Admin<br>3. Bấm Đăng nhập | `phone: "090111222"`<br>`password: "123456"` | Điều hướng vào Bảng điều khiển quản trị `dashboard.jsp` | Pass |
| **TC01_AUTH_04** | Đăng nhập thất bại khi để trống thông tin | Negative | 1. Mở trang đăng nhập<br>2. Bỏ trống SĐT hoặc Mật khẩu<br>3. Bấm Đăng nhập | `phone: ""` (rỗng)<br>`password: ""` (rỗng) | Giữ nguyên trang, báo lỗi "Thông tin không chính xác" | Pass |
| **TC01_AUTH_05** | Đăng nhập thất bại khi sai mật khẩu | Negative | 1. Mở trang đăng nhập<br>2. Nhập đúng SĐT nhưng sai mật khẩu<br>3. Bấm Đăng nhập | `phone: "090333444"`<br>`password: "wrong_pass"` | Báo lỗi đăng nhập không thành công, không cấp Session | Pass |

---

## 2. Module 2: Lọc phòng & Đặt phòng (RoomDAO / BookingDAO)

| Test Case ID | Mục tiêu kiểm thử | Loại test | Các bước thực hiện | Dữ liệu đầu vào (Input) | Kết quả mong đợi (Expected Output) | Trạng thái |
| :--- | :--- | :---: | :--- | :--- | :--- | :---: |
| **TC02_ROOM_01** | Lọc danh sách phòng khả dụng theo ngày | Positive | 1. Chọn ngày Check-in/Check-out tương lai<br>2. Bấm lọc phòng | `Check-in: 03/08/2026`<br>`Check-out: 04/08/2026` | Trả về danh sách tất cả các phòng có trạng thái `Available` | Pass |
| **TC02_ROOM_02** | Chặn chọn ngày lưu trú trong quá khứ | Boundary | 1. Chọn ngày Check-in nhỏ hơn ngày hiện tại | `Check-in: 03/08/2026`<br>`Check-out: 01/08/2026` | Hệ thống vô hiệu hóa/chặn không cho chọn ngày trong quá khứ | Pass |
| **TC02_ROOM_03** | Lọc phòng theo khoảng giá tăng dần | Positive | 1. Kéo thanh trượt khoảng giá (Price Slider)<br>2. Chọn sắp xếp từ thấp đến cao | `minPrice: 300000`<br>`maxPrice: 1500000` | Danh sách hiển thị đúng các phòng trong khoảng giá theo thứ tự tăng dần | Pass |
| **TC02_ROOM_04** | Khởi tạo đơn đặt phòng (Booking Request) | Positive | 1. Chọn phòng khả dụng<br>2. Điền thông tin cá nhân và số lượng khách<br>3. Bấm Xác nhận đặt phòng | `RoomID: 101`<br>`Adults: 2, Children: 1` | Đơn hàng được tạo ở trạng thái `Pending`, chuyển sang bước thanh toán | Pass |

---

## 3. Module 3: Thanh toán & Ngăn ngừa Overbooking (BookingDAO / Trigger)

| Test Case ID | Mục tiêu kiểm thử | Loại test | Các bước thực hiện | Dữ liệu đầu vào (Input) | Kết quả mong đợi (Expected Output) | Trạng thái |
| :--- | :--- | :---: | :--- | :--- | :--- | :---: |
| **TC03_PAY_01** | Thanh toán thành công và khóa phòng | Positive | 1. Quét QR thanh toán cho đơn `Pending`<br>2. Nhận phản hồi thanh toán thành công | `BookingCode: "BK-2026-0001"`<br>`PaymentType: "Full"` | Booking chuyển `Confirmed`, trạng thái phòng chuyển ngay sang `Booked` | Pass |
| **TC03_PAY_02** | Xử lý chống trùng lịch (Anti-Overbooking) | Concurrency | 1. Hai khách hàng cùng thao tác thanh toán 1 phòng tại một thời điểm | Khách A và Khách B cùng đặt `RoomID: 101` | Khách A thanh toán trước thành công; Khách B bị hệ thống từ chối và báo phòng đã hết | Pass |

---

## 4. Module 4: Check-in, Check-out & Xuất hóa đơn (CheckOutActionController / ServiceDAO)

| Test Case ID | Mục tiêu kiểm thử | Loại test | Các bước thực hiện | Dữ liệu đầu vào (Input) | Kết quả mong đợi (Expected Output) | Trạng thái |
| :--- | :--- | :---: | :--- | :--- | :--- | :---: |
| **TC04_OP_01** | Lễ tân xử lý tiếp nhận Check-in | Positive | 1. Tìm đơn booking hợp lệ tại quầy<br>2. Nhấn nút "Check-in" | `BookingCode: "BK-2026-0001"` | Đơn chuyển sang `CheckedIn`, phòng sang `Occupied`, cộng +10 điểm vào `CheckIn_Points` | Pass |
| **TC04_OP_02** | Tính phụ phí dịch vụ và thiệt hại nội thất | Positive | 1. Chọn đơn Check-out<br>2. Nhập số lượng dịch vụ đã dùng (Minibar) và đồ hỏng | `ServiceID: 2, Qty: 3`<br>`FurnitureID: 1, Penalty: 200000` | `ServiceDAO` tính đúng tổng chi phí phụ thu cộng dồn vào hóa đơn | Pass |
| **TC04_OP_03** | Xuất hóa đơn cuối cùng (Check-out hoàn tất) | Positive | 1. Xác nhận thanh toán hóa đơn check-out | `action: "checkout"`<br>`VATPercent: 10` | Booking chuyển `Completed`, phòng trả về `Available` với Condition là `Dirty` | Pass |

---

## 5. Module 5: Quản lý Phòng & Doanh thu (RoomDAO / RevenueDAO)

| Test Case ID | Mục tiêu kiểm thử | Loại test | Các bước thực hiện | Dữ liệu đầu vào (Input) | Kết quả mong đợi (Expected Output) | Trạng thái |
| :--- | :--- | :---: | :--- | :--- | :--- | :---: |
| **TC05_MANAGE_01** | Cập nhật tình trạng dọn dẹp phòng | Positive | 1. Lễ tân chọn phòng đã dọn dẹp xong<br>2. Chuyển tình trạng từ `Dirty` sang `Clean` | `RoomID: 301`<br>`Condition: "Clean"` | CSDL cập nhật ngay lập tức cột Condition, phòng sẵn sàng đón khách mới | Pass |
| **TC05_MANAGE_02** | Thống kê doanh thu theo hóa đơn đã thu | Positive | 1. Admin vào trang Thống kê doanh thu<br>2. Chọn mốc thời gian lọc | `FromDate: 01/07/2026`<br>`ToDate: 31/07/2026` | Hiển thị tổng doanh thu khớp 100% với các hóa đơn có `PaymentStatus = 'Paid'` | Pass |