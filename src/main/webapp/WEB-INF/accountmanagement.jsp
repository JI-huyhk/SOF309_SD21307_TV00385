<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Người Dùng - Verdelle Luxury</title>
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
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 35px;
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

        /* --- PANEL CHỨA BẢNG --- */
        .data-panel {
            background: var(--panel-bg);
            border-radius: 12px;
            padding: 35px;
            border: 1px solid var(--border-color);
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }

        .panel-title {
            margin-top: 0;
            margin-bottom: 30px;
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

        /* --- CẤU TRÚC BẢNG LUXURY --- */
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
            padding: 16px 20px;
            border-bottom: 1px solid var(--border-color);
            text-align: left;
        }

        .admin-table td {
            padding: 20px 20px;
            color: var(--text-dark);
            font-size: 0.95rem;
            border-bottom: 1px solid var(--border-color);
            vertical-align: middle;
        }

        .admin-table tbody tr {
            transition: background-color 0.2s ease;
        }
        .admin-table tbody tr:hover {
            background-color: rgba(255, 255, 255, 0.01);
        }

        .phone-code {
            font-family: 'Courier New', Courier, monospace;
            color: #28a745;
            background: rgba(40, 167, 69, 0.05);
            padding: 4px 8px;
            border-radius: 4px;
            font-weight: bold;
        }

        .badge {
            padding: 6px 14px;
            border-radius: 4px;
            font-size: 0.8rem;
            font-weight: 600;
            display: inline-block;
        }
        .badge-admin { background: rgba(212, 175, 55, 0.15); color: var(--gold-primary); border: 1px solid rgba(212, 175, 55, 0.3); }
        .badge-manager { background: rgba(23, 162, 184, 0.15); color: #17a2b8; border: 1px solid rgba(23, 162, 184, 0.3); }
        .badge-reception { background: rgba(40, 167, 69, 0.15); color: #28a745; border: 1px solid rgba(40, 167, 69, 0.3); }
        .badge-default { background: rgba(108, 117, 125, 0.15); color: #a8a8a8; border: 1px solid rgba(108, 117, 125, 0.3); }

        .action-group {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
        }

        .btn-action {
            padding: 8px 16px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.85rem;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: transparent;
        }
        .btn-detail { border: 1px solid var(--text-light); color: var(--text-light); }
        .btn-detail:hover { background: var(--text-light); color: #000; }
        .btn-update { border: 1px solid var(--gold-primary); color: var(--gold-primary); }
        .btn-update:hover { background: var(--gold-primary); color: #000; }
        .btn-delete { border: 1px solid #dc3545; color: #dc3545; }
        .btn-delete:hover { background: #dc3545; color: #fff; }
    </style>
</head>
<body>

<div class="sidebar">
    <div class="sidebar-header">
        <i class="fa-solid fa-crown"></i> VERDELLE ADMIN
    </div>
    <div class="nav-menu">
        <a href="${pageContext.request.contextPath}/quan-ly-tai-khoan" class="nav-item active">
            <i class="fa-solid fa-users-gear"></i> Quản lý Người dùng
        </a>

        <a href="${pageContext.request.contextPath}/quan-ly-doanh-thu" class="nav-item">
            <i class="fa-solid fa-chart-line"></i> Quản lý Doanh thu
        </a>

        <a href="${pageContext.request.contextPath}/quan-ly-voucher" class="nav-item">
            <i class="fa-solid fa-ticket"></i> Quản lý Voucher
        </a>
        <a href="${pageContext.request.contextPath}/logout" class="nav-item" style="color: #e74c3c; margin-top: auto;">
            <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
        </a>
    </div>
</div>

<div class="main-content">
    <div class="page-header">
        <h2 class="page-title">Quản Lý Người Dùng</h2>
        <div class="welcome-text">
            Chào mừng Quản trị viên: <strong>${sessionScope.firstName != null ? sessionScope.firstName : 'Admin'}</strong> <i class="fa-regular fa-hand-spock" style="color: var(--gold-primary); margin-left: 4px;"></i>
        </div>
    </div>

    <div class="data-panel">
        <h4 class="panel-title"><i class="fa-solid fa-address-book"></i> Danh Sách Thành Viên Hệ Thống</h4>

        <table class="admin-table">
            <thead>
            <tr>
                <th style="width: 8%;"># ID</th>
                <th>Họ và Tên</th>
                <th style="width: 22%;">Số Điện Thoại</th>
                <th style="width: 15%;">Vai Trò</th>
                <th style="text-align: right; width: 35%;">Thao Tác Hệ Thống</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${empty list}">
                    <tr>
                        <td colspan="5" style="color: #666; padding: 45px; text-align: center;">
                            Hiện tại danh sách thành viên đang trống hoặc chưa được tải từ Database lên.
                        </td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="item" items="${list}">
                        <tr>
                            <td><strong style="color: var(--gold-primary);">${item.id}</strong></td>
                            <td style="font-weight: 500; color: #fff; text-align: left;">${item.firstName} ${item.lastName}</td>
                            <td><span class="phone-code">(${item.countryCode}) ${item.phoneNumber}</span></td>
                            <td>
                                <c:choose>
                                    <c:when test="${item.role.trim().toLowerCase() == 'admin'}">
                                        <span class="badge badge-admin">Admin</span>
                                    </c:when>
                                    <c:when test="${item.role.trim().toLowerCase() == 'hotelmanager'}">
                                        <span class="badge badge-manager">Hotel Manager</span>
                                    </c:when>
                                    <c:when test="${item.role.trim().toLowerCase() == 'reception'}">
                                        <span class="badge badge-reception">Reception</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-default">${item.role}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="action-group">
                                    <a href="${pageContext.request.contextPath}/userdetail?id=${item.id}" class="btn-action btn-detail">
                                        <i class="fa-solid fa-circle-info"></i> Chi tiết
                                    </a>
                                    <a href="${pageContext.request.contextPath}/update?id=${item.id}" class="btn-action btn-update">
                                        <i class="fa-regular fa-pen-to-square"></i> Sửa
                                    </a>
                                    <a href="${pageContext.request.contextPath}/delete?id=${item.id}"
                                       class="btn-action btn-delete"
                                       onclick="return confirm('Cậu có chắc chắn muốn ngắt hoạt động thành viên này không?');">
                                        <i class="fa-regular fa-trash-can"></i> Xóa mềm
                                    </a>
                                </div>
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