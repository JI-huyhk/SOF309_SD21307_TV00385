<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quên mật khẩu - Verdelle Hotel</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/FooterStyle.css">
</head>
<body>
<div class="overlay">
    <nav class="navbar">
        <div class="logo">
            <span class="hotel-title">VERDELLE</span>
            <span class="hotel-sub">Hotel</span>
        </div>
    </nav>

    <main class="main-content">
        <div class="login-card">
            <h2>Forgot Password</h2>
            <p style="font-size: 0.9rem; color: #666; margin-bottom: 20px; text-align: center;">Điền email tài khoản của cậu vào đây, tụi mình sẽ gửi một đường link đặt lại mật khẩu bí mật nhé! 🌸</p>

            <form action="ForgotPasswordController" method="POST">
                <input type="hidden" name="action" value="requestToken">
                <div class="input-group">
                    <i class="fa-solid fa-envelope icon"></i>
                    <input type="email" placeholder="Nhập Email của cậu" name="email" required>
                </div>
                <button type="submit" class="btn-login">GỬI LINK XÁC THỰC</button>
            </form>

            <p class="signup-text" style="margin-top: 20px;"><a href="index.jsp"><i class="fa-solid fa-arrow-left"></i> Quay lại Đăng nhập</a></p>
        </div>
    </main>
    <jsp:include page="footer.jsp" />
</div>
</body>
</html>