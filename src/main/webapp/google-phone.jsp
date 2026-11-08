<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hoàn tất đăng ký - Verdelle Hotel</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="overlay" style="display: flex; justify-content: center; align-items: center; height: 100vh;">
    <div class="login-card" style="margin-top: 0;">
        <h2><i class="fa-solid fa-link" style="color: #0097a7;"></i> Bước cuối cùng</h2>
        <p style="font-size: 0.9rem; color: #555; margin-bottom: 20px; text-align: center;">
            Chào <strong>${sessionScope.ggFirstName}</strong>, vui lòng bổ sung số điện thoại để hoàn tất liên kết tài khoản Google nhé!
        </p>

        <form action="GoogleFinishRegisterController" method="POST">
            <div class="input-group">
                <i class="fa-solid fa-phone icon"></i>
                <input type="tel" placeholder="Nhập số điện thoại của bạn" name="phone" required autocomplete="off">
            </div>

            <button type="submit" class="btn-login" style="background-color: #0097a7;">HOÀN TẤT ĐĂNG KÝ</button>
        </form>
    </div>
</div>
</body>
</html>