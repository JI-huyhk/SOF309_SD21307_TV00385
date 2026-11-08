# Nhật ký AI: Thiết kế Test Plan & Test Cases cho Chức năng Đăng nhập & RBAC

## 1. Ngữ cảnh & Mục tiêu
- **Mục tiêu**: Xây dựng tài liệu kế hoạch kiểm thử (TEST_PLAN.md) và bảng ca kiểm thử chi tiết (TEST_CASES.md) cho dự án Verdelle Hotel.
- **Phạm vi**: Tập trung vào chức năng xác thực tài khoản và phân quyền người dùng (RBAC) với các vai trò: Customer, HotelManager, Admin.

## 2. Câu lệnh đã gửi cho AI (Prompt)
> "Tôi đang làm dự án Verdelle Hotel (hệ thống đặt phòng khách sạn Java Servlet/JSP). Hãy đóng vai trò Chuyên viên QA/QC, phân tích yêu cầu nghiệp vụ và thiết kế bộ Test Case theo chuẩn IEEE 829 cho module Authentication & RBAC gồm 5 ca kiểm thử: Khách hàng đăng nhập, Lễ tân đăng nhập, Admin đăng nhập, Để trống thông tin, và Nhập sai mật khẩu."

## 3. Kết quả do AI sinh ra (Raw Output)
AI sinh ra bảng gồm 5 test cases với các cột: Test Case ID, Description, Pre-condition, Test Steps, Test Data, Expected Result. Tuy nhiên, AI mặc định sử dụng dữ liệu đăng nhập bằng username dạng text: `admin`, `receptionist`, `customer01`.

## 4. Chỉnh sửa của Sinh viên & Lý do sửa
- **Điểm AI chưa chuẩn**: Dự án Verdelle Hotel sử dụng số điện thoại làm định danh đăng nhập chính chứ không dùng username dạng chuỗi ký tự.
- **Chỉnh sửa**: Cập nhật lại bộ Test Data trong bảng ca kiểm thử cho khớp với database thực tế của dự án:
    - Khách hàng: `090333444` / `123456` -> Điều hướng về `home.jsp`.
    - Lễ tân: `090222333` / `123456` -> Điều hướng về `reception.jsp`.
    - Quản trị viên: `090111222` / `123456` -> Điều hướng về `dashboard.jsp`.
    - Trường hợp bỏ trống và sai mật khẩu: Báo lỗi "Thông tin không chính xác".