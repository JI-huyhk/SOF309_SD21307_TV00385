<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.util.List" %>
<%@ page import="java.lang.reflect.Method" %>
<%
    // KIỂM TRA QUYỀN TRUY CẬP LỄ TÂN / QUẢN LÝ
    String role = (String) session.getAttribute("userRole");
    if (role == null || (!"hotelmanager".equals(role) && !"admin".equals(role))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Reception Desk - Verdelle Luxury</title>
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

        .main-header-wrapper {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .page-title {
            color: #fff;
            margin: 0;
            font-size: 1.8rem;
            font-weight: 400;
            letter-spacing: 1px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }

        .stat-card {
            background: var(--panel-bg);
            padding: 25px;
            border-radius: 12px;
            border: 1px solid var(--border-color);
            display: flex;
            align-items: center;
            justify-content: space-between;
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
            border-color: rgba(212, 175, 55, 0.3);
        }

        .stat-info h3 {
            margin: 0;
            font-size: 2.2rem;
            color: var(--gold-primary);
            font-weight: 600;
        }

        .stat-info p {
            margin: 8px 0 0 0;
            color: var(--text-light);
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .stat-icon {
            width: 55px;
            height: 55px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.6rem;
            background: rgba(212, 175, 55, 0.08);
            color: var(--gold-primary);
            border: 1px solid rgba(212, 175, 55, 0.2);
        }

        .data-panel {
            background: var(--panel-bg);
            border-radius: 12px;
            padding: 30px;
            border: 1px solid var(--border-color);
        }

        .data-panel h4 {
            margin-top: 0;
            color: #fff;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 20px;
            font-size: 1.1rem;
            font-weight: 500;
            letter-spacing: 0.5px;
        }

        .data-panel h4 i { color: var(--gold-primary); margin-right: 8px; }

        table { width: 100%; border-collapse: collapse; }

        th, td {
            padding: 16px 12px;
            text-align: left;
            border-bottom: 1px solid var(--border-color);
        }

        th {
            color: var(--text-light);
            font-weight: 500;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        td { color: var(--text-dark); font-size: 0.95rem; }

        tbody tr:hover { background-color: rgba(255, 255, 255, 0.02); }

        .btn-status {
            border: none;
            padding: 8px 18px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.85rem;
            font-weight: 600;
            letter-spacing: 0.5px;
            transition: all 0.3s ease;
            display: inline-block;
            vertical-align: middle;
            text-decoration: none;
        }

        .btn-checkin {
            background: linear-gradient(135deg, #2ecc71 0%, #27ae60 100%);
            color: #fff;
            box-shadow: 0 4px 10px rgba(46, 204, 113, 0.2);
        }
        .btn-checkin:hover { background: linear-gradient(135deg, #40d47e 0%, #2ecc71 100%); transform: translateY(-2px); }

        .btn-checkout {
            background: linear-gradient(135deg, #ff4d4d 0%, #cc0000 100%);
            color: #fff;
            box-shadow: 0 4px 10px rgba(255, 77, 77, 0.2);
        }
        .btn-checkout:hover { background: linear-gradient(135deg, #ff6666 0%, #ff4d4d 100%); transform: translateY(-2px); }

        .btn-completed {
            background-color: #2e7d32;
            color: white;
            border: none;
            padding: 8px 18px;
            border-radius: 6px;
            cursor: default;
            pointer-events: none;
            font-size: 0.85rem;
            font-weight: 600;
            display: inline-block;
            vertical-align: middle;
        }
        .btn-completed i { color: #fff; margin-left: 5px; }

        .btn-bill-history {
            background: transparent;
            border: 1px solid var(--gold-primary);
            color: var(--gold-primary);
            padding: 8px 14px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.85rem;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-block;
            margin-right: 8px;
            text-decoration: none;
            vertical-align: middle;
            white-space: nowrap;
        }
        .btn-bill-history:hover {
            background: var(--gold-primary);
            color: #000;
            box-shadow: 0 4px 12px rgba(212, 175, 55, 0.2);
        }

        /* --- MODAL STYLES --- */
        .modal {
            display: none;
            position: fixed;
            z-index: 2000;
            left: 0; top: 0;
            width: 100%; height: 100%;
            background-color: rgba(0,0,0,0.7);
            backdrop-filter: blur(5px);
            align-items: center; justify-content: center;
        }
        .modal-content {
            background-color: var(--panel-bg);
            border: 1px solid var(--border-color);
            padding: 30px;
            border-radius: 12px;
            width: 550px;
            box-shadow: 0 5px 25px rgba(0,0,0,0.5);
            animation: modalFadeIn 0.3s ease;
        }
        @keyframes modalFadeIn { from { opacity: 0; transform: translateY(-20px); } to { opacity: 1; transform: translateY(0); } }
        .modal-header {
            display: flex;
            justify-content: space-between; align-items: center;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 15px; margin-bottom: 20px;
        }
        .modal-header h3 { margin: 0; color: var(--gold-primary); font-size: 1.3rem; }
        .close-btn { color: var(--text-light); font-size: 24px; cursor: pointer; transition: color 0.3s; }
        .close-btn:hover { color: #ff4d4d; }
        .detail-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 15px 25px; margin-bottom: 20px; }
        .detail-item label { display: block; color: var(--text-light); font-size: 0.85rem; text-transform: uppercase; margin-bottom: 5px; }
        .detail-item span { color: #fff; font-size: 1rem; font-weight: 500; }
        .services-section { border-top: 1px solid var(--border-color); padding-top: 15px; margin-top: 15px; }
        .services-section h5 { color: var(--gold-primary); margin: 0 0 10px 0; font-size: 0.95rem; text-transform: uppercase; }
        .service-tag { display: inline-block; background: rgba(212, 175, 55, 0.1); border: 1px solid rgba(212, 175, 55, 0.2); color: var(--gold-primary); padding: 4px 10px; border-radius: 4px; font-size: 0.85rem; margin-right: 8px; margin-bottom: 8px; }
        .btn-viewmore { background: transparent; border: 1px solid var(--gold-primary); color: var(--gold-primary); padding: 7px 14px; border-radius: 6px; cursor: pointer; font-size: 0.8rem; font-weight: 600; transition: all 0.3s; margin-right: 5px; vertical-align: middle; }
        .btn-viewmore:hover { background: var(--gold-primary); color: #000; }
    </style>
</head>
<body>



<%!
    private String getValueByFieldName(Object obj, String fieldName) {
        if (obj == null) return "";
        try {
            for (Method m : obj.getClass().getMethods()) {
                if (m.getReturnType() != void.class && m.getParameterCount() == 0) {
                    if (m.getName().equalsIgnoreCase("get" + fieldName) || m.getName().equalsIgnoreCase(fieldName)) {
                        Object res = m.invoke(obj);
                        return res != null ? res.toString() : "";
                    }
                }
            }
        } catch (Exception e) {}
        return "";
    }

    private String extractCccdFromNote(String note) {
        if (note == null || note.trim().isEmpty()) return "Chưa cập nhật";

        // Quét tìm trực tiếp 12 chữ số (CCCD mới) trong toàn bộ chuỗi
        java.util.regex.Pattern p12 = java.util.regex.Pattern.compile("\\b\\d{12}\\b");
        java.util.regex.Matcher m12 = p12.matcher(note);
        if (m12.find()) {
            return m12.group();
        }

        // Nếu không có 12 số, quét tìm 9 chữ số (CMND cũ)
        java.util.regex.Pattern p9 = java.util.regex.Pattern.compile("\\b\\d{9}\\b");
        java.util.regex.Matcher m9 = p9.matcher(note);
        if (m9.find()) {
            return m9.group();
        }

        return "Chưa cập nhật";
    }
%>

<div class="sidebar">
    <div class="sidebar-header">
        <i class="fa-solid fa-hotel"></i> VERDELLE DESK
    </div>
    <div class="nav-menu">
        <a href="${pageContext.request.contextPath}/reception" class="nav-item active">
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
        <a href="${pageContext.request.contextPath}/booking-history" class="nav-item">
            <i class="fa-solid fa-clock-rotate-left"></i> Lịch sử thuê phòng
        </a>
        <a href="${pageContext.request.contextPath}/logout" class="nav-item" style="color: #e74c3c; margin-top: auto;">
            <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
        </a>
    </div>
</div>

<div class="main-content">
    <div class="main-header-wrapper">
        <h2 class="page-title">Quầy Tiếp Tân (Reception Desk)</h2>
    </div>

    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-info">
                <h3>${empty availableRooms ? '0' : availableRooms}</h3>
                <p>Phòng trống</p>
            </div>
            <div class="stat-icon"><i class="fa-solid fa-door-open"></i></div>
        </div>
        <div class="stat-card">
            <div class="stat-info">
                <h3>${empty bookedRooms ? '0' : bookedRooms}</h3>
                <p>Đang có khách ở</p>
            </div>
            <div class="stat-icon"><i class="fa-solid fa-bed"></i></div>
        </div>
        <div class="stat-card">
            <div class="stat-info">
                <h3>${empty dirtyRooms ? '0' : dirtyRooms}</h3>
                <p>Phòng chờ dọn (Dirty)</p>
            </div>
            <div class="stat-icon"><i class="fa-solid fa-broom"></i></div>
        </div>
        <div class="stat-card">
            <div class="stat-info">
                <h3>${empty incomingCheckins ? '0' : incomingCheckins}</h3>
                <p>Sắp Check-in hôm nay</p>
            </div>
            <div class="stat-icon"><i class="fa-solid fa-plane-arrival"></i></div>
        </div>
    </div>

    <div class="data-panel">
        <h4><i class="fa-solid fa-list-check"></i> Các đơn đặt phòng đang chờ</h4>
        <table>
            <thead>
            <tr>
                <th>Mã Booking</th>
                <th>Tên khách hàng</th>
                <th>Email</th>
                <th>Phòng/Trạng thái</th>
                <th>Hành động</th>
            </tr>
            </thead>
            <tbody>
            <%
                Object listObj = request.getAttribute("todayBookings");
                if (listObj != null && listObj instanceof java.util.List) {
                    java.util.List<?> todayBookings = (java.util.List<?>) listObj;
                    if (!todayBookings.isEmpty()) {
                        for (Object obj : todayBookings) {
                            String id = getValueByFieldName(obj, "bookingId");
                            if (id.isEmpty()) id = getValueByFieldName(obj, "id");

                            String bookingCode = getValueByFieldName(obj, "bookingCode");
                            if (bookingCode.isEmpty()) bookingCode = "BK-" + id;

                            String customerName = getValueByFieldName(obj, "customerName");
                            String phone = getValueByFieldName(obj, "phone");
                            String email = getValueByFieldName(obj, "email");
                            if (email == null || email.isEmpty()) email = "khachhang" + id + "@gmail.com";

                            String status = getValueByFieldName(obj, "status").toLowerCase().trim();

                            String cccd = getValueByFieldName(obj, "identityCard");
                            if (cccd.isEmpty()) {
                                cccd = getValueByFieldName(obj, "cccd");
                            }
                            // 2. Nếu chưa có thì mới mò trong chuỗi Note
                            if (cccd == null || cccd.trim().isEmpty() || "null".equalsIgnoreCase(cccd.trim()) || "Chưa cập nhật".equals(cccd)) {
                                String note = getValueByFieldName(obj, "note");
                                cccd = extractCccdFromNote(note);
                            }

                            String servicesUsed = "Dịch vụ phòng cơ bản";
            %>
            <tr>
                <td><strong style="color: var(--gold-primary);"><%= bookingCode %></strong></td>
                <td><%= customerName %></td>
                <td><%= email %></td>
                <td>
                    <% if ("checkedin".equals(status)) { %>
                    <span style="color: #2ecc71; font-weight: 600;"><i class="fa-solid fa-bed"></i> Đã Check-in</span>
                    <% } else if ("completed".equals(status) || "checkedout".equals(status)) { %>
                    <span style="color: #3498db; font-weight: 600;"><i class="fa-solid fa-circle-check"></i> Đã trả phòng</span>
                    <% } else if ("cancelled".equals(status) || "canceled".equals(status)) { %>
                    <span style="color: #e74c3c; font-weight: 600;"><i class="fa-solid fa-circle-xmark"></i> Đã hủy</span>
                    <% } else { %>
                    <span style="color: #f1c40f; font-weight: 600;"><i class="fa-solid fa-clock"></i> Chờ Check-in</span>
                    <% } %>
                </td>
                <td style="white-space: nowrap;">
                    <button class="btn-viewmore" onclick="openDetailModal('<%= bookingCode %>', '<%= customerName %>', '<%= cccd %>', '<%= phone %>', '<%= email %>', 'Chờ xếp phòng khi nhận phòng', '<%= servicesUsed %>')">
                        <i class="fa-solid fa-eye"></i> Xem thêm
                    </button>

                    <% if ("pending".equals(status)) { %>
                    <a href="${pageContext.request.contextPath}/checkin-list?bookingId=<%= id %>" class="btn-bill-history" title="Chuyển sang trang làm thủ tục">
                        Làm thủ tục <i class="fa-solid fa-arrow-right"></i>
                    </a>
                    <% } %>
                </td>
            </tr>
            <%
                }
            } else {
            %>
            <tr>
                <td colspan="5" style="text-align: center; color: var(--text-light); padding: 30px;">
                    <i class="fa-solid fa-circle-info" style="margin-right: 5px;"></i> Hiện tại không có đơn đặt phòng nào đang chờ xử lý.
                </td>
            </tr>
            <%
                }
            } else {
            %>
            <tr>
                <td colspan="5" style="text-align: center; color: var(--text-light); padding: 30px;">
                    <i class="fa-solid fa-triangle-exclamation" style="margin-right: 5px; color: #ff4d4d;"></i> Không tìm thấy dữ liệu từ Controller (todayBookings is null).
                </td>
            </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>
</div>

<div id="detailModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3><i class="fa-solid fa-circle-info"></i> Chi Tiết Đơn Đặt Phòng <span id="m_id"></span></h3>
            <span class="close-btn" onclick="closeDetailModal()">&times;</span>
        </div>
        <div class="detail-grid">
            <div class="detail-item"><label>Tên khách hàng</label><span id="m_name"></span></div>
            <div class="detail-item"><label>Số CCCD/Passport</label><span id="m_cccd"></span></div>
            <div class="detail-item"><label>Số điện thoại</label><span id="m_phone"></span></div>
            <div class="detail-item"><label>Địa chỉ Email</label><span id="m_email"></span></div>
            <div class="detail-item" style="grid-column: span 2;"><label>Thông tin phòng chi tiết</label><span id="m_room" style="color: var(--gold-primary);"></span></div>
        </div>
        <div class="services-section">
            <h5><i class="fa-solid fa-bell-concierge"></i> Dịch vụ đã sử dụng</h5>
            <div id="m_services"></div>
        </div>
    </div>
</div>

<script>
    function openDetailModal(code, name, cccd, phone, email, room, services) {
        document.getElementById("m_id").innerText = code;
        document.getElementById("m_name").innerText = name;
        document.getElementById("m_cccd").innerText = cccd;
        document.getElementById("m_phone").innerText = phone;
        document.getElementById("m_email").innerText = email;
        document.getElementById("m_room").innerText = room;

        var servicesContainer = document.getElementById("m_services");
        servicesContainer.innerHTML = "";

        if (services && services.trim() !== "") {
            var arr = services.split(",");
            arr.forEach(function(item) {
                var tag = document.createElement("span");
                tag.className = "service-tag";
                tag.innerText = item.trim();
                servicesContainer.appendChild(tag);
            });
        } else {
            servicesContainer.innerHTML = "<span style='color: var(--text-light); font-size:0.9rem;'>Chưa sử dụng dịch vụ nào.</span>";
        }

        document.getElementById("detailModal").style.display = "flex";
    }

    function closeDetailModal() {
        document.getElementById("detailModal").style.display = "none";
    }

    window.onclick = function(event) {
        var modal = document.getElementById("detailModal");
        if (event.target == modal) {
            modal.style.display = "none";
        }
    }
</script>
</body>
</html>