<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Profile - Verdelle Hotel</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/profileStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/NavStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/FooterStyle.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<jsp:include page="header2.jsp" />

<div class="profile-container">

    <div class="profile-banner-top">
        <form action="${pageContext.request.contextPath}/profile/upload-banner" method="POST" enctype="multipart/form-data" id="bannerForm">
            <div class="banner-wrapper" onclick="triggerBannerUpload()" title="Click để đổi ảnh bìa">
                <img src="${not empty sessionScope.bannerUrl ? pageContext.request.contextPath.concat('/').concat(sessionScope.bannerUrl) : 'https://images.alphacoders.com/114/1141777.jpg'}" alt="Banner" class="hutao-banner-img" id="bannerPreview">
                <div class="banner-overlay">
                    <i class="fa-solid fa-camera"></i> Đổi ảnh nền
                </div>
            </div>
            <input type="file" name="bannerFile" id="bannerInput" accept="image/*" onchange="previewAndSubmitBanner()">
        </form>
    </div>

    <div class="profile-body-layout">
        <div class="profile-sidebar-info">
            <div class="avatar-container-block">
                <form action="${pageContext.request.contextPath}/profile/upload-avatar" method="POST" enctype="multipart/form-data" id="avatarForm">
                    <div class="avatar-wrapper" onclick="triggerAvatarUpload()" title="Click để đổi ảnh đại diện">
                        <img src="${not empty sessionScope.avatarUrl ? pageContext.request.contextPath.concat('/').concat(sessionScope.avatarUrl) : 'https://i.pinimg.com/736x/f5/95/92/f59592a832c3c6f4995a94747a7590d9.jpg'}" alt="Avatar" class="profile-avatar" id="avatarPreview">
                        <div class="avatar-overlay">
                            <i class="fa-solid fa-camera"></i>
                        </div>
                    </div>
                    <input type="file" name="avatarFile" id="avatarInput" accept="image/*" onchange="previewAndSubmitAvatar()">
                </form>
            </div>

            <h2 class="profile-name">
                <c:out value="${sessionScope.user.lastName}" /> <c:out value="${sessionScope.user.firstName}" />
            </h2>

            <hr class="divider" style="margin-top: 15px;">
            <button type="button" class="btn-edit-profile">Edit Profile</button>
        </div>

        <div class="profile-main-content">
            <form action="${pageContext.request.contextPath}/profile" method="POST">
                <div class="input-group">
                    <label class="input-label">Email</label>
                    <input type="email" name="email" value="<c:out value="${sessionScope.user.email}" default="ExampleEmail@gmail.com" />">
                </div>

                <div class="input-group">
                    <label class="input-label">Mobile</label>
                    <input type="text" name="mobile" value="<c:out value="${sessionScope.user.phoneNumber}" default="Chưa cập nhật" />">
                </div>

                <div class="input-group readonly-group">
                    <label class="input-label">Account Role</label>
                    <input type="text" name="role" value="<c:out value="${sessionScope.user.role}" default="Customer" />" readonly>
                </div>

                <div class="input-group password-group">
                    <label class="input-label">Password</label>
                    <div class="password-wrapper">
                        <input type="password" id="passInput" name="password" value="<c:out value="${sessionScope.user.password}" />" readonly>
                        <a href="#" class="edit-password-link" onclick="enablePassword(event)">Edit</a>
                    </div>
                </div>

                <div class="social-networks-box">
                    <span class="social-title">Social Networks</span>
                    <div class="social-item">
                        <i class="fa-brands fa-facebook facebook-icon"></i>
                        <span class="social-text">Facebook.com/<c:out value="${sessionScope.user.firstName}" default="VerdelleMintha" /></span>
                        <i class="fa-solid fa-circle-check verified-icon"></i>
                    </div>
                    <div class="social-item">
                        <i class="fa-solid fa-envelope mail-icon"></i>
                        <span class="social-text"><c:out value="${sessionScope.user.email}" default="VerdelleMintha@gmail.com" /></span>
                        <i class="fa-solid fa-circle-check verified-icon"></i>
                    </div>
                    <div class="social-item">
                        <i class="fa-brands fa-instagram instagram-icon"></i>
                        <span class="social-text">MintCosplay</span>
                        <i class="fa-solid fa-circle-check verified-icon"></i>
                    </div>
                </div>

                <button type="submit" class="btn-save">Save Changes</button>
            </form>

            <form action="${pageContext.request.contextPath}/logout" method="POST" style="margin-top: 15px;">
                <button type="submit" class="btn-signout">Sign out</button>
            </form>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />

<script>
    function enablePassword(e) {
        e.preventDefault();
        var passInput = document.getElementById("passInput");
        passInput.readOnly = false;
        passInput.value = "";
        passInput.focus();
    }

    function triggerAvatarUpload() {
        document.getElementById('avatarInput').click();
    }
    function previewAndSubmitAvatar() {
        var fileInput = document.getElementById('avatarInput');
        var file = fileInput.files[0];
        if (file) {
            var reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById('avatarPreview').setAttribute('src', e.target.result);
                if(document.getElementById('navAvatarPreview')) {
                    document.getElementById('navAvatarPreview').setAttribute('src', e.target.result);
                }
            }
            reader.readAsDataURL(file);
            document.getElementById('avatarForm').submit();
        }
    }

    document.addEventListener("DOMContentLoaded", function() {
        const hamburgerBtn = document.getElementById('hamburgerBtn');
        const hamburgerMenu = document.getElementById('hamburgerMenu');
        const themeToggleBtn = document.getElementById('themeToggleBtn');
        const toggleIcon = document.getElementById('toggleIcon');

        if (hamburgerBtn && hamburgerMenu) {
            hamburgerBtn.addEventListener('click', function(e) {
                e.stopPropagation();
                hamburgerMenu.classList.toggle('show');
                hamburgerMenu.classList.toggle('active');
                hamburgerMenu.style.display = hamburgerMenu.classList.contains('show') ? 'block' : 'none';
            });

            document.addEventListener('click', function() {
                if(hamburgerMenu) {
                    hamburgerMenu.classList.remove('show', 'active');
                    hamburgerMenu.style.display = 'none';
                }
            });
        }

        if (themeToggleBtn) {
            if (localStorage.getItem('theme') === 'dark') {
                document.body.classList.add('dark-mode');
                if(toggleIcon) toggleIcon.className = "fa-solid fa-toggle-on";
            }

            themeToggleBtn.addEventListener('click', function(e) {
                e.stopPropagation();
                document.body.classList.toggle('dark-mode');

                if (document.body.classList.contains('dark-mode')) {
                    localStorage.setItem('theme', 'dark');
                    if(toggleIcon) toggleIcon.className = "fa-solid fa-toggle-on";
                } else {
                    localStorage.setItem('theme', 'light');
                    if(toggleIcon) toggleIcon.className = "fa-solid fa-toggle-off";
                }
            });
        }
    });

    function triggerBannerUpload() {
        document.getElementById('bannerInput').click();
    }
    function previewAndSubmitBanner() {
        var fileInput = document.getElementById('bannerInput');
        var file = fileInput.files[0];
        if (file) {
            var reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById('bannerPreview').setAttribute('src', e.target.result);
            }
            reader.readAsDataURL(file);
            document.getElementById('bannerForm').submit();
        }
    }
</script>

<c:if test="${not empty sessionScope.updateStatus}">
    <div id="toastNotice" class="toast-success-box">
        <i class="fa-solid fa-circle-check" style="font-size: 18px;"></i>
        <span>Thay đổi thông tin hồ sơ thành công rồi nhé! ✨</span>
    </div>

    <script>
        setTimeout(function() {
            var toast = document.getElementById('toastNotice');
            if (toast) {
                toast.style.opacity = '0';
                toast.style.transform = 'translateY(-10px)';
                setTimeout(function() { toast.remove(); }, 400);
            }
        }, 3000);
    </script>
    <c:remove var="updateStatus" scope="session" />
</c:if>
</body>
</html>