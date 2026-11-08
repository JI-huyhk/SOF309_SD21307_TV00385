<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Verdelle Hotel - Chi Tiết Tài Khoản</title>
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
            --gold-primary: #d4af37;
            --input-bg: #1a1c23;
            --input-readonly-bg: #101115;
            --btn-gold-border: #d4af37;
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

        .detail-container {
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

        .detail-title {
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

        .form-control {
            width: 100%;
            padding: 12px 14px;
            background: var(--input-readonly-bg);
            border: 1px solid #282419;
            border-radius: 8px;
            color: var(--text-color);
            box-sizing: border-box;
            font-size: 0.95rem;
            outline: none;
        }

        .form-control[readonly] {
            color: #d1d5db;
            cursor: not-allowed;
        }

        .btn-return {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            margin-top: 30px;
            padding: 12px 26px;
            background: transparent;
            border: 1px solid var(--btn-gold-border);
            color: var(--gold-primary);
            font-weight: 700;
            font-size: 0.9rem;
            border-radius: 8px;
            text-decoration: none;
            transition: all 0.3s ease;
            cursor: pointer;
            text-transform: uppercase;
            letter-spacing: 0.8px;
        }

        .btn-return:hover {
            background: linear-gradient(135deg, #d4af37 0%, #aa7c11 100%);
            color: #000000;
            box-shadow: 0 0 15px rgba(212, 175, 55, 0.4);
            transform: translateY(-2px);
        }
    </style>
</head>
<body>

<%--<jsp:include page="/header2.jsp" />--%>

<div class="detail-container">
    <div class="detail-title">
        <i class="fa-solid fa-id-card"></i> Hồ Sơ Chi Tiết Tài Khoản
    </div>

    <div class="form-grid">
        <div class="form-group col-4">
            <label>Mã Tài Khoản (ID)</label>
            <input type="text" class="form-control" value="${user.id}" readonly>
        </div>

        <div class="form-group col-4">
            <label>Vai Trò / Quyền Hạn</label>
            <input type="text" class="form-control"
                   value="${user.role.trim().toLowerCase() == 'admin' ? 'Quản trị viên (Admin)' : (user.role.trim().toLowerCase() == 'partner' ? 'Đối tác (Partner)' : 'Khách hàng (Customer)')}" readonly>
        </div>

        <div class="form-group col-4">
            <label>Trạng Thái Hệ Thống</label>
            <input type="text" class="form-control" style="color: ${user.isActive ? '#e5c158' : '#f44336'}; font-weight: bold;"
                   value="${user.isActive ? 'Đang Hoạt Động' : 'Đã Bị Khóa Mềm'}" readonly>
        </div>

        <div class="form-group col-6">
            <label>Tên (First Name)</label>
            <input type="text" class="form-control" value="${user.firstName}" readonly>
        </div>

        <div class="form-group col-6">
            <label>Họ (Last Name)</label>
            <input type="text" class="form-control" value="${user.lastName}" readonly>
        </div>

        <div class="form-group col-4">
            <label>Mã Quốc Gia</label>
            <input type="text" class="form-control" value="${user.countryCode}" readonly>
        </div>

        <div class="form-group col-8">
            <label>Số Điện Thoại Đăng Nhập</label>
            <input type="text" class="form-control" value="${user.phoneNumber}" readonly>
        </div>

        <div class="form-group col-12">
            <label>Địa Chỉ Email</label>
            <input type="email" class="form-control" value="${user.email}" readonly>
        </div>

        <div class="form-group col-12">
            <label>Mật Khẩu (Đã Mã Hóa Bảo Mật)</label>
            <input type="password" class="form-control" value="${user.password}" readonly>
        </div>
    </div>

    <div style="text-align: right;">
        <a href="${pageContext.request.contextPath}/quan-ly-tai-khoan" class="btn-return">
            <i class="fa-solid fa-arrow-left-long"></i> Quay Lại Danh Sách
        </a>
    </div>
</div>

<jsp:include page="/footer.jsp" />

</body>
</html>