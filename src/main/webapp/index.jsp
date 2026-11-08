<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trang chủ - Verdelle Hotel</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/FooterStyle.css">
    <style>
        .modal-reset {
            display: none; /* Mặc định ẩn đi */
            position: fixed;
            z-index: 9999;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.6); /* Làm tối nền phía sau */
            backdrop-filter: blur(5px); /* Thêm hiệu ứng mờ nền cho thơ mộng */
            justify-content: center;
            align-items: center;
        }

        .modal-reset-content {
            background: #fff;
            animation: popUpAnim 0.3s ease-in-out;
        }

        @keyframes popUpAnim {
            from {
                transform: scale(0.8);
                opacity: 0;
            }
            to {
                transform: scale(1);
                opacity: 1;
            }
        }
    </style>
</head>
<body>
<div class="overlay">

    <nav class="navbar">
        <div class="logo">
            <span class="hotel-title">VERDELLE</span>
            <span class="hotel-sub">Hotel</span>
        </div>
        <ul class="nav-links">
            <li><a href="index.jsp" class="active">Trang chủ</a></li>
            <li><a href="#">Phòng</a></li>
            <li><a href="#">Liên hệ</a></li>
            <li><a href="signup.jsp" class="btn-sign">Đăng ký</a></li>
        </ul>
    </nav>

    <main class="main-content">
        <h1 class="welcome-title">Welcome to our website</h1>

        <div class="login-card">
            <h2>Đăng nhập</h2>
            <form action="LoginController" method="POST">

                <div id="error-message"
                     style="display: none; color: #ff4d4d; font-size: 0.85rem; margin-bottom: 15px; font-weight: bold; text-align: center;">
                </div>

                <div id="success-message"
                     style="display: none; color: #4caf50; font-size: 0.85rem; margin-bottom: 15px; font-weight: bold; text-align: center;">
                </div>

                <div class="input-group">
                    <i class="fa-solid fa-phone icon"></i>
                    <input type="text" placeholder="Số điện thoại" name="phone" required>
                </div>

                <div class="input-group">
                    <i class="fa-solid fa-lock icon"></i>
                    <input type="password" placeholder="Mật khẩu" name="password">
                </div>

                <button type="submit" class="btn-login">Đăng nhập</button>
                <a href="forgotPassword.jsp" class="forgot-pwd">Quên mật khẩu?</a>
            </form>

            <p class="signup-text">Không có tài khoản? <a href="signup.jsp">Đăng ký</a></p>
            <div class="divider">
                <hr>
                <span>Hoặc</span>
                <hr>
            </div>
            <p class="social-text">Đăng nhập bằng mạng xã hội!</p>
            <div class="social-icons">
                <a href="https://accounts.google.com/o/oauth2/auth?client_id=919945983221-5dd3uvtnqlquvtuj9vrqrj6jcqemo6us.apps.googleusercontent.com&redirect_uri=http://localhost:8080/ASM2_JAV101_SD2001_war/GoogleLoginController&response_type=code&scope=email%20profile"
                   class="gg">
                    <i class="fa-brands fa-google"></i>
                </a>
            </div>
        </div>
    </main>
    <jsp:include page="footer.jsp"/>
</div>
<div id="reset-password-modal" class="modal-reset">
    <div class="login-card modal-reset-content">
        <h2>New Password</h2>
        <p style="font-size: 0.85rem; color: #666; text-align: center; margin-bottom: 20px;">Cậu nhập mật khẩu mới thật
            dễ nhớ vào đây nha! 🌸</p>

        <form action="ForgotPasswordController" method="POST">
            <input type="hidden" name="action" value="resetPassword">
            <input type="hidden" name="token" id="reset-token-field">

            <div class="input-group">
                <i class="fa-solid fa-key icon"></i>
                <input type="password" placeholder="Mật khẩu mới của cậu" name="newPassword" required>
            </div>

            <button type="submit" class="btn-login">CẬP NHẬT MẬT KHẨU</button>
        </form>
    </div>
</div>

<script>
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.has('error')) {
        const errorType = urlParams.get('error');
        const errorDiv = document.getElementById('error-message');

        if (errorType === 'wrongPassword') {
            errorDiv.textContent = "Thông tin không chính xác!";
        } else if (errorType === 'userNotFound') {
            errorDiv.textContent = "Thông tin không chính xác!";
        } else {
            errorDiv.textContent = "Đăng nhập thất bại! Vui lòng thử lại.";
        }

        errorDiv.style.display = 'block'; // Hiện file thông báo lỗi lên
    }
    // Kiểm tra nếu đăng ký tài khoản thành công chuyển hướng về
    if (urlParams.has('status') && urlParams.get('status') === 'emailSent') {
        const successDiv = document.getElementById('success-message');
        successDiv.textContent = "Link đặt lại mật khẩu đã được gửi vào hòm thư của cậu rồi nè! Mau check mail nha. 🌸";
        successDiv.style.display = 'block';
    }

    // 2. Khi nhập Email không tồn tại trên hệ thống (khớp với error=emailNotFound)
    if (urlParams.has('error') && urlParams.get('error') === 'emailNotFound') {
        const errorDiv = document.getElementById('error-message');
        errorDiv.textContent = "Email này chưa được đăng ký trên hệ thống của Verdelle mất rồi! Cậu kiểm tra lại nha.";
        errorDiv.style.display = 'block';
    }

    // 3. Khi server gặp lỗi gửi mail (khớp với error=emailSendFailed)
    if (urlParams.has('error') && urlParams.get('error') === 'emailSendFailed') {
        const errorDiv = document.getElementById('error-message');
        errorDiv.textContent = "Hệ thống gặp sự cố khi gửi mail, cậu thử lại sau hoặc kiểm tra lại kết nối mạng nha!";
        errorDiv.style.display = 'block';
    }

    // 4. Khi người dùng click link đổi mật khẩu thành công rực rỡ (khớp với status=resetSuccess)
    if (urlParams.has('status') && urlParams.get('status') === 'resetSuccess') {
        const successDiv = document.getElementById('success-message');
        successDiv.textContent = "Đặt lại mật khẩu mới thành công rực rỡ! Giờ cậu đăng nhập thử đi nè. ✨";
        successDiv.style.display = 'block';
    }

    // 5. Khi đường link xác thực bị hết hạn 15 phút hoặc sai token (khớp với error=tokenInvalidOrExpired)
    if (urlParams.has('error') && urlParams.get('error') === 'tokenInvalidOrExpired') {
        const errorDiv = document.getElementById('error-message');
        errorDiv.textContent = "Đường link xác thực đã hết hạn hoặc không hợp lệ mất rồi! Cậu vui lòng yêu cầu gửi lại link mới nha.";
        errorDiv.style.display = 'block';
    }
    // 6. Kiểm tra xem trên URL có yêu cầu hiển thị Pop-up đổi mật khẩu không
    if (urlParams.has('action') && urlParams.get('action') === 'showResetPopup') {
        const token = urlParams.get('token');
        if (token) {
            // Nạp cái mã token từ URL vào thẻ input ẩn trong form Pop-up
            document.getElementById('reset-token-field').value = token;
            // Đổi trạng thái hiển thị từ 'none' sang 'flex' để Pop-up hiện hình rực rỡ
            document.getElementById('reset-password-modal').style.display = 'flex';
        }
    }
    // 7. Khi cố tình truy cập trái phép vào trang Admin (khớp với error=unauthorized)
    if (urlParams.has('error') && urlParams.get('error') === 'unauthorized') {
        const errorDiv = document.getElementById('error-message');
        errorDiv.textContent = "Cậu không có quyền truy cập vào khu vực quản lý này đâu nè!";
        errorDiv.style.display = 'block';
    }
</script>
</body>
</html>