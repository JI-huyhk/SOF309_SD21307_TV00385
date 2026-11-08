<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đánh Giá Dịch Vụ | Verdelle Hotel</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HeaderStyle.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding-top: 100px;
            background-color: #121212;
            color: #fff;
            margin: 0;
            background-image: radial-gradient(circle at center top, #2a2211 0%, #121212 60%);
            min-height: 100vh;
        }

        .review-card {
            max-width: 650px;
            margin: 40px auto;
            background: rgba(20, 20, 20, 0.9);
            backdrop-filter: blur(15px);
            padding: 40px;
            border-radius: 16px;
            border: 1px solid #dfb76c;
            box-shadow: 0 15px 50px rgba(0,0,0,0.9), 0 0 20px rgba(223, 183, 108, 0.2);
            text-align: center;
        }

        .review-title {
            color: #dfb76c;
            font-size: 1.8rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 8px;
        }

        .booking-info-box {
            background: rgba(255, 255, 255, 0.04);
            border-radius: 8px;
            padding: 15px;
            margin: 20px 0 30px;
            border: 1px dashed rgba(223, 183, 108, 0.4);
            display: flex;
            justify-content: space-around;
        }

        .booking-info-item span { color: #888; font-size: 0.85rem; display: block; margin-bottom: 3px; }
        .booking-info-item strong { color: #ffca28; font-size: 1.1rem; }

        .star-rating {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin: 25px 0;
            font-size: 2.5rem;
            color: #444;
            cursor: pointer;
        }

        .star-rating i {
            transition: all 0.2s ease-in-out;
        }

        .star-rating i.active, .star-rating i:hover {
            color: #ffca28;
            text-shadow: 0 0 15px rgba(255, 202, 40, 0.8);
            transform: scale(1.15);
        }

        .rating-desc {
            font-size: 1rem;
            color: #dfb76c;
            font-weight: bold;
            height: 24px;
            margin-bottom: 20px;
        }

        .textarea-group {
            text-align: left;
            margin-bottom: 30px;
        }

        .textarea-group label {
            display: block;
            margin-bottom: 8px;
            color: #ccc;
            font-size: 0.95rem;
        }

        .textarea-group textarea {
            width: 100%;
            height: 120px;
            background: rgba(0, 0, 0, 0.6);
            border: 1px solid #444;
            border-radius: 8px;
            padding: 12px 15px;
            color: #fff;
            font-family: inherit;
            font-size: 0.95rem;
            resize: vertical;
            outline: none;
            box-sizing: border-box;
            transition: border-color 0.3s;
        }

        .textarea-group textarea:focus {
            border-color: #dfb76c;
            box-shadow: 0 0 10px rgba(223, 183, 108, 0.3);
        }

        .btn-submit-review {
            background: linear-gradient(135deg, #dfb76c, #c89b3c);
            color: #000;
            border: none;
            padding: 14px 40px;
            border-radius: 30px;
            font-size: 1.1rem;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 5px 20px rgba(223, 183, 108, 0.4);
            width: 100%;
        }

        .btn-submit-review:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(223, 183, 108, 0.7);
        }

        .btn-back {
            display: inline-block;
            margin-top: 20px;
            color: #aaa;
            text-decoration: none;
            font-size: 0.9rem;
            transition: 0.3s;
        }
        .btn-back:hover { color: #dfb76c; }
    </style>
</head>
<body>
<jsp:include page="header.jsp" />

<div class="review-card">
    <h2 class="review-title"><i class="fa-solid fa-star-half-stroke"></i> Đánh Giá Dịch Vụ</h2>
    <p style="color: #aaa; font-size: 0.95rem;">Cảm ơn bạn đã lựa chọn Verdelle Hotel! Ý kiến đóng góp của bạn rất quan trọng đối với chúng tôi.</p>

    <div class="booking-info-box">
        <div class="booking-info-item">
            <span>Mã Đặt Phòng</span>
            <strong>${param.bookingCode != null ? param.bookingCode : '---'}</strong>
        </div>
        <div class="booking-info-item">
            <span>Số Phòng</span>
            <strong>R-${param.roomId != null ? param.roomId : '---'}</strong>
        </div>
    </div>

    <form id="reviewForm">
        <input type="hidden" name="bookingId" value="${param.bookingId}">
        <input type="hidden" name="bookingCode" value="${param.bookingCode}">
        <input type="hidden" name="roomId" value="${param.roomId}">
        <input type="hidden" id="ratingInput" name="rating" value="5">

        <div class="star-rating" id="starContainer">
            <i class="fa-solid fa-star active" data-value="1"></i>
            <i class="fa-solid fa-star active" data-value="2"></i>
            <i class="fa-solid fa-star active" data-value="3"></i>
            <i class="fa-solid fa-star active" data-value="4"></i>
            <i class="fa-solid fa-star active" data-value="5"></i>
        </div>

        <div class="rating-desc" id="ratingDesc">Tuyệt vời - Rất hài lòng!</div>

        <div class="textarea-group">
            <label for="comment"><i class="fa-solid fa-pen-to-square"></i> Nhận xét chi tiết:</label>
            <textarea id="comment" name="comment" placeholder="Hãy chia sẻ cảm nhận của bạn về chất lượng phòng, không gian, thái độ phục vụ..."></textarea>
        </div>

        <button type="submit" class="btn-submit-review" id="btnSubmit">
            <i class="fa-solid fa-paper-plane"></i> Gửi Đánh Giá
        </button>
    </form>

    <a href="${pageContext.request.contextPath}/ActivityController" class="btn-back">
        <i class="fa-solid fa-arrow-left"></i> Quay lại lịch sử đặt phòng
    </a>
</div>

<script>
    const stars = document.querySelectorAll('#starContainer i');
    const ratingInput = document.getElementById('ratingInput');
    const ratingDesc = document.getElementById('ratingDesc');
    const descText = {
        1: "Rất không hài lòng",
        2: "Cần cải thiện nhiều",
        3: "Tạm ổn",
        4: "Rất tốt - Hài lòng",
        5: "Tuyệt vời - Rất hài lòng!"
    };

    stars.forEach(star => {
        star.addEventListener('click', function() {
            const val = parseInt(this.getAttribute('data-value'));
            ratingInput.value = val;
            ratingDesc.innerText = descText[val];

            stars.forEach((s, idx) => {
                if (idx < val) {
                    s.classList.add('active');
                } else {
                    s.classList.remove('active');
                }
            });
        });
    });

    document.getElementById('reviewForm').addEventListener('submit', function(e) {
        e.preventDefault();

        const btn = document.getElementById('btnSubmit');
        btn.disabled = true;
        btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Đang gửi...';

        const formData = new URLSearchParams(new FormData(this));

        fetch('${pageContext.request.contextPath}/SubmitReviewController', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
            body: formData.toString()
        })
            .then(response => {
                if (response.ok) {
                    alert('Cảm ơn bạn! Đánh giá phòng của bạn đã được ghi nhận thành công.');
                    window.location.href = '${pageContext.request.contextPath}/ActivityController';
                } else if (response.status === 401) {
                    alert('Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại!');
                    window.location.href = 'login.jsp';
                } else {
                    alert('Có lỗi xảy ra trong quá trình lưu đánh giá. Vui lòng thử lại!');
                    btn.disabled = false;
                    btn.innerHTML = '<i class="fa-solid fa-paper-plane"></i> Gửi Đánh Giá';
                }
            })
            .catch(err => {
                console.error(err);
                alert('Lỗi kết nối máy chủ!');
                btn.disabled = false;
                btn.innerHTML = '<i class="fa-solid fa-paper-plane"></i> Gửi Đánh Giá';
            });
    });
</script>
</body>
</html>