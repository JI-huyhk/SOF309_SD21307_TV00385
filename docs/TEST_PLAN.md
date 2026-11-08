# KẾ HOẠCH KIỂM THỬ (TEST PLAN) - VERDELLE HOTEL

- **Dự án:** Hệ thống Quản lý Khách sạn Verdelle (Verdelle Hotel Management System)
- **Sinh viên:** Huỳnh Khánh Huy - TV00385
- **Lớp:** SD21307
- **Môn học:** Kiểm thử nâng cao (SOF309)

---

## 1. MỤC TIÊU KIỂM THỬ
- Kiểm thử đơn vị (Unit Test) với JUnit 5 cho các luồng xử lý backend, xác thực tài khoản và phân quyền người dùng (RBAC).
- Kiểm thử tự động hóa giao diện (UI Automation Test) với Selenium WebDriver áp dụng mô hình Page Object Model (POM).
- Tích hợp kiểm thử liên tục (CI/CD) thông qua GitHub Actions nhằm đảm bảo chất lượng mã nguồn tự động trong mỗi lần đẩy mã (push/PR).

## 2. PHẠM VI KIỂM THỬ
- **In-Scope:**
    - Xác thực người dùng qua số điện thoại và mật khẩu.
    - Phân quyền theo vai trò (RBAC): Customer, HotelManager (Receptionist), Admin.
    - Xử lý các trường hợp ngoại lệ: để trống dữ liệu, sai mật khẩu, tài khoản không tồn tại.
    - Kiểm thử giao diện form đăng nhập và điều hướng URL theo quyền hạn.
- **Out-of-Scope:**
    - Kiểm thử hiệu năng và tải (Performance & Load Testing).
    - Kiểm thử an toàn thông tin chuyên sâu (Penetration Testing).
    - Kiểm thử tích hợp cổng thanh toán bên thứ ba.

## 3. MÔI TRƯỜNG & CÔNG CỤ KIỂM THỬ
- **Ngôn ngữ & Nền tảng:** Java 17, Jakarta Servlet 6.0, Maven.
- **Kiểm thử logic:** JUnit 5 (Jupiter API & Engine).
- **Kiểm thử giao diện:** Selenium WebDriver, ChromeDriver (hỗ trợ cờ `--headless=new` cho môi trường CI).
- **Hệ thống CI/CD:** GitHub Actions Runner (`ubuntu-latest`).

## 4. CHIẾN LƯỢC KIỂM THỬ
- **Unit Testing:** Thiết kế test case bao phủ logic của Controller/Service xử lý xác thực, kiểm tra các trạng thái trả về (`isSuccess`, `role`, `redirectUrl`, `errorMessage`).
- **UI Testing:** Sử dụng mô hình Page Object Model (tách riêng `LoginPage` và `LoginTest`), áp dụng cơ chế chờ tường minh (`WebDriverWait`) thay cho chờ cứng (`Thread.sleep`).
- **CI Pipeline:** Tự động kích hoạt khi có sự kiện đẩy mã lên nhánh `main`, thực thi lệnh `mvn clean test`, đồng thời lưu trữ báo cáo kiểm thử `surefire-reports` dưới dạng artifact.

## 5. TIÊU CHÍ HOÀN THÀNH (ACCEPTANCE CRITERIA)
- 100% kịch bản kiểm thử đơn vị JUnit 5 thực thi thành công (5/5 tests passed).
- Kịch bản Selenium POM chạy ổn định ở môi trường máy cá nhân và an toàn trên môi trường CI.
- Pipeline GitHub Actions đạt trạng thái thành công (Passed - tích xanh).
- Lưu trữ đầy đủ bộ tài liệu đặc tả kiểm thử và nhật ký cộng tác AI từ mốc Y2 đến Y6.