<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Verdelle Hotel - Quản Lý Phòng Đối Tác</title>
    <link rel="stylesheet" href="css/HeaderStyle.css">
    <link rel="stylesheet" href="css/NavStyle.css">
    <link rel="stylesheet" href="css/FooterStyle.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --bg-color: #f4f7f6;
            --card-bg: #ffffff;
            --text-color: #333333;
            --border-color: #e0e0e0;
            --primary-color: #00bcd4;
        }

        /* Đồng bộ Dark Mode theo LocalStorage giống file Header của cậu */
        body.dark-mode {
            --bg-color: #1a1a1a;
            --card-bg: #2d2d2d;
            --text-color: #ffffff;
            --border-color: #444444;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--bg-color);
            color: var(--text-color);
            margin: 0;
            padding: 0;
            transition: background-color 0.3s, color 0.3s;
        }

        .container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .page-title h2 {
            margin: 0;
            font-size: 1.8rem;
            color: var(--primary-color);
        }

        .page-title p {
            margin: 5px 0 0 0;
            font-size: 0.9rem;
            opacity: 0.7;
        }

        .btn-add-room {
            background-color: #4caf50;
            color: white;
            text-decoration: none;
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: bold;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 4px 6px rgba(76, 175, 80, 0.2);
            transition: all 0.3s ease;
        }

        .btn-add-room:hover {
            background-color: #43a047;
            transform: translateY(-2px);
        }

        /* Định dạng bảng danh sách phòng */
        .room-table-card {
            background-color: var(--card-bg);
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            overflow: hidden;
            border: 1px solid var(--border-color);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }

        th {
            background-color: rgba(0, 188, 212, 0.1);
            color: var(--primary-color);
            padding: 15px;
            font-weight: 600;
            font-size: 0.95rem;
            border-bottom: 2px solid var(--border-color);
        }

        td {
            padding: 15px;
            border-bottom: 1px solid var(--border-color);
            font-size: 0.9rem;
            vertical-align: middle;
        }

        tr:hover {
            background-color: rgba(0, 0, 0, 0.02);
        }

        body.dark-mode tr:hover {
            background-color: rgba(255, 255, 255, 0.02);
        }

        .room-img {
            width: 70px;
            height: 50px;
            object-fit: cover;
            border-radius: 6px;
            border: 1px solid var(--border-color);
        }

        /* Badge Trạng thái phòng */
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
            white-space: nowrap;
        }

        .status-available {
            background-color: rgba(76, 175, 80, 0.15);
            color: #4caf50;
            border: 1px solid rgba(76, 175, 80, 0.3);
        }

        .status-available:hover {
            background-color: #4caf50;
            color: white;
        }

        .status-unavailable {
            background-color: rgba(244, 67, 54, 0.15);
            color: #f43f5e;
            border: 1px solid rgba(244, 67, 54, 0.3);
        }

        .status-unavailable:hover {
            background-color: #f43f5e;
            color: white;
        }

        /* Nút hành động Sửa / Xóa */
        .actions-cell {
            display: flex;
            gap: 10px;
        }

        .btn-action {
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 6px;
            text-decoration: none;
            font-size: 0.85rem;
            transition: all 0.2s ease;
        }

        .btn-edit {
            background-color: rgba(255, 152, 0, 0.15);
            color: #ff9800;
            border: 1px solid rgba(255, 152, 0, 0.3);
        }

        .btn-edit:hover {
            background-color: #ff9800;
            color: white;
        }

        .btn-delete {
            background-color: rgba(244, 67, 54, 0.15);
            color: #f44336;
            border: 1px solid rgba(244, 67, 54, 0.3);
        }

        .btn-delete:hover {
            background-color: #f44336;
            color: white;
        }

        .empty-message {
            padding: 40px;
            text-align: center;
            opacity: 0.6;
            font-style: italic;
        }
    </style>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="container">
    <div class="page-header">
        <div class="page-title">
            <h2>Quản Lý Danh Sách Phòng</h2>
            <p>Chào mừng quay trở lại, <strong>${sessionScope.firstName}</strong>! Dưới đây là các phòng thuộc khách sạn của cậu.</p>
        </div>
        <a href="quan-ly-phong?action=addForm" class="btn-add-room">
            <i class="fa-solid fa-circle-plus"></i> Thêm phòng mới
        </a>
    </div>

    <div class="room-table-card">
        <table>
            <thead>
            <tr>
                <th style="width: 80px; text-align: center;">Hình ảnh</th>
                <th>Tên phòng / Loại</th>
                <th style="text-align: center;">Mã khách sạn</th>
                <th style="text-align: center;">Diện tích</th>
                <th style="text-align: center;">Sức chứa tối đa</th>
                <th style="text-align: right;">Giá phòng / Đêm</th>
                <th style="text-align: center; width: 190px;">Trạng thái (Bấm đổi)</th>
                <th style="width: 100px; text-align: center;">Hành động</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${not empty rooms}">
                    <c:forEach var="room" items="${rooms}">
                        <tr>
                            <td style="text-align: center;">
                                <img src="${room.image}" class="room-img" alt="Room Image"
                                     onerror="this.src='https://images.unsplash.com/photo-1618773928121-c32242e63f39?w=500'">
                            </td>

                            <td>
                                <div style="font-weight: 600; color: var(--primary-color);">${room.roomName != null ? room.roomName : 'Chưa đặt tên'}</div>
                                <div style="font-size: 0.8rem; opacity: 0.7; margin-top: 2px;">${room.roomTypeName}</div>
                            </td>

                            <td style="text-align: center; font-weight: bold; opacity: 0.8;">
                                #${room.hotelId}
                            </td>

                            <td style="text-align: center;">
                                    ${room.area} m²
                            </td>

                            <td style="text-align: center;">
                                <i class="fa-solid fa-user" style="font-size: 0.8rem; opacity: 0.7;"></i> ${room.maxAdults} Lớn
                                <span style="margin: 0 4px; opacity: 0.3;">|</span>
                                <i class="fa-solid fa-child" style="font-size: 0.8rem; opacity: 0.7;"></i> ${room.maxChildren} Trẻ
                            </td>

                            <td style="text-align: right; font-weight: 600; color: #4caf50;">
                                <fmt:formatNumber value="${room.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                            </td>

                            <td style="text-align: center;">
                                <c:choose>
                                    <c:when test="${room.status == 'Available'}">
                                        <a href="quan-ly-phong?action=toggleStatus&roomId=${room.roomId}&currentStatus=${room.status}"
                                           class="status-badge status-available" title="Bấm để chuyển sang Bảo trì">
                                            <i class="fa-solid fa-circle-check"></i> Sẵn sàng đón khách
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="quan-ly-phong?action=toggleStatus&roomId=${room.roomId}&currentStatus=${room.status}"
                                           class="status-badge status-unavailable" title="Bấm để chuyển sang Sẵn sàng">
                                            <i class="fa-solid fa-screwdriver-wrench"></i> Đang bảo trì 🛠️
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <td style="text-align: center;">
                                <div class="actions-cell">
                                    <a href="quan-ly-phong?action=editForm&roomId=${room.roomId}" class="btn-action btn-edit" title="Sửa thông tin phòng">
                                        <i class="fa-solid fa-pen-to-square"></i>
                                    </a>
                                    <a href="quan-ly-phong?action=delete&roomId=${room.roomId}" class="btn-action btn-delete"
                                       title="Xóa phòng" onclick="return confirm('Cậu có chắc chắn muốn xóa phòng này không?');">
                                        <i class="fa-solid fa-trash-can"></i>
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="8" class="empty-message">
                            <i class="fa-solid fa-bed-pulse" style="font-size: 2rem; display:block; margin-bottom:10px; opacity:0.5;"></i>
                            Khách sạn của cậu hiện chưa cấu hình phòng nào hết nè.
                        </td>
                    </tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>
</div>

<script>
    // Đồng bộ chế độ ban đêm ăn theo sự kiện click ở Header của cậu ngay lập tức
    if (localStorage.getItem('theme') === 'dark') {
        document.body.classList.add('dark-mode');
    }

    // Lắng nghe thay đổi theme từ hệ thống nếu cậu click nút ở Header mà không reload trang
    window.addEventListener('storage', function() {
        if (localStorage.getItem('theme') === 'dark') {
            document.body.classList.add('dark-mode');
        } else {
            document.body.classList.remove('dark-mode');
        }
    });
</script>
</body>
<footer>
    <jsp:include page="footer.jsp" />
</footer>
</html>