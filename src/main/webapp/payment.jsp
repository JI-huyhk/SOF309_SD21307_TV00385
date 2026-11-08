<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="currentPrice" value="${not empty finalPrice ? finalPrice : sessionScope.finalPrice}" />
<fmt:formatNumber value="${currentPrice}" pattern="#" var="fullAmount" groupingUsed="false" />
<fmt:formatNumber value="${currentPrice / 2}" pattern="#" var="depositAmount" groupingUsed="false" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Verdelle Hotel - Chi tiết thanh toán</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/NavStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/FooterStyle.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        /* ================= TONE MÀU CHỦ ĐẠO LUXURY GOLD & DARK ================= */
        :root {
            --brand-primary: #dfb76c;
            --brand-gold: #dfb76c;
            --gold-light: #f3e1bd;
            --gold-dark: #aa8443;
            --bg-body: #0b0b0b;
            --surface: #141414;
            --text-main: #ffffff;
            --text-muted: #a0a0a0;
            --border-soft: #2a2418;
            --brand-success: #26a69a;
            --radius-lg: 16px;
            --radius-md: 10px;
            --shadow-soft: 0 8px 32px rgba(0, 0, 0, 0.7);
            --shadow-hover: 0 12px 40px rgba(223, 183, 108, 0.15);
        }

        body {
            background: radial-gradient(circle at 50% 30%, #1a1a1a 0%, #0b0b0b 70%, #050505 100%) !important;
            background-attachment: fixed !important;
            color: var(--text-main);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
        }

        /* --- THANH TIẾN TRÌNH STEPPER LUXURY --- */
        .modern-stepper {
            background: var(--surface);
            padding: 25px 0;
            border-bottom: 1px solid var(--border-soft);
            box-shadow: var(--shadow-soft);
        }
        .stepper-inner {
            max-width: 650px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            position: relative;
        }
        .stepper-line {
            position: absolute;
            top: 15px;
            left: 40px;
            right: 40px;
            height: 2px;
            background: #252525;
            z-index: 1;
        }
        .stepper-line-fill {
            position: absolute;
            top: 15px;
            left: 40px;
            width: 50%;
            height: 2px;
            background: linear-gradient(90deg, var(--gold-dark), var(--brand-gold));
            z-index: 2;
        }
        .step {
            position: relative;
            z-index: 3;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 8px;
            width: 130px;
        }
        .step-circle {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: #1a1a1a;
            color: var(--text-muted);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 0.9rem;
            border: 2px solid var(--border-soft);
            transition: all 0.3s;
        }
        .step.completed .step-circle {
            background: linear-gradient(135deg, #1d7a6e, var(--brand-success));
            color: white;
            border-color: #80cbc4;
        }
        .step.active .step-circle {
            background: linear-gradient(135deg, var(--gold-dark), var(--brand-gold));
            color: #000000;
            font-weight: bold;
            box-shadow: 0 0 15px rgba(223, 183, 108, 0.4);
            border-color: var(--gold-light);
        }
        .step-text {
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-muted);
            text-align: center;
        }
        .step.completed .step-text { color: var(--brand-success); }
        .step.active .step-text { color: var(--gold-light); font-weight: 700; }

        /* --- BỐ CỤC CHÍNH --- */
        .main-content-layout {
            max-width: 1140px;
            margin: 40px auto 50px;
            padding: 0 20px;
            display: grid;
            grid-template-columns: 1.4fr 1fr;
            gap: 30px;
            align-items: start;
        }

        /* --- THẺ GLASS CARD CỦA TRANG BOOKING ĐƯỢC MANG SANG --- */
        .glass-card {
            background: var(--surface);
            border-radius: var(--radius-lg);
            padding: 28px;
            margin-bottom: 24px;
            box-shadow: var(--shadow-soft);
            border: 1px solid var(--border-soft);
            transition: all 0.3s ease;
        }
        .glass-card:hover {
            box-shadow: var(--shadow-hover);
            border-color: var(--gold-dark);
        }
        .card-header-title {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--brand-gold);
            margin-bottom: 18px;
            display: flex;
            align-items: center;
            gap: 10px;
            letter-spacing: 0.5px;
            text-transform: uppercase;
        }

        /* --- CẤU TRÚC ẢNH BANNER MỚI TỪ BOOKING.JSP --- */
        .summary-img-wrap {
            width: 100%;
            height: 180px;
            border-radius: var(--radius-md);
            overflow: hidden;
            margin-bottom: 20px;
            border: 1px solid var(--border-soft);
            box-shadow: 0 4px 15px rgba(0,0,0,0.5);
            position: relative;
        }
        .summary-img-wrap img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }
        .summary-img-wrap:hover img {
            transform: scale(1.05);
        }

        .payment-method-container {
            display: flex;
            flex-direction: column;
            gap: 12px;
            margin-top: 15px;
        }
        .method-option {
            display: flex;
            align-items: flex-start;
            gap: 15px;
            padding: 16px;
            border: 1px solid var(--border-soft);
            border-radius: var(--radius-md);
            cursor: pointer;
            transition: all 0.2s ease;
            background: #181818;
        }
        .method-option:hover {
            border-color: var(--brand-gold);
            background: #222222;
        }
        .method-option input[type="radio"] {
            accent-color: var(--brand-gold);
            width: 18px;
            height: 18px;
            margin-top: 2px;
        }

        /* QR VÀ NÚT BẤM */
        .qr-display-box {
            width: 450px;
            height: 450px;
            border: 1px solid var(--brand-gold);
            margin: 25px auto 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #ffffff;
            border-radius: var(--radius-md);
            box-shadow: 0 0 20px rgba(223, 183, 108, 0.15);
            padding: 10px;
            position: relative;
            overflow: hidden;
        }

        /* LỚP PHỦ Ổ KHÓA CỰC CHÁY KHI CHUYỂN KHOẢN THÀNH CÔNG */
        .qr-lock-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(11, 11, 11, 0.88);
            backdrop-filter: blur(5px);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            border-radius: var(--radius-md);
            opacity: 0;
            visibility: hidden;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            z-index: 10;
        }

        .qr-display-box.locked .qr-lock-overlay {
            opacity: 1;
            visibility: visible;
            background: rgba(11, 11, 11, 0.98); /* Phủ đen gần như hoàn toàn */
            backdrop-filter: blur(15px); /* Tăng độ mờ che nát bét cái QR */
        }

        /* Đánh bay luôn cái ảnh QR khỏi tầm nhìn khi đã khóa */
        .qr-display-box.locked img {
            opacity: 0;
            pointer-events: none;
            visibility: hidden;
        }

        .qr-lock-icon {
            font-size: 3.5rem;
            color: var(--brand-success) !important;
            filter: drop-shadow(0 0 12px rgba(38, 166, 154, 0.8));
            animation: lockPulse 1.5s infinite alternate ease-in-out;
        }

        .qr-lock-text {
            margin-top: 10px;
            font-size: 0.85rem;
            font-weight: 800;
            color: #ffffff;
            letter-spacing: 1.5px;
            text-transform: uppercase;
        }

        @keyframes lockPulse {
            0% { transform: scale(0.92); opacity: 0.85; }
            100% { transform: scale(1.08); opacity: 1; }
        }

        .btn-waiting-payment {
            width: 100%;
            padding: 16px;
            background: #222222;
            color: #666666;
            border: 1px solid #333333;
            border-radius: var(--radius-md);
            font-size: 1.05rem;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            cursor: not-allowed;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            margin-top: 20px;
            transition: all 0.4s ease;
        }

        .btn-continue-active {
            background: linear-gradient(135deg, var(--gold-dark) 0%, var(--brand-gold) 50%, var(--gold-dark) 100%) !important;
            color: #000000 !important;
            border: none !important;
            cursor: pointer !important;
            box-shadow: 0 4px 15px rgba(223, 183, 108, 0.3) !important;
        }
        .btn-continue-active:hover {
            background: linear-gradient(135deg, var(--brand-gold) 0%, var(--gold-light) 50%, var(--brand-gold) 100%) !important;
            box-shadow: 0 6px 20px rgba(223, 183, 108, 0.5) !important;
            transform: translateY(-2px);
        }

        /* SIDEBAR CHI TIẾT */
        .sidebar-block {
            background: var(--surface);
            border: 1px solid var(--border-soft);
            border-radius: var(--radius-lg);
            padding: 24px;
            margin-bottom: 24px;
            box-shadow: var(--shadow-soft);
            transition: all 0.3s ease;
        }
        .sidebar-block:hover {
            border-color: var(--gold-dark);
        }
        .price-breakdown-row {
            display: flex;
            justify-content: space-between;
            font-size: 0.9rem;
            margin-bottom: 12px;
            color: var(--text-main);
        }
        .final-price-box {
            border-top: 1px dashed var(--border-soft);
            margin-top: 15px;
            padding-top: 15px;
        }
        .discount-badge {
            background: rgba(211, 47, 47, 0.15);
            color: #ff5252;
            padding: 6px 14px;
            font-weight: 700;
            border-radius: 20px;
            display: inline-block;
            margin-bottom: 15px;
            font-size: 0.85rem;
        }

        .timeline-container {
            margin-top: 15px;
            position: relative;
        }
        .timeline-line {
            height: 4px;
            background: var(--brand-success);
            border-radius: 2px;
            position: relative;
            margin-bottom: 10px;
        }
        .timeline-dot {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: var(--brand-success);
            position: absolute;
            top: -4px;
        }

        i.fa-solid, i.fa-regular, i.fa-shield-halved {
            color: var(--brand-gold);
        }
        .btn-waiting-payment i { color: inherit !important; }
        .step.completed i.fa-check { color: #ffffff !important; }

        /* Box thông báo phong cách booking.jsp */
        .perk-info-box {
            padding: 12px;
            background: rgba(38, 166, 154, 0.05);
            border: 1px solid rgba(38, 166, 154, 0.3);
            border-radius: var(--radius-md);
            margin-bottom: 15px;
        }
    </style>
</head>
<body>

<jsp:include page="header.jsp" />

<!-- STEPPER NGHỆ THUẬT -->
<div class="modern-stepper">
    <div class="stepper-inner">
        <div class="stepper-line"></div>
        <div class="stepper-line-fill"></div>
        <div class="step completed">
            <div class="step-circle"><i class="fa-solid fa-check"></i></div>
            <div class="step-text" style="color: var(--brand-success);">Khách hàng</div>
        </div>
        <div class="step active">
            <div class="step-circle">2</div>
            <div class="step-text">Thanh toán</div>
        </div>
        <div class="step">
            <div class="step-circle">3</div>
            <div class="step-text">Hoàn tất</div>
        </div>
    </div>
</div>

<div class="main-content-layout">

    <!-- KHỐI THANH TOÁN CHÍNH (BÊN TRÁI) -->
    <div class="left-payment-flow">
        <div class="glass-card">
            <div class="card-header-title">
                <i class="fa-solid fa-shield-halved"></i> Cổng Thanh Toán Bảo Mật
            </div>
            <p style="font-size: 0.85rem; color: var(--gold-light); margin: -5px 0 20px 0; display: flex; align-items: center; gap: 6px;">
                <i class="fa-solid fa-lock" style="font-size: 0.75rem;"></i> Mọi thông tin thanh toán đều được mã hóa chuẩn quốc tế
            </p>

            <div class="payment-method-container">
                <label class="method-option">
                    <input type="radio" name="paymentMethod" value="qr" checked>
                    <div>
                        <strong style="font-size: 0.95rem; display:block; margin-bottom:4px; color: var(--text-main);">Thanh toán qua QR (Trả thẳng 100%)</strong>
                        <span style="font-size: 0.85rem; color: var(--text-muted); line-height: 1.4;">Quét mã chuyển khoản nhanh toàn bộ 100% hóa đơn. Hệ thống xác nhận phòng ngay lập tức.</span>
                    </div>
                </label>
            </div>

            <div id="qr-section">
                <div class="qr-display-box" id="qr-box">
                    <img id="qr-image" src="" alt="QR Payment" style="max-width:100%; max-height:100%; object-fit: contain;">
                    <!-- LỚP PHỦ Ổ KHÓA CỰC CHÁY CHE KÍN MÃ QR -->
                    <div class="qr-lock-overlay">
                        <i class="fa-solid fa-lock qr-lock-icon"></i>
                        <span class="qr-lock-text">ĐÃ XÁC NHẬN</span>
                    </div>
                </div>
                <p id="qr-note" style="text-align: center; font-size: 0.85rem; font-weight: bold; margin-top: 12px; transition: color 0.3s;"></p>
            </div>

            <div style="font-size: 0.8rem; color: var(--text-muted); line-height: 1.5; margin-top: 25px; padding-top: 15px; border-top: 1px solid var(--border-soft);">
                Thực hiện bước tiếp theo đồng nghĩa với việc quý khách chấp nhận tuân theo
                <a href="#" style="color: var(--brand-primary); text-decoration: none; font-weight: 600;">Điều khoản Sử dụng</a> và <a href="#" style="color: var(--brand-primary); text-decoration: none; font-weight: 600;">Chính sách Quyền riêng tư</a> của Verdelle Hotel.
            </div>
        </div>
        <div class="glass-card">
            <div class="card-header-title"><i class="fa-solid fa-bell-concierge"></i> Yêu cầu & Ghi chú</div>
            <p style="font-size: 0.85rem; color: var(--text-muted); margin-bottom: 20px;">* Ghi chú của bạn đã được đồng bộ từ bước đặt phòng.</p>

            <div style="border-top: 1px dashed var(--border-soft); padding-top: 15px;">
                <label style="font-size: 0.9rem; font-weight: 600; color: var(--gold-light); display: flex; align-items: center; gap: 8px; margin-bottom: 10px;">
                    <i class="fa-solid fa-wand-magic-sparkles"></i> Ghi chú tự động
                </label>

                <button type="button" id="btn-auto-note" style="width: 100%; margin-bottom: 10px; border: 1px solid var(--brand-success); color: var(--brand-success); background: transparent; padding: 8px 18px; border-radius: 20px; font-size: 0.85rem; font-weight: 600; cursor: pointer;">
                    Tạo Ghi Chú Tự Động
                </button>

                <textarea id="input-custom-note" readonly style="width: 100%; padding: 12px 16px; background: #1a1a1a; border: 1px solid var(--border-soft); border-radius: var(--radius-md); color: var(--text-main); font-family: inherit; font-size: 0.95rem; min-height: 80px; resize: vertical; box-sizing: border-box; margin-top: 10px;">${not empty sessionScope.customerNote ? sessionScope.customerNote : ''}</textarea>
            </div>
        </div>
        <form action="FinalizeBookingController" method="POST">
            <!-- Các trường cũ đã có (bổ sung check null để an toàn hơn) -->
            <input type="hidden" name="customerNoteFinal" id="hiddenCustomerNoteFinal" value="${not empty sessionScope.customerNote ? sessionScope.customerNote : ''}">
            <input type="hidden" name="roomId" value="${not empty roomId ? roomId : sessionScope.roomId}">
            <input type="hidden" name="customerName" value="${not empty customerName ? customerName : sessionScope.customerName}">
            <input type="hidden" name="paymentMethod" id="hiddenPaymentMethod" value="qr">
            <input type="hidden" name="voucherCode" value="${not empty voucherCode ? voucherCode : sessionScope.voucherCode}">

            <!-- BỔ SUNG: Chống lỗi thiếu dữ liệu bằng cách nhồi thêm các biến quan trọng từ Session/Request -->
            <input type="hidden" name="price" value="${not empty finalPrice ? finalPrice : sessionScope.finalPrice}">
            <input type="hidden" name="dateRange" value="${not empty dateRange ? dateRange : sessionScope.dateRange}">
            <input type="hidden" name="customerId" value="${not empty customerId ? customerId : sessionScope.customerId}">
            <input type="hidden" name="customerEmail" value="${not empty customerEmail ? customerEmail : sessionScope.customerEmail}">
            <input type="hidden" name="customerPhone" value="${not empty customerPhone ? customerPhone : sessionScope.customerPhone}">
            <input type="hidden" name="requiredRooms" value="${not empty requiredRooms ? requiredRooms : sessionScope.requiredRooms}">

            <!-- Nâng cấp nút bấm: Thêm class btn-continue-active để sáng nút và cho phép click -->
            <button type="submit" class="btn-waiting-payment btn-continue-active">
                <i class="fa-solid fa-check-circle"></i> XÁC NHẬN ĐẶT PHÒNG
            </button>
        </form>

        <p style="text-align: center; font-size: 0.85rem; color: var(--brand-success); margin-top: 15px; font-weight: 600;">
            <i class="fa-solid fa-circle-check" style="color: var(--brand-success) !important;"></i> An tâm thay đổi! Hủy phòng miễn phí trước ngày đi
        </p>
    </div>

    <!-- KHỐI TÓM TẮT ĐẶT PHÒNG (BÊN PHẢI) -->
    <div class="right-booking-summary">

        <div class="glass-card" style="padding: 24px;">
            <!-- ẢNH ĐẠI DIỆN PHÒNG ĐƯỢC CHUYỂN TỪ TRANG BOOKING SANG -->
            <div class="summary-img-wrap">
                <img src="https://images.unsplash.com/photo-1611892440504-42a792e24d32?auto=format&amp;fit=crop&amp;w=500&amp;q=80" alt="Luxury Room View">
            </div>

            <h4 style="font-size: 1.15rem; font-weight: 800; margin: 0 0 6px 0; color: var(--gold-light); text-transform: uppercase;">${not empty hotelName ? hotelName : 'Verdelle Hotel'}</h4>

            <div style="color: var(--brand-gold); font-size: 0.8rem; margin-bottom: 15px;">
                <i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i>
            </div>

            <p style="font-size: 0.85rem; color: var(--text-muted); margin: 0 0 14px 0; display: flex; align-items: center; gap: 8px; border-bottom: 1px dashed var(--border-soft); padding-bottom: 12px;">
                <i class="fa-regular fa-calendar-days" style="color: var(--brand-gold);"></i> Lịch trình: ${not empty dateRange ? dateRange : 'Đang cập nhật'}
            </p>
            <ul style="padding-left: 0; margin: 0; font-size: 0.85rem; color: var(--text-muted); line-height: 1.6; list-style: none;">
                <li style="margin-bottom: 6px;"><i class="fa-solid fa-moon" style="width: 20px;"></i> Thời gian ngụ: <strong>${not empty totalNights ? totalNights : 'N/A'} đêm</strong></li>
                <li><i class="fa-solid fa-bed" style="width: 20px;"></i> Quy mô: <strong>${not empty requiredRooms ? requiredRooms : '1'} x</strong> Phòng "${not empty roomName ? roomName : 'Tiêu chuẩn'}"</li>
            </ul>
        </div>

        <div class="sidebar-block" style="padding: 18px 20px;">
            <div class="perk-info-box">
                <div style="font-size: 0.85rem; font-weight: bold; color: var(--brand-success); margin-bottom: 4px;">
                    <i class="fa-solid fa-thumbs-up" style="color: var(--brand-success) !important;"></i> Lựa chọn phòng tuyệt vời
                </div>
                <div style="font-size: 0.8rem; color: var(--text-muted);">
                    Đánh giá trung bình từ khách lưu trú thực tế tại đây luôn đạt <strong>8,5 / 10</strong>.
                </div>
            </div>

            <c:if test="${discount > 0}">
                <div style="font-size:0.85rem; color:#ff5252; font-weight:bold; text-align:center; padding: 10px; background: #2a1515; border-radius: var(--radius-md); margin-top: 12px; border: 1px solid #5c2626;">
                    <i class="fa-solid fa-tags" style="color: #ff5252 !important;"></i> Khớp ưu đãi! Bạn tiết kiệm được <fmt:formatNumber value="${discount}" type="number" groupingUsed="true"/> đ
                </div>
            </c:if>
        </div>

        <div class="glass-card" style="padding: 24px;">
            <c:if test="${not empty voucherCode}">
                <div class="discount-badge">
                    <i class="fa-solid fa-tag" style="color: #ff5252 !important;"></i> Mã ưu đãi áp dụng: <strong>${voucherCode}</strong>
                </div>
            </c:if>

            <div class="price-breakdown-row" style="color: var(--brand-success); font-weight: bold;">
                <span>Phí dịch vụ đặt trước phòng</span>
                <span style="color: var(--brand-success);">MIỄN PHÍ</span>
            </div>

            <div class="price-breakdown-row">
                <span>Giá gốc (${requiredRooms} phòng x ${totalNights} đêm)</span>
                <c:choose>
                    <c:when test="${discount > 0}">
                        <span style="text-decoration: line-through; color: var(--text-muted);"><fmt:formatNumber value="${priceWithVAT}" type="number" groupingUsed="true"/> đ</span>
                    </c:when>
                    <c:otherwise>
                        <span><fmt:formatNumber value="${priceWithVAT}" type="number" groupingUsed="true"/> đ</span>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="price-breakdown-row">
                <span>Giá phòng trung bình (${requiredRooms} phòng / đêm)</span>
                <span><fmt:formatNumber value="${basePrice * requiredRooms}" type="number" groupingUsed="true"/> đ</span>
            </div>

            <div class="price-breakdown-row">
                <span>Thuế và phí dịch vụ (10% VAT)</span>
                <span><fmt:formatNumber value="${taxAndFees}" type="number" groupingUsed="true"/> đ</span>
            </div>

            <c:if test="${discount > 0}">
                <div class="price-breakdown-row" style="color: #ff5252; font-weight: 600;">
                    <span>Chiết khấu Voucher (15%)</span>
                    <span style="color: #ff5252;">- <fmt:formatNumber value="${discount}" type="number" groupingUsed="true"/> đ</span>
                </div>
            </c:if>

            <div class="final-price-box price-breakdown-row" style="align-items: center;">
                <span style="font-weight: 800; font-size: 1.1rem; color: var(--gold-light);">Giá cuối cùng</span>
                <span style="font-size: 1.7rem; font-weight: 900; color: var(--brand-gold);"><fmt:formatNumber value="${finalPrice}" type="number" groupingUsed="true"/> đ</span>
            </div>

            <p style="font-size: 0.75rem; color: var(--text-muted); text-align: right; margin: 5px 0 0 0;">
                (Giá đã bao gồm toàn bộ thuế VAT: <fmt:formatNumber value="${taxAndFees}" type="number" groupingUsed="true"/> đ)
            </p>
        </div>

        <div style="background: var(--surface); border: 1px solid var(--border-soft); border-left: 4px solid var(--brand-gold); border-radius: 4px var(--radius-md) var(--radius-md) 4px; padding: 15px; margin-bottom: 24px; box-shadow: var(--shadow-soft);">
            <strong style="font-size: 0.9rem; display: block; margin-bottom: 4px; color: var(--gold-light);">Thông tin thu ngân</strong>
            <span style="font-size: 0.8rem; color: var(--text-muted); line-height: 1.4; display: block;">
                Khách sạn trực tiếp xử lý và thu tiền cho giao dịch này, không qua trung gian.
            </span>
        </div>

        <div class="glass-card" style="padding: 24px;">
            <strong style="font-size: 0.9rem; display: block; margin-bottom: 8px; color: var(--text-main);">Quy định hủy phòng</strong>
            <p style="font-size: 0.8rem; color: var(--brand-success); margin: 0 0 15px 0; line-height: 1.5;">
                <strong>An tâm tuyệt đối!</strong> Hủy phòng hoàn toàn miễn phí trước khi ngày nhận phòng diễn ra. Quý khách dễ dàng chỉnh sửa thông tin trên hệ thống mà không lo phụ phí!
            </p>

            <div class="timeline-container">
                <div class="timeline-line">
                    <div class="timeline-dot" style="left: 0;"></div>
                    <div class="timeline-dot" style="left: 50%;"></div>
                    <div class="timeline-dot" style="right: 0; background: #cbd5e1;"></div>
                </div>
                <div style="display: flex; justify-content: space-between; font-size: 0.75rem; color: var(--text-muted); font-weight: 500;">
                    <span>Hôm nay</span>
                    <span>Hạn hủy free</span>
                    <span>Ngày Check-in</span>
                </div>
            </div>
        </div>

    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        // 1. GOM TOÀN BỘ BIẾN LÊN ĐẦU ĐỂ TRÁNH LỖI CRASH JS KHI CHƯA KHAI BÁO
        const radioMethods = document.querySelectorAll('input[name="paymentMethod"]');
        const qrSection = document.getElementById("qr-section");
        const targetForm = document.querySelector('form[action="FinalizeBookingController"]');

        if (!targetForm) return;

        const submitBtn = targetForm.querySelector('button[type="submit"]');
        const roomIdInput = targetForm.querySelector('input[name="roomId"]');
        const btnAutoNote = document.getElementById('btn-auto-note');
        const noteTextarea = document.getElementById('input-custom-note');
        const hiddenCustomerNoteFinal = document.getElementById('hiddenCustomerNoteFinal');
        const qrBox = document.getElementById('qr-box');

        if (!submitBtn || !roomIdInput || !btnAutoNote) return;

        submitBtn.setAttribute("id", "submit-booking-btn");
        submitBtn.disabled = true;

        let pollingInterval = null;
        let isSubmitting = false;

        const roomId = roomIdInput.value;
        const fullAmount = parseInt("${fullAmount}".replace(/[^0-9]/g, '')) || 0;
        const depositAmount = parseInt("${depositAmount}".replace(/[^0-9]/g, '')) || 0;
        const contextPath = "${pageContext.request.contextPath}";

        // 2. TÁCH RIÊNG HÀM XỬ LÝ GIAO DIỆN "Ổ KHÓA CỰC CHÁY"
        function triggerPaymentSuccess() {
            clearInterval(pollingInterval);

            if (qrBox) {
                qrBox.classList.add('locked'); // Kích hoạt CSS ổ khóa
                // Xóa trắng nguồn ảnh QR, triệt tiêu 100% khả năng quét đúp
                const qrImg = document.getElementById('qr-image');
                if(qrImg) qrImg.removeAttribute('src');
            }

            document.querySelector('.payment-method-container').style.opacity = '0.3';
            document.querySelector('.payment-method-container').style.pointerEvents = 'none';
            document.querySelector('.right-booking-summary').style.opacity = '0.3';

            btnAutoNote.style.boxShadow = "0 0 15px 5px rgba(38, 166, 154, 0.6)";
            btnAutoNote.style.transform = "scale(1.02)";
            btnAutoNote.style.transition = "all 0.3s";
            btnAutoNote.dataset.paymentDone = "true"; // Bật cờ cho phép tạo ghi chú

            submitBtn.innerHTML = "<i class='fa-solid fa-lock'></i> BẠN PHẢI BẤM TẠO GHI CHÚ TRƯỚC";
            submitBtn.classList.remove("btn-continue-active");
            submitBtn.disabled = true;
        }

        // 3. HÀM RENDER QR VÀ FETCH TỰ ĐỘNG
        function verifyRealPayment() {
            const selectedMethod = document.querySelector('input[name="paymentMethod"]:checked').value;
            const hiddenMethodInput = document.getElementById("hiddenPaymentMethod");
            if (hiddenMethodInput) hiddenMethodInput.value = selectedMethod;

            const qrImage = document.getElementById("qr-image");
            const qrNote = document.getElementById("qr-note");
            if (qrSection) qrSection.style.display = "block";

            submitBtn.innerHTML = '<i class="fa-solid fa-lock"></i> CHỜ THANH TOÁN';
            submitBtn.classList.remove("btn-continue-active");
            submitBtn.disabled = true;

            let currentAmount = (selectedMethod === "direct") ? depositAmount : fullAmount;

            if (qrNote) {
                qrNote.innerHTML = (selectedMethod === "direct")
                    ? '<i class="fa-solid fa-money-bill-wave"></i> Vui lòng quét mã ĐẶT CỌC 50% để hoàn tất thủ tục!'
                    : '<i class="fa-solid fa-qrcode"></i> Vui lòng quét mã THANH TOÁN 100% để xuất vé lập tức!';
                qrNote.style.color = "var(--brand-gold)";
            }

            if (qrImage) {
                const safeAmount = String(currentAmount);
                qrImage.src = "https://img.vietqr.io/image/MB-0834178906-compact2.png?amount=" + safeAmount + "&addInfo=VD" + roomId + "&accountName=" + encodeURIComponent("VERDELLE HOTEL");
            }

            startRealTimeChecking();
        }

        function startRealTimeChecking() {
            clearInterval(pollingInterval);
            pollingInterval = setInterval(function() {
                fetch(contextPath + '/CheckPaymentStatusController?roomId=' + roomId)
                    .then(response => response.json())
                    .then(data => {
                        if (data.isPaid === true || data.isPaid === "true") {
                            triggerPaymentSuccess(); // Gọi hàm mở khóa nếu Webhook chạy thật (đã deploy server)
                        }
                    })
                    .catch(error => console.log("Đang chờ xác nhận..."));
            }, 3000);
        }

        // 🚨 CHỨC NĂNG DEMO ĐÃ BỊ VÔ HIỆU HÓA KHI LÊN PRODUCTION
        // Không cho phép bấm đúp để qua mặt thanh toán nữa
        /*
        if (qrBox) {
            qrBox.addEventListener('dblclick', function() {
                console.log("🛠️ Chế độ Demo Localhost: Đã giả lập thanh toán thành công!");
                triggerPaymentSuccess();
            });
        }
        */

        radioMethods.forEach(radio => radio.addEventListener("change", verifyRealPayment));
        verifyRealPayment();

        // 4. SỰ KIỆN NÚT GHI CHÚ
        btnAutoNote.addEventListener('click', function() {
            if (this.dataset.paymentDone !== "true") {
                alert("⚠️ Bạn phải thanh toán (quét QR thành công) trước khi tạo ghi chú xác nhận!");
                return;
            }

            const selectedMethod = document.querySelector('input[name="paymentMethod"]:checked').value;
            let remainingAmount = (selectedMethod === "direct") ? (fullAmount - depositAmount) : 0;
            let methodPrefix = (selectedMethod === "direct") ? "Cọc 50%" : "Thanh toán 100%";
            let oldNote = "${not empty sessionScope.customerNote ? sessionScope.customerNote : ''}";

            let newNote = methodPrefix + "; số tiền còn lại là: " + remainingAmount.toLocaleString('vi-VN') + "đ; " + oldNote;

            noteTextarea.value = newNote;
            hiddenCustomerNoteFinal.value = newNote;

            document.querySelector('.right-booking-summary').style.opacity = '1';
            document.getElementById('qr-section').style.opacity = '0.3';
            document.getElementById('qr-section').style.pointerEvents = 'none';

            this.innerText = "Đã Cập Nhật Ghi Chú ✓";
            this.style.color = "#000";
            this.style.background = "var(--brand-success)";
            this.style.boxShadow = "none";
            this.style.transform = "none";

            submitBtn.innerHTML = "HOÀN TẤT ĐẶT PHÒNG <i class='fa-solid fa-arrow-right'></i>";
            submitBtn.classList.add("btn-continue-active");
            submitBtn.disabled = false;
        });

        // 5. CHẶN FORM SUBMIT KHI CHƯA GHI CHÚ
        targetForm.addEventListener('submit', function(e) {
            if (isSubmitting) {
                e.preventDefault();
                return;
            }

            const hasValidNote = noteTextarea.value.includes("Thanh toán 100%") || noteTextarea.value.includes("Cọc 50%");

            if (submitBtn.classList.contains("btn-continue-active") && !hasValidNote) {
                e.preventDefault();
                alert("❌ Bắt buộc: Vui lòng bấm nút 'Tạo Ghi Chú Tự Động' để xác nhận số tiền trước khi hoàn tất đặt phòng!");
                btnAutoNote.style.border = "2px solid red";
                setTimeout(() => { btnAutoNote.style.border = "1px solid var(--brand-success)"; }, 1500);
            } else if (hasValidNote) {
                isSubmitting = true;
                submitBtn.innerHTML = "<i class='fa-solid fa-spinner fa-spin'></i> ĐANG XỬ LÝ...";
                submitBtn.style.pointerEvents = 'none';
                submitBtn.style.opacity = '0.7';
            }
        });
    });
</script>

</body>
<footer>
    <jsp:include page="footer.jsp" />
</footer>
</html>