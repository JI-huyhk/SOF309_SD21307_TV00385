# Nhật ký AI - Tuần 2: Thiết kế & Viết Unit Test Controller (JUnit 5 + Mockito)

## 1. Thông tin chung
- **Công cụ AI sử dụng:** Gemini
- **Mục tiêu:** Viết Unit Test kiểm thử độc lập 11 Servlet/Controller trong hệ thống đặt phòng khách sạn Verdelle Hotel mà không phụ thuộc Tomcat hay kết nối SQL Server thật.
- **Các file Test đã triển khai (`src/test/java/com/poly/sof309/controllers/`):**
  1. `AuthControllerTest.java` (Kiểm thử `LoginController`, `RegisterController`)
  2. `BookingControllerTest.java` (Kiểm thử `BookingHistoryController`, `ActivityController`, `UserdetailController`)
  3. `CheckInAndPaymentControllerTest.java` (Kiểm thử `CheckInListController`, `CheckPaymentStatusController`)
  4. `BookingFlowControllerTest.java` (Kiểm thử `BookingController`, `FinalizeBookingController`)
  5. `ReceptionAndAdminControllerTest.java` (Kiểm thử `CheckInActionController`, `CheckOutListController`, `DashboardController`, `UpdateController`)

## 2. Prompt đã sử dụng
> "Đóng vai QA Automation Engineer. Dựa trên mã nguồn các Servlet trong dự án, hãy viết bộ Unit Test bằng JUnit 5 và Mockito (áp dụng `mockConstruction` cho tầng DAO, `mockStatic` cho `EmailService`, và `@MockitoSettings(strictness = Strictness.LENIENT)` cho các request nhiều tham số). Yêu cầu bắt buộc:
> 1. Sử dụng `@ParameterizedTest` + `@CsvSource` để kiểm tra phân quyền, thuật toán tính tiền/số đêm, chuẩn hóa ngày tháng và các trường hợp biên form.
> 2. Sử dụng `assertThrows()` để bắt ngoại lệ `NumberFormatException` khi tham số đầu vào sai định dạng.
> 3. Sử dụng `@Timeout(value = 2, unit = TimeUnit.SECONDS)` để kiểm soát thời gian phản hồi dưới 2 giây."

## 3. Quá trình xử lý lỗi & Tối ưu
- Bổ sung thư viện `mockito-core` và `mockito-junit-jupiter` (`5.11.0`) vào `pom.xml`.
- Cấu hình `<argLine>-Dnet.bytebuddy.experimental=true</argLine>` trong `maven-surefire-plugin` để tương thích với môi trường JDK 25 trên máy cá nhân.

## 4. Kết quả kiểm thử
- **Lệnh thực thi:** `mvn test -Dtest=*ControllerTest`
- **Trạng thái:** `BUILD SUCCESS` (100% Pass, 0 Failures, 0 Errors).