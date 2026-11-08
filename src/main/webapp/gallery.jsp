<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Thư Viện Ảnh - Khách sạn Verdelle</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600&family=Plus+Jakarta+Sans:wght@300;400;600;700&display=swap" rel="stylesheet">

  <style>
    html, body {
      margin: 0;
      padding: 0;
      background-color: #0d0d0d;
      color: #ffffff;
      font-family: 'Plus Jakarta Sans', sans-serif;
    }

    .container-inner {
      max-width: 1200px;
      margin: 0 auto;
      padding: 0 20px;
      box-sizing: border-box;
    }

    /* Banner Đầu Trang */
    .gallery-hero {
      position: relative;
      height: 35vh;
      min-height: 250px;
      display: flex;
      align-items: center;
      justify-content: center;
      background: url('https://images.unsplash.com/photo-1541971875076-8f970d573be6?auto=format&fit=crop&w=1600&q=80') center/cover no-repeat;
    }

    .gallery-hero::before {
      content: '';
      position: absolute;
      inset: 0;
      background: linear-gradient(180deg, rgba(0,0,0,0.3) 0%, #0d0d0d 100%);
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
      display: block;
    }

    .hero-title {
      font-family: 'Playfair Display', serif;
      font-size: 3rem;
      margin: 0;
      background: linear-gradient(90deg, #ffe066, #d4af37, #aa7c11);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
    }

    /* Lưới hiển thị toàn bộ ảnh (CSS Grid) */
    .gallery-section {
      padding: 60px 0 100px 0;
    }

    .gallery-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
      gap: 24px;
    }

    .gallery-item {
      position: relative;
      height: 260px;
      overflow: hidden;
      border: 1px solid rgba(212, 175, 55, 0.15);
      border-radius: 4px;
      background: #161616;
      cursor: pointer;
      transition: all 0.4s ease;
    }

    .gallery-item img {
      width: 100%;
      height: 100%;
      object-fit: cover;
      transition: transform 0.6s cubic-bezier(0.25, 0.46, 0.45, 0.94);
    }

    /* Lớp phủ mờ khi di chuột vào ảnh */
    .gallery-item::after {
      content: '';
      position: absolute;
      inset: 0;
      background: linear-gradient(to top, rgba(0, 0, 0, 0.8) 0%, rgba(0, 0, 0, 0) 100%);
      opacity: 0.6;
      transition: opacity 0.4s;
    }

    .gallery-item:hover {
      border-color: #d4af37;
      box-shadow: 0 10px 25px rgba(212, 175, 55, 0.15);
    }

    .gallery-item:hover img {
      transform: scale(1.08);
    }

    /* Khối nút chân trang */
    .navigation-footer-box {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 40px 20px 80px 20px;
    }

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
    }

    .btn-nav-left {
      color: #cbd5e1;
      border: 1px solid rgba(212, 175, 55, 0.25);
      background: rgba(22, 22, 22, 0.6);
    }

    .btn-nav-left:hover {
      border-color: #d4af37;
      color: #ffffff;
      background: #161616;
    }

    .btn-nav-left:hover i {
      transform: translateX(-5px);
    }

    .btn-gold-solid {
      background: linear-gradient(90deg, #aa7c11, #d4af37);
      color: #000000 !important;
    }

    .btn-gold-solid:hover {
      background: linear-gradient(90deg, #d4af37, #ffe066);
      box-shadow: 0 6px 25px rgba(212, 175, 55, 0.35);
    }

    .btn-gold-solid:hover i {
      transform: translateX(5px);
    }

    .btn-nav-left i, .btn-gold-solid i {
      transition: transform 0.3s ease;
    }

    @media (max-width: 600px) {
      .gallery-grid { grid-template-columns: 1fr; }
      .navigation-footer-box { flex-direction: column-reverse; gap: 16px; }
      .navigation-footer-box a { width: 100%; justify-content: center; }
    }
  </style>
</head>
<body>

<jsp:include page="header.jsp" />

<section class="gallery-hero">
  <div class="hero-title-box">
    <span class="hero-subtitle">Không gian đỉnh cao</span>
    <h1 class="hero-title">Thư Viện Hình Ảnh</h1>
  </div>
</section>

<section class="container-inner gallery-section">
  <div class="gallery-grid">
    <div class="gallery-item">
      <img src="https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=800&q=80" alt="Phòng Deluxe King">
    </div>
    <div class="gallery-item">
      <img src="https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=800&q=80" alt="Phòng Executive Suite">
    </div>
    <div class="gallery-item">
      <img src="https://images.unsplash.com/photo-1591088398332-8a7791972843?auto=format&fit=crop&w=800&q=80" alt="Góc làm việc trong phòng Presidential">
    </div>
    <div class="gallery-item">
      <img src="https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=800&q=80" alt="Phòng ngủ hướng phố">
    </div>
    <div class="gallery-item">
      <img src="https://i.pinimg.com/originals/96/8f/0e/968f0eb19f773af59a1a91ec6d38a96b.jpg" alt="Phòng Suite Hoàng Gia">
    </div>
    <div class="gallery-item">
      <img src="https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=800&q=80" alt="Chi tiết giường ngủ Premium">
    </div>
    <div class="gallery-item">
      <img src="https://images.unsplash.com/photo-1631049307264-da0ec9d70304?auto=format&fit=crop&w=800&q=80" alt="Không gian phòng ngủ đón nắng">
    </div>

    <div class="gallery-item">
      <img src="https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=800&q=80" alt="Đại sảnh Verdelle">
    </div>
    <div class="gallery-item">
      <img src="https://images.unsplash.com/photo-1541971875076-8f970d573be6?auto=format&fit=crop&w=800&q=80" alt="Kiến trúc hành lang">
    </div>
    <div class="gallery-item">
      <img src="https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=800&q=80" alt="Quầy lễ tân">
    </div>
    <div class="gallery-item">
      <img src="https://images.unsplash.com/photo-1445019980597-93fa8acb246c?auto=format&fit=crop&w=800&q=80" alt="Lối vào sảnh chính">
    </div>

    <div class="gallery-item">
      <img src="https://images.unsplash.com/photo-1544161515-4ab6ce6db874?auto=format&fit=crop&w=800&q=80" alt="Nhà hàng Fine Dining">
    </div>
    <div class="gallery-item">
      <img src="https://images.unsplash.com/photo-1514933651103-005eec06c04b?auto=format&fit=crop&w=800&q=80" alt="Lounge & Bar cao cấp">
    </div>
    <div class="gallery-item">
      <img src="https://images.unsplash.com/photo-1550966871-3ed3cdb5ed0c?auto=format&fit=crop&w=800&q=80" alt="Bàn tiệc tối lãng mạn">
    </div>
    <div class="gallery-item">
      <img src="https://images.unsplash.com/photo-1574096079513-d8259312b785?auto=format&fit=crop&w=800&q=80" alt="Hầm rượu vang">
    </div>
    <div class="gallery-item">
      <img src="https://images.unsplash.com/photo-1414235077428-338989a2e8c0?auto=format&fit=crop&w=800&q=80" alt="Món ăn chuẩn Michelin">
    </div>

    <div class="gallery-item">
      <img src="https://images.unsplash.com/photo-1576013551627-0cc20b96c2a7?auto=format&fit=crop&w=800&q=80" alt="Hồ bơi vô cực hoàng hôn">
    </div>
    <div class="gallery-item">
      <img src="https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=800&q=80" alt="Phòng tắm Suite cao cấp">
    </div>
    <div class="gallery-item">
      <img src="https://images.unsplash.com/photo-1540555700478-4be289fbecef?auto=format&fit=crop&w=800&q=80" alt="Không gian Spa trị liệu">
    </div>
    <div class="gallery-item">
      <img src="https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd?auto=format&fit=crop&w=800&q=80" alt="Khu ghế nghỉ ban công">
    </div>
    <div class="gallery-item">
      <img src="https://images.unsplash.com/photo-1600566753190-17f0baa2a6c3?auto=format&fit=crop&w=800&q=80" alt="Bồn tắm sục Jacuzzi">
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