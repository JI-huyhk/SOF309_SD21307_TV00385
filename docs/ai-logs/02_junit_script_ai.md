# Nhật ký AI: Hỗ trợ viết Unit Test cho Controller bằng JUnit 5

## 1. Ngữ cảnh & Mục tiêu
- **Mục tiêu**: Hiện thực hóa 5 ca kiểm thử đã thiết kế ở Y2 thành mã nguồn Unit Test tự động chạy độc lập bằng thư viện JUnit 5.
- **Vị trí file**: `src/test/java/com/poly/sof309/controllers/SampleControllerTest.java`.

## 2. Câu lệnh đã gửi cho AI (Prompt)
> "Dựa trên 5 test cases đăng nhập và phân quyền RBAC (TC01) của Verdelle Hotel, hãy viết mã nguồn Unit Test bằng JUnit 5 trong file SampleControllerTest.java. Mã nguồn cần sử dụng các annotation chuẩn (@Test, @DisplayName, các hàm assertions) và mô phỏng được logic xác thực của LoginController."

## 3. Kết quả do AI sinh ra (Raw Output)
```java
@Test
public void testCustomerLogin() {
    boolean res = checkLogin("090333444", "123456");
    assertTrue(res);
}