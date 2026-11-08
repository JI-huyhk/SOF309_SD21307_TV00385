# Nhật ký AI: Phân tích Stack Trace lỗi và gỡ lỗi (Debugging)

## 1. Ngữ cảnh & Mục tiêu
- **Mục tiêu**: Xử lý các lỗi phát sinh trong quá trình build và chạy tự động trên môi trường CI/CD GitHub Actions:
    1. Lỗi biên dịch thiếu thư viện `jakarta.servlet` và `jakarta.persistence` trên máy ảo Linux.
    2. Lỗi xung đột cấu hình Maven do khai báo trùng lặp thư viện (`duplicate declaration`) trong `pom.xml`.
- **Phạm vi file xử lý**: `pom.xml`.

---

## 2. Câu lệnh đã gửi cho AI (Prompt)
> "Khi đẩy mã nguồn lên GitHub Actions, bước 'Run Tests' bị fail với log lỗi:
> `[ERROR] package jakarta.persistence does not exist`
> `[ERROR] package jakarta.servlet does not exist`
> `[ERROR] cannot find symbol class HttpServlet, class Entity, class Table`
> Sau khi tôi thêm dependency vào pom.xml thì lại bị lỗi tiếp theo:
> `[ERROR] 'dependencies.dependency' must be unique: jakarta.servlet:jakarta.servlet-api:jar -> version 6.1.0 vs 6.0.0 @ line 116`
> `[ERROR] duplicate declaration of version 3.1.0 @ line 123`
> Hãy giải thích nguyên nhân và hướng dẫn cách sửa triệt để file pom.xml."

---

## 3. Kết quả do AI sinh ra (Raw Output)
AI giải thích 2 nguyên nhân cốt lõi:
1. **Lỗi thiếu gói ban đầu**: Ở máy local, thư viện `jakarta.servlet` được server Tomcat bên ngoài tự nhúng, hoặc trong `pom.xml` đang để `<scope>provided</scope>`/`<scope>test</scope>`. Khi runner GitHub Actions thực hiện `mvn clean test`, Maven không có các dependency này để biên dịch các class model/controller trong `src/main/java`.
2. **Lỗi duplicate declaration**: Người dùng dán thêm dependency mới trong khi file `pom.xml` vốn đã tồn tại thẻ `<dependency>` cho `jakarta.servlet-api` (bản 6.1.0) và `jakarta.persistence-api` (bản 3.1.0). Việc khai báo 2 lần với 2 phiên bản khác nhau khiến Maven parser dừng toàn bộ tiến trình.

Giải pháp AI đề xuất:
- Xóa bỏ 2 khối `<dependency>` vừa dán thêm ở cuối file (dòng 116 - 125).
- Tìm 2 khối thư viện có sẵn phía trên trong `pom.xml`, loại bỏ thuộc tính `<scope>provided</scope>` hoặc `<scope>test</scope>` để thư viện được áp dụng ở phạm vi `compile`.

---

## 4. Chỉnh sửa của Sinh viên & Lý do sửa
- **Điểm AI hướng dẫn cần kiểm tra thực tế**: Cần định vị chính xác vị trí các thẻ trùng lặp trong `pom.xml` để tránh xóa nhầm các dependency khác (như JUnit 5 hay Selenium).
- **Thao tác thực hiện**:
    1. Mở `pom.xml`, xóa sạch đoạn code thêm trùng lặp ở cuối file:
       ```xml
       <!-- Xóa bỏ đoạn trùng gây lỗi line 116 và line 123 -->
       <dependency>
           <groupId>jakarta.servlet</groupId>
           <artifactId>jakarta.servlet-api</artifactId>
           <version>6.0.0</version>
       </dependency>
       <dependency>
           <groupId>jakarta.persistence</groupId>
           <artifactId>jakarta.persistence-api</artifactId>
           <version>3.1.0</version>
       </dependency>
       ```
    2. Tại khối khai báo `jakarta.servlet-api` (6.1.0) và `jakarta.persistence-api` (3.1.0) gốc trong `pom.xml`, loại bỏ thẻ `<scope>provided</scope>` để máy ảo GitHub Actions tải về và biên dịch đầy đủ 62 file mã nguồn.
- **Kết quả**: Commit `fix(ci): remove duplicate dependencies and fix scope` kích hoạt lại workflow và chuyển toàn bộ tiến trình sang tích xanh (Passed).