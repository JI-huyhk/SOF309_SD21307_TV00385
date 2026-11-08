<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lịch Sử Thuê Phòng - Verdelle Luxury</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --sidebar-width: 260px;
            --bg-color: #0b0b0e;
            --panel-bg: #14141a;
            --sidebar-bg: #09090c;
            --text-light: #9a9aab;
            --text-dark: #f5f5f7;
            --gold-primary: #d4af37;
            --gold-hover: #b89327;
            --border-color: #22222a;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            background-color: var(--bg-color);
            color: var(--text-dark);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            display: flex;
            min-height: 100vh;
        }

        /* --- SIDEBAR NAVIGATION --- */
        .sidebar {
            width: var(--sidebar-width);
            background-color: var(--sidebar-bg);
            color: white;
            display: flex;
            flex-direction: column;
            border-right: 1px solid var(--border-color);
            position: fixed;
            top: 0;
            bottom: 0;
            left: 0;
            z-index: 100;
        }

        .sidebar-header {
            padding: 25px 20px;
            text-align: center;
            border-bottom: 1px solid var(--border-color);
            font-size: 1.2rem;
            font-weight: bold;
            color: var(--gold-primary);
            letter-spacing: 2px;
            text-shadow: 0px 2px 4px rgba(0, 0, 0, 0.5);
        }

        .nav-menu {
            list-style: none;
            padding: 0;
            margin: 20px 0;
            display: flex;
            flex-direction: column;
            height: 100%;
        }

        .nav-item {
            padding: 14px 20px;
            display: flex;
            align-items: center;
            gap: 15px;
            color: var(--text-light);
            text-decoration: none;
            transition: all 0.3s ease;
            font-size: 0.95rem;
        }

        .nav-item i { transition: transform 0.3s ease; }

        .nav-item:hover, .nav-item.active {
            background: linear-gradient(90deg, rgba(212, 175, 55, 0.1) 0%, rgba(20, 20, 26, 0) 100%);
            color: #fff;
            border-left: 4px solid var(--gold-primary);
        }

        .nav-item:hover i, .nav-item.active i {
            color: var(--gold-primary);
            transform: scale(1.1);
        }

        /* --- MAIN CONTENT AREA --- */
        .main-wrapper {
            margin-left: var(--sidebar-width);
            flex: 1;
            padding: 40px;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        h2 {
            color: #fff;
            font-weight: 400;
            font-size: 1.8rem;
            letter-spacing: 1px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        h2 i { color: var(--gold-primary); }

        /* --- BỘ LỌC DỮ LIỆU --- */
        .filter-box {
            background: var(--panel-bg);
            padding: 20px 25px;
            border-radius: 12px;
            margin-bottom: 25px;
            border: 1px solid var(--border-color);
        }

        .filter-form {
            display: flex;
            gap: 20px;
            align-items: flex-end;
            flex-wrap: wrap;
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

        .filter-form input[type="date"],
        .filter-form input[type="text"] {
            background: var(--bg-color);
            border: 1px solid var(--border-color);
            color: #fff;
            padding: 10px 14px;
            border-radius: 6px;
            outline: none;
            font-size: 0.9rem;
        }

        .filter-form input:focus {
            border-color: var(--gold-primary);
        }

        .btn-filter {
            background: linear-gradient(135deg, var(--gold-primary) 0%, var(--gold-hover) 100%);
            color: #000;
            border: none;
            padding: 11px 22px;
            font-weight: 600;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn-filter:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(212, 175, 55, 0.25);
        }

        .btn-reset {
            color: var(--text-light);
            text-decoration: none;
            font-size: 0.85rem;
            margin-bottom: 10px;
            transition: 0.2s;
        }

        .btn-reset:hover {
            color: var(--gold-primary);
            text-decoration: underline;
        }

        /* --- BẢNG DANH SÁCH --- */
        .table-responsive {
            background: var(--panel-bg);
            border-radius: 12px;
            border: 1px solid var(--border-color);
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.4);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 16px 20px;
            text-align: left;
            border-bottom: 1px solid var(--border-color);
            font-size: 0.95rem;
        }

        th {
            background-color: #1a1a22;
            color: var(--text-light);
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.8rem;
            letter-spacing: 0.8px;
        }

        tbody tr:hover {
            background-color: rgba(255, 255, 255, 0.02);
        }

        .badge {
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            display: inline-block;
        }

        .badge-success {
            background: rgba(46, 204, 113, 0.15);
            color: #2ecc71;
            border: 1px solid rgba(46, 204, 113, 0.3);
        }

        .badge-info {
            background: rgba(52, 152, 219, 0.15);
            color: #3498db;
            border: 1px solid rgba(52, 152, 219, 0.3);
        }

        .badge-warning {
            background: rgba(241, 196, 15, 0.15);
            color: #f1c40f;
            border: 1px solid rgba(241, 196, 15, 0.3);
        }

        .badge-danger {
            background: rgba(231, 76, 60, 0.15);
            color: #e74c3c;
            border: 1px solid rgba(231, 76, 60, 0.3);
        }

        .btn-invoice {
            background: transparent;
            border: 1px solid var(--gold-primary);
            color: var(--gold-primary);
            padding: 6px 12px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.8rem;
            font-weight: 600;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .btn-invoice:hover {
            background: var(--gold-primary);
            color: #000;
            box-shadow: 0 4px 12px rgba(212, 175, 55, 0.2);
        }
    </style>
</head>
<body>

<div class="sidebar">
    <div class="sidebar-header">
        <i class="fa-solid fa-hotel"></i> VERDELLE DESK
    </div>
    <div class="nav-menu">
        <a href="${pageContext.request.contextPath}/reception" class="nav-item">
            <i class="fa-solid fa-bed"></i> Sơ đồ phòng & Đặt phòng
        </a>
        <a href="${pageContext.request.contextPath}/checkin-list" class="nav-item">
            <i class="fa-solid fa-address-card"></i> Làm thủ tục Check-in
        </a>
        <a href="${pageContext.request.contextPath}/checkout-list" class="nav-item">
            <i class="fa-solid fa-right-from-bracket"></i> Làm thủ tục Check-out
        </a>
        <a href="${pageContext.request.contextPath}/room-controller" class="nav-item">
            <i class="fa-solid fa-door-closed"></i> Quản lý phòng
        </a>
        <a href="${pageContext.request.contextPath}/booking-history" class="nav-item active">
            <i class="fa-solid fa-clock-rotate-left"></i> Lịch sử thuê phòng
        </a>
        <a href="${pageContext.request.contextPath}/logout" class="nav-item" style="color: #e74c3c; margin-top: auto;">
            <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
        </a>
    </div>
</div>

<main class="main-wrapper">
    <div class="page-header">
        <h2><i class="fa-solid fa-clock-rotate-left"></i> LỊCH SỬ KHÁCH HÀNG ĐÃ THUÊ PHÒNG</h2>
    </div>

    <div class="filter-box">
        <form action="booking-history" method="GET" class="filter-form">
            <div class="form-group">
                <label>Từ ngày (Check-in):</label>
                <input type="date" name="fromDate" value="${fromDate}">
            </div>
            <div class="form-group">
                <label>Đến ngày (Check-in):</label>
                <input type="date" name="toDate" value="${toDate}">
            </div>
            <button type="submit" class="btn-filter"><i class="fa-solid fa-filter"></i> Lọc Dữ Liệu</button>
            <a href="booking-history" class="btn-reset"><i class="fa-solid fa-rotate-left"></i> Mặc định</a>
        </form>
    </div>

    <div class="table-responsive">
        <table>
            <thead>
            <tr>
                <th>Mã Đơn</th>
                <th>Tên Khách Hàng</th>
                <th>Số Phòng</th>
                <th>Ngày Đến</th>
                <th>Ngày Đi</th>
                <th>Tổng Tiền Hóa Đơn</th>
                <th>Trạng Thái</th>
                <th>Thao Tác</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="b" items="${historyList}">
                <tr>
                    <td><strong style="color: var(--gold-primary);">${b.bookingCode}</strong></td>
                    <td>${b.customerName != null ? b.customerName : 'Khách vãng lai'}</td>
                    <td><span style="font-weight: 600; color: #f39c12;">Phòng ${b.roomNumber != null ? b.roomNumber : b.roomId}</span></td>

                    <td><fmt:formatDate value="${b.checkInDate}" pattern="dd/MM/yyyy"/></td>
                    <td><fmt:formatDate value="${b.checkOutDate}" pattern="dd/MM/yyyy"/></td>

                    <td style="font-weight: 600; color: #2ecc71;">
                        <fmt:formatNumber value="${b.totalPrice}" type="number" maxFractionDigits="0"/> VND
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${b.status == 'completed' || b.status == 'Completed' || b.status == 'checkedout'}">
                                <span class="badge badge-success"><i class="fa-solid fa-circle-check"></i> Đã trả phòng</span>
                            </c:when>
                            <c:when test="${b.status == 'checkedin'}">
                                <span class="badge badge-info"><i class="fa-solid fa-bed"></i> Đang ở</span>
                            </c:when>
                            <c:when test="${b.status == 'cancelled'}">
                                <span class="badge badge-danger"><i class="fa-solid fa-ban"></i> Đã hủy</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-warning"><i class="fa-solid fa-hourglass-half"></i> Đang chờ (${b.status})</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:if test="${b.status == 'completed' || b.status == 'Completed' || b.status == 'checkedout'}">
                            <a href="view-invoice-details?bookingId=${b.id}" class="btn-invoice">
                                <i class="fa-solid fa-file-invoice-dollar"></i> Xem Hóa Đơn
                            </a>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty historyList}">
                <tr>
                    <td colspan="8" style="text-align: center; color: var(--text-light); padding: 40px 0;">
                        <i class="fa-solid fa-inbox" style="font-size: 2rem; display: block; margin-bottom: 10px; opacity: 0.5;"></i>
                        Không tìm thấy lịch sử thuê phòng nào trong hệ thống.
                    </td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>
</main>

</body>
</html>