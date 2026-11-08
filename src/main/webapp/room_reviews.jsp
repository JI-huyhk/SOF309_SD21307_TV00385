<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" isELIgnored="false" %>
<%@ page import="java.util.List" %>
<%@ page import="controller.ReviewController.ReviewModel" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đánh Giá & Nhận Xét - Verdelle Luxury</title>
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
            --gold-hover: #ffca28;
            --accent-orange: #ff7043;
        }

        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: var(--bg-color);
            color: var(--text-main);
            padding: 30px 20px;
            margin: 0;
        }

        .page-container {
            max-width: 1000px;
            margin: 0 auto;
        }

        /* Nút quay lại */
        .back-box {
            text-align: left;
            margin-bottom: 25px;
            width: 100%;
        }
        .btn-back {
            color: var(--gold-hover);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-weight: 600;
            font-size: 0.95rem;
            transition: all 0.2s ease;
        }
        .btn-back:hover {
            color: #fff;
            transform: translateX(-3px);
        }

        /* --- HERO ROOM BANNER --- */
        .room-hero-card {
            position: relative;
            border-radius: 16px;
            overflow: hidden;
            background: var(--panel-bg);
            border: 1px solid var(--border-color);
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
            display: flex;
            min-height: 220px;
        }

        .room-hero-image {
            width: 45%;
            position: relative;
            overflow: hidden;
        }

        .room-hero-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }

        .room-hero-overlay {
            position: absolute;
            inset: 0;
            background: linear-gradient(90deg, rgba(20,20,26,0) 0%, var(--panel-bg) 100%);
        }

        .room-hero-info {
            width: 55%;
            padding: 30px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            box-sizing: border-box;
        }

        .room-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: rgba(212, 175, 55, 0.1);
            border: 1px solid rgba(212, 175, 55, 0.3);
            color: var(--gold-primary);
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 700;
            letter-spacing: 1px;
            width: fit-content;
            margin-bottom: 12px;
            text-transform: uppercase;
        }

        .room-title {
            font-size: 2rem;
            font-weight: 800;
            color: var(--gold-hover);
            margin: 0 0 15px 0;
            letter-spacing: 0.5px;
            text-shadow: 0 2px 4px rgba(0,0,0,0.5);
        }

        .room-stats {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        .stat-tag {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            padding: 8px 14px;
            border-radius: 8px;
            font-size: 0.85rem;
            color: var(--text-muted);
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .stat-tag strong {
            color: var(--text-main);
        }

        /* --- THÔNG BÁO CHÍNH SÁCH CHỐNG REVIEW BOMB --- */
        .review-policy-notice {
            background: rgba(212, 175, 55, 0.05);
            border: 1px solid rgba(212, 175, 55, 0.2);
            border-radius: 12px;
            padding: 16px 20px;
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            gap: 14px;
            color: var(--text-muted);
            font-size: 0.9rem;
            line-height: 1.5;
        }

        .review-policy-notice i {
            font-size: 1.4rem;
            color: var(--gold-primary);
            flex-shrink: 0;
        }

        .review-policy-notice strong {
            color: var(--gold-hover);
        }

        /* --- VÙNG CHỨA NỘI DUNG ĐÁNH GIÁ --- */
        .review-container {
            background: var(--panel-bg);
            padding: 35px;
            border-radius: 16px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.4);
            border: 1px solid var(--border-color);
        }

        .review-header-title {
            color: #fff;
            margin: 0 0 20px 0;
            font-size: 1.25rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 15px;
        }

        .review-header-title i {
            color: var(--gold-primary);
        }

        .review-list {
            margin-top: 20px;
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .review-item {
            background: var(--card-bg);
            padding: 20px;
            border-radius: 10px;
            border: 1px solid var(--border-color);
            border-left: 4px solid var(--gold-primary);
            transition: transform 0.2s ease;
        }

        .review-item:hover {
            transform: translateY(-2px);
            border-color: rgba(212, 175, 55, 0.3);
        }

        .reviewer-meta {
            font-weight: 700;
            color: var(--gold-hover);
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .reviewer-user {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.95rem;
        }

        .review-stars {
            font-size: 0.85rem;
            letter-spacing: 2px;
        }

        .review-text {
            margin: 0;
            line-height: 1.6;
            color: var(--text-main);
            font-size: 0.95rem;
            opacity: 0.9;
            padding-left: 26px;
        }

        .empty-reviews {
            text-align: center;
            padding: 40px 20px;
            color: var(--text-muted);
        }

        .empty-reviews i {
            font-size: 2.5rem;
            color: rgba(255,255,255,0.15);
            margin-bottom: 12px;
            display: block;
        }

        @media (max-width: 768px) {
            .room-hero-card { flex-direction: column; }
            .room-hero-image { width: 100%; height: 180px; }
            .room-hero-info { width: 100%; padding: 20px; }
        }
    </style>
</head>
<body>

<div class="page-container">
    <div class="back-box">
        <a href="room_list.jsp" class="btn-back">
            <i class="fa-solid fa-arrow-left"></i> Quay lại Danh sách phòng
        </a>
    </div>

    <%
        // Ưu tiên lấy roomNumber thực tế ("101", "103", "201",...) từ Controller
        Object roomNumberAttr = request.getAttribute("roomNumber");
        String currentRoomNumber = (roomNumberAttr != null && !roomNumberAttr.toString().trim().isEmpty())
                ? roomNumberAttr.toString()
                : null;

        // Fallback nếu Controller cũ truyền attribute tên "roomId"
        if (currentRoomNumber == null) {
            Object roomIdAttr = request.getAttribute("roomId");
            currentRoomNumber = (roomIdAttr != null) ? roomIdAttr.toString() : "101";
        }

        // Lấy roomType ("Standard", "Deluxe", "Suite VIP",...) từ Controller
        Object roomTypeAttr = request.getAttribute("roomType");
        String currentRoomType = (roomTypeAttr != null && !roomTypeAttr.toString().trim().isEmpty())
                ? roomTypeAttr.toString()
                : "VERDELLE LUXURY SUITE";

        List<ReviewModel> reviews = (List<ReviewModel>) request.getAttribute("reviews");
        int totalReviews = (reviews != null) ? reviews.size() : 0;
    %>

    <!-- HERO SHOWCASE CHO PHÒNG ĐANG XEM -->
    <div class="room-hero-card">
        <div class="room-hero-image">
            <img src="https://images.unsplash.com/photo-1618773928121-c32242e63f39?w=800" alt="Phòng <%= currentRoomNumber %>">
            <div class="room-hero-overlay"></div>
        </div>
        <div class="room-hero-info">
            <div class="room-badge">
                <i class="fa-solid fa-crown"></i> <%= currentRoomType %>
            </div>
            <h1 class="room-title">Phòng <%= currentRoomNumber %></h1>
            <div class="room-stats">
                <div class="stat-tag">
                    <i class="fa-solid fa-star" style="color: var(--gold-hover);"></i>
                    <strong>5.0</strong> / 5.0
                </div>
                <div class="stat-tag">
                    <i class="fa-solid fa-comments"></i>
                    <strong><%= totalReviews %></strong> Đánh giá
                </div>
                <div class="stat-tag">
                    <i class="fa-solid fa-shield-halved" style="color: #2ecc71;"></i>
                    Khách thực tế
                </div>
            </div>
        </div>
    </div>

    <!-- THÔNG BÁO CHÍNH SÁCH CHỐNG REVIEW BOMB -->
    <div class="review-policy-notice">
        <i class="fa-solid fa-shield-cat"></i>
        <div>
            <strong>Đánh giá đã qua xác thực:</strong> Để đảm bảo tính trung thực và ngăn chặn đánh giá ảo (Review Bombing), chỉ những khách hàng đã đặt phòng thành công và hoàn tất chuyến lưu trú tại <strong>Verdelle Luxury</strong> mới được phép gửi nhận xét.
        </div>
    </div>

    <!-- DANH SÁCH BÌNH LUẬN -->
    <div class="review-container">
        <div class="review-header-title">
            <i class="fa-solid fa-comments"></i> Nhận xét từ khách hàng (<%= totalReviews %>)
        </div>

        <div class="review-list">
            <%
                if (reviews == null || reviews.isEmpty()) {
            %>
            <div class="empty-reviews">
                <i class="fa-regular fa-comment-dots"></i>
                Chưa có lượt đánh giá nào cho Phòng <%= currentRoomNumber %>.
            </div>
            <%
            } else {
                for (ReviewModel r : reviews) {
                    StringBuilder stars = new StringBuilder();
                    for(int i = 0; i < r.rating; i++) {
                        stars.append("⭐");
                    }
            %>
            <div class="review-item">
                <div class="reviewer-meta">
                    <div class="reviewer-user">
                        <i class="fa-solid fa-circle-user" style="font-size: 1.2rem; color: var(--gold-primary);"></i>
                        <%= r.customerName %>
                    </div>
                    <div class="review-stars"><%= stars.toString() %></div>
                </div>
                <p class="review-text"><%= r.comment %></p>
            </div>
            <%
                    }
                }
            %>
        </div>
    </div>
</div>

</body>
</html>