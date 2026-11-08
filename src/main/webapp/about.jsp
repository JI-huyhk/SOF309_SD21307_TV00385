<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Về Chúng Tôi - Khách sạn Verdelle</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400..900;1,400..900&family=Plus+Jakarta+Sans:wght@300;400;600;700&display=swap" rel="stylesheet">

    <style>
        /* ==========================================================================
           CSS TRẦN THUẦN - BLACK & GOLD LUXURY STYLE (ABOUT US)
           ========================================================================== */

        html, body {
            margin: 0;
            padding: 0;
            background-color: #0d0d0d; /* Đen tuyền hoàng gia */
            color: #ffffff;
            font-family: 'Plus Jakarta Sans', sans-serif;
            scroll-behavior: smooth;
        }

        .container-inner {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
            box-sizing: border-box;
        }

        /* Banner Đầu Trang (Hero Banner) */
        .about-hero {
            position: relative;
            height: 45vh;
            min-height: 350px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: url('https://images.unsplash.com/photo-1541971875076-8f970d573be6?auto=format&fit=crop&w=1600&q=80') center/cover no-repeat;
            overflow: hidden;
        }

        .about-hero::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(180deg, rgba(0,0,0,0.4) 0%, rgba(13,13,13,1) 100%);
            z-index: 1;
        }

        .hero-title-box {
            position: relative;
            z-index: 2;
            text-align: center;
        }

        .hero-subtitle {
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 4px;
            color: #d4af37;
            margin-bottom: 8px;
            font-weight: 600;
        }

        .hero-title {
            font-family: 'Playfair Display', serif;
            font-size: 3.5rem;
            font-weight: 400;
            margin: 0;
            letter-spacing: 2px;
            background: linear-gradient(90deg, #ffe066 0%, #d4af37 50%, #aa7c11 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        /* Khối Nội Dung Chính (Câu chuyện thương hiệu) */
        .story-section {
            padding: 80px 0;
        }

        .story-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 60px;
            align-items: center;
        }

        .story-content h2 {
            font-family: 'Playfair Display', serif;
            font-size: 2.2rem;
            color: #d4af37;
            font-weight: 400;
            margin: 0 0 24px 0;
            letter-spacing: 1px;
        }

        .story-content p {
            color: #cbd5e1;
            font-size: 0.95rem;
            line-height: 1.8;
            margin-bottom: 20px;
            text-align: justify;
        }

        .story-content .highlight-text {
            font-family: 'Playfair Display', serif;
            font-style: italic;
            font-size: 1.15rem;
            color: #fff;
            border-left: 2px solid #d4af37;
            padding-left: 20px;
            margin: 30px 0;
        }

        .story-image-box {
            position: relative;
            height: 500px;
            border: 1px solid rgba(212, 175, 55, 0.3);
            padding: 15px;
            box-sizing: border-box;
        }

        .story-image-box img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        /* Khối Chỉ Số Thống Kê (Milestones) */
        .stats-section {
            background-color: #111111;
            border-top: 1px solid rgba(212, 175, 55, 0.1);
            border-bottom: 1px solid rgba(212, 175, 55, 0.1);
            padding: 60px 0;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 30px;
            text-align: center;
        }

        .stat-number {
            font-family: 'Playfair Display', serif;
            font-size: 3rem;
            color: #d4af37;
            margin-bottom: 8px;
        }

        .stat-label {
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 2px;
            color: #a0aec0;
        }

        /* Khối Giá Trị Cốt Lõi */
        .values-section {
            padding: 80px 0;
            text-align: center;
        }

        .section-title {
            font-family: 'Playfair Display', serif;
            font-size: 2rem;
            color: #d4af37;
            text-transform: uppercase;
            letter-spacing: 3px;
            margin-bottom: 48px;
            font-weight: 400;
        }

        .values-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 30px;
        }

        .value-card {
            background: #161616;
            border: 1px solid rgba(212, 175, 55, 0.15);
            padding: 40px 30px;
            border-radius: 4px;
            transition: all 0.3s ease;
        }

        .value-card:hover {
            transform: translateY(-5px);
            border-color: #d4af37;
            box-shadow: 0 10px 30px rgba(212, 175, 55, 0.1);
        }

        .value-icon {
            font-size: 2.5rem;
            color: #d4af37;
            margin-bottom: 24px;
        }

        .value-card h3 {
            font-family: 'Playfair Display', serif;
            font-size: 1.3rem;
            margin: 0 0 16px 0;
            color: #ffffff;
            font-weight: 500;
        }

        .value-card p {
            font-size: 0.88rem;
            color: #cbd5e1;
            line-height: 1.7;
            margin: 0;
        }

        /* --- KHỐI ĐIỀU HƯỚNG CHÂN TRANG (LEFT & RIGHT) --- */
        .navigation-footer-box {
            display: flex;
            justify-content: space-between; /* Đẩy 2 nút ra 2 đầu xa nhất bên trái và phải */
            align-items: center;
            padding: 60px 20px 100px 20px; /* Tạo khoảng cách thoáng đẹp mắt trước khi xuống footer */
            box-sizing: border-box;
        }

        /* Kiểu dáng chung cho nút điều hướng */
        .navigation-footer-box a {
            display: inline-flex;
            align-items: center;
            gap: 12px;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 2px;
            font-weight: 700;
            text-decoration: none;
            padding: 14px 32px;
            border-radius: 2px;
            transition: all 0.3s ease;
            box-sizing: border-box;
        }

        /* NÚT BÊN TRÁI: Quay về trang chủ (Nền đen xám mờ, viền vàng mảnh) */
        .btn-nav-left {
            color: #cbd5e1;
            border: 1px solid rgba(212, 175, 55, 0.25);
            background: rgba(22, 22, 22, 0.6);
        }

        .btn-nav-left i {
            transition: transform 0.3s ease;
            color: #d4af37;
        }

        .btn-nav-left:hover {
            border-color: #d4af37;
            color: #ffffff;
            background: #161616;
            box-shadow: 0 4px 15px rgba(212, 175, 55, 0.05);
        }

        .btn-nav-left:hover i {
            transform: translateX(-5px); /* Di chuyển mũi tên sang trái khi hover */
        }

        /* NÚT BÊN PHẢI: Đặt phòng ngay hôm nay (Gradient màu vàng khối Luxury rực rỡ) */
        .btn-gold-solid {
            background: linear-gradient(90deg, #aa7c11 0%, #d4af37 100%);
            color: #000000 !important;
            border: none;
            box-shadow: 0 4px 15px rgba(212, 175, 55, 0.15);
        }

        .btn-gold-solid i {
            transition: transform 0.3s ease;
        }

        .btn-gold-solid:hover {
            background: linear-gradient(90deg, #d4af37 0%, #ffe066 100%);
            box-shadow: 0 6px 25px rgba(212, 175, 55, 0.35);
        }

        .btn-gold-solid:hover i {
            transform: translateX(5px); /* Di chuyển mũi tên sang phải khi hover */
        }

        /* Hỗ trợ hiển thị mượt mà và tự xếp dọc trên giao diện điện thoại */
        @media (max-width: 600px) {
            .navigation-footer-box {
                flex-direction: column-reverse; /* Đặt phòng lên trên, quay về xuống dưới khi màn hình bé */
                gap: 16px;
                align-items: stretch;
                padding: 40px 20px 60px 20px;
            }
            .navigation-footer-box a {
                justify-content: center;
                width: 100%;
            }
        }

        /* Responsive chung */
        @media (max-width: 992px) {
            .story-grid { grid-template-columns: 1fr; gap: 40px; }
            .story-image-box { height: 400px; }
            .stats-grid { grid-template-columns: repeat(2, 1fr); gap: 40px; }
            .values-grid { grid-template-columns: 1fr; }
            .hero-title { font-size: 2.5rem; }
        }
    </style>
</head>
<body>

<jsp:include page="header.jsp" />

<section class="about-hero">
    <div class="hero-title-box">
        <span class="hero-subtitle">Hành trình di sản</span>
        <h1 class="hero-title">Về Khách Sạn Verdelle</h1>
    </div>
</section>

<section class="container-inner story-section">
    <div class="story-grid">
        <div class="story-content">
            <h2>Kiến Tạo Nghệ Thuật Sống Đẳng Cấp</h2>
            <p>
                Được thành lập với tầm nhìn định nghĩa lại khái niệm xa xỉ đương đại, Khách sạn Verdelle không chỉ đơn thuần là nơi dừng chân, mà là một điểm đến biểu tượng cho phong cách sống thượng lưu giữa lòng thành phố sôi động.
            </p>
            <p>
                Mỗi không gian tại Verdelle là sự kết tinh hoàn hảo giữa lối kiến trúc hoàng gia tinh tế và những tiện nghi công nghệ đột phá. Chúng tôi tỉ mỉ chăm chút từng chi tiết nhỏ nhất nhằm mang tới cho các doanh nhân toàn cầu, các phái đoàn quốc tế một không gian yên bình, riêng tư nhưng không kém phần tráng lệ.
            </p>
            <div class="highlight-text">
                "Tại Verdelle, sự sang trọng không nằm ở những điều phô trương, mà ẩn hiện trong trải nghiệm cá nhân hóa tuyệt đối và sự hiếu khách chân thành từ tâm."
            </div>
            <p>
                Với quy mô 530 phòng nghỉ cao cấp, hệ thống sảnh hội nghị đa năng đạt chuẩn quốc tế cùng chuỗi nhà hàng ẩm thực độc bản, Verdelle tự hào đồng hành cùng mỗi bước chân thành công và những khoảnh khắc kỷ niệm thăng hoa của quý khách.
            </p>
        </div>

        <div class="story-image-box">
            <img src="https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=800&q=80" alt="Không gian Verdelle">
        </div>
    </div>
</section>

<section class="stats-section">
    <div class="container-inner">
        <div class="stats-grid">
            <div>
                <div class="stat-number">530</div>
                <div class="stat-label">Phòng nghỉ cao cấp</div>
            </div>
            <div>
                <div class="stat-number">5★</div>
                <div class="stat-label">Tiêu chuẩn quốc tế</div>
            </div>
            <div>
                <div class="stat-number">4</div>
                <div class="stat-label">Nhà hàng độc bản</div>
            </div>
            <div>
                <div class="stat-number">20m</div>
                <div class="stat-label">Di chuyển tới sân bay</div>
            </div>
        </div>
    </div>
</section>

<section class="container-inner values-section">
    <h2 class="section-title">Giá Trị Cốt Lõi</h2>

    <div class="values-grid">
        <div class="value-card">
            <div class="value-icon"><i class="fa-solid fa-gem"></i></div>
            <h3>Sự Tinh Tế</h3>
            <p>Từ kiến trúc không gian đến cung cách phục vụ, mọi chi tiết đều được trau chuốt đạt tới sự hoàn mỹ nhằm lay động mọi giác quan.</p>
        </div>

        <div class="value-card">
            <div class="value-icon"><i class="fa-solid fa-bell-concierge"></i></div>
            <h3>Cá Nhân Hóa</h3>
            <p>Chúng tôi lắng nghe và thấu hiểu mọi thói quen của quý khách để mang đến những dịch vụ may đo riêng biệt độc nhất.</p>
        </div>

        <div class="value-card">
            <div class="value-icon"><i class="fa-solid fa-shield-halved"></i></div>
            <h3>Sự Riêng Tư</h3>
            <p>Cam kết mang lại một không gian tĩnh lặng tuyệt đối, an toàn và bảo mật tối đa cho những kỳ nghỉ hay cuộc gặp gỡ cấp cao.</p>
        </div>
    </div>
</section>

<section class="container-inner navigation-footer-box">
    <a href="home.jsp" class="btn-nav-left">
        <i class="fa-solid fa-arrow-left-long"></i> Quay về trang chủ
    </a>

    <a href="room_list.jsp" class="btn-gold-solid">
        Đặt phòng ngay hôm nay <i class="fa-solid fa-arrow-right-long"></i>
    </a>
</section>

<jsp:include page="footer.jsp" />

</body>
</html>