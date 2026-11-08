<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/HeaderStyle.css">

<style>
    /* ================= ĐỒNG BỘ TONE LUXURY GOLD & TỐI ================= */
    :root {
        --header-gold: #dfb76c;
        --header-gold-light: #f3e1bd;
        --header-bg-card: #141414;
        --header-border: #2a2418;
    }

    /* 1. Ép thanh navbar dàn đều 2 bên góc màn hình */
    nav.navbar {
        position: fixed !important;
        top: 0 !important;
        left: 0 !important;
        width: 100% !important;
        z-index: 99999 !important;
        background-color: transparent !important; /* Mặc định trong suốt trên banner */
        display: flex !important;
        justify-content: space-between !important;
        align-items: center !important;
        padding: 20px 50px !important;
        box-sizing: border-box !important;
        transition: background-color 0.3s ease-in-out, padding 0.3s ease-in-out !important;
    }

    /* Khi lướt màn hình xuống -> Đổi nền đen luxury */
    nav.navbar.navbar-scrolled {
        background-color: #0b0b0b !important;
        padding: 14px 50px !important;
        border-bottom: 1px solid var(--header-border) !important;
        box-shadow: 0 4px 25px rgba(0, 0, 0, 0.8) !important;
    }

    nav.navbar ul {
        display: flex !important;
        flex-direction: row !important;
        list-style: none !important;
        gap: 30px !important;
        margin: 0 !important;
        padding: 0 !important;
        align-items: center !important;
    }

    nav.navbar ul li a {
        transition: color 0.2s ease;
    }
    nav.navbar ul li a:hover {
        color: var(--header-gold) !important;
    }

    /* Đổi màu chữ nút bấm dropdown cho đồng bộ */
    .admin-dropdown-btn {
        background-color: transparent !important;
        color: #ffffff !important;
        border: none !important;
        cursor: pointer !important;
        font-size: 0.95rem !important;
        padding: 0 !important;
        transition: color 0.2s ease;
    }
    .admin-dropdown-btn:hover {
        color: var(--header-gold) !important;
    }
    .admin-dropdown-btn i {
        color: inherit !important; /* Chạy theo màu chữ cha */
    }

    /* 2. KHÓA CHẶT LAYOUT CHO ADMIN SUBMENU (Ẩn tuyệt đối, chống tự động hiện) */
    nav.navbar ul li .admin-submenu {
        display: none !important; /* KHÓA CHẶT ẨN: Ngăn chặn tuyệt đối việc tự động mở khi vừa load trang */
        position: absolute !important;
        top: 100% !important;
        left: 0 !important;
        background-color: var(--header-bg-card) !important;
        min-width: 230px !important;
        border: 1px solid var(--header-border) !important;
        box-shadow: 0 8px 32px rgba(0,0,0,0.7) !important;
        padding: 8px 0 !important;
        margin: 12px 0 0 0 !important;
        list-style: none !important;
        border-radius: 8px !important;
        z-index: 100000 !important;
    }

    /* Ép các mục bên trong menu Admin xếp hàng dọc gọn gàng */
    .admin-submenu li {
        display: block !important;
        width: 100% !important;
        padding: 0 !important;
        margin: 0 !important;
    }

    .admin-submenu li a {
        display: flex !important;
        align-items: center !important;
        gap: 10px !important;
        width: 100% !important;
        padding: 11px 20px !important;
        color: #ffffff !important;
        text-decoration: none !important;
        font-size: 0.88rem !important;
        box-sizing: border-box !important;
        text-align: left !important;
        white-space: nowrap !important;
        transition: all 0.2s ease;
    }

    .admin-submenu li a:hover {
        background-color: #222222 !important;
        color: var(--header-gold) !important;
    }

    /* 3. KHÓA CHẶT LAYOUT CHO HAMBURGER DROPDOWN (Ẩn tuyệt đối, chống tự động hiện) */
    nav.navbar ul li .hamburger-dropdown {
        display: none !important; /* KHÓA CHẶT ẨN: Ngăn chặn tuyệt đối việc tự động mở khi vừa load trang */
        position: absolute !important;
        top: 100% !important;
        right: 0 !important;
        background-color: var(--header-bg-card) !important;
        min-width: 220px !important;
        border: 1px solid var(--header-border) !important;
        box-shadow: 0 8px 32px rgba(0,0,0,0.7) !important;
        padding: 8px 0 !important;
        margin: 12px 0 0 0 !important;
        border-radius: 8px !important;
        z-index: 100000 !important;
    }

    /* Ép các thẻ liên kết bên trong Hamburger xếp hàng dọc và dàn ngang text */
    .hamburger-dropdown a,
    .hamburger-dropdown .menu-item {
        display: flex !important;
        align-items: center !important;
        gap: 10px !important;
        width: 100% !important;
        padding: 11px 20px !important;
        color: #ffffff !important;
        text-decoration: none !important;
        font-size: 0.88rem !important;
        box-sizing: border-box !important;
        text-align: left !important;
        white-space: nowrap !important;
        transition: all 0.2s ease;
    }

    .hamburger-dropdown a:hover,
    .hamburger-dropdown .menu-item:hover {
        background-color: #222222 !important;
        color: var(--header-gold) !important;
    }

    /* ĐÈ BẠT MẠNG CƯỠNG CHẾ: CHỈ KHI NHẤN VÀO (JS thêm class .show) thì mới được hiển thị block */
    nav.navbar ul li .admin-submenu.show,
    nav.navbar ul li .hamburger-dropdown.show {
        display: block !important;
    }

    /* Fix nút hamburger menu không bị lỗi màu */
    .hamburger-icon-btn {
        background: transparent !important;
        border: none !important;
        color: #fff !important;
        font-size: 1.1rem !important;
        cursor: pointer !important;
        transition: color 0.2s;
    }
    .hamburger-icon-btn:hover {
        color: var(--header-gold) !important;
    }

    /* ĐẢM BẢO AVATAR CÓ VÙNG BẤM RỘNG RÃI VÀ ĐÈ LÊN TRÊN HERO VIDEO */
    .nav-user-profile-link {
        display: flex !important;
        align-items: center !important;
        justify-content: center !important;
        cursor: pointer !important;
        position: relative !important;
        z-index: 100005 !important;
        text-decoration: none !important;
    }
</style>

<nav class="navbar" id="mainNavbar">
    <div class="logo" onclick="location.href='${pageContext.request.contextPath}/home.jsp'" style="cursor: pointer;">
        <span style="color: #fff; font-weight: bold; font-size: 1.4rem; letter-spacing: 1px;">VERDELLE</span>
        <span style="color: var(--header-gold); font-size: 0.85rem; display: block; margin-top: -4px; font-weight: 600;">Hotel</span>
    </div>

    <ul>
        <li><a href="${pageContext.request.contextPath}/ActivityController" style="color: #fff; text-decoration: none; font-size: 0.95rem;">Hoạt động</a></li>

        <li><a href="#" style="color: #fff; text-decoration: none; font-size: 0.95rem;">Liên hệ</a></li>

        <!-- SỬA ĐỔI CHÍNH XÁC PHẦN ĐIỀU HƯỚNG USER PROFILE Ở ĐÂY -->
        <c:choose>
            <c:when test="${not empty sessionScope.firstName}">
                <li class="user-profile-header">
                    <a href="${pageContext.request.contextPath}/profile.jsp" class="nav-user-profile-link" style="gap: 8px;">
                        <img id="navAvatarPreview"
                             src="${not empty sessionScope.avatarUrl ? pageContext.request.contextPath.concat('/').concat(sessionScope.avatarUrl) : 'https://cdn-icons-png.flaticon.com/512/1144/1144760.png'}"
                             class="user-avatar-circle"
                             style="width: 30px; height: 30px; border-radius: 50%; object-fit: cover; border: 1px solid var(--header-gold);"
                             alt="Avatar">
                        <div style="font-size: 0.85rem; color: #fff;">
                            <strong>${sessionScope.firstName}</strong>
                        </div>
                    </a>
                </li>
            </c:when>
            <c:otherwise>
                <li class="user-profile-header">
                    <a href="${pageContext.request.contextPath}/profile.jsp" class="nav-user-profile-link">
                        <img src="https://cdn-icons-png.flaticon.com/512/1144/1144760.png" class="user-avatar-circle" style="width: 30px; height: 30px; border-radius: 50%; border: 1px solid var(--header-gold);" alt="Default User">
                    </a>
                </li>
            </c:otherwise>
        </c:choose>

        <li class="hamburger-menu-container" style="position: relative;">
            <button class="hamburger-icon-btn" id="hamburgerBtn" aria-label="Menu">
                <i class="fa-solid fa-bars"></i>
            </button>
            <div class="hamburger-dropdown" id="hamburgerMenu">
                <a href="#">
                    <i class="fa-regular fa-comments" style="color: var(--header-gold) !important;"></i> Liên hệ CSKH
                </a>
                <a href="#">
                    <i class="fa-solid fa-gear" style="color: var(--header-gold) !important;"></i> Cài đặt hệ thống
                </a>
                <div class="menu-item" id="themeToggleBtn" style="display: flex !important; justify-content: space-between; align-items: center; cursor: pointer;">
                    <span><i class="fa-regular fa-moon" style="color: #f1c40f !important;"></i> Chế độ đêm</span>
                    <i class="fa-solid fa-toggle-off toggle-theme-switch" id="toggleIcon" style="color: #ccc; font-size: 1.2rem; margin: 0;"></i>
                </div>
            </div>
        </li>
    </ul>
</nav>

<script>
    if (localStorage.getItem('theme') === 'dark') {
        document.body.classList.add('dark-mode');
    } else {
        document.body.classList.remove('dark-mode');
    }

    document.addEventListener("DOMContentLoaded", function() {
        const navbarEl = document.getElementById('mainNavbar');
        const hamburgerBtn = document.getElementById('hamburgerBtn');
        const hamburgerMenu = document.getElementById('hamburgerMenu');
        const adminDropdownBtn = document.getElementById('adminDropdownBtn');
        const adminSubmenu = document.getElementById('adminSubmenu');
        const partnerDropdownBtn = document.getElementById('partnerDropdownBtn');
        const partnerSubmenu = document.getElementById('partnerSubmenu');
        const themeToggleBtn = document.getElementById('themeToggleBtn');
        const toggleIcon = document.getElementById('toggleIcon');

        // Bắt sự kiện cuộn chuột đổi màu
        window.addEventListener('scroll', function() {
            if (window.scrollY > 40) {
                if (navbarEl) navbarEl.classList.add('navbar-scrolled');
            } else {
                if (navbarEl) navbarEl.classList.remove('navbar-scrolled');
            }
        });

        if (toggleIcon) {
            if (localStorage.getItem('theme') === 'dark') {
                toggleIcon.className = "fa-solid fa-toggle-on";
                toggleIcon.style.color = "#dfb76c";
            } else {
                toggleIcon.className = "fa-solid fa-toggle-off";
                toggleIcon.style.color = "#ccc";
            }
        }

        if (themeToggleBtn) {
            themeToggleBtn.addEventListener('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                const isDark = document.body.classList.toggle('dark-mode');
                if (isDark) {
                    localStorage.setItem('theme', 'dark');
                    if (toggleIcon) {
                        toggleIcon.className = "fa-solid fa-toggle-on";
                        toggleIcon.style.color = "#dfb76c";
                    }
                } else {
                    localStorage.setItem('theme', 'light');
                    if (toggleIcon) {
                        toggleIcon.className = "fa-solid fa-toggle-off";
                        toggleIcon.style.color = "#ccc";
                    }
                }
            });
        }

        // Đóng mở cưỡng chế chính xác bằng click chuột, chặn đứng xung đột
        if (adminDropdownBtn && adminSubmenu) {
            adminDropdownBtn.addEventListener('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                adminSubmenu.classList.toggle('show');
                if (partnerSubmenu) partnerSubmenu.classList.remove('show');
                if (hamburgerMenu) hamburgerMenu.classList.remove('show');
            });
        }

        if (partnerDropdownBtn && partnerSubmenu) {
            partnerDropdownBtn.addEventListener('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                partnerSubmenu.classList.toggle('show');
                if (adminSubmenu) adminSubmenu.classList.remove('show');
                if (hamburgerMenu) hamburgerMenu.classList.remove('show');
            });
        }

        if (hamburgerBtn && hamburgerMenu) {
            hamburgerBtn.addEventListener('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                hamburgerMenu.classList.toggle('show');
                if (adminSubmenu) adminSubmenu.classList.remove('show');
                if (partnerSubmenu) partnerSubmenu.classList.remove('show');
            });
        }

        // Click ra ngoài vùng Dropdown tự đóng gọn gàng
        document.addEventListener('click', function(e) {
            if (adminSubmenu && adminDropdownBtn && !adminDropdownBtn.contains(e.target) && !adminSubmenu.contains(e.target)) {
                adminSubmenu.classList.remove('show');
            }
            if (partnerSubmenu && partnerDropdownBtn && !partnerDropdownBtn.contains(e.target) && !partnerSubmenu.contains(e.target)) {
                partnerSubmenu.classList.remove('show');
            }
            if (hamburgerMenu && !hamburgerBtn.contains(e.target) && !hamburgerMenu.contains(e.target)) {
                hamburgerMenu.classList.remove('show');
            }
        });
    });
</script>