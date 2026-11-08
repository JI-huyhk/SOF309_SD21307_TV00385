<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Verdelle Hotel - Đặt phòng & Thanh toán</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/NavStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/FooterStyle.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        /* ================= TONE MÀU NỀN ĐEN VÀNG GOLD LUXURY ================= */
        :root {
            --brand-navy: #dfb76c;
            --brand-gold: #dfb76c;
            --gold-light: #f3e1bd;
            --gold-dark: #aa8443;
            --bg-body: #0b0b0b;
            --surface: #141414;
            --text-main: #ffffff;
            --text-muted: #a0a0a0;
            --border-soft: #2a2418;
            --accent-green: #26a69a;
            --accent-orange: #ffca28;
            --radius-lg: 16px;
            --radius-md: 10px;
            --shadow-soft: 0 8px 32px rgba(0, 0, 0, 0.7);
            --shadow-hover: 0 12px 40px rgba(223, 183, 108, 0.15);
        }

        /* Thay thế toàn bộ ảnh bằng nền đen Gradient luxury có chiều sâu */
        body {
            background: radial-gradient(circle at 50% 30%, #1a1a1a 0%, #0b0b0b 70%, #050505 100%) !important;
            background-attachment: fixed !important;
            color: var(--text-main) !important;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
        }

        /* Hủy bỏ hoàn toàn các lớp phủ background cũ */
        body::before {
            display: none !important;
        }

        /* --- THANH TIẾN TRÌNH LUXURY --- */
        .modern-stepper {
            background: var(--surface);
            padding: 25px 0;
            border-bottom: 1px solid var(--border-soft);
            box-shadow: var(--shadow-soft);
        }
        .stepper-inner {
            max-width: 700px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            position: relative;
        }
        .stepper-line {
            position: absolute;
            top: 15px;
            left: 50px;
            right: 50px;
            height: 2px;
            background: #252525;
            z-index: 1;
        }
        .stepper-line-fill {
            position: absolute;
            top: 15px;
            left: 50px;
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
            width: 120px;
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
        .step.active .step-text {
            color: var(--gold-light);
        }

        /* --- BỐ CỤC CHÍNH (GRID LỆCH) --- */
        .booking-layout {
            max-width: 1140px;
            margin: 40px auto;
            padding: 0 20px;
            display: grid;
            grid-template-columns: 1.8fr 1.2fr;
            gap: 30px;
            align-items: start;
        }

        /* --- CÁC KHỐI CARD THÔNG TIN THƯỢNG LƯU --- */
        .glass-card {
            background: var(--surface) !important;
            border-radius: var(--radius-lg);
            padding: 28px;
            margin-bottom: 24px;
            box-shadow: var(--shadow-soft);
            border: 1px solid var(--border-soft) !important;
            transition: all 0.3s ease;
        }
        .glass-card:hover {
            box-shadow: var(--shadow-hover);
            border-color: var(--gold-dark) !important;
        }
        .card-header {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--brand-gold);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            letter-spacing: 0.5px;
            text-transform: uppercase;
        }

        /* Thông tin khách */
        .guest-info-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: #1a1a1a;
            padding: 16px 20px;
            border-radius: var(--radius-md);
            border: 1px dashed var(--border-soft);
        }
        .btn-edit-modern {
            background: transparent;
            border: 1px solid var(--brand-gold);
            color: var(--brand-gold);
            padding: 8px 18px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }
        .btn-edit-modern:hover {
            background: linear-gradient(135deg, var(--gold-dark), var(--brand-gold));
            color: #000;
            box-shadow: 0 0 10px rgba(223, 183, 108, 0.3);
        }

        /* Checkbox hiện đại */
        .modern-checkbox {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 12px 16px;
            border: 1px solid var(--border-soft);
            border-radius: var(--radius-md);
            margin-bottom: 12px;
            cursor: pointer;
            transition: all 0.2s;
            background: #181818;
        }
        .modern-checkbox:hover {
            border-color: var(--brand-gold);
            background: #222;
        }
        .modern-checkbox input[type="checkbox"] {
            width: 18px;
            height: 18px;
            accent-color: var(--brand-gold);
        }

        /* Khu vực nhập Note / Ghi chú */
        .note-textarea {
            width: 100%;
            padding: 12px 16px;
            background: #1a1a1a;
            border: 1px solid var(--border-soft);
            border-radius: var(--radius-md);
            color: var(--text-main);
            font-family: inherit;
            font-size: 0.95rem;
            resize: vertical;
            min-height: 80px;
            transition: all 0.3s;
            box-sizing: border-box;
            margin-top: 15px;
        }
        .note-textarea:focus {
            outline: none;
            border-color: var(--brand-gold);
            box-shadow: 0 0 10px rgba(223, 183, 108, 0.2);
            background: #1e1e1e;
        }

        /* Quyền lợi */
        .perk-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid var(--border-soft);
        }
        .perk-item:last-child { border-bottom: none; padding-bottom: 0; }

        .badge-free {
            background: rgba(38, 166, 154, 0.15);
            color: var(--accent-green);
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 800;
            border: 1px solid rgba(38, 166, 154, 0.3);
        }

        /* --- SIDEBAR BÊN PHẢI --- */
        .sidebar-sticky {
            position: sticky;
            top: 20px;
        }
        .summary-img-wrap {
            height: 160px;
            border-radius: var(--radius-md);
            overflow: hidden;
            margin-bottom: 20px;
            border: 1px solid var(--border-soft);
        }
        .summary-img-wrap img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .date-flex {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            background: #1a1a1a;
            border-radius: var(--radius-md);
            padding: 15px;
            margin-bottom: 20px;
            border: 1px solid var(--border-soft);
        }
        .date-col { flex: 1; }
        .date-label { font-size: 0.75rem; color: var(--text-muted); text-transform: uppercase; letter-spacing: 1px; margin-bottom: 5px; }
        .date-val { font-size: 1rem; font-weight: 700; color: var(--gold-light); }
        .date-divider { color: var(--border-soft); font-size: 1.2rem; }

        /* Tính tiền */
        .price-breakdown {
            margin: 20px 0;
            padding-top: 15px;
            border-top: 1px dashed var(--border-soft);
        }
        .price-line {
            display: flex;
            justify-content: space-between;
            font-size: 0.9rem;
            color: var(--text-muted);
            margin-bottom: 10px;
        }
        .price-line strong { color: var(--text-main); }

        .total-box {
            background: rgba(223, 183, 108, 0.05);
            border-radius: var(--radius-md);
            padding: 20px;
            margin-top: 20px;
            text-align: right;
            border: 1px solid rgba(223, 183, 108, 0.15);
        }

        /* NÚT XÁC NHẬN THANH TOÁN SIÊU SANG */
        .btn-submit-modern {
            width: 100%;
            background: linear-gradient(135deg, var(--gold-dark) 0%, var(--brand-gold) 50%, var(--gold-dark) 100%);
            color: #000000;
            padding: 16px;
            border: none;
            border-radius: var(--radius-md);
            font-size: 1.05rem;
            font-weight: 700;
            cursor: pointer;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            margin-top: 20px;
            transition: all 0.4s ease;
            box-shadow: 0 4px 15px rgba(223, 183, 108, 0.2);
        }
        .btn-submit-modern:hover {
            background: linear-gradient(135deg, var(--brand-gold) 0%, var(--gold-light) 50%, var(--brand-gold) 100%);
            box-shadow: 0 6px 20px rgba(223, 183, 108, 0.4);
            transform: translateY(-2px);
        }
        .btn-submit-modern:active { transform: scale(0.98); }

        /* Voucher */
        .modern-voucher {
            background: #1e1910;
            border: 1px solid #4a3b1e;
            border-radius: var(--radius-md);
            padding: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        /* Modal cập nhật thông tin */
        .custom-modal-overlay {
            position: fixed;
            inset: 0; background: rgba(0,0,0,0.85); backdrop-filter: blur(5px);
            display: flex; align-items: center; justify-content: center; z-index: 9999;
            opacity: 0; pointer-events: none;
            transition: opacity 0.3s;
        }
        .custom-modal-overlay.show { opacity: 1; pointer-events: auto; }

        .custom-modal-card {
            background: var(--surface);
            width: 100%; max-width: 600px;
            border-radius: var(--radius-lg); padding: 30px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.9);
            border: 1px solid var(--border-soft);
            transform: translateY(-20px); transition: transform 0.3s;
        }
        .custom-modal-overlay.show .custom-modal-card { transform: translateY(0); }

        .modal-input-wrapper { display: flex; flex-direction: column; gap: 8px; margin-bottom: 15px; }
        .modal-input-wrapper label { font-size: 0.85rem; font-weight: 600; color: var(--gold-light); }

        .modal-input-wrapper input {
            padding: 12px 15px;
            background: #1a1a1a;
            border: 1px solid var(--border-soft);
            border-radius: var(--radius-md);
            color: #fff;
            outline: none;
            transition: border 0.3s;
        }
        .modal-input-wrapper input:focus { border-color: var(--brand-gold); box-shadow: 0 0 8px rgba(223, 183, 108, 0.2); }

        i.fa-solid, i.fa-regular {
            color: var(--brand-gold);
        }

        /* Hiệu ứng pop-in cho ổ khóa voucher */
        @keyframes lockPopIn {
            0% { transform: scale(0.5); opacity: 0; }
            70% { transform: scale(1.1); opacity: 1; }
            100% { transform: scale(1); opacity: 1; }
        }

        /* HIỆU ỨNG THANH NĂNG LƯỢNG GOLD */
        .energy-bar-container {
            width: 100%; height: 10px; background: #1a1a1a;
            border-radius: 10px; overflow: hidden; margin-top: 10px;
            border: 1px solid var(--border-soft); box-shadow: inset 0 1px 3px rgba(0,0,0,0.5);
        }
        .energy-bar-fill {
            height: 100%; width: 0%; border-radius: 10px;
            background: linear-gradient(90deg, #aa8443, #ffca28, #dfb76c);
            background-size: 200% 200%;
            animation: goldFlow 2s ease infinite;
            transition: width 1s ease-in-out;
        }
        @keyframes goldFlow {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        /* HIỆU ỨNG RUNG LẮC NHẮC NHỞ VOUCHER */
        .shake-warning {
            animation: shakeIt 0.4s ease-in-out;
            border-color: #ff5252 !important;
            box-shadow: 0 0 15px rgba(255, 82, 82, 0.4) !important;
            background: rgba(255, 82, 82, 0.05) !important;
        }
        @keyframes shakeIt {
            0%, 100% { transform: translateX(0); }
            20%, 60% { transform: translateX(-5px); }
            40%, 80% { transform: translateX(5px); }
        }
        .voucher-warning-text {
            color: #ff5252; font-size: 0.8rem; font-weight: bold;
            margin-top: 5px; display: none; margin-bottom: 10px;
        }
    </style>
</head>
<body>

<c:set var="userSessionName" value="${sessionScope.firstName}" />

<jsp:include page="header.jsp" />

<div class="modern-stepper">
    <div class="stepper-inner">
        <div class="stepper-line"></div>
        <div class="stepper-line-fill"></div>
        <div class="step active">
            <div class="step-circle"><i class="fa-solid fa-check" style="color: #000;"></i></div>
            <div class="step-text">Khách hàng</div>
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
<div class="booking-layout">
    <div class="main-details">
        <div class="glass-card">
            <div class="card-header"><i class="fa-solid fa-user-tie"></i> Thông tin người đặt</div>
            <div class="guest-info-row" style="flex-wrap: wrap; gap: 15px;">
                <div style="display: flex; gap: 20px; align-items: center; flex: 1;">
                    <div style="width: 50px; height: 50px; background: #222; border: 1px solid var(--border-soft); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.5rem;">
                        <i class="fa-regular fa-user"></i>
                    </div>
                    <div>
                        <div id="display-name" style="font-size: 1.1rem; font-weight: 700; margin-bottom: 4px; color: var(--gold-light);">${sessionScope.customerName != null ? sessionScope.customerName : sessionScope.firstName}</div>
                        <div id="display-email" style="font-size: 0.85rem; color: var(--text-muted); margin-bottom: 2px;">${sessionScope.customerEmail != null ? sessionScope.customerEmail : sessionScope.userEmail}</div>
                        <div id="display-phone" style="font-size: 0.85rem; color: var(--text-muted);"><i class="fa-solid fa-phone" style="font-size: 0.75rem;"></i> ${sessionScope.customerPhone != null ? sessionScope.customerPhone : sessionScope.userPhone}</div>
                    </div>
                </div>
                <!-- Box thông tin hạng và điểm (Nâng cấp Năng lượng) -->
                <div style="background: rgba(223, 183, 108, 0.1); padding: 12px 15px; border-radius: var(--radius-md); border: 1px solid var(--brand-gold); flex: 1; min-width: 250px;">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 4px;">
                        <div style="font-size: 0.9rem; color: var(--gold-light); font-weight: bold;">
                            <i class="fa-solid fa-crown"></i> Hạng: <span id="current-rank">${not empty requestScope.rank ? requestScope.rank : (not empty sessionScope.membershipRank ? sessionScope.membershipRank : 'Member')}</span>
                        </div>
                        <div style="font-size: 0.75rem; color: var(--text-muted);">
                            Uy tín: <span style="color: var(--accent-green); font-weight: bold;">${not empty requestScope.uyTin ? requestScope.uyTin : 100}</span>
                        </div>
                    </div>

                    <div class="energy-bar-container">
                        <div class="energy-bar-fill" id="rank-progress-bar"></div>
                    </div>

                    <div style="display: flex; justify-content: space-between; margin-top: 6px; font-size: 0.75rem;">
                        <span style="color: var(--accent-orange); font-weight: bold;">${not empty requestScope.loyalPoint ? requestScope.loyalPoint : 0} điểm</span>
                        <span id="next-rank-info" style="color: var(--text-muted);">Đang tải...</span>
                    </div>
                </div>

                <script>
                    document.addEventListener("DOMContentLoaded", function() {
                        const currentPoints = parseInt('${not empty requestScope.loyalPoint ? requestScope.loyalPoint : 0}', 10);
                        let nextRank = "Member";
                        let pointsNeeded = 0;
                        let maxPoints = 0;
                        let basePoints = 0;

                        if (currentPoints < 500) { nextRank = "Silver"; maxPoints = 500; basePoints = 0; }
                        else if (currentPoints < 1000) { nextRank = "Gold"; maxPoints = 1000; basePoints = 500; }
                        else if (currentPoints < 1500) { nextRank = "Diamond"; maxPoints = 1500; basePoints = 1000; }
                        else { nextRank = "MAX"; }

                        const progressBar = document.getElementById("rank-progress-bar");
                        const nextRankInfo = document.getElementById("next-rank-info");

                        if (nextRank === "MAX") {
                            progressBar.style.width = "100%";
                            nextRankInfo.innerHTML = "<i class='fa-solid fa-star'></i> Đạt cấp tối đa";
                        } else {
                            pointsNeeded = maxPoints - currentPoints;
                            // Tính % trong chặng hiện tại
                            let percent = ((currentPoints - basePoints) / (maxPoints - basePoints)) * 100;
                            setTimeout(() => { progressBar.style.width = percent + "%"; }, 300);
                            nextRankInfo.innerHTML = "Cần <b style='color: var(--brand-gold);'>" + pointsNeeded + " điểm</b> lên <b>" + nextRank + "</b>";
                        }
                    });
                </script>
                <button id="btn-edit" class="btn-edit-modern"><i class="fa-solid fa-pen"></i> Sửa</button>
            </div>
        </div>

        <div class="glass-card">
            <div class="card-header"><i class="fa-solid fa-bell-concierge"></i> Yêu cầu & Ghi chú</div>
            <p style="font-size: 0.85rem; color: var(--text-muted); margin-bottom: 20px;">* Chúng tôi sẽ nỗ lực đáp ứng các yêu cầu của bạn dựa trên tình trạng phòng thực tế.</p>

            <label class="modern-checkbox">
                <input type="checkbox" name="specialReq" value="highFloor">
                <span><i class="fa-solid fa-city" style="color: var(--brand-gold); width: 25px;"></i> Phòng tầng cao, view thoáng</span>
            </label>
            <label class="modern-checkbox">
                <input type="checkbox" name="specialReq" value="quietRoom">
                <span><i class="fa-solid fa-volume-xmark" style="color: var(--brand-gold); width: 25px;"></i> Phòng yên tĩnh (xa thang máy)</span>
            </label>
            <label class="modern-checkbox">
                <input type="checkbox" name="specialReq" value="earlyCheckin">
                <span><i class="fa-solid fa-stopwatch" style="color: var(--brand-gold); width: 25px;"></i> Ưu tiên nhận phòng sớm</span>
            </label>

            <!-- KHU VỰC TEXTAREA ĐỂ LƯU VÀO CỘT "NOTE" DATABASE SQL -->
            <div style="margin-top: 20px; border-top: 1px dashed var(--border-soft); padding-top: 15px;">
                <label style="font-size: 0.9rem; font-weight: 600; color: var(--gold-light); display: flex; align-items: center; gap: 8px; margin-bottom: 10px;">
                    <i class="fa-solid fa-wand-magic-sparkles"></i> Ghi chú tự động
                </label>
                <button type="button" id="btn-auto-note" class="btn-edit-modern" style="width: 100%; margin-bottom: 10px; border-color: var(--accent-green); color: var(--accent-green);">
                    Tạo Ghi Chú Tự Động
                </button>
                <!-- Thêm readonly để khách không tự sửa phá format -->
                <textarea id="input-custom-note" class="note-textarea" readonly placeholder="Vui lòng điền đủ thông tin cá nhân và bấm nút tạo ghi chú..."></textarea>
            </div>
        </div>

        <div class="glass-card" style="border-left: 5px solid var(--accent-green);">
            <div class="card-header" style="color: var(--accent-green);"><i class="fa-solid fa-gift" style="color: var(--accent-green);"></i> Đặc quyền của bạn</div>
            <div class="perk-item">
                <span style="font-size: 0.95rem; font-weight: 500;"><i class="fa-solid fa-wifi" style="color: var(--accent-green); margin-right: 10px;"></i> Internet tốc độ cao</span>
                <span class="badge-free">MIỄN PHÍ</span>
            </div>
            <div class="perk-item">
                <span style="font-size: 0.95rem; font-weight: 500;"><i class="fa-solid fa-mug-saucer" style="color: var(--accent-green); margin-right: 10px;"></i> Buffet sáng hảo hạng</span>
                <span class="badge-free">ĐÃ BAO GỒM</span>
            </div>
        </div>
    </div>

    <div class="sidebar-sticky">
        <div class="glass-card" style="padding: 24px;">
            <div class="summary-img-wrap">
                <c:choose>
                    <c:when test="${not empty selectedRoom.image}">
                        <img src="${selectedRoom.image}" alt="Room">
                    </c:when>
                    <c:otherwise>
                        <div style="width: 100%; height: 100%; background: #222; display: flex; align-items: center; justify-content: center;"><i class="fa-solid fa-hotel" style="font-size: 3rem; color: #444;"></i></div>
                    </c:otherwise>
                </c:choose>
            </div>

            <h3 style="font-size: 1.2rem; font-weight: 800; margin-bottom: 5px; color: var(--gold-light);">${not empty selectedRoom.hotelName ? selectedRoom.hotelName : 'Verdelle Hotel'}</h3>
            <div style="color: var(--brand-gold); font-size: 0.8rem; margin-bottom: 20px;">
                <i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i>
            </div>

            <div class="date-flex">
                <!-- Khối Check-in an toàn -->
                <div class="date-col">
                    <div class="date-label">Check-in</div>
                    <div class="date-val" id="val-checkin">
                        ${not empty dateRange ? (dateRange.contains('to') ? dateRange.split('to')[0].trim() : dateRange) : (not empty sessionScope.dateRange ? (sessionScope.dateRange.contains('to') ? sessionScope.dateRange.split('to')[0].trim() : sessionScope.dateRange) : '01/06/2026')}
                    </div>
                </div>

                <!-- Khối Check-out an toàn -->
                <div class="date-col">
                    <div class="date-label">Check-out</div>
                    <div class="date-val" id="val-checkout">
                        ${not empty dateRange ? (dateRange.contains('to') ? dateRange.split('to')[1].trim() : 'N/A') : (not empty sessionScope.dateRange ? (sessionScope.dateRange.contains('to') ? sessionScope.dateRange.split('to')[1].trim() : 'N/A') : '05/06/2026')}
                    </div>
                </div>

                <div id="val-guests" style="grid-column: span 2; border-top: 1px dashed var(--border-soft); padding-top: 12px; color: var(--text-muted); text-align: center; font-size: 0.9rem;">
                    <i class="fa-solid fa-users" style="width: 20px;"></i>
                    Khách: ${not empty sessionScope.qtyAdults ? sessionScope.qtyAdults : 2} Lớn,
                    ${not empty sessionScope.qtyChildren ? sessionScope.qtyChildren : 0} Trẻ em
                </div>
            </div>

            <div style="font-size: 0.9rem; line-height: 1.6; margin-bottom: 20px;">
                <div style="font-weight: bold; font-size: 1rem; color: var(--text-main); margin-bottom: 8px;">${not empty selectedRoom.roomName ? selectedRoom.roomName : 'Phòng Tiêu Chuẩn'}</div>
                <div style="color: var(--text-muted);"><i class="fa-solid fa-maximize" style="width: 20px;"></i> Diện tích: ${not empty selectedRoom.area ? selectedRoom.area : 'N/A'} m²</div>
                <div style="color: var(--text-muted);">
                    <i class="fa-solid fa-users" style="width: 20px;"></i>
                    Khách: ${not empty sessionScope.qtyAdults ? sessionScope.qtyAdults : 2} Lớn,
                    ${not empty sessionScope.qtyChildren ? sessionScope.qtyChildren : 0} Trẻ em
                    <c:if test="${not empty sessionScope.childrenAges}">
                        <span style="font-size: 0.8rem; color: var(--brand-gold);"> (Tuổi: ${sessionScope.childrenAges})</span>
                    </c:if>
                </div>
                <div style="color: var(--text-muted);"><i class="fa-solid fa-bed" style="width: 20px;"></i> Giường: ${not empty selectedRoom.bed ? selectedRoom.bed : 'N/A'}</div>
            </div>

            <!-- BỔ SUNG: Checkbox Không chọn voucher (Có Validator) -->
            <div id="voucher-warning" class="voucher-warning-text">
                <i class="fa-solid fa-circle-exclamation"></i> Có vẻ bạn chưa áp mã ưu đãi! Vui lòng chọn voucher hoặc tích vào ô bên dưới nhé.
            </div>
            <label id="lbl-no-voucher" class="modern-checkbox" style="margin-bottom: 10px; border-color: var(--text-muted); transition: all 0.3s;">
                <input type="checkbox" id="chk-no-voucher">
                <span style="color: var(--text-muted); font-weight: bold;">Tôi không có / Không muốn dùng mã ưu đãi</span>
            </label>

            <!-- CẬP NHẬT: Thêm position: relative và id để dễ kiểm soát lớp phủ -->
            <div class="modern-voucher" id="voucher-container" style="flex-direction: column; gap: 10px; align-items: stretch; position: relative; overflow: hidden;">

                <!-- BỔ SUNG: Lớp phủ (Overlay) khóa khu vực voucher -->
                <div id="voucher-lock-overlay" style="display: none; position: absolute; inset: 0; background: rgba(11, 11, 11, 0.85); backdrop-filter: blur(4px); z-index: 10; flex-direction: column; align-items: center; justify-content: center; text-align: center; border-radius: var(--radius-md);">
                    <i class="fa-solid fa-lock" style="font-size: 2rem; color: var(--text-muted); margin-bottom: 10px; animation: lockPopIn 0.4s ease forwards;"></i>
                    <span style="color: var(--text-muted); font-size: 0.9rem; font-weight: bold; margin-bottom: 12px;">Đã bỏ qua ưu đãi</span>
                    <button type="button" id="btn-change-mind" style="background: transparent; border: 1px dashed var(--brand-gold); color: var(--brand-gold); padding: 6px 16px; border-radius: 20px; font-size: 0.8rem; font-weight: bold; cursor: pointer; transition: 0.3s;">
                        <i class="fa-solid fa-rotate-left"></i> Đổi ý
                    </button>
                </div>

                <div style="display: flex; justify-content: space-between; align-items: center;">
                    <div>
                        <div style="font-weight: 800; color: var(--accent-orange); font-size: 1rem;"><i class="fa-solid fa-ticket"></i> MÃ ƯU ĐÃI</div>
                        <div style="font-size: 0.75rem; color: var(--text-muted); margin-top: 4px;" id="voucher-desc-display">Chưa áp dụng mã nào</div>
                    </div>
                    <button type="button" id="btn-show-vouchers" style="background: transparent; border: 1px solid var(--accent-orange); color: var(--accent-orange); padding: 5px 12px; border-radius: 20px; font-size: 0.8rem; font-weight: bold; cursor: pointer; transition: 0.3s;">
                        Chọn Voucher <span style="background: var(--accent-orange); color: #000; padding: 2px 6px; border-radius: 50%; font-size: 0.7rem; margin-left: 5px;">${not empty availableVouchers ? availableVouchers.size() : 0}</span>
                    </button>
                </div>

                <div style="display: flex; gap: 10px; margin-top: 5px;">
                    <input type="text" id="input-voucher-code" readonly placeholder="Mã voucher sẽ hiển thị ở đây..." style="flex: 1; padding: 8px 12px; background: #111; border: 1px solid var(--border-soft); border-radius: var(--radius-md); color: var(--accent-orange); font-weight: bold; outline: none;">
                    <button type="button" id="btn-apply-voucher" style="background: var(--accent-orange); color: #000; border: none; padding: 8px 15px; border-radius: var(--radius-md); font-weight: bold; cursor: pointer;">Áp dụng</button>
                </div>
                <button type="button" id="btn-remove-voucher" style="display: none; background: transparent; color: #ff5252; border: 1px dashed #ff5252; padding: 6px; border-radius: var(--radius-md); font-size: 0.8rem; cursor: pointer; margin-top: 5px;">Hủy mã đang dùng</button>
            </div>

            <c:set var="rawPrice" value="${not empty selectedRoom.price ? selectedRoom.price : 1450000}" />
            <c:set var="priceWithVAT" value="${rawPrice * 1.1}" />
            <fmt:formatNumber var="formattedPriceWithVAT" value="${priceWithVAT}" pattern="#"/>

            <div class="price-breakdown">
                <div class="price-line">
                    <span>Giá gốc (${totalNights} đêm x ${requiredRooms} phòng)</span>
                    <strong><fmt:formatNumber value="${selectedRoom.basePrice}" type="number" groupingUsed="true"/> đ</strong>
                </div>
                <div class="price-line">
                    <span>Thuế & Phí dịch vụ (VAT 10%)</span>
                    <strong style="color: var(--accent-green);">Đã bao gồm</strong>
                </div>
            </div>

            <div class="total-box">
                <div style="font-size: 0.85rem; color: var(--text-muted); margin-bottom: 5px; text-transform: uppercase; font-weight: 600;">Tổng thanh toán</div>
                <div id="strike-price-display" style="display: none; font-size: 1rem; color: var(--text-muted); text-decoration: line-through; margin-bottom: 4px;"></div>
                <div id="final-price-display" style="font-size: 1.8rem; font-weight: 900; color: var(--brand-gold);">
                    <fmt:formatNumber value="${priceWithVAT}" type="number" groupingUsed="true"/> đ
                </div>
            </div>

            <!-- FORM SUBMIT VỀ PAYMENT CONTROLLER -->
            <!-- FORM SUBMIT VỀ PAYMENT CONTROLLER -->
            <form id="form-booking-submit" action="PaymentController" method="POST">
                <!-- Checkbox Điều khoản -->
                <label class="modern-checkbox" style="margin-top: 15px; background: transparent; border: none; padding: 0;">
                    <input type="checkbox" id="chk-terms" required>
                    <span style="font-size: 0.85rem; color: var(--text-muted);">
            Tôi đã đọc và đồng ý với <a href="javascript:void(0)" id="link-terms" style="color: var(--brand-gold);">Điều khoản & Chính sách</a> của khách sạn.
        </span>
                </label>

                <!-- Các Input ẩn lưu dữ liệu hệ thống -->
                <input type="hidden" id="hidden-customer-cccd" name="customerCCCD" value="">
                <input type="hidden" id="hidden-book-for-other" name="isBookingForOther" value="false">
                <input type="hidden" id="hidden-final-price" name="price" value="${formattedPriceWithVAT}">
                <input type="hidden" id="hidden-voucher-code" name="voucherCode" value="">
                <input type="hidden" id="hidden-special-req" name="specialReqs" value="">
                <input type="hidden" id="hidden-customer-note" name="customerNote" value=""> <!-- Input quan trọng lưu NOTE tổng hợp -->

                <!-- Thông tin phòng và phòng đặt -->
                <input type="hidden" name="roomId" value="${selectedRoom.roomId}">
                <input type="hidden" name="roomName" value="${selectedRoom.roomName}">
                <input type="hidden" name="hotelName" value="${selectedRoom.hotelName}">
                <input type="hidden" id="hidden-date-range" name="dateRange" value="${not empty dateRange ? dateRange : (not empty sessionScope.dateRange ? sessionScope.dateRange : '01/06/2026 to 05/06/2026')}">
                <input type="hidden" name="requiredRooms" value="${requiredRooms}">
                <input type="hidden" name="totalNights" value="${totalNights}">
                <input type="hidden" name="basePrice" value="${selectedRoom.basePrice}">
                <input type="hidden" name="qtyAdults" value="${not empty sessionScope.qtyAdults ? sessionScope.qtyAdults : 2}">
                <input type="hidden" name="qtyChildren" value="${not empty sessionScope.qtyChildren ? sessionScope.qtyChildren : 0}">

                <!-- Dữ liệu khách hàng (Ưu tiên lấy userId, nếu null thì lấy customerId) -->
                <input type="hidden" name="customerId" value="${not empty sessionScope.userId ? sessionScope.userId : sessionScope.customerId}">
                <input type="hidden" id="hidden-customer-name" name="customerName" value="${sessionScope.customerName != null ? sessionScope.customerName : sessionScope.firstName}">
                <input type="hidden" id="hidden-customer-email" name="customerEmail" value="${sessionScope.customerEmail != null ? sessionScope.customerEmail : sessionScope.userEmail}">
                <input type="hidden" id="hidden-customer-phone" name="customerPhone" value="${sessionScope.customerPhone != null ? sessionScope.customerPhone : sessionScope.userPhone}">

                <!-- DUY NHẤT 1 NÚT THANH TOÁN CHÍNH -->
                <button type="submit" class="btn-submit-modern" id="btn-final-submit">
                    XÁC NHẬN THANH TOÁN
                </button>

                <!-- Nút Quay Về -->
                <button type="button" onclick="history.back()" style="width: 100%; background: transparent; color: var(--text-muted); border: 1px solid var(--border-soft); padding: 12px; border-radius: var(--radius-md); font-weight: bold; cursor: pointer; margin-top: 10px; transition: 0.3s;">
                    <i class="fa-solid fa-arrow-left"></i> QUAY VỀ TRANG TRƯỚC
                </button>
            </form>

            <!-- SCRIPT KIỂM TRA BẮT BUỘC VOUCHER HOẶC CHECKBOX -->
            <script>
                document.getElementById('form-booking-submit').addEventListener('submit', function(event) {
                    const voucherCode = document.getElementById('hidden-voucher-code').value.trim();
                    const noVoucherChk = document.getElementById('chk-no-voucher').checked;
                    const lblNoVoucher = document.getElementById('lbl-no-voucher');
                    const warningText = document.getElementById('voucher-warning');

                    // Nếu CHƯA áp mã VÀ CHƯA tích ô "Không dùng mã"
                    if (voucherCode === "" && !noVoucherChk) {
                        event.preventDefault(); // Ngăn form gửi đi

                        // Hiển thị thông báo
                        warningText.style.display = "block";

                        // Scroll nhẹ tới khu vực voucher để khách thấy
                        lblNoVoucher.scrollIntoView({ behavior: 'smooth', block: 'center' });

                        // Thêm hiệu ứng rung lắc (Shake) và viền đỏ
                        lblNoVoucher.classList.remove('shake-warning');
                        void lblNoVoucher.offsetWidth; // Trigger reflow để reset animation
                        lblNoVoucher.classList.add('shake-warning');

                        // Cảnh báo động nhấp nháy cho người dùng
                        lblNoVoucher.querySelector('span').style.color = "#ff5252";
                        setTimeout(() => {
                            lblNoVoucher.classList.remove('shake-warning');
                            lblNoVoucher.querySelector('span').style.color = "var(--text-muted)";
                        }, 2500); // Tắt hiệu ứng sau 2.5s
                    } else {
                        // Pass điều kiện -> Cho phép submit bình thường
                        warningText.style.display = "none";
                    }
                });

                // Tắt cảnh báo ngay khi người dùng click vào Checkbox
                document.getElementById('chk-no-voucher').addEventListener('change', function() {
                    if(this.checked) {
                        document.getElementById('voucher-warning').style.display = "none";
                        document.getElementById('lbl-no-voucher').classList.remove('shake-warning');
                        document.getElementById('lbl-no-voucher').querySelector('span').style.color = "var(--text-muted)";
                    }
                });
            </script>
        </div>
    </div>
</div>

<div id="modal-edit" class="custom-modal-overlay">
    <div id="modal-card" class="custom-modal-card">
        <h3 style="font-size: 1.4rem; font-weight: 800; color: var(--brand-gold); margin: 0 0 5px 0;">Cập nhật thông tin</h3>
        <p style="font-size: 0.85rem; color: var(--text-muted); margin-bottom: 20px;">Đảm bảo thông tin chính xác để làm thủ tục nhận phòng.</p>

        <!-- Thêm Tab/Checkbox Đặt hộ -->
        <label class="modern-checkbox" style="margin-bottom: 20px; border-color: var(--accent-green);">
            <input type="checkbox" id="chk-book-for-other">
            <span style="color: var(--accent-green); font-weight: bold;">Tôi đang đặt phòng hộ người khác</span>
        </label>

        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
            <div class="modal-input-wrapper">
                <label><i class="fa-solid fa-lock" style="color: var(--text-muted); font-size: 0.8rem;"></i> Họ (Surname) <span style="color: red;">*</span></label>
                <input type="text" id="input-surname" placeholder="Ví dụ: NGUYEN" readonly style="background: #111; cursor: not-allowed; color: var(--text-muted); border-color: var(--surface);">
            </div>
            <div class="modal-input-wrapper">
                <label><i class="fa-solid fa-lock" style="color: var(--text-muted); font-size: 0.8rem;"></i> Tên Đệm & Tên <span style="color: red;">*</span></label>
                <input type="text" id="input-name" placeholder="Ví dụ: VAN A" readonly style="background: #111; cursor: not-allowed; color: var(--text-muted); border-color: var(--surface);">
            </div>

            <!-- Thêm trường CCCD (Ô duy nhất được phép nhập) -->
            <div class="modal-input-wrapper" style="grid-column: span 2;">
                <label>CCCD / Passport <span style="color: red;">*</span></label>
                <input type="text" id="input-cccd" placeholder="Nhập số Căn cước công dân hoặc Hộ chiếu (Bắt buộc)">
            </div>

            <div class="modal-input-wrapper" style="grid-column: span 2;">
                <label><i class="fa-solid fa-lock" style="color: var(--text-muted); font-size: 0.8rem;"></i> Email liên hệ <span style="color: red;">*</span></label>
                <input type="email" id="input-email" placeholder="example@gmail.com" readonly style="background: #111; cursor: not-allowed; color: var(--text-muted); border-color: var(--surface);">
            </div>
            <div class="modal-input-wrapper" style="grid-column: span 2;">
                <label><i class="fa-solid fa-lock" style="color: var(--text-muted); font-size: 0.8rem;"></i> Số điện thoại <span style="color: red;">*</span></label>
                <div style="display: flex; gap: 10px;">
                    <input type="text" value="+ 84" readonly style="width: 70px; text-align: center; background: #222; border: 1px solid var(--border-soft); color: var(--gold-light); font-weight: bold; border-radius: var(--radius-md); cursor: not-allowed;">
                    <input type="tel" id="input-phone" placeholder="Nhập số điện thoại" style="flex: 1; background: #111; cursor: not-allowed; color: var(--text-muted); border-color: var(--surface);" readonly>
                </div>
            </div>
        </div>

        <div style="display: flex; justify-content: flex-end; gap: 15px; margin-top: 30px;">
            <button type="button" id="btn-modal-close" style="padding: 12px 24px; background: transparent; color: var(--text-muted); border: 1px solid var(--border-soft); border-radius: var(--radius-md); font-weight: bold; cursor: pointer;">Hủy</button>
            <button type="button" id="btn-modal-save" style="padding: 12px 24px; background: linear-gradient(135deg, var(--gold-dark), var(--brand-gold)); color: #000; border: none; border-radius: var(--radius-md); font-weight: bold; cursor: pointer;">Lưu thay đổi</button>
        </div>
    </div>
</div>
<!-- Modal Danh Sách Voucher -->
<div id="modal-vouchers" class="custom-modal-overlay">
    <div class="custom-modal-card" style="max-width: 500px;">
        <h3 style="font-size: 1.4rem; font-weight: 800; color: var(--brand-gold); margin: 0 0 5px 0;"><i class="fa-solid fa-gift"></i> Voucher Của Bạn</h3>
        <p style="font-size: 0.85rem; color: var(--text-muted); margin-bottom: 20px;">Áp dụng cho hạng: <strong style="color: var(--gold-light);">${not empty sessionScope.membershipRank ? sessionScope.membershipRank : 'Member'}</strong></p>

        <div style="max-height: 350px; overflow-y: auto; display: flex; flex-direction: column; gap: 15px; padding-right: 5px;">
            <c:choose>
                <c:when test="${not empty availableVouchers}">
                    <c:forEach items="${availableVouchers}" var="voucher">
                        <div class="voucher-item" style="border: 1px dashed var(--accent-orange); background: rgba(255, 202, 40, 0.05); padding: 15px; border-radius: var(--radius-md); display: flex; justify-content: space-between; align-items: center;">
                            <div>
                                <div style="font-weight: 900; color: var(--accent-orange); font-size: 1.1rem; letter-spacing: 1px;">${voucher.voucherCode}</div>
                                <div style="font-size: 0.8rem; color: var(--text-main); margin-top: 4px;">Giảm ${voucher.discountPercent}% (Tối đa <fmt:formatNumber value="${voucher.maxDiscountAmount}" type="number" groupingUsed="true"/>đ)</div>
                                <div style="font-size: 0.75rem; color: var(--text-muted); margin-top: 2px;">Áp dụng cho hạng: <strong style="color: var(--gold-light);">${voucher.requiredRank} trở lên</strong></div>
                            </div>
                            <button type="button" class="btn-use-voucher" data-code="${voucher.voucherCode}" data-percent="${voucher.discountPercent}" data-max="${voucher.maxDiscountAmount}" style="background: linear-gradient(135deg, var(--gold-dark), var(--brand-gold)); color: #000; border: none; padding: 8px 16px; border-radius: 20px; font-weight: bold; cursor: pointer;">Sử dụng</button>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div style="text-align: center; color: var(--text-muted); font-style: italic; padding: 20px;">
                        Hiện tại không có mã ưu đãi nào khả dụng cho hạng khách của bạn.
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <button type="button" id="btn-close-vouchers" style="width: 100%; margin-top: 20px; padding: 12px; background: transparent; color: var(--text-muted); border: 1px solid var(--border-soft); border-radius: var(--radius-md); font-weight: bold; cursor: pointer;">Đóng</button>
    </div>
</div>

<!-- Modal Điều khoản & Chính sách -->
<div id="modal-terms" class="custom-modal-overlay">
    <div class="custom-modal-card" style="text-align: center;">
        <h3 style="font-size: 1.4rem; font-weight: 800; color: var(--brand-gold); margin-bottom: 15px;">ĐIỀU KHOẢN & CHÍNH SÁCH</h3>
        <div style="font-size: 1.1rem; color: #fff; line-height: 1.8; margin-bottom: 20px; background: #1a1a1a; padding: 20px; border-radius: var(--radius-md); border: 1px solid var(--border-soft);">
            Bạn sẽ đến lúc <strong>14:00</strong> ngày <span id="term-display-checkin" style="color: var(--accent-green);"></span><br>
            và rời đi vào lúc <strong>12:00</strong> ngày <span id="term-display-checkout" style="color: var(--accent-orange);"></span>.
        </div>

        <button type="button" id="btn-close-terms" style="display: none; width: 100%; padding: 12px; background: linear-gradient(135deg, #444, #222); color: #fff; border: 1px solid var(--border-soft); border-radius: var(--radius-md); font-weight: bold; cursor: pointer;">Đã Hiểu & Đóng</button>
        <div id="terms-countdown" style="font-size: 0.9rem; color: var(--text-muted);">Nút đóng sẽ hiện lên sau <span id="countdown-sec" style="color: var(--gold-light); font-weight: bold;">5</span> giây...</div>
    </div>
</div>
<script>
    const LOGGED_IN_ACCOUNT_NAME = "${userSessionName}".trim();

    // =========================================================================
    // 1. KHAI BÁO CÁC BIẾN & TRUY XUẤT PHẦN TỬ DOM THÔNG QUA ID
    // =========================================================================
    const btnEdit = document.getElementById('btn-edit');
    const modalEdit = document.getElementById('modal-edit');
    const modalCard = document.querySelector('.custom-modal-card');
    const btnModalClose = document.getElementById('btn-modal-close');
    const btnModalSave = document.getElementById('btn-modal-save');

    const displayName = document.getElementById('display-name');
    const displayEmail = document.getElementById('display-email');
    const displayPhone = document.getElementById('display-phone');

    const inputSurname = document.getElementById('input-surname');
    const inputName = document.getElementById('input-name');
    const inputCccd = document.getElementById('input-cccd');
    const inputEmail = document.getElementById('input-email');
    const inputPhone = document.getElementById('input-phone');
    const chkBookForOther = document.getElementById('chk-book-for-other');

    // --- BỔ SUNG LƯU Ý KHI BẤM VÀO Ô CCCD ---
    let hasAcknowledgedCccd = false; // Biến đánh dấu khách đã đọc cảnh báo chưa

    // Reset lại cờ cảnh báo nếu khách đổi ý (tích/bỏ tích ô đặt hộ) trong lúc bảng đang mở
    chkBookForOther.addEventListener('change', function() {
        hasAcknowledgedCccd = false;
    });

    inputCccd.addEventListener('click', function(e) {
        // LUÔN LUÔN hiện cảnh báo 1 lần duy nhất trước khi nhập, bất kể là đặt cho ai
        if (!hasAcknowledgedCccd) {
            inputCccd.blur(); // Đẩy focus ra ngoài ngay lập tức để không cho gõ phím

            // Kiểm tra khách đang tích hay không tích để ra câu chữ phù hợp
            const isBookingForOther = chkBookForOther.checked;
            const popupTitle = isBookingForOther ? "THÔNG BÁO ĐẶT HỘ" : "THÔNG BÁO XÁC NHẬN";
            const popupMessage = isBookingForOther
                ? "Bạn đang đặt hộ phòng, vui lòng nhập <strong>CHÍNH XÁC số Căn cước công dân / Passport</strong> của <strong>người bạn muốn đặt hộ</strong>!"
                : "Hệ thống ghi nhận bạn đang đặt phòng cho chính mình.<br>Vui lòng nhập <strong>CHÍNH XÁC số Căn cước công dân / Passport của bạn</strong>!";

            // Tạo bảng thông báo nổi
            const warningOverlay = document.createElement('div');
            warningOverlay.className = 'custom-modal-overlay show';
            warningOverlay.style.zIndex = '10001'; // Nổi đè lên cả Modal Edit
            warningOverlay.innerHTML = `
                <div class="custom-modal-card" style="text-align: center; max-width: 450px; border: 1px solid var(--accent-orange); box-shadow: 0 0 20px rgba(255, 160, 0, 0.2);">
                    <h3 style="color: var(--accent-orange); margin-bottom: 15px;">
                        <i class="fa-solid fa-triangle-exclamation"></i> ` + popupTitle + `
                    </h3>
                    <p style="font-size: 0.95rem; color: #fff; line-height: 1.6; margin-bottom: 15px; text-align: left;">
                        ` + popupMessage + `<br><br>
                        <span style="color: var(--text-muted); font-size: 0.85rem;">
                            <i>Lý do:</i> Tuyệt đối không được sai số vì dữ liệu này <strong>rất quan trọng</strong> dùng để đối chiếu khi làm thủ tục check-in tại lễ tân.
                        </span>
                    </p>
                    <div id="cccd-countdown-text" style="font-size: 0.9rem; color: var(--gold-light);">
                        Bạn có thể tiếp tục sau <span id="cccd-timer" style="font-weight: 900; font-size: 1.2rem; color: var(--accent-orange);">5</span> giây...
                    </div>
                    <div style="display: flex; justify-content: center; margin-top: 25px;">
                        <button id="btn-understand-cccd" style="display: none; padding: 10px 20px; background: linear-gradient(135deg, var(--gold-dark), var(--brand-gold)); color: #000; border: none; border-radius: var(--radius-md); font-weight: bold; cursor: pointer; transition: 0.3s; width: 100%;">Tôi đã hiểu & Bắt đầu nhập</button>
                    </div>
                </div>
            `;

            document.body.appendChild(warningOverlay);

            let timeLeft = 5;
            const timerSpan = warningOverlay.querySelector('#cccd-timer');
            const countdownText = warningOverlay.querySelector('#cccd-countdown-text');
            const btnUnderstand = warningOverlay.querySelector('#btn-understand-cccd');

            // Đếm ngược 5 giây
            const countdownInterval = setInterval(() => {
                timeLeft--;
                timerSpan.innerText = timeLeft;
                if (timeLeft <= 0) {
                    clearInterval(countdownInterval);
                    countdownText.style.display = 'none';
                    btnUnderstand.style.display = 'block'; // Hiện nút cho phép nhập
                }
            }, 1000);

            // Xử lý khi khách bấm nút "Tôi đã hiểu"
            btnUnderstand.addEventListener('click', () => {
                document.body.removeChild(warningOverlay);
                hasAcknowledgedCccd = true; // Đánh dấu đã xem xong để click thoải mái
                setTimeout(() => inputCccd.focus(), 100); // Trả lại con trỏ chuột để gõ
            });
        }
    });
    // --- KẾT THÚC BỔ SUNG ---

    // Chỉ cho phép nhập chữ số và tối đa 12 ký tự
    inputCccd.addEventListener('input', function() {
        this.value = this.value.replace(/\D/g, '').slice(0, 12);
    });

    const hiddenName = document.getElementById('hidden-customer-name');
    const hiddenEmail = document.getElementById('hidden-customer-email');
    const hiddenPhone = document.getElementById('hidden-customer-phone');
    const hiddenCccd = document.getElementById('hidden-customer-cccd');
    const hiddenBookForOther = document.getElementById('hidden-book-for-other');
    const hiddenSpecialReq = document.getElementById('hidden-special-req');
    const hiddenCustomerNote = document.getElementById('hidden-customer-note');

    const btnAutoNote = document.getElementById('btn-auto-note');
    const inputCustomNote = document.getElementById('input-custom-note');

    const strikePriceDisplay = document.getElementById('strike-price-display');
    const finalPriceDisplay = document.getElementById('final-price-display');
    const hiddenFinalPrice = document.getElementById('hidden-final-price');
    const hiddenVoucherCode = document.getElementById('hidden-voucher-code');

    const btnShowVouchers = document.getElementById('btn-show-vouchers');
    const modalVouchers = document.getElementById('modal-vouchers');
    const btnCloseVouchers = document.getElementById('btn-close-vouchers');
    const inputVoucherCode = document.getElementById('input-voucher-code');
    const btnApplyVoucher = document.getElementById('btn-apply-voucher');
    const btnRemoveVoucher = document.getElementById('btn-remove-voucher');
    const voucherDescDisplay = document.getElementById('voucher-desc-display');
    const useVoucherBtns = document.querySelectorAll('.btn-use-voucher');

    // Các biến cho tính năng Không dùng Voucher
    const chkNoVoucher = document.getElementById('chk-no-voucher');
    const voucherLockOverlay = document.getElementById('voucher-lock-overlay');
    const btnChangeMind = document.getElementById('btn-change-mind');

    let currentVoucherPercent = 0;
    let currentVoucherMax = 0;

    const formSubmit = document.getElementById('form-booking-submit');

    const linkTerms = document.getElementById('link-terms');
    const modalTerms = document.getElementById('modal-terms');
    const btnCloseTerms = document.getElementById('btn-close-terms');
    const termsCountdown = document.getElementById('terms-countdown');
    const countdownSec = document.getElementById('countdown-sec');

    const originalPriceWithVAT = parseFloat("${formattedPriceWithVAT}");
    let hasReadTerms = false; // Cờ kiểm tra khách đã đọc điều khoản chưa

    // =========================================================================
    // 2. CHỨC NĂNG CHỈNH SỬA & ĐỒNG BỘ THÔNG TIN KHÁCH HÀNG (MODAL EDIT)
    // =========================================================================
    btnEdit.addEventListener('click', (e) => {
        e.stopPropagation();

        const hName = document.getElementById('hidden-customer-name');
        const hEmail = document.getElementById('hidden-customer-email');
        const hPhone = document.getElementById('hidden-customer-phone');
        const hCccd = document.getElementById('hidden-customer-cccd');
        const hBookOther = document.getElementById('hidden-book-for-other');

        const savedName = hName ? hName.value.trim() : '';
        if (savedName) {
            const nameParts = savedName.split(' ');
            if (nameParts.length >= 2) {
                inputSurname.value = nameParts[0];
                inputName.value = nameParts.slice(1).join(' ');
            } else {
                inputSurname.value = '';
                inputName.value = savedName;
            }
        } else {
            inputSurname.value = '';
            inputName.value = '';
        }

        inputEmail.value = hEmail ? hEmail.value.trim() : '';
        inputCccd.value = hCccd ? hCccd.value.trim() : '';

        if (hPhone) {
            inputPhone.value = hPhone.value.replace('+ 84 ', '').trim();
        }

        chkBookForOther.checked = hBookOther && hBookOther.value === "true";
        hasAcknowledgedCccd = false; // Reset lại cảnh báo CCCD mỗi lần mở bảng sửa
        modalEdit.classList.add('show');
    });

    // Hàm thực thi việc lưu sau khi khách hàng đã xác nhận chắc chắn
    function executeSave() {
        const newFullName = inputSurname.value.trim() + " " + inputName.value.trim();
        const finalPhone = "+ 84 " + inputPhone.value.trim();

        // SỬA LỖI: Tôn trọng quyết định tích checkbox của người dùng.
        // Chỉ tự động bật "Đặt hộ" nếu khách đổi tên khác với tên tài khoản,
        // và tuyệt đối không tự động tắt (false) nếu khách đã chủ động tích.
        if (newFullName.trim().toLowerCase() !== LOGGED_IN_ACCOUNT_NAME.toLowerCase()) {
            chkBookForOther.checked = true;
        }

        displayName.innerText = newFullName;
        displayEmail.innerText = inputEmail.value.trim();
        displayPhone.innerHTML = '<i class="fa-solid fa-phone" style="font-size: 0.75rem;"></i> ' + finalPhone;

        if (hiddenName) hiddenName.value = newFullName;
        if (hiddenEmail) hiddenEmail.value = inputEmail.value.trim();
        if (hiddenPhone) hiddenPhone.value = finalPhone;
        if (hiddenCccd) hiddenCccd.value = inputCccd.value.trim();
        if (hiddenBookForOther) hiddenBookForOther.value = chkBookForOther.checked ? "true" : "false";

        modalEdit.classList.remove('show');

        if (inputCustomNote.value.trim() !== "") {
            alert("⚠️ Thông tin và trạng thái Đặt hộ đã thay đổi.\nĐừng quên bấm lại nút 'Tạo Ghi Chú Tự Động' để đồng bộ nhé!");
        }
    }

    // Hàm gọi popup dằn mặt đếm ngược 5 giây
    function saveAndCloseModal() {
        const cccdVal = inputCccd.value.trim();
        // Regex kiểm tra: Đúng 9 số HOẶC Đúng 12 số
        const cccdRegex = /^(\d{9}|\d{12})$/;

        // 1. Kiểm tra bỏ trống thông tin
        if (!inputSurname.value.trim() || !inputName.value.trim() || !cccdVal || !inputEmail.value.trim() || !inputPhone.value.trim()) {
            alert("NÀY! Bạn chưa nhập đủ thông tin kìa!\nHãy kiểm tra lại Họ tên, CCCD, Email và Số điện thoại.");
            return;
        }

        // 2. Chốt chặn Regex cho CCCD / Passport (Chỉ chấp nhận đúng 9 hoặc 12 số)
        if (!cccdRegex.test(cccdVal)) {
            alert("❌ SỐ CCCD/PASSPORT KHÔNG HỢP LỆ!\n\nVui lòng nhập đúng:\n- 9 chữ số (đối với CMND cũ / Passport)\n- 12 chữ số (đối với Căn cước công dân mới)");
            inputCccd.focus();
            return;
        }

        // Tạo giao diện popup bằng Javascript cho tiện lợi, không cần qua HTML
        const confirmOverlay = document.createElement('div');
        confirmOverlay.className = 'custom-modal-overlay show';
        confirmOverlay.style.zIndex = '10000'; // Nằm đè lên tất cả modal khác
        confirmOverlay.innerHTML = `
            <div class="custom-modal-card" style="text-align: center; max-width: 450px;">
                <h3 style="color: var(--accent-orange); margin-bottom: 15px;">
                    <i class="fa-solid fa-triangle-exclamation"></i> BẠN CHẮC CHẮN CHƯA?
                </h3>
                <p style="font-size: 1rem; color: #fff; line-height: 1.6; margin-bottom: 15px;">
                    Bạn đã kiểm tra kỹ thông tin mình vừa nhập chưa?<br>
                    <span style="color: var(--text-muted); font-size: 0.9rem;">Vì nó <strong>rất rất quan trọng</strong> trong việc Check-in, vui lòng kiểm tra kỹ để tránh mất thời gian của chính bạn sau này.</span>
                </p>
                <div id="confirm-countdown-text" style="font-size: 0.9rem; color: var(--gold-light);">
                    Nút Xác Nhận sẽ hiện ra sau <span id="confirm-timer" style="font-weight: 900; font-size: 1.2rem;">5</span> giây...
                </div>
                <div style="display: flex; justify-content: center; gap: 15px; margin-top: 25px;">
                    <button id="btn-cancel-confirm" style="padding: 10px 20px; background: transparent; color: var(--text-muted); border: 1px solid var(--border-soft); border-radius: var(--radius-md); font-weight: bold; cursor: pointer; transition: 0.3s;">Hủy, để tôi xem lại</button>
                    <button id="btn-accept-confirm" style="display: none; padding: 10px 20px; background: linear-gradient(135deg, var(--gold-dark), var(--brand-gold)); color: #000; border: none; border-radius: var(--radius-md); font-weight: bold; cursor: pointer; transition: 0.3s;">Chắc chắn, Lưu ngay!</button>
                </div>
            </div>
        `;

        document.body.appendChild(confirmOverlay);

        let timeLeft = 5;
        const timerSpan = confirmOverlay.querySelector('#confirm-timer');
        const countdownText = confirmOverlay.querySelector('#confirm-countdown-text');
        const btnAccept = confirmOverlay.querySelector('#btn-accept-confirm');
        const btnCancel = confirmOverlay.querySelector('#btn-cancel-confirm');

        // Hàm đếm ngược
        const countdownInterval = setInterval(() => {
            timeLeft--;
            timerSpan.innerText = timeLeft;
            if (timeLeft <= 0) {
                clearInterval(countdownInterval);
                countdownText.style.display = 'none';
                btnAccept.style.display = 'block'; // Hiện nút Xác nhận sau 5s
            }
        }, 1000);

        // Bấm Hủy -> Tắt đếm ngược và xóa bảng thông báo đi
        btnCancel.addEventListener('click', () => {
            clearInterval(countdownInterval);
            document.body.removeChild(confirmOverlay);
        });

        // Bấm Xác nhận -> Xóa bảng thông báo và chạy logic lưu thông tin gốc
        btnAccept.addEventListener('click', () => {
            document.body.removeChild(confirmOverlay);
            executeSave();
        });
    }

    btnModalSave.addEventListener('click', saveAndCloseModal);
    btnModalClose.addEventListener('click', () => modalEdit.classList.remove('show'));

    modalEdit.addEventListener('click', (e) => {
        if (modalCard && !modalCard.contains(e.target) && e.target === modalEdit) {
            saveAndCloseModal();
        }
    });

    // =========================================================================
    // 3. CHỨC NĂNG TÍNH TOÁN VOUCHER KHUYẾN MÃI (DỰA TRÊN % VÀ MAX GIẢM)
    // =========================================================================
    // Mở / Đóng Modal Voucher
    btnShowVouchers.addEventListener('click', () => modalVouchers.classList.add('show'));
    btnCloseVouchers.addEventListener('click', () => modalVouchers.classList.remove('show'));

    // Khi khách bấm nút "Sử dụng" một mã bất kỳ trong danh sách
    useVoucherBtns.forEach(btn => {
        btn.addEventListener('click', function() {
            const code = this.getAttribute('data-code');
            currentVoucherPercent = parseFloat(this.getAttribute('data-percent'));
            currentVoucherMax = parseFloat(this.getAttribute('data-max'));

            inputVoucherCode.value = code;
            voucherDescDisplay.innerText = `Sẵn sàng áp dụng mã ${code} (Giảm ${currentVoucherPercent}%)`;
            voucherDescDisplay.style.color = "var(--text-muted)";
            modalVouchers.classList.remove('show');
        });
    });

    // Khi khách bấm nút "Áp dụng" ở trang chính để trừ tiền
    // Khi khách bấm nút "Áp dụng" ở trang chính để trừ tiền
    btnApplyVoucher.addEventListener('click', function() {
        const code = inputVoucherCode.value.trim();
        if (!code) {
            alert("Vui lòng mở danh sách và Chọn một mã voucher!");
            return;
        }

        // Tính toán số tiền được giảm
        let discountAmount = (originalPriceWithVAT * currentVoucherPercent) / 100;

        // Kiểm tra trần tối đa [MaxDiscountAmount]
        if (discountAmount > currentVoucherMax) {
            discountAmount = currentVoucherMax;
        }

        const discountedPrice = Math.round(originalPriceWithVAT - discountAmount);

        // Hiển thị UI giá tiền mới
        strikePriceDisplay.innerText = originalPriceWithVAT.toLocaleString('vi-VN') + " đ";
        strikePriceDisplay.style.display = "block";
        finalPriceDisplay.innerText = discountedPrice.toLocaleString('vi-VN') + " đ";

        voucherDescDisplay.innerText = `Đã áp dụng mã ${code} (Giảm ${discountAmount.toLocaleString('vi-VN')} đ)`;
        voucherDescDisplay.style.color = "var(--accent-green)";

        // Lưu giá trị vào các input ẩn để submit xuống Backend
        hiddenFinalPrice.value = discountedPrice;
        hiddenVoucherCode.value = code;

        // Thay đổi nút Áp Dụng thành Hủy
        btnApplyVoucher.style.display = 'none';
        btnRemoveVoucher.style.display = 'inline-block';

        // KHÓA NÚT CHỌN VOUCHER (VÔ HIỆU HÓA)
        btnShowVouchers.style.opacity = '0.4';
        btnShowVouchers.style.pointerEvents = 'none';
        btnShowVouchers.onclick = function(e) {
            e.preventDefault();
            alert("Bạn đang sử dụng một mã voucher rồi. Nếu muốn thay đổi voucher, bạn cần phải bấm 'Hủy mã đang dùng' trước!");
        };
    });

    // Khi khách bấm nút "Hủy mã"
    // Khi khách bấm nút "Hủy mã"
    btnRemoveVoucher.addEventListener('click', function() {
        // Khôi phục biến
        currentVoucherPercent = 0;
        currentVoucherMax = 0;
        inputVoucherCode.value = '';

        // Trả lại UI trạng thái cũ
        voucherDescDisplay.innerText = "Chưa áp dụng mã nào";
        voucherDescDisplay.style.color = "var(--text-muted)";
        strikePriceDisplay.style.display = "none";
        finalPriceDisplay.innerText = originalPriceWithVAT.toLocaleString('vi-VN') + " đ";

        // Trả lại dữ liệu gốc cho hidden input
        hiddenFinalPrice.value = originalPriceWithVAT;
        hiddenVoucherCode.value = "null"; // Chuyển thành chữ null theo yêu cầu

        // Chuyển nút
        btnApplyVoucher.style.display = 'inline-block';
        btnRemoveVoucher.style.display = 'none';

        // MỞ KHÓA LẠI NÚT CHỌN VOUCHER (RESET)
        btnShowVouchers.style.opacity = '1';
        btnShowVouchers.style.pointerEvents = 'auto';
        btnShowVouchers.onclick = null; // Gỡ alert chửi
    });

    // BỔ SUNG: Logic khi tích chọn "Không dùng voucher"
    chkNoVoucher.addEventListener('change', function() {
        if (this.checked) {
            // Hiển thị màn khóa bằng Flexbox
            voucherLockOverlay.style.display = 'flex';

            // Nếu khách đang áp dụng mã mà bấm "Không dùng", tự động hủy mã đó đi để reset giá
            if (hiddenVoucherCode.value.trim() !== '') {
                btnRemoveVoucher.click();
            }
        } else {
            // Tắt màn khóa
            voucherLockOverlay.style.display = 'none';
        }
    });

    // BỔ SUNG: Nút "Đổi ý" bên trong màn khóa
    btnChangeMind.addEventListener('click', function() {
        chkNoVoucher.checked = false; // Bỏ tích checkbox
        chkNoVoucher.dispatchEvent(new Event('change')); // Kích hoạt sự kiện change ở trên để mở khóa
    });

    // =========================================================================
    // 4. HÀM TRUNG TÂM: RÁP CHUỖI GHI CHÚ CHUẨN XÁC 100% (DÙNG ĐỂ TẠO & SO SÁNH)
    // =========================================================================
    function generateNoteString() {
        const parts = [];

        // 1. Trạng thái đặt hộ
        const isBookForOther = document.getElementById('hidden-book-for-other');
        if (isBookForOther && isBookForOther.value === "true") {
            parts.push("Đặt hộ");
        } else {
            parts.push("Không đặt hộ");
        }

        // 2. Họ & Tên
        const hName = document.getElementById('hidden-customer-name').value.trim();
        if (hName) {
            const arr = hName.split(' ');
            if (arr.length >= 2) {
                parts.push(arr.slice(1).join(' ')); // Tên Đệm & Tên
                parts.push(arr[0]);                 // Họ
            } else {
                parts.push(hName);
            }
        }

        // 3. CCCD
        const hCccd = document.getElementById('hidden-customer-cccd').value.trim();
        if (hCccd) parts.push(hCccd);

        // 4. Email
        const hEmail = document.getElementById('hidden-customer-email').value.trim();
        if (hEmail) parts.push(hEmail);

        // 5. Số điện thoại
        const hPhone = document.getElementById('hidden-customer-phone').value.replace('+ 84', '').trim();
        if (hPhone) parts.push(hPhone);

        // 6. LẤY TRỰC TIẾP NGÀY THÁNG TỪ GIAO DIỆN (Lợi dụng dữ liệu có sẵn)
        // 6. LẤY TRỰC TIẾP TỪ INPUT ẨN CỦA HỆ THỐNG (Bảo đảm chính xác 100%, không lo lỗi giao diện)
        const dateRangeInput = document.getElementById('hidden-date-range');
        if (dateRangeInput && dateRangeInput.value) {
            const dates = dateRangeInput.value.split('to');
            const checkinDate = dates[0] ? dates[0].trim() : '';
            const checkoutDate = dates[1] ? dates[1].trim() : '';

            if (checkinDate && checkoutDate) {
                parts.push("14h " + checkinDate + " - 12h " + checkoutDate);
            }
        }

        // 7. Yêu cầu đặc biệt (Các checkbox Option)
        const checkedReqs = Array.from(document.querySelectorAll('input[name="specialReq"]:checked'))
            .map(cb => cb.value.trim());
        if (checkedReqs.length > 0) {
            parts.push(...checkedReqs);
        }

        // Trả về chuỗi được nối chuẩn chỉnh bằng dấu chấm phẩy
        return parts.filter(p => p !== "").join(';');
    }

    // =========================================================================
    // 5. NÚT CLICK TẠO GHI CHÚ TỰ ĐỘNG (ĐÃ THÊM BẮT LỖI)
    // =========================================================================
    btnAutoNote.addEventListener('click', function () {
        // 1. Lấy dữ liệu hiện tại từ các trường ẩn để kiểm tra
        const checkName = document.getElementById('hidden-customer-name').value.trim();
        const checkCccd = document.getElementById('hidden-customer-cccd').value.trim();
        const checkEmail = document.getElementById('hidden-customer-email').value.trim();
        const checkPhone = document.getElementById('hidden-customer-phone').value.replace('+ 84', '').trim();

        // 2. Bắt lỗi: Nếu thiếu 1 trong các thông tin quan trọng thì chặn lại
        if (!checkName || !checkCccd || !checkEmail || !checkPhone) {
            alert("⚠️ THIẾU THÔNG TIN BẮT BUỘC!\n\nBạn chưa điền đầy đủ thông tin cá nhân (đặc biệt là CCCD/Passport).\n👉 Vui lòng kéo lên phần 'Thông tin người đặt', bấm nút 'Sửa' để bổ sung đầy đủ trước khi tạo ghi chú nhé!");

            // Hiệu ứng UX: Nhấp nháy nút Sửa màu đỏ để điều hướng ánh mắt của khách
            const btnEditHighlight = document.getElementById('btn-edit');
            btnEditHighlight.style.transition = "all 0.3s";
            btnEditHighlight.style.boxShadow = "0 0 15px #ff5252";
            btnEditHighlight.style.borderColor = "#ff5252";
            btnEditHighlight.style.color = "#ff5252";

            setTimeout(() => {
                btnEditHighlight.style.boxShadow = "none";
                btnEditHighlight.style.borderColor = "var(--brand-gold)";
                btnEditHighlight.style.color = "var(--brand-gold)";
            }, 3000); // Tắt nhấp nháy sau 3 giây

            return; // Dừng lại, không chạy đoạn code tạo ghi chú bên dưới nữa
        }

        // 3. Nếu đã đủ thông tin thì tiến hành tạo ghi chú bình thường
        const finalAutoNote = generateNoteString(); // Gọi hàm trung tâm ở trên

        if (inputCustomNote) inputCustomNote.value = finalAutoNote;
        if (hiddenCustomerNote) hiddenCustomerNote.value = finalAutoNote;

        // Hiệu ứng UX thành công
        btnAutoNote.innerText = "Đã Tạo Ghi Chú Thành Công ✓";
        btnAutoNote.style.background = "var(--accent-green)";
        btnAutoNote.style.color = "#000";
        setTimeout(() => {
            btnAutoNote.innerHTML = "<i class='fa-solid fa-wand-magic-sparkles'></i> Tạo Ghi Chú Tự Động";
            btnAutoNote.style.background = "transparent";
            btnAutoNote.style.color = "var(--accent-green)";
            btnAutoNote.style.borderColor = "var(--accent-green)";
        }, 3000);
    });

    // =========================================================================
    // 6. CHỨC NĂNG MODAL ĐIỀU KHOẢN VÀ THỜI GIAN ĐẾM NGƯỢC
    // =========================================================================
    linkTerms.addEventListener('click', function() {
        // Đổ ngày tháng vào modal terms lấy trực tiếp từ giao diện
        document.getElementById('term-display-checkin').innerText = document.getElementById('val-checkin').innerText.trim() || "N/A";
        document.getElementById('term-display-checkout').innerText = document.getElementById('val-checkout').innerText.trim() || "N/A";;

        btnCloseTerms.style.display = 'none';
        termsCountdown.style.display = 'block';
        modalTerms.classList.add('show');

        let timeLeft = 5;
        countdownSec.innerText = timeLeft;

        const timer = setInterval(() => {
            timeLeft--;
            countdownSec.innerText = timeLeft;
            if (timeLeft <= 0) {
                clearInterval(timer);
                termsCountdown.style.display = 'none';
                btnCloseTerms.style.display = 'block';
            }
        }, 1000);
    });

    btnCloseTerms.addEventListener('click', () => {
        hasReadTerms = true; // Xác nhận khách đã đọc xong điều khoản hợp lệ
        modalTerms.classList.remove('show');
    });;

    // =========================================================================
    // 7. RÀNG BUỘC CHỐT CHẶN: ÉP PHẢI ĐỒNG BỘ MỌI THAY ĐỔI TRƯỚC KHI SUBMIT
    // =========================================================================

    // Ràng buộc khi KHÁCH TÍCH VÀO CHECKBOX ĐIỀU KHOẢN
    const chkTerms = document.getElementById('chk-terms');
    if (chkTerms) {
        chkTerms.addEventListener('change', function() {
            if (this.checked) {
                if (!hasReadTerms) {
                    this.checked = false; // Hủy dấu tích chọn
                    alert("⚠️ Bạn phải bấm trực tiếp vào liên kết 'Điều khoản & Chính sách' và đọc hết nội dung trước khi tích chọn đồng ý!");
                    linkTerms.click(); // Tự động mở modal điều khoản lên ép khách xem
                    return;
                }
                const currentNote = document.getElementById('input-custom-note').value.trim();
                const expectedNote = generateNoteString(); // Lấy Note mong muốn của thời điểm hiện tại

                // Lỗi 1: Chưa hề bấm tạo Note
                if (!currentNote) {
                    this.checked = false;
                    alert("❌ LỖI: Bạn chưa bấm nút 'Tạo Ghi Chú Tự Động'!");
                    return;
                }

                // Lỗi 2: Khách thay đổi thông tin cá nhân HOẶC tích thêm/bỏ tích các Option yêu cầu
                if (currentNote !== expectedNote) {
                    this.checked = false;
                    alert("PHÁT HIỆN THAY ĐỔI YÊU CẦU HOẶC THÔNG TIN:\n\nBạn đã thay đổi Thông tin cá nhân HOẶC tích thêm/bỏ tích các 'Yêu cầu đặc biệt' sau khi tạo Ghi chú!\n\n👉 YÊU CẦU: Hãy bấm lại nút 'Tạo Ghi Chú Tự Động' để hệ thống đồng bộ lại toàn bộ dữ liệu chính xác!");
                }
            }
        });
    }

    // Ràng buộc LẦN CUỐI khi KHÁCH BẤM SUBMIT THANH TOÁN
    formSubmit.addEventListener('submit', function(e) {
        const chkTerms = document.getElementById('chk-terms');

        // ĐÃ SỬA: CHỈ CHẶN KHI KHÁCH CHƯA NHẬP MÃ VÀ CŨNG CHƯA TÍCH VÀO "KHÔNG DÙNG VOUCHER"
        const appliedVoucherCode = hiddenVoucherCode.value.trim();
        const isNoVoucherChecked = document.getElementById('chk-no-voucher').checked;

        if (!appliedVoucherCode && !isNoVoucherChecked) {
            e.preventDefault(); // Chặn việc gửi form thanh toán
            alert("🎟️ THÔNG BÁO: Bạn chưa chọn Voucher!\n\n- Nếu muốn dùng ưu đãi: Vui lòng bấm 'Chọn Voucher' -> 'Sử dụng' -> 'Áp dụng'.\n- Nếu KHÔNG muốn dùng: Vui lòng tích vào ô 'Tôi không có / Không muốn dùng mã ưu đãi' phía trên để đi tiếp.");

            // --- COMBO HIỆU ỨNG UX CHỈ DẪN (DYNAMIC EFFECTS) ---
            const voucherBox = document.querySelector('.modern-voucher');

            if (voucherBox) {
                // 1. Tự động cuộn trang mượt mà đến đúng khung voucher (phòng khi khách đang lướt ở dưới)
                voucherBox.scrollIntoView({ behavior: 'smooth', block: 'center' });

                // 2. Hiệu ứng rung lắc (Shake) khung để cảnh báo
                voucherBox.animate([
                    { transform: 'translateX(0)' },
                    { transform: 'translateX(-10px)' },
                    { transform: 'translateX(10px)' },
                    { transform: 'translateX(-10px)' },
                    { transform: 'translateX(10px)' },
                    { transform: 'translateX(0)' }
                ], { duration: 400, easing: 'ease-in-out' });

                // 3. Hiệu ứng nhấp nháy phát sáng (Pulse Glow) liên tục 5 chu kỳ
                // (Thêm fallback màu #ff6b00 phòng trường hợp mất biến --accent-orange)
                voucherBox.animate([
                    { boxShadow: '0 0 0px transparent', borderColor: '#4a3b1e' },
                    { boxShadow: '0 0 25px var(--accent-orange, #ff6b00)', borderColor: 'var(--accent-orange, #ff6b00)' },
                    { boxShadow: '0 0 0px transparent', borderColor: '#4a3b1e' }
                ], { duration: 800, iterations: 5 });

                // 4. Nhấn mạnh CỤ THỂ vào NÚT BẤM bên trong khung voucher (Chỉ dẫn chỗ cần nhấn)
                // (Nó sẽ tìm tất cả thẻ button bên trong voucherBox để nhấp nháy phóng to)
                const actionButtons = voucherBox.querySelectorAll('button');
                actionButtons.forEach(btn => {
                    btn.animate([
                        { transform: 'scale(1)', backgroundColor: 'transparent' },
                        { transform: 'scale(1.15)', backgroundColor: 'var(--accent-orange, #ff6b00)', color: '#fff' },
                        { transform: 'scale(1)', backgroundColor: 'transparent' }
                    ], { duration: 600, iterations: 6 });
                });
            }
            // --- KẾT THÚC COMBO HIỆU ỨNG ---

            return; // Dừng hàm tại đây, bắt khách phải làm theo
        }

        // Thay thế câu điều kiện kiểm tra chkTerms cũ bằng đoạn này:
        if (!chkTerms.checked || !hasReadTerms) {
            e.preventDefault();
            alert("⚠️ Bạn phải đọc và đồng ý với Điều khoản & Chính sách trước khi tiến hành thanh toán!");
            if (!hasReadTerms) linkTerms.click();
            return;
        }

        const currentNote = inputCustomNote.value.trim();
        const expectedNote = generateNoteString();

        if (!currentNote) {
            e.preventDefault();
            alert("❌ Vui lòng nhấn nút 'Tạo Ghi Chú Tự Động' trước khi xác nhận thanh toán.");
            return;
        }

        // So sánh chuỗi chốt hạ
        if (currentNote !== expectedNote) {
            e.preventDefault();
            chkTerms.checked = false; // Thu hồi tick điều khoản luôn
            alert("LỖI NGHIÊM TRỌNG: Dữ liệu ghi chú hiện tại không khớp với các lựa chọn của bạn. Vui lòng nhấn lại nút 'Tạo Ghi Chú Tự Động'!");
            return;
        }

        // Cập nhật các hidden input lần cuối gửi về Controller
        const checkedReqs = Array.from(document.querySelectorAll('input[name="specialReq"]:checked'))
            .map(cb => cb.value)
            .join('; ');
        hiddenSpecialReq.value = checkedReqs;


        hiddenCustomerNote.value = currentNote;
    });
</script>
<footer>
    <jsp:include page="footer.jsp" />
</footer>
</body>
</html>