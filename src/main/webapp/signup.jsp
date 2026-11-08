<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %> <!-- TỚ ĐÃ THÊM THƯ VIỆN JSTL Ở ĐÂY -->
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Sign Up - Verdelle Hotel</title> <!-- Đã sửa tiêu đề -->
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/FooterStyle.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* CSS MODAL OTP XINH XẮN */
        .otp-modal {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.6);
            z-index: 9999;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .otp-box {
            background: #fff;
            padding: 30px;
            border-radius: 15px;
            width: 380px;
            text-align: center;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.2);
            animation: fadeIn 0.3s ease;
            color: #333;
        }

        .otp-box h3 {
            color: #0097a7;
            margin-bottom: 15px;
            font-size: 1.4rem;
        }

        .otp-input-container input {
            width: 85%;
            padding: 12px 10px;
            font-size: 1.1rem;
            text-align: center;
            letter-spacing: 3px;
            border: 1.5px solid #0097a7;
            border-radius: 8px;
            outline: none;
            margin: 15px 0;
            box-sizing: border-box;
        }

        .otp-input-container input:focus {
            border-color: #007a87;
            box-shadow: 0 0 5px rgba(0, 151, 167, 0.2);
        }

        .timer-text {
            font-size: 0.9rem;
            color: #666;
            margin-bottom: 10px;
        }

        #timer {
            color: #ff4d4d;
            font-weight: bold;
        }

        .btn-verify {
            background: #0097a7;
            color: #fff;
            border: none;
            padding: 10px 20px;
            font-weight: bold;
            border-radius: 5px;
            cursor: pointer;
            width: 100%;
            margin-top: 10px;
        }

        .btn-resend {
            background: none;
            border: none;
            color: #0097a7;
            cursor: pointer;
            font-size: 0.85rem;
            text-decoration: underline;
            margin-bottom: 15px;
        }

        .btn-resend:disabled {
            color: #ccc;
            cursor: not-allowed;
            text-decoration: none;
        }

        .btn-cancel-modal {
            display: block;
            margin-top: 10px;
            font-size: 0.85rem;
            color: #888;
            text-decoration: none;
        }

        @keyframes fadeIn {
            from {
                transform: scale(0.9);
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
            <li><a href="index.jsp">Trang chủ</a></li>
            <li><a href="#">Phòng</a></li>
            <li><a href="#">Liên hệ</a></li>
            <li><a href="index.jsp" class="btn-sign">Đặng nhập</a></li>
        </ul>
    </nav>

    <main class="main-content">
        <h1 class="welcome-title">Welcome to our website</h1>

        <div class="login-card">
            <h2>Đăng ký</h2>

            <form action="RegisterController" method="POST">

                <%-- Đã dọn dẹp lại khối if-else hiển thị lỗi gọn gàng và không bị hở thẻ --%>
                <% String errorParam = request.getParameter("error");
                    if ("1".equals(errorParam)) { %>
                <p style="color: #ff4d4d; font-size: 0.85rem; margin-bottom: 15px; font-weight: bold; text-align: center;">
                    Đăng ký thất bại! Số điện thoại đã được sử dụng.
                </p>
                <% } else if ("passwordMismatch".equals(errorParam)) { %>
                <p style="color: #ff4d4d; font-size: 0.85rem; margin-bottom: 15px; font-weight: bold; text-align: center;">
                    Mật khẩu xác nhận không trùng khớp! Vui lòng nhập lại.
                </p>
                <% } %>

                <div id="error-message"
                     style="display: none; color: #ff4d4d; font-size: 0.85rem; margin-bottom: 15px; font-weight: bold; text-align: center;">
                </div>

                <div class="floating-group">
                    <input type="text" id="ten" name="firstName" placeholder=" " required>
                    <label for="ten">Tên</label>
                </div>

                <div class="floating-group">
                    <input type="text" id="ho" name="lastName" placeholder=" " required>
                    <label for="ho">Họ</label>
                </div>

                <div class="floating-group">
                    <input type="email" id="email" name="email" placeholder=" " required>
                    <label for="email">Địa chỉ Email</label>
                </div>

                <div class="floating-group">
                    <input type="password" id="password" name="password" placeholder=" " required>
                    <label for="password">Mật khẩu</label>
                </div>

                <div class="floating-group">
                    <input type="password" id="confirmPassword" name="confirmPassword" placeholder=" " required>
                    <label for="confirmPassword">Xác thực mật khẩu</label>
                </div>

                <div class="row-group">
                    <div class="floating-group country-box">
                        <select id="country" name="country" required>
                            <option value="+84" selected>+ 84</option>
                            <option value="+1">+ 1</option>
                            <option value="+81">+ 81</option>
                        </select>
                    </div>

                    <div class="floating-group phone-box">
                        <input type="tel" id="phone" name="phone" placeholder=" " required>
                        <label for="phone">Số điện thoại</label>
                    </div>
                </div>

                <button type="submit" class="btn-continue">Tiếp tục</button>

                <div class="terms-group">
                    <input type="checkbox" id="terms" required>
                    <label for="terms">
                        Tôi đồng ý với các điều khoản và chính sách bảo mật của Verdelle Hotel.
                    </label>
                </div>
            </form>
        </div>
    </main>
    <jsp:include page="footer.jsp"/>
    <div id="otpModal" class="otp-modal" style="${openOTPModal ? 'display: flex;' : 'display: none;'}">
        <div class="otp-box">
            <h3><i class="fa-solid fa-shield-halved"></i> Xác thực Email</h3>
            <p>Hệ thống đã gửi mã OTP gồm 6 chữ số đến địa chỉ email: <br><strong
                    style="color: #0097a7;">${sessionScope.tempEmail}</strong></p>

            <form action="VerifyOTPController" method="POST">
                <div class="otp-input-container">
                    <input type="text" name="otpInput" maxlength="6" placeholder="Nhập 6 số tại đây" required
                           autocomplete="off">
                </div>

                <div id="countdown-timer" class="timer-text">Mã hiệu lực còn: <span id="timer">120</span>s</div>

                <!-- Đã sửa lỗi type chính tả chữ classs thành class -->
                <button type="button" id="btnResend" class="btn-resend" onclick="resendOTP()">Gửi lại mã</button>

                <div class="modal-buttons">
                    <button type="submit" class="btn-verify">XÁC NHẬN</button>
                    <a href="signup.jsp" class="btn-cancel-modal">Hủy bỏ</a>
                </div>
            </form>

            <c:if test="${not empty otpError}">
                <p style="color: #ff4d4d; font-size: 0.85rem; margin-top: 10px; font-weight: bold;">${otpError}</p>
            </c:if>
        </div>
    </div>
</div>
<script>
    let countdownInterval;

    if (document.getElementById('otpModal').style.display === 'flex') {
        startCountdown(120);
    }

    function startCountdown(seconds) {
        if (countdownInterval) {
            clearInterval(countdownInterval);
        }

        let timeLeft = seconds;
        const timerSpan = document.getElementById('timer');
        const timerDiv = document.getElementById('countdown-timer');

        timerDiv.innerHTML = 'Mã hiệu lực còn: <span id="timer">' + timeLeft + '</span>s';

        countdownInterval = setInterval(() => {
            timeLeft--;

            const currentTimerSpan = document.getElementById('timer');
            if (currentTimerSpan) {
                currentTimerSpan.textContent = timeLeft;
            }

            if (timeLeft <= 0) {
                clearInterval(countdownInterval);
                timerDiv.innerHTML = "<span style='color: #ff4d4d;'>⚠️ Mã OTP này đã hết hạn! Vui lòng ấn Gửi lại mã.</span>";
            }
        }, 1000);
    }

    function resendOTP() {
        fetch('ResendOTPController', {method: 'POST'})
            .then(response => response.text())
            .then(data => {
                if (data === "success") {
                    alert("✉️ Mã OTP mới đã được gửi thành công vào Email của bạn!");
                    startCountdown(120);
                } else {
                    alert("❌ Gửi lại mã thất bại! Vui lòng thử lại sau.");
                }
            })
            .catch(err => alert("Có lỗi xảy ra trong quá trình gửi lại mã."));
    }

    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.has('error') && urlParams.get('error') === 'duplicateEmailRegister') {
        const errorDiv = document.getElementById('error-message');
        errorDiv.textContent = "Email này đã được đăng ký trên hệ thống rồi nè! Cậu thử dùng Email khác nha. 🌸";
        errorDiv.style.display = 'block';
    }
</script>
</body>
</html>