<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.temporal.ChronoUnit" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Đơn Đặt Phòng | Verdelle Hotel</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HeaderStyle.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- Flatpickr -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <link rel="stylesheet" type="text/css" href="https://npmcdn.com/flatpickr/dist/themes/dark.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>

    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        /* TÔNG MÀU LUXURY ĐEN - GOLD */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding-top: 90px;
            background-color: #121212;
            color: #fff;
            margin: 0;
            background-image: radial-gradient(circle at top right, #2a2211 0%, #121212 40%);
            min-height: 100vh;
        }

        .container {
            max-width: 1200px;
            margin: 30px auto;
            background: rgba(20, 20, 20, 0.85);
            backdrop-filter: blur(15px);
            padding: 30px;
            border-radius: 12px;
            border: 1px solid #dfb76c;
            box-shadow: 0 10px 40px rgba(0,0,0,0.8);
        }

        /* KHU VỰC CHART VÀ STATS */
        .dashboard-top {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: linear-gradient(135deg, rgba(223, 183, 108, 0.1), rgba(0,0,0,0.5));
            padding: 20px;
            border-radius: 8px;
            border-left: 5px solid #dfb76c;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .stat-card h2 { margin: 0 0 10px 0; color: #dfb76c; font-size: 1.5rem; text-transform: uppercase; letter-spacing: 1px;}
        .points-display { font-size: 1.8rem; font-weight: bold; color: #ffca28; margin-bottom: 5px;}
        .points-desc { font-size: 0.9rem; color: #aaa; }

        .chart-container {
            background: rgba(0, 0, 0, 0.6);
            padding: 15px;
            border-radius: 8px;
            border: 1px solid #333;
            height: 200px;
            position: relative;
        }

        /* TABS VÀ FILTER */
        .controls-wrapper { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 20px; }
        .tabs { display: flex; gap: 10px; }
        .tab-btn { background: rgba(255,255,255,0.05); color: #ccc; border: 1px solid #333; padding: 10px 25px; border-radius: 6px; cursor: pointer; font-weight: bold; transition: all 0.3s; }
        .tab-btn.active { background: #dfb76c; color: #000; border-color: #ffca28; box-shadow: 0 0 15px rgba(223, 183, 108, 0.5); }
        .filter-box { width: 300px; }
        .filter-box label { display: block; font-size: 0.85rem; color: #aaa; margin-bottom: 5px; }
        .date-input-wrap { display: flex; align-items: center; background: rgba(0,0,0,0.5); border: 1px solid #dfb76c; border-radius: 6px; padding: 8px 15px; }
        .date-input-wrap i { color: #dfb76c; margin-right: 10px; }
        .date-input-wrap input { background: transparent; border: none; color: #fff; width: 100%; outline: none; font-family: inherit; }

        /* BẢNG DỮ LIỆU & HIỆU ỨNG CHUYỂN TAB CỰC CHÁY */
        .table-container { overflow-x: auto; display: none; }
        .table-container.active { display: block; animation: fireTab 0.5s cubic-bezier(0.25, 1, 0.5, 1) forwards; }
        @keyframes fireTab {
            0% { opacity: 0; transform: scale(0.95) translateY(20px); filter: brightness(2) drop-shadow(0 0 20px #dfb76c); }
            50% { opacity: 0.8; filter: brightness(1.5) drop-shadow(0 0 10px #dfb76c); }
            100% { opacity: 1; transform: scale(1) translateY(0); filter: brightness(1) drop-shadow(0 0 0 transparent); }
        }

        /* HIỆU ỨNG NĂNG LƯỢNG GOLD */
        .energy-bar-container {
            width: 100%; height: 12px; background: rgba(0,0,0,0.6);
            border-radius: 10px; overflow: hidden; margin: 15px 0;
            border: 1px solid #dfb76c; box-shadow: inset 0 1px 5px rgba(0,0,0,0.8);
        }
        .energy-bar-fill {
            height: 100%; width: 0%; border-radius: 10px;
            background: linear-gradient(90deg, #aa8443, #ffca28, #fffde7, #ffca28, #dfb76c);
            background-size: 300% 300%;
            animation: goldFlow 1.5s ease infinite;
            transition: width 1.5s cubic-bezier(0.25, 1, 0.5, 1);
            box-shadow: 0 0 10px rgba(255, 202, 40, 0.6);
        }
        @keyframes goldFlow { 0% { background-position: 0% 50%; } 50% { background-position: 100% 50%; } 100% { background-position: 0% 50%; } }

        /* ĐIỂM NHẤP NHÁY VÀ COUNTUP */
        .glowing-points { display: inline-block; text-shadow: 0 0 15px rgba(255, 202, 40, 0.8); animation: pulseGold 2s infinite; font-weight: 900; }
        @keyframes pulseGold {
            0% { text-shadow: 0 0 10px rgba(255, 202, 40, 0.5); }
            50% { text-shadow: 0 0 20px rgba(255, 202, 40, 1), 0 0 30px rgba(255, 255, 255, 0.5); transform: scale(1.05); }
            100% { text-shadow: 0 0 10px rgba(255, 202, 40, 0.5); }
        }

        table { width: 100%; border-collapse: collapse; text-align: center; }
        th { background: rgba(223, 183, 108, 0.15); color: #dfb76c; padding: 15px; border-bottom: 2px solid #dfb76c; text-transform: uppercase; font-size: 0.9rem; }
        td { padding: 15px; border-bottom: 1px solid rgba(223, 183, 108, 0.2); vertical-align: middle; }
        tr:hover td { background: rgba(255, 255, 255, 0.03); }

        /* NÚT VÀ HIỆU ỨNG */
        .btn-cancel { background: linear-gradient(135deg, #e74c3c, #c0392b); color: white; padding: 8px 15px; border-radius: 4px; border: none; cursor: pointer; transition: 0.3s; font-weight: bold; width: 100%; }
        .btn-cancel:hover { transform: translateY(-2px); box-shadow: 0 6px 15px rgba(231, 76, 60, 0.5); }
        .status-badge { padding: 6px 12px; border-radius: 20px; font-size: 0.8rem; font-weight: bold; display: inline-block;}
        .badge-upcoming { background: rgba(241, 196, 15, 0.2); color: #f1c40f; border: 1px solid #f1c40f; } /* Sắp tới */
        .badge-checkedin { background: rgba(52, 152, 219, 0.2); color: #3498db; border: 1px solid #3498db; } /* Đang check-in */
        .badge-completed { background: rgba(46, 204, 113, 0.2); color: #2ecc71; border: 1px solid #2ecc71; } /* Hoàn thành */
        .badge-cancelled { background: rgba(231, 76, 60, 0.2); color: #e74c3c; border: 1px solid #e74c3c; } /* Đã hủy */

        .msg-alert { padding: 15px; border-radius: 6px; margin-bottom: 20px; font-weight: bold; display: flex; align-items: center; gap: 10px; border-left: 4px solid; }
        .msg-alert.success { background: rgba(223, 183, 108, 0.1); color: #dfb76c; border-color: #dfb76c; }
        .msg-alert.error { background: rgba(231, 76, 60, 0.1); color: #e74c3c; border-color: #e74c3c; }

        .reflection-timer { font-size: 0.85rem; color: #ffca28; margin-top: 5px; font-weight: bold; display: inline-block; }

        .btn-review {
            background: linear-gradient(135deg, #dfb76c, #c89b3c);
            color: #000;
            padding: 7px 14px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: bold;
            font-size: 0.85rem;
            display: inline-block;
            transition: all 0.3s ease;
            box-shadow: 0 2px 10px rgba(223, 183, 108, 0.3);
        }
        .btn-review:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(223, 183, 108, 0.6);
            color: #000;
        }
        .status-badge-reviewed {
            background: rgba(46, 204, 113, 0.15);
            color: #2ecc71;
            border: 1px solid #2ecc71;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: bold;
            display: inline-block;
        }
    </style>
</head>
<body>
<jsp:include page="header.jsp" />

<div class="container">

    <!-- KHU VỰC THỐNG KÊ VÀ CHART -->
    <div class="dashboard-top">
        <div class="stat-card">
            <%
                Integer currentUserId = (Integer) session.getAttribute("userId");
                if(currentUserId != null) {
                    try {
                        dao.UserDAO uDao = new dao.UserDAO();
                        java.util.Map<String, Object> points = uDao.getUserPoints(currentUserId);
                        if(points != null && points.get("uyTin") != null) {
                            request.setAttribute("uyTin", points.get("uyTin"));
                            request.setAttribute("loyalPoint", points.get("loyalPoint"));
                            request.setAttribute("rank", points.get("rank"));
                        }
                    } catch (Exception e) { e.printStackTrace(); }
                }
            %>
            <div style="display: flex; justify-content: space-between; align-items: flex-end;">
                <h2><i class="fa-solid fa-crown"></i> Cấp Bậc: <span style="color: #fff;">${not empty requestScope.rank ? requestScope.rank : 'Thành Viên Mới'}</span></h2>
                <div style="font-size: 0.85rem; color: #dfb76c; font-weight: bold;" id="next-rank-info">Đang tính toán...</div>
            </div>

            <!-- THANH NĂNG LƯỢNG RANK -->
            <div class="energy-bar-container">
                <div class="energy-bar-fill" id="rank-progress-bar"></div>
            </div>

            <div class="points-display">
                <i class="fa-solid fa-shield-halved"></i> <span id="uyTinCount" class="glowing-points">0</span> Điểm Uy Tín
            </div>
            <div class="points-desc">
                Điểm Thành Viên: <strong style="color: #fff;" class="glowing-points" id="loyalPointCount">0</strong> <strong style="color: #fff;">PTS</strong>
            </div>
        </div>
        <div class="chart-container">
            <canvas id="pointsChart"></canvas>
        </div>
    </div>

    <c:if test="${not empty requestScope.message}">
        <div class="msg-alert ${requestScope.msgType == 'success' ? 'success' : 'error'}">
            <i class="fa-solid ${requestScope.msgType == 'success' ? 'fa-check-circle' : 'fa-triangle-exclamation'}"></i>
                ${requestScope.message}
        </div>
    </c:if>
    <c:choose>
        <c:when test="${not empty requestScope.uyTin and requestScope.uyTin <= 0}">
            <!-- KHU VỰC BỊ KHÓA DO ĐIỂM UY TÍN = 0 -->
            <div style="text-align: center; padding: 60px 20px; background: rgba(0,0,0,0.85); border-radius: 12px; border: 2px dashed #e74c3c; margin-top: 30px; box-shadow: 0 0 30px rgba(231, 76, 60, 0.2);">
                <i class="fa-solid fa-lock" style="font-size: 5rem; color: #e74c3c; margin-bottom: 25px;"></i>
                <h2 style="color: #e74c3c; font-size: 2rem; text-transform: uppercase; margin-bottom: 15px;">Tài Khoản Bị Hạn Chế Chức Năng</h2>
                <p style="font-size: 1.1rem; color: #ddd; max-width: 650px; margin: 0 auto 35px; line-height: 1.8;">
                    Vì điểm uy tín của bạn chỉ còn <strong style="color: #e74c3c; font-size: 1.3rem;">0</strong>, bạn không thể thực hiện thêm thao tác hủy đơn hay quản lý phòng lúc này.<br><br>
                    Hãy đến khách sạn và trải nghiệm dịch vụ đối với những đơn đã đặt. Sau khi hoàn tất thủ tục <strong>Check-out</strong>, khu vực này sẽ được mở khóa, đồng thời bạn sẽ được thưởng <strong style="color: #2ecc71;">+25 điểm Uy tín</strong> và <strong style="color: #ffca28;">+100 Điểm thành viên</strong>.
                </p>
                <a href="${pageContext.request.contextPath}/home.jsp" style="display: inline-block; padding: 12px 35px; background: linear-gradient(135deg, #dfb76c, #c89b3c); color: #000; text-decoration: none; font-weight: bold; border-radius: 6px; transition: 0.3s; font-size: 1.1rem;"><i class="fa-solid fa-house"></i> Quay Về Trang Chủ</a>
            </div>
        </c:when>
        <c:otherwise>
            <!-- MỞ C:OTHERWISE BỌC LẠI GIAO DIỆN CŨ -->
            <div class="controls-wrapper">
                <div class="tabs">
                    <button class="tab-btn active" onclick="switchTab('pending')">Đơn Sắp Tới</button>
                    <button class="tab-btn" onclick="switchTab('checkedin')">Đang Lưu Trú</button>
                    <button class="tab-btn" onclick="switchTab('completed')">Đã Trả Phòng</button>
                    <button class="tab-btn" onclick="switchTab('cancelled')">Đã Hủy</button>
                </div>
                <div class="filter-box">
                    <label>Lọc xem theo ngày Check-in:</label>
                    <div class="date-input-wrap">
                        <i class="fa-regular fa-calendar"></i>
                        <input type="text" id="dateFilter" placeholder="Chọn ngày...">
                    </div>
                </div>
            </div>

            <!-- BẢNG 1: ĐƠN SẮP TỚI (PENDING - Có nút hủy) -->
            <div id="tab-pending" class="table-container active">
                <table>
                    <thead>
                    <tr>
                        <th>Mã Đặt</th>
                        <th>Phòng</th>
                        <th>Check-in</th>
                        <th>Check-out</th>
                        <th>Tổng Tiền</th>
                        <th>Trạng Thái</th>
                        <th>Chi Tiết</th>
                        <th>Hành Động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:set var="hasPending" value="false" />
                    <c:forEach items="${bookingHistory}" var="b">
                        <c:if test="${b.status == 'pending'}">
                            <c:set var="hasPending" value="true" />
                            <%
                                model.Booking currentB = (model.Booking) pageContext.getAttribute("b");
                                boolean canCancelFrontend = false;
                                String cancelMsgFrontend = "";
                                int customerType = 2;

                                java.time.LocalDate checkIn = new java.sql.Date(currentB.getCheckInDate().getTime()).toLocalDate();
                                java.time.LocalDate checkOut = (currentB.getCheckOutDate() != null) ?
                                        new java.sql.Date(currentB.getCheckOutDate().getTime()).toLocalDate() : checkIn.plusDays(1);

                                java.util.Date createdAtDate = currentB.getCreatedAt();
                                java.time.LocalDateTime createdAt = (createdAtDate != null) ?
                                        new java.sql.Timestamp(createdAtDate.getTime()).toLocalDateTime() :
                                        java.time.LocalDateTime.now();

                                long daysNotice = java.time.temporal.ChronoUnit.DAYS.between(createdAt.toLocalDate(), checkIn);
                                long totalNights = java.time.temporal.ChronoUnit.DAYS.between(checkIn, checkOut);
                                long minutesElapsed = java.time.temporal.ChronoUnit.MINUTES.between(createdAt, java.time.LocalDateTime.now());
                                double penaltyPercent = 0.0;
                                double penaltyFee = 0.0; // BỔ SUNG: Biến tính ra SỐ TIỀN PHẠT THỰC TẾ

                                if (daysNotice >= 2 && totalNights > 10) {
                                    customerType = 1;
                                    if (minutesElapsed <= 20) {
                                        canCancelFrontend = true;
                                        penaltyPercent = 0.0;
                                        penaltyFee = 0.0;
                                        cancelMsgFrontend = "Bạn đang trong 20 phút an toàn. Hủy đơn sẽ MIỄN PHÍ tiền phòng nhưng bị trừ cứng 25 điểm Uy Tín/Thành Viên. Bạn chắc chắn chứ?";
                                    } else if (minutesElapsed <= 80) { // ĐÃ SỬA: 20 phút đầu + 60 phút tiếp theo = 80 phút
                                        canCancelFrontend = true;
                                        penaltyPercent = 50.0;
                                        penaltyFee = currentB.getTotalPrice() * 0.5; // TÍNH 50% TIỀN PHẠT
                                        cancelMsgFrontend = "Bạn đã qua 20 phút an toàn. Khung giờ hiện tại sẽ bị PHẠT 50% tiền phòng và trừ 25 điểm. Bạn chắc chắn chứ?";
                                    }
                                } else {
                                    customerType = 2;
                                    if (minutesElapsed <= 20) {
                                        canCancelFrontend = true;
                                        penaltyPercent = 5.0;
                                        penaltyFee = currentB.getTotalPrice() * 0.05; // TÍNH 5% TIỀN PHẠT
                                        cancelMsgFrontend = "Bạn có 20 phút để hủy đơn. Phạt 5% tiền phòng và trừ cứng 25 điểm Uy Tín/Thành Viên. Bạn chắc chắn chứ?";
                                    }
                                }
                                pageContext.setAttribute("penaltyPercent", penaltyPercent);
                                pageContext.setAttribute("penaltyFee", penaltyFee); // Đẩy tiền thật ra JSTL
                                pageContext.setAttribute("totalNights", totalNights);
                                pageContext.setAttribute("customerType", customerType);
                                pageContext.setAttribute("canCancelFrontend", canCancelFrontend);
                                pageContext.setAttribute("cancelMsgFrontend", cancelMsgFrontend);
                            %>
                            <tr class="booking-row" data-checkin="${b.checkInDate}">
                                <td style="font-weight: bold;">${b.bookingCode}</td>
                                <td style="color: #dfb76c; font-weight: bold;">R-${b.roomId}</td>
                                <td>${b.checkInDate}</td>
                                <td>${b.checkOutDate}</td>
                                <td style="color: #f1c40f; font-weight: bold;"><fmt:formatNumber value="${b.totalPrice}" type="currency" currencySymbol="₫"/></td>
                                <td><span class="status-badge badge-upcoming"><i class="fa-solid fa-clock"></i> Sắp tới</span></td>
                                <td style="text-align: center;">
                                    <div style="margin-bottom: 8px;">
                                        <c:choose>
                                            <c:when test="${customerType == 1}">
                                                <span class="type-badge blink-gold" title="Bạn là khách hàng VIP lưu trú dài ngày!"><i class="fa-solid fa-star"></i> KHÁCH LOẠI 1</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="type-badge blink-blue" title="Chính sách tiêu chuẩn áp dụng cho đơn này."><i class="fa-solid fa-user"></i> KHÁCH LOẠI 2</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div style="display: flex; gap: 5px; justify-content: center;">
                                        <button type="button" class="btn-info" onclick="showPolicy(${customerType})"><i class="fa-solid fa-scroll"></i> CS Hủy</button>
                                        <button type="button" class="btn-info" onclick="showBookingDetails('${b.bookingCode}', '${b.checkInDate}', '${b.checkOutDate}', ${totalNights}, '${b.roomId}')"><i class="fa-solid fa-eye"></i> Lịch Trình</button>
                                    </div>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${canCancelFrontend}">
                                            <!-- SỬA: Gọi hàm JS checkRealTimeCancel thay vì confirm mặc định -->
                                            <form action="${pageContext.request.contextPath}/CancelController" method="POST" onsubmit="return checkRealTimeCancel(event, ${b.createdAt.time}, ${customerType}, '${cancelMsgFrontend}');">
                                                <input type="hidden" name="bookingId" value="${b.id}">
                                                <input type="hidden" name="penaltyPercent" value="${penaltyPercent}">
                                                <!-- BỔ SUNG: Truyền thẳng SỐ TIỀN PHẠT về cho Controller -->
                                                <input type="hidden" name="penaltyFee" value="${penaltyFee}">
                                                <button type="submit" class="btn-cancel"><i class="fa-solid fa-xmark"></i> Hủy Phòng</button>
                                                <div class="reflection-timer" data-booking-time="${b.createdAt.time}" data-type="${customerType}">
                                                    <i class="fa-solid fa-hourglass-half"></i> Đang tính toán...
                                                </div>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <span style='color:#e74c3c; font-size: 0.85rem; font-style: italic;'><i class="fa-solid fa-lock"></i> Đã vô hiệu hóa hủy</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:if>
                    </c:forEach>
                    <c:if test="${not hasPending}">
                        <tr><td colspan="8" style="color: #888; padding: 40px;"><i class="fa-regular fa-folder-open fa-2x"></i><br><br>Không có đơn phòng nào đang chờ.</td></tr>
                    </c:if>
                    </tbody>
                </table>
            </div>

            <!-- BẢNG 2: ĐANG LƯU TRÚ (CHECKED-IN - Không có nút hủy) -->
            <div id="tab-checkedin" class="table-container">
                <table>
                    <thead>
                    <tr>
                        <th>Mã Đặt</th>
                        <th>Phòng</th>
                        <th>Check-in</th>
                        <th>Check-out</th>
                        <th>Tổng Tiền</th>
                        <th>Trạng Thái</th>
                        <th>Ghi Chú</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:set var="hasCheckedIn" value="false" />
                    <c:forEach items="${bookingHistory}" var="b">
                        <c:if test="${b.status == 'checkedin'}">
                            <c:set var="hasCheckedIn" value="true" />
                            <tr class="booking-row" data-checkin="${b.checkInDate}">
                                <td style="font-weight: bold;">${b.bookingCode}</td>
                                <td style="color: #dfb76c; font-weight: bold;">R-${b.roomId}</td>
                                <td>${b.checkInDate}</td>
                                <td>${b.checkOutDate}</td>
                                <td style="color: #3498db; font-weight: bold;"><fmt:formatNumber value="${b.totalPrice}" type="currency" currencySymbol="₫"/></td>
                                <td><span class="status-badge badge-checkedin"><i class="fa-solid fa-bed"></i> Đang lưu trú</span></td>
                                <td>
                                    <span style='color:#888; font-size: 0.85rem;'><i class="fa-solid fa-ban"></i> Hủy bị khóa</span>
                                </td>
                            </tr>
                        </c:if>
                    </c:forEach>
                    <c:if test="${not hasCheckedIn}">
                        <tr><td colspan="7" style="color: #888; padding: 40px;">Bạn hiện không lưu trú tại phòng nào.</td></tr>
                    </c:if>
                    </tbody>
                </table>
            </div>

            <!-- BẢNG 3: ĐÃ TRẢ PHÒNG (COMPLETED) -->
            <div id="tab-completed" class="table-container">
                <table>
                    <thead>
                    <tr>
                        <th>Mã Đặt</th>
                        <th>Phòng</th>
                        <th>Check-in</th>
                        <th>Check-out</th>
                        <th>Tổng Tiền</th>
                        <th>Trạng Thái</th>
                        <th>Đánh Giá Dịch Vụ</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:set var="hasCompleted" value="false" />
                    <c:forEach items="${bookingHistory}" var="b">
                        <c:if test="${b.status == 'completed'}">
                            <c:set var="hasCompleted" value="true" />
                            <tr class="booking-row" data-checkin="${b.checkInDate}">
                                <td style="font-weight: bold;">${b.bookingCode}</td>
                                <td style="color: #dfb76c; font-weight: bold;">R-${b.roomId}</td>
                                <td>${b.checkInDate}</td>
                                <td>${b.checkOutDate}</td>
                                <td style="color: #2ecc71; font-weight: bold;"><fmt:formatNumber value="${b.totalPrice}" type="currency" currencySymbol="₫"/></td>
                                <td><span class="status-badge badge-completed"><i class="fa-solid fa-check-double"></i> Đã trả phòng</span></td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/review.jsp?bookingId=${b.id}&roomId=${b.roomId}&bookingCode=${b.bookingCode}" class="btn-review">
                                        <i class="fa-solid fa-star"></i> Đánh giá ngay
                                    </a>
                                </td>
                            </tr>
                        </c:if>
                    </c:forEach>
                    <c:if test="${not hasCompleted}">
                        <tr><td colspan="7" style="color: #888; padding: 40px;">Chưa có lịch sử hoàn thành chuyến đi nào.</td></tr>
                    </c:if>
                    </tbody>
                </table>
            </div>

            <!-- BẢNG 4: ĐÃ HỦY (CANCELLED) -->
            <div id="tab-cancelled" class="table-container">
                <table>
                    <thead>
                    <tr>
                        <th>Mã Đặt</th>
                        <th>Phòng</th>
                        <th>Check-in</th>
                        <th>Tổng Tiền</th>
                        <th>Trạng Thái</th>
                        <th>Hậu Quả / Ghi Chú</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:set var="hasCancelled" value="false" />
                    <c:forEach items="${bookingHistory}" var="b">
                        <c:if test="${b.status == 'cancelled'}">
                            <c:set var="hasCancelled" value="true" />
                            <tr class="booking-row" data-checkin="${b.checkInDate}" style="opacity: 0.6; filter: grayscale(50%);">
                                <td>${b.bookingCode}</td>
                                <td>R-${b.roomId}</td>
                                <td>${b.checkInDate}</td>
                                <td style="text-decoration: line-through;"><fmt:formatNumber value="${b.totalPrice}" type="currency" currencySymbol="₫"/></td>
                                <td><span class="status-badge badge-cancelled"><i class="fa-solid fa-ban"></i> Đã Hủy</span></td>
                                <td style="color: #e74c3c; font-size: 0.85rem; font-weight: bold;">
                                    Xem chi tiết trong Mail / Lịch sử phạt
                                </td>
                            </tr>
                        </c:if>
                    </c:forEach>
                    <c:if test="${not hasCancelled}">
                        <tr><td colspan="6" style="color: #888; padding: 40px;">Lịch sử hủy phòng của bạn đang trống. Rất cảm ơn vì sự uy tín của bạn!</td></tr>
                    </c:if>
                    </tbody>
                </table>
            </div>

        </c:otherwise>
    </c:choose>
</div>
<!-- STYLE CHO BADGE VÀ MODAL -->
<style>
    .btn-info { background: transparent; color: #dfb76c; border: 1px solid #dfb76c; padding: 5px 10px; border-radius: 4px; cursor: pointer; transition: 0.3s; font-size: 0.8rem;}
    .btn-info:hover { background: #dfb76c; color: #000; }

    .type-badge { font-size: 0.75rem; padding: 3px 8px; border-radius: 12px; font-weight: bold; border: 1px solid; display: inline-block;}
    .blink-gold { color: #ffca28; border-color: #ffca28; animation: blinker 1.5s linear infinite; }
    .blink-blue { color: #3498db; border-color: #3498db; animation: blinker 2s linear infinite; }
    @keyframes blinker { 50% { opacity: 0.3; } }

    /* THEME MODAL CUSTOM */
    .custom-modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.8); backdrop-filter: blur(5px); }
    .modal-content { background: linear-gradient(to bottom, #1a1a1a, #121212); margin: 10% auto; padding: 25px; border: 1px solid #dfb76c; border-radius: 8px; width: 450px; color: #fff; box-shadow: 0 0 20px rgba(223, 183, 108, 0.3); position: relative;}
    .close-modal { color: #aaa; float: right; font-size: 28px; font-weight: bold; cursor: pointer; }
    .close-modal:hover { color: #dfb76c; }
    .modal-title { color: #dfb76c; border-bottom: 1px solid #333; padding-bottom: 10px; margin-top: 0; }
    .modal-body p { line-height: 1.6; color: #ccc; }
    .highlight-text { color: #ffca28; font-weight: bold; }
</style>

<!-- MODAL CHÍNH SÁCH -->
<div id="policyModal" class="custom-modal">
    <div class="modal-content">
        <span class="close-modal" onclick="closeModals()">&times;</span>
        <h3 class="modal-title"><i class="fa-solid fa-scale-balanced"></i> Chính Sách Hủy Phòng</h3>
        <div id="policyBody" class="modal-body">
            <!-- Nội dung sẽ được JS fill vào -->
        </div>
    </div>
</div>

<!-- MODAL LỊCH TRÌNH -->
<div id="detailsModal" class="custom-modal">
    <div class="modal-content">
        <span class="close-modal" onclick="closeModals()">&times;</span>
        <h3 class="modal-title"><i class="fa-solid fa-map-location-dot"></i> Chi Tiết Lịch Trình</h3>
        <div id="detailsBody" class="modal-body">
            <!-- Nội dung sẽ được JS fill vào -->
        </div>
    </div>
</div>

<script>
    // SIÊU NÂNG CẤP FRONTEND: Chống Spam Click + Chống F12 + Auto Loading
    function checkRealTimeCancel(event, createdAtTime, customerType, defaultMsg) {
        let now = new Date().getTime();
        let created = new Date(createdAtTime).getTime();

        if (now < created) {
            alert("PHÁT HIỆN BẤT THƯỜNG: Thời gian hệ thống của máy bạn không đồng bộ với máy chủ. Vui lòng chỉnh lại giờ chuẩn để thao tác!");
            event.preventDefault();
            return false;
        }

        let secondsElapsed = Math.floor((now - created) / 1000);

        if (customerType === 1 && secondsElapsed > (80 * 60 + 10)) {
            alert("Đã quá thời hạn 80 phút (20p an toàn + 60p phạt) để hủy cho Khách Loại 1! Nút hủy này đã vô hiệu hóa.");
            event.preventDefault();
            return false;
        } else if (customerType === 2 && secondsElapsed > (20 * 60 + 10)) {
            alert("THAO TÁC THẤT BẠI: Đã quá 20 phút an toàn! Bạn không thể hủy đơn lúc này nữa.");
            event.preventDefault();
            return false;
        }

        let isConfirmed = confirm('CẢNH BÁO: ' + defaultMsg);
        if (isConfirmed) {
            // TỰ ĐỘNG KHÓA NÚT & HIỆN ICON SPINNER DÙNG RỦI RO SPAM CLICK
            let form = event.target;
            let submitBtn = form.querySelector('button[type="submit"]');
            if (submitBtn) {
                submitBtn.disabled = true;
                submitBtn.style.opacity = '0.6';
                submitBtn.style.cursor = 'wait';
                submitBtn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Đang hủy đơn...';
            }
            return true;
        }
        return false;
    }

    function showPolicy(type) {
        let content = "";
        if(type === 1) {
            content = `
                    <p><span class="type-badge blink-gold">KHÁCH LOẠI 1</span> (Áp dụng cho VIP lưu trú $> 10$ đêm & đặt trước $\ge 2$ ngày).</p>
                    <ul style="color: #ccc; padding-left: 20px; line-height: 1.8;">
                        <li><strong>Khoảng an toàn (0 - 20 phút):</strong> Miễn phí hủy tiền phòng.</li>
                        <li><strong>Giai đoạn 2 (20 phút - 1 tiếng):</strong> Phạt <span class="highlight-text">50% tổng tiền phòng</span>.</li>
                        <li><strong>Chốt đơn:</strong> Quá 1 tiếng, nút hủy sẽ tự động vô hiệu hóa.</li>
                        <li><strong>Điểm phạt:</strong> Mọi thao tác hủy đều bị trừ <span class="highlight-text" style="color: #e74c3c">25 Điểm Uy Tín/Thành Viên</span>.</li>
                    </ul>
                `;
        } else {
            content = `
                    <p><span class="type-badge blink-blue">KHÁCH LOẠI 2</span> (Áp dụng cho đơn Tiêu chuẩn).</p>
                    <ul style="color: #ccc; padding-left: 20px; line-height: 1.8;">
                        <li><strong>Khoảng an toàn (0 - 20 phút):</strong> Phạt <span class="highlight-text">5% tổng tiền phòng</span>.</li>
                        <li><strong>Chốt đơn:</strong> Quá 20 phút, nút hủy sẽ tự động khóa và không thể hủy nữa.</li>
                        <li><strong>Điểm phạt:</strong> Mọi thao tác hủy đều bị trừ <span class="highlight-text" style="color: #e74c3c">25 Điểm Uy Tín/Thành Viên</span>.</li>
                    </ul>
                `;
        }
        document.getElementById('policyBody').innerHTML = content;
        document.getElementById('policyModal').style.display = 'block';
    }

    function showBookingDetails(code, checkIn, checkOut, nights, roomId) {
        let content = `
                <p>Mã đơn hàng: <strong style="color:white;">` + code + `</strong> | Số phòng: <strong style="color:white;">R-` + roomId + `</strong></p>
                <div style="background: rgba(255,255,255,0.05); padding: 15px; border-radius: 6px; margin-top: 15px;">
                    <div style="margin-bottom: 15px; border-left: 3px solid #2ecc71; padding-left: 10px;">
                        <div style="font-size: 0.85rem; color: #888;">THỜI GIAN NHẬN PHÒNG</div>
                        <div style="font-size: 1.2rem; font-weight: bold; color: #2ecc71;">14:00 Chiều</div>
                        <div style="color: #ccc;">Ngày ` + checkIn + `</div>
                    </div>

                    <div style="margin-bottom: 15px; padding-left: 10px; color: #dfb76c;">
                        <i class="fa-solid fa-arrow-down"></i> Lưu trú tổng cộng: <strong>` + nights + ` đêm</strong>
                    </div>

                    <div style="border-left: 3px solid #e74c3c; padding-left: 10px;">
                        <div style="font-size: 0.85rem; color: #888;">THỜI GIAN TRẢ PHÒNG</div>
                        <div style="font-size: 1.2rem; font-weight: bold; color: #e74c3c;">12:00 Trưa</div>
                        <div style="color: #ccc;">Ngày ` + checkOut + `</div>
                    </div>
                </div>
                <p style="font-size: 0.8rem; color: #777; margin-top: 15px; text-align: center;">*Vui lòng mang theo CMND/CCCD khi đến quầy lễ tân.</p>
            `;
        document.getElementById('detailsBody').innerHTML = content;
        document.getElementById('detailsModal').style.display = 'block';
    }

    function closeModals() {
        document.getElementById('policyModal').style.display = 'none';
        document.getElementById('detailsModal').style.display = 'none';
    }

    window.onclick = function(event) {
        if (event.target == document.getElementById('policyModal')) closeModals();
        if (event.target == document.getElementById('detailsModal')) closeModals();
    }
</script>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        const uyTin = ${not empty requestScope.uyTin ? requestScope.uyTin : 100};
        const loyalPoint = ${not empty requestScope.loyalPoint ? requestScope.loyalPoint : 0};

        // --- 1. HIỆU ỨNG ĐẾM SỐ (COUNT UP ANIMATION) ---
        function animateValue(id, start, end, duration) {
            const obj = document.getElementById(id);
            if (!obj) return;
            if (start === end) { obj.innerHTML = end; return; }
            let startTimestamp = null;
            const step = (timestamp) => {
                if (!startTimestamp) startTimestamp = timestamp;
                const progress = Math.min((timestamp - startTimestamp) / duration, 1);
                // Sử dụng hàm easeOutExpo cho mượt
                const easeOut = progress === 1 ? 1 : 1 - Math.pow(2, -10 * progress);
                obj.innerHTML = Math.floor(easeOut * (end - start) + start);
                if (progress < 1) {
                    window.requestAnimationFrame(step);
                } else {
                    obj.innerHTML = end;
                }
            };
            window.requestAnimationFrame(step);
        }

        // Chạy hiệu ứng đếm số trong 1.5 giây
        animateValue("uyTinCount", 0, uyTin, 1500);
        animateValue("loyalPointCount", 0, loyalPoint, 1500);

        // --- 2. HIỆU ỨNG THANH NĂNG LƯỢNG RANK ---
        let nextRank = "Member";
        let pointsNeeded = 0;
        let maxPoints = 0;
        let basePoints = 0;

        if (loyalPoint < 500) { nextRank = "Silver"; maxPoints = 500; basePoints = 0; }
        else if (loyalPoint < 1000) { nextRank = "Gold"; maxPoints = 1000; basePoints = 500; }
        else if (loyalPoint < 1500) { nextRank = "Diamond"; maxPoints = 1500; basePoints = 1000; }
        else { nextRank = "MAX"; }

        const progressBar = document.getElementById("rank-progress-bar");
        const nextRankInfo = document.getElementById("next-rank-info");

        if (nextRank === "MAX") {
            progressBar.style.width = "100%";
            nextRankInfo.innerHTML = "<i class='fa-solid fa-star'></i> Đã đạt cấp tối đa";
        } else {
            pointsNeeded = maxPoints - loyalPoint;
            let percent = ((loyalPoint - basePoints) / (maxPoints - basePoints)) * 100;
            // Delay 0.4s trước khi chạy thanh tiến trình để tạo độ ngầu
            setTimeout(() => { progressBar.style.width = percent + "%"; }, 400);
            nextRankInfo.innerHTML = "Cần <b style='color: #ffca28;'>" + pointsNeeded + " điểm</b> lên <b>" + nextRank + "</b>";
        }

        // --- 3. KHỞI TẠO CHART.JS (BẢN CHOÁY, BƠM NĂNG LƯỢNG & NHẤP NHÁY NEON) ---
        const canvas = document.getElementById('pointsChart');
        const ctx = canvas.getContext('2d');

        // 👉 3.0. BƠM HIỆU ỨNG NHẤP NHÁY (NEON PULSE) BẰNG ĐỘNG LỰC CSS
        if (!document.getElementById('neonChartStyle')) {
            const style = document.createElement('style');
            style.id = 'neonChartStyle';
            // Dùng drop-shadow tỏa sáng ra ngoài canvas, chớp tắt liên tục
            style.innerHTML = `
                @keyframes chartNeonPulse {
                    0% { filter: drop-shadow(0 -2px 5px rgba(255, 202, 40, 0.3)); }
                    50% { filter: drop-shadow(0 -10px 25px rgba(255, 202, 40, 0.9)) drop-shadow(0 0 15px rgba(46, 204, 113, 0.7)); }
                    100% { filter: drop-shadow(0 -2px 5px rgba(255, 202, 40, 0.3)); }
                }
                #pointsChart {
                    animation: chartNeonPulse 1.5s infinite ease-in-out;
                }
            `;
            document.head.appendChild(style);
        }

        // 3.1. Tạo Gradient (Tập trung độ chói lên phần đỉnh)
        const uyTinGradient = ctx.createLinearGradient(0, 0, 0, 300);
        uyTinGradient.addColorStop(0, 'rgba(255, 202, 40, 1)');   // Đỉnh chói lóa
        uyTinGradient.addColorStop(0.2, 'rgba(255, 202, 40, 0.7)'); // Gắt ở phần trên
        uyTinGradient.addColorStop(1, 'rgba(255, 202, 40, 0.02)');  // Đáy tối mờ mờ

        const loyalGradient = ctx.createLinearGradient(0, 0, 0, 300);
        loyalGradient.addColorStop(0, 'rgba(46, 204, 113, 1)');
        loyalGradient.addColorStop(0.2, 'rgba(46, 204, 113, 0.7)');
        loyalGradient.addColorStop(1, 'rgba(46, 204, 113, 0.02)');

        // 3.2. Khởi tạo biểu đồ
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['Điểm Uy Tín', 'Điểm Thành Viên'],
                datasets: [{
                    label: 'Thống Kê Điểm Số',
                    data: [uyTin, loyalPoint],
                    backgroundColor: [uyTinGradient, loyalGradient],
                    // Đổi viền trên thành màu trắng ngà/trắng xanh để giống lõi đèn Neon
                    borderColor: ['#fffde7', '#d5f5e3'],
                    borderWidth: { top: 5, right: 0, bottom: 0, left: 0 }, // Viền đỉnh cực dày
                    borderRadius: { topLeft: 8, topRight: 8, bottomLeft: 0, bottomRight: 0 }
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                animation: {
                    y: {
                        duration: 2500, // Hiệu ứng bơm từ từ
                        easing: 'easeOutQuart'
                    },
                    delay: (context) => {
                        // Cột xanh delay 0.4s để chạy sau cột vàng
                        return context.type === 'data' ? context.dataIndex * 400 : 0;
                    }
                },
                layout: {
                    // Cần khoảng không phía trên để luồng sáng (shadow) bung ra không bị cắt viền
                    padding: { top: 25 }
                },
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        backgroundColor: 'rgba(0,0,0,0.8)',
                        titleColor: '#dfb76c',
                        bodyFont: { size: 14, weight: 'bold' },
                        borderColor: '#dfb76c',
                        borderWidth: 1
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        // Đổi lưới thành dạng nét đứt (sci-fi radar)
                        grid: { color: 'rgba(255, 255, 255, 0.05)', borderDash: [5, 5] },
                        ticks: { color: '#888' }
                    },
                    x: {
                        grid: { display: false },
                        ticks: { color: '#dfb76c', font: { weight: 'bold', size: 14 } }
                    }
                }
            }
        });
    });

    function switchTab(tabId) {
        document.querySelectorAll('.table-container').forEach(el => el.classList.remove('active'));
        document.querySelectorAll('.tab-btn').forEach(el => el.classList.remove('active'));
        document.getElementById('tab-' + tabId).classList.add('active');
        event.target.classList.add('active');
    }

    flatpickr("#dateFilter", {
        dateFormat: "Y-m-d",
        onChange: function(selectedDates, dateStr, instance) {
            // Đã đổi thành lọc trên tất cả các tab (Xóa #activeTable)
            const rows = document.querySelectorAll('.booking-row');
            rows.forEach(row => {
                const checkInDate = row.getAttribute('data-checkin');
                if(dateStr === "" || checkInDate.includes(dateStr)) {
                    row.style.display = 'table-row';
                } else {
                    row.style.display = 'none';
                }
            });
        }
    });

    // SIÊU NÂNG CẤP: ĐẾM NGƯỢC REALTIME & TỰ ĐỘNG KHÓA CỨNG NÚT BẤM (DISABLE BUTTON)
    function initReflectionTimers() {
        const timers = document.querySelectorAll('.reflection-timer');
        const TWENTY_MINS_MS = 20 * 60 * 1000;
        const EIGHTY_MINS_MS = 80 * 60 * 1000;

        setInterval(() => {
            const now = new Date().getTime();

            timers.forEach(timer => {
                const bookingTime = parseInt(timer.getAttribute('data-booking-time'));
                const type = parseInt(timer.getAttribute('data-type'));
                const form = timer.closest('form');

                if(!isNaN(bookingTime)) {
                    const elapsed = now - bookingTime;

                    if (type === 1) {
                        if (elapsed <= TWENTY_MINS_MS) {
                            const diff = TWENTY_MINS_MS - elapsed;
                            const m = Math.floor(diff / 60000);
                            const s = Math.floor((diff % 60000) / 1000);
                            timer.innerHTML = `<i class="fa-solid fa-stopwatch"></i> An toàn: `+m+`p `+s+`s (0%)`;
                            timer.style.color = '#2ecc71';
                        } else if (elapsed <= EIGHTY_MINS_MS) {
                            const diff = EIGHTY_MINS_MS - elapsed;
                            const m = Math.floor(diff / 60000);
                            const s = Math.floor((diff % 60000) / 1000);
                            timer.innerHTML = `<i class="fa-solid fa-stopwatch"></i> Phạt 50%: còn `+m+`p `+s+`s`;
                            timer.style.color = '#ffca28';
                        } else {
                            timer.innerHTML = `<i class="fa-solid fa-lock"></i> Đã vô hiệu hóa hủy`;
                            timer.style.color = '#e74c3c';
                            if(form) {
                                const cancelBtn = form.querySelector('.btn-cancel');
                                if(cancelBtn && !cancelBtn.disabled) {
                                    cancelBtn.disabled = true; // Khóa cứng nút
                                    cancelBtn.style.opacity = '0.4';
                                    cancelBtn.style.cursor = 'not-allowed';
                                    cancelBtn.innerHTML = '<i class="fa-solid fa-lock"></i> Hết hạn hủy';
                                }
                            }
                        }
                    } else {
                        if (elapsed <= TWENTY_MINS_MS) {
                            const diff = TWENTY_MINS_MS - elapsed;
                            const m = Math.floor(diff / 60000);
                            const s = Math.floor((diff % 60000) / 1000);
                            timer.innerHTML = `<i class="fa-solid fa-stopwatch"></i> Phạt 5%: còn `+m+`p `+s+`s`;
                            timer.style.color = '#2ecc71';
                        } else {
                            timer.innerHTML = `<i class="fa-solid fa-lock"></i> Đã vô hiệu hóa hủy`;
                            timer.style.color = '#e74c3c';
                            if(form) {
                                const cancelBtn = form.querySelector('.btn-cancel');
                                if(cancelBtn && !cancelBtn.disabled) {
                                    cancelBtn.disabled = true; // Khóa cứng nút
                                    cancelBtn.style.opacity = '0.4';
                                    cancelBtn.style.cursor = 'not-allowed';
                                    cancelBtn.innerHTML = '<i class="fa-solid fa-lock"></i> Hết hạn hủy';
                                }
                            }
                        }
                    }
                }
            });
        }, 1000);
    }

    document.addEventListener('DOMContentLoaded', initReflectionTimers);
</script>
</body>
</html>