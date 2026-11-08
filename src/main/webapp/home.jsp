<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    // Kiểm tra nếu trong Session chưa có đối tượng user đăng nhập
    if (session.getAttribute("currentUser") == null && session.getAttribute("user") == null) {
        session.setAttribute("status", "Guest");
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Khách sạn Verdelle - Luxury Black & Gold</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400..900;1,400..900&family=Plus+Jakarta+Sans:wght@300;400;600;700&display=swap" rel="stylesheet">

    <style>
        /* ==========================================================================
           CSS TRẦN THUẦN - BLACK & GOLD PREMIUM STYLE (THAY THẾ TAILWIND)
           ========================================================================== */

        /* Cấu hình cơ bản */
        html, body {
            margin: 0;
            padding: 0;
            background-color: #0d0d0d; /* Đen tuyền hoàng gia */
            color: #ffffff;
            font-family: 'Plus Jakarta Sans', sans-serif;
            scroll-behavior: smooth;
        }

        /* Khung bao bọc nội dung giới hạn độ rộng */
        .container-inner {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
            box-sizing: border-box;
        }

        /* --- 1. Header & Video Tràn Màn Hình --- */
        header.hero-wrapper {
            position: relative;
            height: 100vh;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            overflow: hidden;
        }

        .video-bg {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            z-index: 0;
        }

        .video-overlay {
            position: absolute;
            inset: 0;
            background: rgba(0, 0, 0, 0.55); /* Làm tối nền để nổi bật chữ */
            z-index: 10;
        }

        .header-nav-container {
            position: relative;
            z-index: 50;
        }

        .hero-center-content {
            position: relative;
            z-index: 20;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            flex-grow: 1;
            padding: 0 20px;
            margin-bottom: 48px;
            width: 100%;
            box-sizing: border-box;
        }

        /* Tiêu đề khẩu hiệu Gradient Gold */
        .premium-slogan {
            font-family: 'Playfair Display', serif;
            font-style: italic;
            color: #ffffff;
            font-size: 3.5rem;
            text-center: center;
            max-width: 1000px;
            margin: 0 0 48px 0;
            text-align: center;
            line-height: 1.25;
            background: linear-gradient(90deg, #ffe066 0%, #d4af37 50%, #aa7c11 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            filter: drop-shadow(0px 4px 10px rgba(0,0,0,0.7));
        }

        /* --- 2. Thanh Tìm Kiếm Đặt Phòng (Booking Bar) --- */
        /* --- SỬA LẠI GRID CHO THANH ĐẶT PHÒNG KHÔNG BỊ DƯ KHOẢNG TRỐNG --- */
        .booking-form-grid {
            width: 100%;
            max-width: 1100px;
            background: #161616; /* Nền xám đen mịn */
            border: 1px solid rgba(212, 175, 55, 0.3);
            border-radius: 4px;
            display: grid;
            /* Cấu hình lại số cột: các ô nhập ngày chiếm nhiều đất hơn, các ô select thu gọn vừa đủ */
            grid-template-columns: repeat(12, 1fr);
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.8);
            overflow: hidden;
        }

        /* Định nghĩa lại số cột chiếm (Span) chính xác để tổng bằng 12 */
        .cell-checkin {
            grid-column: span 3;
        }
        .cell-checkout {
            grid-column: span 3;
        }
        .cell-rooms {
            grid-column: span 1;
            flex-direction: column;
            align-items: flex-start;
            justify-content: center;
        }
        .cell-adults {
            grid-column: span 1;
            flex-direction: column;
            align-items: flex-start;
            justify-content: center;
        }
        .cell-children {
            grid-column: span 2; /* Tăng nhẹ để chứa đủ chữ "Trẻ em (0-11 tuổi)" không bị xuống dòng lỗi */
            flex-direction: column;
            align-items: flex-start;
            justify-content: center;
        }

        /* NÚT KIỂM TRA PHÒNG TRỐNG: Chiếm trọn 2 cột cuối cùng, khít hoàn toàn viền phải */
        .btn-submit-booking {
            grid-column: span 2;
            background: transparent;
            color: #d4af37;
            border: none;
            border-left: 1px solid rgba(212, 175, 55, 0.3);
            font-weight: 700;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 1px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            line-height: 1.4;
            padding: 0 15px;
            width: 100%;
            box-sizing: border-box;
        }

        .btn-submit-booking:hover {
            background: linear-gradient(90deg, #aa7c11, #d4af37);
            color: #000000;
        }

        /* Giữ nguyên cấu trúc đệm chung của các ô */
        .form-cell {
            padding: 16px;
            display: flex;
            align-items: center;
            gap: 12px;
            border-right: 1px solid rgba(212, 175, 55, 0.15);
            min-width: 0;
            box-sizing: border-box;
        }

        .cell-label {
            display: block;
            text-transform: uppercase;
            font-size: 10px;
            font-weight: 700;
            letter-spacing: 1px;
            color: #f3e5ab; /* Chữ vàng nhạt nhã nhặn */
        }

        .cell-input {
            text-transform: uppercase;
            font-size: 0.85rem;
            font-weight: 700;
            color: #ffffff;
            margin-top: 2px;
            background: transparent;
            border: none;
            outline: none;
            width: 100%;
            cursor: pointer;
        }
        .cell-input::placeholder { color: #666; }

        .cell-select {
            width: 100%;
            background: transparent;
            text-transform: uppercase;
            font-size: 0.85rem;
            font-weight: 700;
            color: #ffffff;
            border: none;
            outline: none;
            cursor: pointer;
            margin-top: 2px;
            appearance: none;
            -webkit-appearance: none;
            -moz-appearance: none;
        }
        .cell-select option {
            background-color: #161616;
            color: #fff;
        }

        /* Nút kiểm tra phòng trống dạng hoàng gia */
        .btn-submit-booking {
            grid-column: span 1.5;
            background: transparent;
            color: #d4af37;
            border-left: 1px solid rgba(212, 175, 55, 0.3);
            font-weight: 700;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 1px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            line-height: 1.4;
            padding: 0 10px;
        }

        .btn-submit-booking:hover {
            background: linear-gradient(90deg, #aa7c11, #d4af37);
            color: #000000;
        }

        /* Liên kết phụ dưới thanh tìm kiếm */
        .meta-links {
            display: flex;
            align-items: center;
            gap: 16px;
            margin-top: 20px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .meta-links a {
            color: #cbd5e1;
            text-decoration: none;
            transition: color 0.3s;
        }
        .meta-links a:hover { color: #d4af37; text-decoration: underline; }
        .meta-links .divider { color: rgba(255, 255, 255, 0.3); }

        /* --- 3. Các Khối Nội Dung (Sections) --- */
        .section-padding {
            padding: 80px 0 60px 0;
            text-align: center;
        }

        .section-title {
            color: #d4af37;
            font-family: 'Playfair Display', serif;
            font-size: 2rem;
            font-weight: 400;
            letter-spacing: 4px;
            margin: 0 0 24px 0;
            text-transform: uppercase;
        }

        .section-desc {
            max-width: 700px;
            margin: 0 auto 30px auto;
            font-size: 0.95rem;
            color: #cbd5e1;
            line-height: 1.8;
        }

        .link-view-all {
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 3px;
            font-weight: 700;
            color: #ffffff;
            text-decoration: underline;
            transition: color 0.3s;
        }
        .link-view-all:hover { color: #d4af37; }

        /* Lưới trải nghiệm nổi bật */
        .experience-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 24px;
            margin-top: 48px;
        }

        .experience-card {
            position: relative;
            height: 400px;
            background-color: #161616;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
            padding: 24px;
            box-sizing: border-box;
            border: 1px solid rgba(212, 175, 55, 0.15);
            border-radius: 8px;
        }

        .card-bg-img {
            position: absolute;
            inset: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.6s ease;
            z-index: 0;
        }
        .experience-card:hover .card-bg-img {
            transform: scale(1.06);
        }

        .card-shadow-overlay {
            position: absolute;
            inset: 0;
            background: linear-gradient(180deg, rgba(0,0,0,0.1) 0%, rgba(0,0,0,0.85) 100%);
            z-index: 10;
        }

        .card-inner-text {
            position: relative;
            z-index: 20;
            text-align: center;
        }
        .card-inner-text h4 {
            font-family: 'Playfair Display', serif;
            font-style: italic;
            font-size: 1.25rem;
            color: #ffffff;
            margin: 0 0 10px 0;
            font-weight: 400;
        }
        .card-inner-text a {
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 2px;
            color: #d4af37;
            text-decoration: underline;
            opacity: 0.8;
            transition: opacity 0.3s;
        }
        .experience-card:hover .card-inner-text a { opacity: 1; }

        /* --- 4. Bộ Sưu Tập Ảnh (Gallery) --- */
        .bg-dark-section {
            background-color: #111111;
            border-top: 1px solid rgba(212, 175, 55, 0.1);
            border-bottom: 1px solid rgba(212, 175, 55, 0.1);
        }

        .filter-nav-bar {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 24px;
            margin-bottom: 40px;
        }

        .filter-btn {
            background: transparent;
            border: none;
            color: #a0aec0;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 2px;
            font-weight: 600;
            cursor: pointer;
            padding-bottom: 4px;
            border-bottom: 1px solid transparent;
            transition: all 0.3s ease;
            outline: none;
        }
        .filter-btn:hover { color: #ffffff; }
        .filter-btn.active {
            color: #d4af37;
            font-weight: 700;
            border-bottom: 2px solid #d4af37;
        }

        .gallery-photo-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 12px;
        }

        .gallery-item {
            height: 250px;
            background-color: #1a1a1a;
            overflow: hidden;
            border: 1px solid rgba(255, 255, 255, 0.05);
        }
        .gallery-item img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: filter 0.3s;
        }
        .gallery-item:hover img {
            filter: brightness(1.1);
        }

        /* --- 5. Ưu Đãi Đặc Biệt (Offers) --- */
        .offers-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 32px;
            margin-top: 48px;
            text-align: left;
        }

        .offer-img-box {
            height: 240px;
            overflow: hidden;
            margin-bottom: 16px;
            border-radius: 4px;
            border: 1px solid rgba(212, 175, 55, 0.1);
        }
        .offer-img-box img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s;
        }
        .offer-img-box:hover img { transform: scale(1.04); }

        .offer-title {
            font-size: 1.2rem;
            font-weight: 600;
            color: #ffffff;
            margin: 0 0 8px 0;
        }
        .offer-p {
            font-size: 0.88rem;
            color: #cbd5e1;
            line-height: 1.6;
            margin: 0 0 16px 0;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .btn-explore-offer {
            display: inline-block;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 2px;
            font-weight: 700;
            color: #d4af37;
            border: 1px solid #d4af37;
            padding: 10px 20px;
            text-decoration: none;
            transition: all 0.3s;
            border-radius: 2px;
        }
        .btn-explore-offer:hover {
            background: #d4af37;
            color: #000000;
            box-shadow: 0 4px 15px rgba(212, 175, 55, 0.3);
        }

        /* --- 6. Địa Chỉ & Bản Đồ --- */
        .location-section {
            max-width: 900px;
            margin: 0 auto;
            padding: 60px 20px;
            text-align: center;
        }
        .location-title {
            font-size: 1.15rem;
            letter-spacing: 3px;
            text-transform: uppercase;
            font-weight: 400;
            color: #d4af37;
            margin-bottom: 16px;
        }
        .location-phone {
            font-size: 1.25rem;
            color: #ffffff;
            margin: 12px 0;
            font-weight: 600;
        }
        .location-address {
            font-size: 0.85rem;
            color: #a0aec0;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin: 4px 0 16px 0;
        }

        /* --- 7. Footer Instagram Grid --- */
        .footer-social-grid {
            display: grid;
            grid-template-columns: repeat(8, 1fr);
            gap: 2px;
            background-color: #0d0d0d;
            width: 100%;
            overflow: hidden;
        }
        .footer-social-grid .thumb-box {
            height: 100px;
        }
        .footer-social-grid img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .btn-floating-booking {
            position: fixed;
            top: 50%;
            right: 0;
            transform: translateY(-50%); /* Căn nút nằm ở chính giữa hoàn hảo theo chiều dọc */
            z-index: 9999; /* Đảm bảo nút luôn nằm trên cùng, không bị các khối khác che mất */
            background: rgba(22, 22, 22, 0.9); /* Màu xám đen hơi trong suốt nhẹ nhàng */
            color: #d4af37;
            border: 1px solid rgba(212, 175, 55, 0.5);
            border-right: none; /* Bỏ viền phải để nút hòa vào cạnh màn hình */
            border-radius: 12px 0 0 12px; /* Bo góc mượt mà bên trái */
            font-weight: 700;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            padding: 20px 15px;
            text-align: center;
            line-height: 1.6;
            box-shadow: -5px 0 15px rgba(0, 0, 0, 0.4);
            writing-mode: horizontal-tb; /* Giữ chữ nằm ngang dễ đọc */
        }

        /* Hiệu ứng ngọt ngào khi trỏ chuột vào */
        .btn-floating-booking:hover {
            background: linear-gradient(90deg, #aa7c11, #d4af37);
            color: #000000;
            padding-right: 25px; /* Nút sẽ trượt nhẹ ra ngoài một xíu */
            box-shadow: -8px 0 20px rgba(212, 175, 55, 0.3);
        }

        /* --- Responsive Cho Điện Thoại --- */
        @media (max-width: 992px) {
            .booking-form-grid { grid-template-columns: 1fr; }
            .form-cell { grid-column: span 12 !important; border-right: none; border-b: 1px solid rgba(212, 175, 55, 0.15); }
            .btn-submit-booking { grid-column: span 12; padding: 16px 0; border-left: none; }
            .premium-slogan { font-size: 2.2rem; }
            .experience-grid, .gallery-photo-grid, .offers-grid { grid-template-columns: repeat(2, 1fr); }
            .footer-social-grid { grid-template-columns: repeat(4, 1fr); }
        }

        @media (max-width: 600px) {
            .experience-grid, .gallery-photo-grid, .offers-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

<header class="hero-wrapper">
    <video id="bgVideo" autoplay loop muted playsinline class="video-bg">
        <source src="${pageContext.request.contextPath}/videos/HDBG.mp4" type="video/mp4">
        Trình duyệt của bạn không hỗ trợ thẻ video.
    </video>
    <div class="video-overlay"></div>

    <div class="header-nav-container">
        <jsp:include page="header.jsp" />
    </div>

    <div class="hero-center-content">
        <h1 class="premium-slogan">
            Cửa ngõ đến với cuộc sống <br class="hidden-mobile"> và giải trí cao cấp
        </h1>

        <form action="room_list.jsp" method="GET">
            <button type="submit" class="btn-floating-booking">
                Kiểm tra<br>phòng trống
            </button>
        </form>

        <div class="meta-links">
            <a href="#">Mã khuyến mãi</a>
            <span class="divider">|</span>
            <a href="#">Sửa đổi / Hủy đặt chỗ</a>
        </div>
    </div>

    <div style="height: 48px; position: relative; z-index: 0;"></div>
</header>

<section class="container-inner section-padding">
    <h2 class="section-title">Khách Sạn Verdelle</h2>
    <p class="section-desc">
        Tọa lạc tại trung tâm thành phố và cách Sân bay chỉ 20 phút di chuyển, Khách sạn Verdelle mang đến 530 phòng nghỉ hiện đại, không gian sự kiện linh hoạt cùng các lựa chọn ẩm thực phong phú. Nơi đây được thiết kế hoàn hảo cho các doanh nhân quốc tế và khách đoàn tìm kiếm sự tiện nghi và thoải mái.
    </p>
    <a href="about.jsp" class="link-view-all">Xem tất cả</a>

    <div class="experience-grid">
        <div class="experience-card">
            <img src="https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=600&q=80" class="card-bg-img" alt="Thư giãn">
            <div class="card-shadow-overlay"></div>
            <div class="card-inner-text">
                <h4>Thư Giãn & Tái Tạo</h4>
                <a href="#">Khám phá ngay</a>
            </div>
        </div>
        <div class="experience-card">
            <img src="https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=600&q=80" class="card-bg-img" alt="Ẩm thực">
            <div class="card-shadow-overlay"></div>
            <div class="card-inner-text">
                <h4>Thưởng Thức Ẩm Thực</h4>
                <a href="#">Khám phá ngay</a>
            </div>
        </div>
        <div class="experience-card">
            <img src="https://images.unsplash.com/photo-1519167758481-83f550bb49b3?auto=format&fit=crop&w=600&q=80" class="card-bg-img" alt="Sự kiện">
            <div class="card-shadow-overlay"></div>
            <div class="card-inner-text">
                <h4>Gặp Gỡ & Kỷ Niệm</h4>
                <a href="#">Khám phá ngay</a>
            </div>
        </div>
    </div>
</section>

<section class="bg-dark-section section-padding">
    <div class="container-inner">
        <h2 class="section-title">Bộ Sưu Tập Ảnh</h2>

        <div class="filter-nav-bar">
            <button data-filter="all" class="filter-btn active">Tất cả</button>
            <button data-filter="diem-den" class="filter-btn">Điểm đến</button>
            <button data-filter="phong-nghi" class="filter-btn">Phòng nghỉ</button>
            <button data-filter="hoi-nghi" class="filter-btn">Hội nghị & Tiệc cưới</button>
            <button data-filter="cau-lac-bo" class="filter-btn">Câu lạc bộ cư dân</button>
            <button data-filter="giai-tri" class="filter-btn">Giải trí</button>
            <button data-filter="nha-hang" class="filter-btn">Nhà hàng</button>
        </div>

        <div class="gallery-photo-grid">
            <div class="gallery-item" data-category="diem-den"><img src="https://images.unsplash.com/photo-1564507592333-c60657eea523?auto=format&fit=crop&w=500&q=80" alt=""></div>
            <div class="gallery-item" data-category="diem-den"><img src="https://tse1.mm.bing.net/th/id/OIP.FtudhIBH-HYhxMpS4TU-sAHaE8?rs=1&pid=ImgDetMain&o=7&rm=3" alt=""></div>
            <div class="gallery-item" data-category="diem-den"><img src="https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=500&q=80" alt=""></div>
            <div class="gallery-item" data-category="diem-den"><img src="https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?auto=format&fit=crop&w=500&q=80" alt=""></div>
            <div class="gallery-item" data-category="diem-den"><img src="https://images.unsplash.com/photo-1501854140801-50d01698950b?auto=format&fit=crop&w=500&q=80" alt=""></div>
            <div class="gallery-item" data-category="diem-den"><img src="https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?auto=format&fit=crop&w=500&q=80" alt=""></div>

            <div class="gallery-item" data-category="phong-nghi"><img src="https://images.unsplash.com/photo-1540555700478-4be289fbecef?auto=format&fit=crop&w=500&q=80" alt=""></div>
            <div class="gallery-item" data-category="phong-nghi"><img src="https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=500&q=80" alt=""></div>
            <div class="gallery-item" data-category="phong-nghi"><img src="https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=500&q=80" alt=""></div>
            <div class="gallery-item" data-category="phong-nghi"><img src="https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=500&q=80" alt=""></div>
            <div class="gallery-item" data-category="phong-nghi"><img src="https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=500&q=80" alt=""></div>
            <div class="gallery-item" data-category="phong-nghi"><img src="https://images.unsplash.com/photo-1541971875076-8f970d573be6?auto=format&fit=crop&w=500&q=80" alt=""></div>

            <div class="gallery-item" data-category="hoi-nghi"><img src="https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?auto=format&fit=crop&w=500&q=80" alt=""></div>
            <div class="gallery-item" data-category="hoi-nghi"><img src="https://images.unsplash.com/photo-1511578314322-379afb476865?auto=format&fit=crop&w=500&q=80" alt=""></div>
            <div class="gallery-item" data-category="hoi-nghi"><img src="https://images.unsplash.com/photo-1519167758481-83f550bb49b3?auto=format&fit=crop&w=500&q=80" alt=""></div>
            <div class="gallery-item" data-category="hoi-nghi"><img src="https://images.unsplash.com/photo-1431540015161-0bf868a2d407?auto=format&fit=crop&w=500&q=80" alt=""></div>
            <div class="gallery-item" data-category="hoi-nghi"><img src="https://images.unsplash.com/photo-1515187029135-18ee286d815b?auto=format&fit=crop&w=500&q=80" alt=""></div>
            <div class="gallery-item" data-category="hoi-nghi"><img src="https://cache.marriott.com/marriottassets/marriott/SANDT/sandt-ballroom-0178-hor-feat.jpg" alt=""></div>

            <div class="gallery-item" data-category="cau-lac-bo"><img src="https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=500&q=80" alt=""></div>
            <div class="gallery-item" data-category="cau-lac-bo"><img src="https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?auto=format&fit=crop&w=500&q=80" alt=""></div>
            <div class="gallery-item" data-category="cau-lac-bo"><img src="https://images.unsplash.com/photo-1571896349842-33c89424de2d?auto=format&fit=crop&w=500&q=80" alt=""></div>
            <div class="gallery-item" data-category="cau-lac-bo"><img src="https://images.unsplash.com/photo-1540555700478-4be289fbecef?auto=format&fit=crop&w=500&q=80" alt=""></div>
            <div class="gallery-item" data-category="cau-lac-bo"><img src="https://images.unsplash.com/photo-1584132967334-10e028bd69f7?auto=format&fit=crop&w=500&q=80" alt=""></div>
            <div class="gallery-item" data-category="cau-lac-bo"><img src="https://images.unsplash.com/photo-1568495248636-6432b97bd949?auto=format&fit=crop&w=500&q=80" alt=""></div>

            <div class="gallery-item" data-category="giai-tri"><img src="https://images.unsplash.com/photo-1571008887538-b36bb32f4571?auto=format&fit=crop&w=500&q=80" alt=""></div>
            <div class="gallery-item" data-category="giai-tri"><img src="https://images.unsplash.com/photo-1517604931442-7e0c8ed2963c?auto=format&fit=crop&w=500&q=80" alt=""></div>
            <div class="gallery-item" data-category="giai-tri"><img src="https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?auto=format&fit=crop&w=500&q=80" alt=""></div>
            <div class="gallery-item" data-category="giai-tri"><img src="https://images.unsplash.com/photo-1536440136628-849c177e76a1?auto=format&fit=crop&w=500&q=80" alt=""></div>
            <div class="gallery-item" data-category="giai-tri"><img src="https://images.unsplash.com/photo-1513151233558-d860c5398176?auto=format&fit=crop&w=500&q=80" alt=""></div>
            <div class="gallery-item" data-category="giai-tri"><img src="https://images.unsplash.com/photo-1492684223066-81342ee5ff30?auto=format&fit=crop&w=500&q=80" alt=""></div>

            <div class="gallery-item" data-category="nha-hang"><img src="https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=500&q=80" alt=""></div>
            <div class="gallery-item" data-category="nha-hang"><img src="https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=500&q=80" alt=""></div>
            <div class="gallery-item" data-category="nha-hang"><img src="https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=500&q=80" alt=""></div>
            <div class="gallery-item" data-category="nha-hang"><img src="https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=500&q=80" alt=""></div>
            <div class="gallery-item" data-category="nha-hang"><img src="https://images.unsplash.com/photo-1537047902294-62a40c20a6ae?auto=format&fit=crop&w=500&q=80" alt=""></div>
            <div class="gallery-item" data-category="nha-hang"><img src="https://images.unsplash.com/photo-1559339352-11d035aa65de?auto=format&fit=crop&w=500&q=80" alt=""></div>
        </div>

        <a href="gallery.jsp" class="link-view-all" style="display: inline-block; margin-top: 40px;">Xem tất cả</a>
    </div>
</section>

<section class="container-inner section-padding">
    <h2 class="section-title">Ưu Đãi Đặc Biệt</h2>
    <div class="offers-grid">
        <div>
            <div class="offer-img-box">
                <img src="https://images.unsplash.com/photo-1551024709-8f23befc6f87?auto=format&fit=crop&w=600&q=80" alt="">
            </div>
            <h3 class="offer-title">Thành viên điện tử</h3>
            <p class="offer-p">Lên kế hoạch trước và tận hưởng ưu đãi tiết kiệm độc quyền tại Verdelle.</p>
            <a href="#" class="btn-explore-offer">Khám phá thêm</a>
        </div>
        <div>
            <div class="offer-img-box">
                <img src="https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=600&q=80" alt="">
            </div>
            <h3 class="offer-title">Khuyến mãi tốt</h3>
            <p class="offer-p">Lên kế hoạch cho chuyến đi hoàn hảo của bạn từ sớm để nhận ngay các mức giá ưu đãi hấp dẫn...</p>
            <a href="#" class="btn-explore-offer">Khám phá thêm</a>
        </div>
        <div>
            <div class="offer-img-box">
                <img src="https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?auto=format&fit=crop&w=600&q=80" alt="">
            </div>
            <h3 class="offer-title">Kéo dài kỳ nghỉ</h3>
            <p class="offer-p">Kéo dài thời gian thư giãn tuyệt vời của bạn tại Verdelle và tận hưởng thêm các đêm nghỉ...</p>
            <a href="#" class="btn-explore-offer">Khám phá thêm</a>
        </div>
    </div>
    <a href="#" class="link-view-all" style="display: inline-block; margin-top: 48px;">Xem tất cả</a>
</section>

<section class="location-section">
    <h3 class="location-title">Khám phá điểm đến tiếp theo của bạn @ VERDELLE</h3>
    <p class="location-phone">+84 83 417 8906</p>
    <p class="location-address">76 Lê Lai, Phường Bến Thành, Quận 1, Thành phố Hồ Chí Minh, Việt Nam</p>
    <a href="#" class="link-view-all" style="font-size: 11px;">Xem bản đồ đường đi</a>
</section>

<footer class="bg-dark-section">
    <div class="footer-social-grid">
        <div class="thumb-box"><img src="https://images.unsplash.com/photo-1541971875076-8f970d573be6?auto=format&fit=crop&w=200&q=80" alt=""></div>
        <div class="thumb-box"><img src="https://images.unsplash.com/photo-1550966871-3ed3cdb5ed0c?auto=format&fit=crop&w=200&q=80" alt=""></div>
        <div class="thumb-box"><img src="https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=200&q=80" alt=""></div>
        <div class="thumb-box"><img src="https://images.unsplash.com/photo-1537047902294-62a40c20a6ae?auto=format&fit=crop&w=200&q=80" alt=""></div>
        <div class="thumb-box"><img src="https://images.unsplash.com/photo-1502082553048-f009c37129b9?auto=format&fit=crop&w=200&q=80" alt=""></div>
        <div class="thumb-box"><img src="https://images.unsplash.com/photo-1414235077428-338989a2e8c0?auto=format&fit=crop&w=200&q=80" alt=""></div>
        <div class="thumb-box"><img src="https://images.unsplash.com/photo-1578474846511-04ba529f0b88?auto=format&fit=crop&w=200&q=80" alt=""></div>
        <div class="thumb-box"><img src="https://tse4.mm.bing.net/th/id/OIP.gfN-fyxF04pun4J3nmXrFQHaE8?rs=1&pid=ImgDetMain&o=7&rm=3" alt=""></div>
    </div>

    <jsp:include page="footer.jsp" />
</footer>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const buttons = document.querySelectorAll('.filter-btn');
        const items = document.querySelectorAll('.gallery-item');

        function filterGallery(filterValue) {
            let count = 0;
            items.forEach(item => {
                const itemCategory = item.getAttribute('data-category');

                if (filterValue === 'all') {
                    if (count < 6) {
                        item.style.display = 'block';
                        count++;
                    } else {
                        item.style.display = 'none';
                    }
                } else {
                    if (itemCategory === filterValue) {
                        item.style.display = 'block';
                    } else {
                        item.style.display = 'none';
                    }
                }
            });
        }

        filterGallery('all');

        buttons.forEach(button => {
            button.addEventListener('click', function() {
                buttons.forEach(btn => btn.classList.remove('active'));
                this.classList.add('active');

                const filterValue = this.getAttribute('data-filter');
                filterGallery(filterValue);
            });
        });
    });

    document.addEventListener("DOMContentLoaded", function() {
        var video = document.getElementById("bgVideo");
        if (video) {
            video.muted = true; // Bắt buộc mute thì trình duyệt mới cho autoplay
            video.play().catch(function(error) {
                console.log("Lỗi autoplay video:", error);
            });
        }
    });
</script>
</body>
</html>