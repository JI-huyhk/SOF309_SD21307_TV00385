<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Xác Nhận Check-In - Verdelle Luxury</title>
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

        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--bg-color);
            color: var(--text-dark);
            display: flex;
            height: 100vh;
            overflow: hidden;
        }

        /* --- SIDEBAR NAVIGATION --- */
        .sidebar {
            width: var(--sidebar-width);
            background-color: var(--sidebar-bg);
            color: white;
            display: flex;
            flex-direction: column;
            border-right: 1px solid var(--border-color);
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
            overflow-y: auto;
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
        .main-content {
            flex: 1;
            padding: 40px;
            overflow-y: auto;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        h2 {
            color: #fff;
            margin: 0;
            font-weight: 400;
            font-size: 1.8rem;
            letter-spacing: 1px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        h2 i { color: var(--gold-primary); }

        /* --- BỘ LỌC / TÌM KIẾM --- */
        .search-box {
            background: var(--panel-bg);
            padding: 20px 25px;
            border-radius: 12px;
            margin-bottom: 25px;
            border: 1px solid var(--border-color);
        }

        .search-form {
            display: flex;
            gap: 15px;
            align-items: center;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
            flex: 1;
            max-width: 350px;
        }

        .form-group label {
            color: var(--text-light);
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .search-form input[type="text"] {
            background: var(--bg-color);
            border: 1px solid var(--border-color);
            color: #fff;
            padding: 10px 14px;
            border-radius: 6px;
            outline: none;
            font-size: 0.9rem;
        }

        .search-form input:focus {
            border-color: var(--gold-primary);
        }

        .btn-search {
            background: linear-gradient(135deg, var(--gold-primary) 0%, var(--gold-hover) 100%);
            color: #000;
            border: none;
            padding: 11px 22px;
            font-weight: 600;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 24px;
        }

        .btn-search:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(212, 175, 55, 0.25);
        }

        /* --- BẢNG DANH SÁCH CHECK-IN --- */
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
            vertical-align: middle;
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

        .btn-checkin-action {
            background: linear-gradient(135deg, #2ecc71 0%, #27ae60 100%);
            color: #000;
            border: none;
            padding: 8px 16px;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            font-size: 0.85rem;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            text-decoration: none;
        }

        .btn-checkin-action:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(46, 204, 113, 0.3);
        }

        .error-message {
            background: rgba(231, 76, 60, 0.15);
            border: 1px solid #e74c3c;
            color: #e74c3c;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 25px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
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
        <a href="${pageContext.request.contextPath}/checkin-list" class="nav-item active">
            <i class="fa-solid fa-address-card"></i> Làm thủ tục Check-in
        </a>
        <a href="${pageContext.request.contextPath}/checkout-list" class="nav-item">
            <i class="fa-solid fa-right-from-bracket"></i> Làm thủ tục Check-out
        </a>
        <a href="${pageContext.request.contextPath}/room-controller" class="nav-item">
            <i class="fa-solid fa-door-closed"></i> Quản lý phòng
        </a>
        <a href="${pageContext.request.contextPath}/booking-history" class="nav-item">
            <i class="fa-solid fa-clock-rotate-left"></i> Lịch sử thuê phòng
        </a>
        <!-- SỬA TẠI ĐÂY: Đã dọn dẹp kí tự thừa ở phần Đăng xuất -->
        <a href="${pageContext.request.contextPath}/logout" class="nav-item" style="color: #e74c3c; margin-top: auto;">
            <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
        </a>
    </div>
</div>

<main class="main-content">
    <div class="page-header">
        <h2><i class="fa-solid fa-address-card"></i> LÀM THỦ TỤC CHECK-IN KHÁCH HÀNG</h2>
    </div>

    <!-- Hiển thị lỗi nếu Servlet hoặc DAO có vấn đề -->
    <c:if test="${not empty errorMessage}">
        <div class="error-message">
            <i class="fa-solid fa-triangle-exclamation"></i> ${errorMessage}
        </div>
    </c:if>

    <div class="search-box">
        <form action="${pageContext.request.contextPath}/checkin-list" method="GET" class="search-form">
            <div class="form-group">
                <label>Mã Đặt Phòng / Tên Khách:</label>
                <input type="text" name="searchKey" value="${param.searchKey}" placeholder="Nhập mã booking hoặc tên khách...">
            </div>
            <button type="submit" class="btn-search"><i class="fa-solid fa-magnifying-glass"></i> Tìm Kiếm</button>
        </form>
    </div>

    <div class="table-responsive">
        <table>
            <thead>
            <tr>
                <th>Mã Booking</th>
                <th>Ngày Check-in</th>
                <th>Ngày Check-out</th>
                <th>Mã Khách Hàng</th>
                <th>Tên Khách Hàng</th>
                <th>Số Phòng</th>
                <th>CCCD / Passport</th>
                <th>Thao Tác</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${not empty checkinList}">
                    <c:forEach var="item" items="${checkinList}">
                        <tr>
                            <td>
                                <strong style="color: var(--gold-primary);">
                                        ${not empty item.bookingCode ? item.bookingCode : 'BK-ONLINE'}
                                </strong>
                            </td>

                            <td>
                                <fmt:formatDate value="${item.checkInDate}" pattern="dd/MM/yyyy"/>
                            </td>

                            <td>
                                <fmt:formatDate value="${item.checkOutDate}" pattern="dd/MM/yyyy"/>
                            </td>

                            <td>
                                <span style="color: #3b82f6; font-weight: 600;">
                                    KH-${item.customerId}
                                </span>
                            </td>

                            <td>
                                <strong>${item.customerName}</strong>
                            </td>

                            <td>
                                <span style="font-weight: 600; color: #f39c12;">
                                    Phòng ${not empty item.roomNumber ? item.roomNumber : item.roomId}
                                </span>
                            </td>

                            <td>
                                <span style="color: #2ecc71;">
                                        ${not empty item.identityCard ? item.identityCard : 'Chưa cập nhật'}
                                </span>
                            </td>

                            <td>
                                <form action="${pageContext.request.contextPath}/checkin-action" method="POST" style="margin:0;">
                                    <input type="hidden" name="action" value="checkin">
                                    <input type="hidden" name="bookingId" value="${item.id}">
                                    <input type="hidden" name="roomId" value="${item.roomId}">
                                    <button type="submit" class="btn-checkin-action">
                                        <i class="fa-solid fa-key"></i> Check-in
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>

                <c:otherwise>
                    <tr>
                        <td colspan="8" style="text-align: center; color: var(--text-light); padding: 40px 0;">
                            <i class="fa-solid fa-inbox" style="font-size: 2rem; display: block; margin-bottom: 10px; opacity: 0.5;"></i>
                            Không có đơn đặt phòng nào đang chờ Check-in.
                        </td>
                    </tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>
</main>
</body>
</html>