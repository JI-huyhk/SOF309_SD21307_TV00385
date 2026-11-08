<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Verdelle Hotel - Chỉnh Sửa Thành Viên</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HeaderStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/NavStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/FooterStyle.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --bg-color: #0b0c10;
            --card-bg: #141519;
            --text-color: #f0f0f0;
            --sub-text: #a0a5b5;
            --border-color: #2a2415;
            --border-gold: #d4af37;
            --gold-primary: #d4af37;
            --gold-light: #f3cf65;
            --input-bg: #1a1c23;
            --input-readonly-bg: #101115;
            --btn-gold: linear-gradient(135deg, #d4af37 0%, #aa7c11 100%);
            --btn-secondary: #22242b;
            --btn-cancel-text: #cccccc;
        }

        html, body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--bg-color) !important;
            color: var(--text-color);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .form-container {
            max-width: 750px;
            width: 100%;
            margin: 50px auto;
            padding: 35px;
            background: var(--card-bg);
            border: 1px solid rgba(212, 175, 55, 0.35);
            border-radius: 16px;
            box-sizing: border-box;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.7), 0 0 20px rgba(212, 175, 55, 0.08);
        }

        .form-title {
            font-size: 1.5rem;
            color: var(--gold-primary);
            margin-top: 0;
            margin-bottom: 25px;
            font-weight: 700;
            letter-spacing: 1px;
            display: flex;
            align-items: center;
            gap: 12px;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 15px;
            text-transform: uppercase;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(12, 1fr);
            gap: 20px;
        }

        .col-4 { grid-column: span 4; }
        .col-6 { grid-column: span 6; }
        .col-8 { grid-column: span 8; }
        .col-12 { grid-column: span 12; }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group label {
            font-size: 0.82rem;
            color: var(--gold-primary);
            margin-bottom: 8px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.8px;
        }

        .form-control, .form-select {
            width: 100%;
            padding: 12px 14px;
            background: var(--input-bg);
            border: 1px solid #332c1e;
            border-radius: 8px;
            color: var(--text-color);
            box-sizing: border-box;
            font-size: 0.95rem;
            outline: none;
            transition: all 0.3s ease;
        }

        .form-select option {
            background-color: var(--card-bg);
            color: var(--text-color);
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--gold-primary);
            box-shadow: 0 0 10px rgba(212, 175, 55, 0.25);
        }

        .form-control[readonly] {
            background: var(--input-readonly-bg);
            color: var(--sub-text);
            border-color: #222;
            cursor: not-allowed;
        }

        .btn-group {
            margin-top: 35px;
            display: flex;
            justify-content: flex-end;
            gap: 15px;
        }

        .btn-custom {
            padding: 12px 26px;
            font-weight: 700;
            font-size: 0.9rem;
            border-radius: 8px;
            text-decoration: none;
            transition: all 0.3s ease;
            cursor: pointer;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            border: none;
        }

        .btn-submit {
            background: var(--btn-gold);
            color: #000000;
            box-shadow: 0 4px 15px rgba(212, 175, 55, 0.2);
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(212, 175, 55, 0.4);
            filter: brightness(1.1);
        }

        .btn-cancel {
            background: transparent;
            border: 1px solid #444;
            color: var(--btn-cancel-text);
        }

        .btn-cancel:hover {
            border-color: var(--gold-primary);
            color: var(--gold-primary);
            background: rgba(212, 175, 55, 0.05);
        }
    </style>
</head>
<body>

<%--<jsp:include page="/header2.jsp"/>--%>

<div class="form-container">
    <div class="form-title">
        <i class="fa-regular fa-pen-to-square"></i> Chỉnh Sửa Thông Tin Thành Viên
    </div>

    <form method="POST" action="${pageContext.request.contextPath}/update">
        <div class="form-grid">
            <div class="form-group col-4">
                <label>ID Thành Viên</label>
                <input type="text" class="form-control" name="id" value="${user.id}" readonly>
            </div>

            <div class="form-group col-8">
                <label>Vai Trò Hệ Thống (Role)</label>
                <select name="role" class="form-select">
                    <option value="customer" ${user.role.equalsIgnoreCase('customer') ? 'selected' : ''}>Khách hàng (Customer)</option>
                    <option value="partner" ${user.role.equalsIgnoreCase('partner') ? 'selected' : ''}>Đối tác (Partner)</option>
                    <option value="admin" ${user.role.equalsIgnoreCase('admin') ? 'selected' : ''}>Quản trị viên (Admin)</option>
                </select>
            </div>

            <div class="form-group col-6">
                <label>Tên (First name)</label>
                <input type="text" class="form-control" name="firstName" value="${user.firstName}" required>
            </div>

            <div class="form-group col-6">
                <label>Họ (Last name)</label>
                <input type="text" class="form-control" name="lastName" value="${user.lastName}" required>
            </div>

            <div class="form-group col-4">
                <label>Mã Quốc Gia</label>
                <input type="text" class="form-control" name="countryCode" value="${user.countryCode}" placeholder="VD: +84" required>
            </div>

            <div class="form-group col-8">
                <label>Số Điện Thoại Đăng Nhập</label>
                <input type="text" class="form-control" name="phoneNumber" value="${user.phoneNumber}" required>
            </div>

            <div class="form-group col-12">
                <label>Địa Chỉ Email</label>
                <input type="email" class="form-control" name="email" value="${user.email}" required>
            </div>

            <div class="form-group col-12">
                <label>Mật Khẩu Mới</label>
                <input type="password" class="form-control" name="password" value="${user.password}" required>
            </div>
        </div>

        <div class="btn-group">
            <button type="submit" class="btn-custom btn-submit">
                <i class="fa-regular fa-floppy-disk"></i> Lưu Thay Đổi
            </button>
            <a href="${pageContext.request.contextPath}/quan-ly-tai-khoan" class="btn-custom btn-cancel">
                <i class="fa-solid fa-xmark"></i> Hủy Bỏ
            </a>
        </div>
    </form>
</div>

<jsp:include page="/footer.jsp"/>

</body>
</html>