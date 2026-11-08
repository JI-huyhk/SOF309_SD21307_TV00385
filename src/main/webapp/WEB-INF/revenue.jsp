<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thống Kê Doanh Thu - Verdelle Luxury</title>
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
            margin-bottom: 35px;
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

        /* --- HỆ THỐNG THẺ TIỆN ÍCH THỐNG KÊ (CARDS) --- */
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
            margin-bottom: 35px;
        }

        .dash-card {
            background: var(--panel-bg);
            border: 1px solid var(--border-color);
            padding: 24px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.2);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .card-info {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .card-label {
            font-size: 0.8rem;
            color: var(--text-light);
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .card-value {
            font-size: 1.4rem;
            font-weight: 600;
            color: #fff;
        }

        .card-value.gold {
            color: var(--gold-primary);
            font-family: 'Courier New', Courier, monospace;
        }

        /* Đã chỉnh màu icon sáng rõ nét lên màu vàng nhạt/hoàng kim */
        .card-icon {
            font-size: 2rem;
            color: var(--gold-primary);
            filter: drop-shadow(0 0 6px rgba(212, 175, 55, 0.3));
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

        /* --- CẤU TRÚC BẢNG --- */
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

        .code-style {
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

        <a href="${pageContext.request.contextPath}/quan-ly-doanh-thu" class="nav-item active">
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
        <h2 class="page-title">Báo Cáo Thống Kê Doanh Thu</h2>
        <div class="welcome-text">
            Chào mừng Quản trị viên: <strong>${sessionScope.firstName != null ? sessionScope.firstName : 'Admin'}</strong> <i class="fa-regular fa-hand-spock" style="color: var(--gold-primary); margin-left: 4px;"></i>
        </div>
    </div>

    <!-- CARDS: Đã xóa bớt thẻ Doanh Thu Treo và chỉnh sáng icon -->
    <div class="dashboard-grid">
        <div class="dash-card">
            <div class="card-info">
                <div class="card-label">Doanh Thu Thực Thu</div>
                <div class="card-value gold">
                    <fmt:formatNumber value="${totalReceived != null ? totalReceived : 0}" type="number" groupingUsed="true"/> đ
                </div>
            </div>
            <i class="fa-solid fa-wallet card-icon"></i>
        </div>
        <div class="dash-card">
            <div class="card-info">
                <div class="card-label">Tổng Đơn Đặt Phòng</div>
                <div class="card-value">${totalOrders != null ? totalOrders : 0} đơn</div>
            </div>
            <i class="fa-solid fa-bed card-icon"></i>
        </div>
    </div>

    <div class="data-panel">
        <h4 class="panel-title"><i class="fa-solid fa-money-bill-trend-up"></i> Danh Sách Doanh Thu Hệ Thống</h4>

        <table class="admin-table">
            <thead>
            <tr>
                <th style="width: 10%;"># ID</th>
                <th>Tên Khách Hàng</th>
                <th style="width: 20%;">Mã Phòng</th>
                <th style="width: 18%;">Ngày Check-In</th>
                <th style="width: 18%;">Tổng Tiền</th>
                <th style="width: 18%;">Trạng Thái</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${empty listRevenue}">
                    <tr>
                        <td colspan="6" style="color: #666; padding: 45px; text-align: center;">
                            Hiện tại danh sách doanh thu đang trống hoặc chưa được tải từ Database.
                        </td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="b" items="${listRevenue}">
                        <tr>
                            <td><strong style="color: var(--gold-primary);">${b.id}</strong></td>
                            <td style="font-weight: 500; color: #fff; text-align: left;">${b.customerName}</td>
                            <td><span class="code-style">${b.bookingCode}</span></td>
                            <td><fmt:formatDate value="${b.checkInDate}" pattern="dd/MM/yyyy"/></td>
                            <td>
                                <strong style="color: #fff;">
                                    <fmt:formatNumber value="${b.amount}" type="number" groupingUsed="true"/> đ
                                </strong>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${b.status eq 'Confirmed'}">
                                        <span class="badge bg-success">Đã xác nhận</span>
                                    </c:when>
                                    <c:when test="${b.status eq 'ReadyCheckIn'}">
                                        <span class="badge bg-info">Sẵn sàng Check-in</span>
                                    </c:when>
                                    <c:when test="${b.status eq 'Completed' or b.status eq 'CheckedOut'}">
                                        <span class="badge bg-primary">Hoàn thành</span>
                                    </c:when>
                                    <c:when test="${b.status eq 'Cancelled'}">
                                        <span class="badge bg-danger">Đã hủy</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-warning">Chờ thanh toán</span>
                                    </c:otherwise>
                                </c:choose>
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