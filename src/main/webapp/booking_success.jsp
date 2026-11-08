<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Verdelle Hotel - Đặt phòng thành công</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/NavStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/FooterStyle.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --bg-color: #0b0b0e;
            --panel-bg: #14141a;
            --card-bg: #1a1a24;
            --text-main: #f5f5f7;
            --text-muted: #9a9aab;
            --border-color: #22222a;
            --gold-primary: #d4af37;
            --gold-hover: #b89327;
            --success-green: #2ecc71;
        }

        body {
            background-color: var(--bg-color);
            color: var(--text-main);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
        }

        /* Thanh tiến trình đặt phòng */
        .booking-progress-bar {
            background: #09090c;
            border-bottom: 1px solid var(--border-color);
            padding: 20px 0;
        }

        .progress-steps-container {
            max-width: 650px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            position: relative;
            padding: 0 40px;
        }

        .progress-line-back {
            position: absolute;
            top: 13px;
            left: 40px;
            right: 40px;
            height: 2px;
            background: var(--gold-primary);
            z-index: 1;
        }

        .step-item {
            position: relative;
            z-index: 3;
            display: flex;
            flex-direction: column;
            align-items: center;
            flex: 1;
            text-align: center;
            font-size: 0.85rem;
            color: var(--gold-primary);
            font-weight: 600;
            letter-spacing: 0.5px;
        }

        .step-number {
            width: 26px;
            height: 26px;
            border-radius: 50%;
            background: var(--gold-primary);
            color: #000;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.75rem;
            font-weight: bold;
            margin-bottom: 8px;
            box-shadow: 0 0 10px rgba(212, 175, 55, 0.4);
        }

        /* Khung chính chứa hóa đơn */
        .success-main-container {
            max-width: 800px;
            margin: 40px auto;
            background: var(--panel-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 35px;
            display: flex;
            gap: 30px;
            position: relative;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
        }

        .success-left {
            flex: 1.1;
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

        .sparkle-key-container {
            position: relative;
            display: inline-block;
            margin-bottom: 20px;
            background: rgba(212, 175, 55, 0.08);
            border: 1px solid rgba(212, 175, 55, 0.25);
            width: 110px;
            height: 110px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 0 25px rgba(212, 175, 55, 0.15);
        }

        .sparkle-key-container .main-key {
            font-size: 3.5rem;
            color: var(--gold-primary);
            transform: rotate(-45deg);
            display: inline-block;
            filter: drop-shadow(0 2px 8px rgba(212, 175, 55, 0.4));
        }

        .sparkle-key-container .sparkle {
            position: absolute;
            color: var(--gold-primary);
        }

        .sparkle-key-container .sp-1 { top: 15px; left: 15px; font-size: 1.2rem; }
        .sparkle-key-container .sp-2 { top: 10px; right: 20px; font-size: 0.9rem; }
        .sparkle-key-container .sp-3 { bottom: 20px; right: 15px; font-size: 1.1rem; }

        .success-title {
            color: var(--gold-primary);
            font-size: 1.7rem;
            font-weight: 700;
            margin: 10px 0;
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        .success-subtext {
            font-size: 0.9rem;
            color: var(--text-muted);
            margin-bottom: 20px;
            line-height: 1.6;
        }

        .success-subtext strong {
            color: var(--text-main);
        }

        .booking-code-box {
            font-size: 1.4rem;
            font-weight: 700;
            color: var(--gold-primary);
            margin: 10px 0 25px 0;
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            padding: 10px 22px;
            border-radius: 8px;
            display: inline-block;
            letter-spacing: 1px;
        }

        .success-right {
            flex: 0.9;
            background: var(--card-bg);
            border: 1px dashed rgba(212, 175, 55, 0.3);
            border-radius: 12px;
            padding: 25px;
            position: relative;
        }

        .success-right::before {
            content: "";
            position: absolute;
            top: -6px; left: 0; right: 0;
            height: 12px;
            background-image: radial-gradient(circle, rgba(20, 20, 26, 0) 4px, var(--panel-bg) 5px);
            background-size: 12px 12px;
            transform: rotate(180deg);
        }

        .success-right::after {
            content: "";
            position: absolute;
            bottom: -6px; left: 0; right: 0;
            height: 12px;
            background-image: radial-gradient(circle, rgba(20, 20, 26, 0) 4px, var(--panel-bg) 5px);
            background-size: 12px 12px;
        }

        .ticket-label {
            font-size: 0.8rem;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 3px;
        }

        .ticket-value {
            font-size: 1rem;
            font-weight: 600;
            color: var(--text-main);
            margin-bottom: 16px;
        }

        .total-price-row {
            border-top: 1px dashed var(--border-color);
            margin-top: 20px;
            padding-top: 15px;
        }

        .support-info-box {
            border: 1px solid rgba(212, 175, 55, 0.25);
            background: rgba(212, 175, 55, 0.05);
            border-radius: 8px;
            padding: 12px 15px;
            text-align: left;
            font-size: 0.8rem;
            color: var(--text-muted);
            margin-top: 20px;
            width: 100%;
            box-sizing: border-box;
            line-height: 1.5;
        }

        .btn-group-container {
            display: flex;
            gap: 12px;
            margin-top: 15px;
            width: 100%;
            justify-content: center;
        }

        .btn-action {
            padding: 12px 20px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.9rem;
            cursor: pointer;
            text-decoration: none;
            text-align: center;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-home {
            background: linear-gradient(135deg, var(--gold-primary) 0%, var(--gold-hover) 100%);
            color: #000;
            box-shadow: 0 4px 12px rgba(212, 175, 55, 0.25);
        }

        .btn-home:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(212, 175, 55, 0.35);
        }

        .btn-gmail {
            background: transparent;
            border: 1px solid var(--gold-primary);
            color: var(--gold-primary);
        }

        .btn-gmail:hover {
            background: var(--gold-primary);
            color: #000;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="booking-progress-bar">
    <div class="progress-steps-container">
        <div class="progress-line-back"></div>
        <div class="step-item">
            <div class="step-number"><i class="fa-solid fa-check"></i></div>
            <span>Thông tin khách hàng</span>
        </div>
        <div class="step-item">
            <div class="step-number"><i class="fa-solid fa-check"></i></div>
            <span>Chi tiết thanh toán</span>
        </div>
        <div class="step-item">
            <div class="step-number"><i class="fa-solid fa-check"></i></div>
            <span>Hoàn thành đặt chỗ</span>
        </div>
    </div>
</div>

<div class="success-main-container">

    <div class="success-left">
        <div class="sparkle-key-container">
            <i class="fa-solid fa-wand-magic-sparkles sparkle sp-1"></i>
            <i class="fa-solid fa-star sparkle sp-2"></i>
            <i class="fa-solid fa-key main-key"></i>
            <i class="fa-solid fa-star sparkle sp-3"></i>
        </div>

        <div class="success-title">Đặt Phòng Thành Công!</div>
        <div class="success-subtext">
            Cảm ơn <strong>"${not empty customerName ? customerName : 'Quý khách'}"</strong> đã lựa chọn <strong>"${not empty hotelName ? hotelName : 'Verdelle Luxury Hotel'}"</strong>.<br>
            Rất hân hạnh được đón tiếp bạn!
        </div>

        <div class="booking-code-box">
            Mã xác nhận: #${not empty bookingId ? bookingId : 'VDL9999'}
        </div>

        <div class="btn-group-container">
            <a href="${pageContext.request.contextPath}/home.jsp" class="btn-action btn-home">
                <i class="fa-solid fa-house"></i> Về Trang Chủ
            </a>

            <a href="SendEmailController?bookingId=${not empty bookingId ? bookingId : 'VDL9999'}" class="btn-action btn-gmail">
                <i class="fa-regular fa-envelope"></i> Gửi về Gmail
            </a>
        </div>
    </div>

    <div class="success-right">
        <div class="ticket-label">Khách sạn:</div>
        <div class="ticket-value">"${not empty hotelName ? hotelName : 'Verdelle Luxury Hotel'}"</div>

        <div class="ticket-label">Hạng phòng:</div>
        <div class="ticket-value">${not empty requiredRooms ? requiredRooms : '1'} x phòng "${not empty roomName ? roomName : 'Standard Room'}"</div>

        <div class="ticket-label">Trạng thái thanh toán:</div>
        <div class="ticket-value" style="color: #4caf50;">Đã thanh toán (via QR)</div>

        <div class="total-price-row">
            <div class="ticket-label" style="font-weight: 600; color: var(--gold-primary);">Tổng chi phí:</div>
            <div style="font-size: 1.6rem; font-weight: 700; color: #fff; margin-top: 5px;">
                <fmt:formatNumber value="${finalPrice}" type="number" groupingUsed="true"/> đ
            </div>
        </div>

        <div class="support-info-box">
            <strong style="display:block; margin-bottom:5px; font-size: 0.85rem; color: var(--gold-primary);">
                <i class="fa-solid fa-circle-info"></i> Thông tin hỗ trợ
            </strong>
            Một email chi tiết kèm hướng dẫn nhận phòng đã được gửi đến email của bạn.<br>
            Cần hỗ trợ gấp? Hotline: <strong style="color: #fff;">0834178906</strong>
        </div>
    </div>

</div>

<div style="margin-top: 40px;"></div>

<script>
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.has('status')) {
        const status = urlParams.get('status');

        if (status === 'emailSent') {
            alert("✉️ Hệ thống đã gửi hóa đơn thành công vào Gmail của bạn!");
        } else if (status === 'emailFailed') {
            alert("❌ Gửi mail thất bại! Vui lòng kiểm tra lại cấu hình thông tin gửi.");
        } else if (status === 'emailNotLoggedIn') {
            alert("⚠️ Không tìm thấy email khách hàng! Bạn cần đăng nhập để sử dụng chức năng này.");
        }

        window.history.replaceState({}, document.title, window.location.pathname);
    }
</script>

</body>
<footer>
    <jsp:include page="footer.jsp" />
</footer>
</html>