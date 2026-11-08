# Nhật ký AI: Thiết lập và chuẩn hóa Workflow CI/CD với GitHub Actions

## 1. Ngữ cảnh & Mục tiêu
- **Mục tiêu**: Xây dựng kịch bản kiểm thử tự động hóa CI/CD bằng GitHub Actions để mỗi lần push commit mới lên nhánh `main`, hệ thống tự động tải code, cài đặt môi trường Java, thực thi kiểm thử và lưu trữ báo cáo.
- **Phạm vi file**: `.github/workflows/test.yml`.

---

## 2. Câu lệnh đã gửi cho AI (Prompt)
> "Tôi có file .github/workflows/test.yml nhưng IntelliJ báo lỗi cú pháp '! 8 warnings' và GitHub Actions không thực thi được do các dấu gạch ngang '-' bị ngắt dòng rời rạc khỏi thuộc tính name. Hãy định dạng lại chuẩn cú pháp YAML cho workflow này: chạy trên ubuntu-latest, thiết lập JDK 17 temurin có cache maven, chạy lệnh 'mvn clean test' và export thư mục target/surefire-reports/ làm artifact."

---

## 3. Kết quả do AI sinh ra (Raw Output)

```yaml
name: CI Automation Test

on:
  push:
    branches: [ main, master ]
  pull_request:
    branches: [ main, master ]
  workflow_dispatch:

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Set up JDK 17
        uses: actions/setup-java@v4
        with:
          java-version: '17'
          distribution: 'temurin'
          cache: maven

      - name: Run Tests
        run: mvn clean test

      - name: Upload Test Report
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: test-reports
          path: target/surefire-reports/