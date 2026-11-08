<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Voucher - Verdelle Luxury</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --sidebar-width: 280px;
            --bg-color: #0b0b0e;
            --panel-bg: #14141a;
            --sidebar-bg: #09090c;
            --text-light: #9a9aab;
            --text-dark: #f5f5f7;
            --gold-primary: #d4af37;
            --gold-hover: #b89327;
            --border-color: #22222a;
        }

        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--bg-color);
            color: var(--text-dark);
            display: flex;
            height: 100vh;
            overflow: hidden;
        }

        /* --- SIDEBAR MENU TRÁI --- */
        .sidebar {
            width: var(--sidebar-width);
            background-color: var(--sidebar-bg);
            color: white;
            display: flex;
            flex-direction: column;
            border-right: 1px solid var(--border-color);
        }

        .sidebar-header {
            padding: 30px 24px;
            text-align: left;
            border-bottom: 1px solid var(--border-color);
            font-size: 1.15rem;
            font-weight: bold;
            color: var(--gold-primary);
            letter-spacing: 1.5px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .nav-menu {
            list-style: none;
            padding: 0;
            margin: 20px 0;
            overflow-y: auto;
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        .nav-item {
            padding: 16px 24px;
            display: flex;
            align-items: center;
            gap: 15px;
            color: var(--text-light);
            text-decoration: none;
            transition: all 0.3s ease;
            font-size: 0.95rem;
            box-sizing: border-box;
            border-left: 4px solid transparent;
        }

        .nav-item i {
            transition: transform 0.3s ease;
            width: 20px;
            text-align: center;
        }

        .nav-item:hover, .nav-item.active {
            background: linear-gradient(90deg, rgba(212, 175, 55, 0.08) 0%, rgba(20, 20, 26, 0) 100%);
            color: #fff;
            border-left: 4px solid var(--gold-primary);
        }

        .nav-item:hover i, .nav-item.active i {
            color: var(--gold-primary);
            transform: scale(1.1);
        }

        /* --- KHU VỰC NỘI DUNG CHÍNH --- */
        .main-content {
            flex: 1;
            padding: 40px;
            overflow-y: auto;
            box-sizing: border-box;
        }

        .page-header {
            margin-bottom: 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .page-title {
            color: #fff;
            margin: 0;
            font-size: 1.75rem;
            font-weight: 500;
            letter-spacing: 0.5px;
        }

        .welcome-text {
            color: var(--text-light);
            font-size: 0.95rem;
        }
        .welcome-text strong {
            color: var(--gold-primary);
        }

        /* --- NOTIFICATION MESSAGES --- */
        .alert {
            padding: 14px 20px;
            border-radius: 8px;
            margin-bottom: 25px;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .alert-success {
            background: rgba(40, 167, 69, 0.15);
            color: #28a745;
            border: 1px solid rgba(40, 167, 69, 0.3);
        }
        .alert-error {
            background: rgba(220, 53, 69, 0.15);
            color: #dc3545;
            border: 1px solid rgba(220, 53, 69, 0.3);
        }

        /* --- FORM TẠO VOUCHER --- */
        .form-panel {
            background: var(--panel-bg);
            border-radius: 12px;
            padding: 30px;
            border: 1px solid var(--border-color);
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            margin-bottom: 35px;
        }

        .panel-title {
            margin-top: 0;
            margin-bottom: 20px;
            color: #fff;
            font-size: 1.15rem;
            font-weight: 500;
            letter-spacing: 0.5px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .panel-title i {
            color: var(--gold-primary);
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .form-group label {
            color: var(--text-light);
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-control {
            background-color: #09090c;
            border: 1px solid var(--border-color);
            color: #fff;
            padding: 12px 16px;
            border-radius: 6px;
            font-size: 0.95rem;
            outline: none;
            transition: border-color 0.3s ease;
        }

        .form-control:focus {
            border-color: var(--gold-primary);
        }

        .btn-submit {
            grid-column: span 3;
            background: var(--gold-primary);
            color: #000;
            border: none;
            padding: 14px;
            border-radius: 6px;
            font-weight: 600;
            font-size: 1rem;
            cursor: pointer;
            transition: background 0.3s ease;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin-top: 10px;
        }

        .btn-submit:hover {
            background: var(--gold-hover);
        }

        /* --- PANEL CHỨA BẢNG --- */
        .data-panel {
            background: var(--panel-bg);
            border-radius: 12px;
            padding: 30px;
            border: 1px solid var(--border-color);
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }

        .admin-table {
            width: 100%;
            border-collapse: collapse;
        }

        .admin-table th {
            color: var(--text-light);
            font-weight: 500;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            padding: 16px 15px;
            border-bottom: 1px solid var(--border-color);
            text-align: left;
        }

        .admin-table td {
            padding: 18px 15px;
            color: var(--text-dark);
            font-size: 0.95rem;
            border-bottom: 1px solid var(--border-color);
            vertical-align: middle;
        }

        .admin-table tbody tr:hover {
            background-color: rgba(255, 255, 255, 0.01);
        }

        .code-style {
            font-family: 'Courier New', Courier, monospace;
            color: var(--gold-primary);
            background: rgba(212, 175, 55, 0.1);
            padding: 4px 10px;
            border-radius: 4px;
            font-weight: bold;
            letter-spacing: 1px;
        }

        .badge {
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 0.8rem;
            font-weight: 600;
            display: inline-block;
        }
        .badge-active {
            background: rgba(40, 167, 69, 0.15);
            color: #28a745;
            border: 1px solid rgba(40, 167, 69, 0.3);
        }
        .badge-inactive {
            background: rgba(220, 53, 69, 0.15);
            color: #dc3545;
            border: 1px solid rgba(220, 53, 69, 0.3);
        }

        .btn-delete {
            background: rgba(220, 53, 69, 0.1);
            color: #dc3545;
            border: 1px solid rgba(220, 53, 69, 0.3);
            padding: 6px 14px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.85rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-delete:hover {
            background: #dc3545;
            color: #fff;
        }
    </style>
</head>
<body>

<div class="sidebar">
    <div class="sidebar-header">
        <i class="fa-solid fa-crown"></i> VERDELLE ADMIN
    </div>
    <div class="nav-menu">
        <a href="${pageContext.request.contextPath}/quan-ly-tai-khoan" class="nav-item">
            <i class="fa-solid fa-users-gear"></i> Quản lý Người dùng
        </a>

        <a href="${pageContext.request.contextPath}/quan-ly-doanh-thu" class="nav-item">
            <i class="fa-solid fa-chart-line"></i> Quản lý Doanh thu
        </a>

        <a href="${pageContext.request.contextPath}/quan-ly-voucher" class="nav-item active">
            <i class="fa-solid fa-ticket"></i> Quản lý Voucher
        </a>

        <a href="${pageContext.request.contextPath}/logout" class="nav-item" style="color: #e74c3c; margin-top: auto;">
            <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
        </a>
    </div>
</div>

<div class="main-content">
    <div class="page-header">
        <h2 class="page-title">Quản Lý & Phát Hành Voucher</h2>
        <div class="welcome-text">
            Chào mừng Quản trị viên: <strong>${sessionScope.firstName != null ? sessionScope.firstName : 'Admin'}</strong> <i class="fa-regular fa-hand-spock" style="color: var(--gold-primary); margin-left: 4px;"></i>
        </div>
    </div>

    <!-- CẢNH BÁO THÔNG BÁO -->
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success">
            <i class="fa-solid fa-circle-check"></i> ${sessionScope.successMessage}
        </div>
        <% session.removeAttribute("successMessage"); %>
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-error">
            <i class="fa-solid fa-circle-exclamation"></i> ${sessionScope.errorMessage}
        </div>
        <% session.removeAttribute("errorMessage"); %>
    </c:if>

    <!-- NỬA TRÊN: FORM TẠO VOUCHER -->
    <div class="form-panel">
        <h4 class="panel-title"><i class="fa-solid fa-plus-circle"></i> Tạo Mã Voucher Mới</h4>
        <form action="${pageContext.request.contextPath}/quan-ly-voucher" method="POST">
            <input type="hidden" name="action" value="create">
            <div class="form-grid">
                <div class="form-group">
                    <label>Mã Voucher</label>
                    <input type="text" name="voucherCode" class="form-control" placeholder="VD: SUMMER2026"
                           pattern="[A-Za-z0-9_]+" title="Chỉ chứa chữ cái, số và dấu gạch dưới, không khoảng trắng" required>
                </div>
                <div class="form-group">
                    <label>Phần Trăm Giảm (%)</label>
                    <input type="number" name="discountPercent" class="form-control" placeholder="1 - 100"
                           min="1" max="100" required>
                </div>
                <div class="form-group">
                    <label>Mức Giảm Tối Đa (VNĐ)</label>
                    <input type="number" name="maxDiscountAmount" class="form-control" placeholder="VD: 500000"
                           min="0" step="1000" required>
                </div>
                <div class="form-group">
                    <label>Hạng Khách Hàng Yêu Cầu</label>
                    <select name="requiredRank" class="form-control" required>
                        <option value="Member">Member</option>
                        <option value="Silver">Silver</option>
                        <option value="Gold">Gold</option>
                        <option value="Diamond">Diamond</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Ngày Bắt Đầu</label>
                    <input type="datetime-local" name="validFrom" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>Ngày Hết Hạn</label>
                    <input type="datetime-local" name="validTo" class="form-control" required>
                </div>
                <button type="submit" class="btn-submit">
                    <i class="fa-solid fa-paper-plane"></i> Phát Hành Voucher
                </button>
            </div>
        </form>
    </div>

    <!-- NỬA DƯỚI: TRUY VẤN DANH SÁCH VOUCHER -->
    <div class="data-panel">
        <h4 class="panel-title"><i class="fa-solid fa-list-check"></i> Sổ Danh Sách Voucher</h4>

        <table class="admin-table">
            <thead>
            <tr>
                <th>Mã Voucher</th>
                <th>Giảm (%)</th>
                <th>Tối Đa</th>
                <th>Hạng Áp Dụng</th>
                <th>Thời Gian Hiệu Lực</th>
                <th>Trạng Thái</th>
                <th style="text-align: right;">Hành Động</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${empty listVouchers}">
                    <tr>
                        <td colspan="7" style="color: #666; padding: 45px; text-align: center;">
                            Chưa có voucher nào trong hệ thống.
                        </td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="v" items="${listVouchers}">
                        <tr>
                            <td><span class="code-style">${v.voucherCode}</span></td>
                            <td style="font-weight: bold; color: #28a745;">${v.discountPercent}%</td>
                            <td>
                                <fmt:formatNumber value="${v.maxDiscountAmount}" type="number" groupingUsed="true"/> đ
                            </td>
                            <td><strong style="color: var(--text-dark);">${v.requiredRank}</strong></td>
                            <td style="font-size: 0.85rem; color: var(--text-light);">
                                <fmt:formatDate value="${v.validFrom}" pattern="dd/MM/yyyy HH:mm"/>
                                <br>
                                <span style="color: #666;">đến</span>
                                <fmt:formatDate value="${v.validTo}" pattern="dd/MM/yyyy HH:mm"/>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${v.isActive}">
                                        <span class="badge badge-active">Khả dụng</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-inactive">Vô hiệu</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td style="text-align: right;">
                                <c:if test="${v.isActive}">
                                    <form action="${pageContext.request.contextPath}/quan-ly-voucher" method="POST" style="display:inline;" onsubmit="return confirm('Bạn có chắc muốn vô hiệu hóa Voucher ${v.voucherCode}?');">
                                        <input type="hidden" name="action" value="deactivate">
                                        <input type="hidden" name="voucherCode" value="${v.voucherCode}">
                                        <button type="submit" class="btn-delete">
                                            <i class="fa-solid fa-ban"></i> Vô hiệu
                                        </button>
                                    </form>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>