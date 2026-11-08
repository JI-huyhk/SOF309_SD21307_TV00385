<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/HeaderStyle.css">

<style>
    /* 1. Ép thanh navbar dàn đều 2 bên góc màn hình và ĐỔI NỀN ĐEN */
    nav.navbar {
        position: fixed !important;
        top: 0 !important;
        left: 0 !important;
        width: 100% !important;
        z-index: 99999 !important;
        background-color: #000000 !important; /* Đã đổi từ trong suốt thành ĐEN TUYỀN */
        display: flex !important;
        justify-content: space-between !important;
        align-items: center !important;
        padding: 16px 50px !important; /* Thu gọn khoảng cách một chút cho tinh tế */
        box-sizing: border-box !important;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.4) !important; /* Tạo vệt đổ bóng nhẹ tách biệt với banner */
        transition: background-color 0.3s ease-in-out, padding 0.3s ease-in-out !important;
    }

    /* Khi lướt màn hình xuống -> Đổi nền đen */
    nav.navbar.navbar-scrolled {
        background-color: #000000 !important;
        padding: 12px 50px !important;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.5) !important;
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

    /* Định dạng nút bấm dropdown cho đồng bộ */
    .admin-dropdown-btn {
        background-color: transparent !important;
        color: #ffffff !important;
        border: none !important;
        cursor: pointer !important;
        font-size: 0.95rem !important;
        padding: 0 !important;
        transition: color 0.2s ease;
    }

    /* 2. KHÓA CHẶT LAYOUT CHO ADMIN SUBMENU (Sửa lỗi tự hiển thị & vỡ chữ) */
    nav.navbar ul li .admin-submenu {
        display: none !important; /* KHÓA ẨN TUYỆT ĐỐI: Ngăn chặn tự động mở ra lúc vừa load trang */
        position: absolute !important;
        top: 100% !important;
        left: 0 !important;
        background-color: #ffffff !important; /* Buộc phải có nền trắng */
        min-width: 210px !important; /* Tăng nhẹ để chứa đủ chữ không bị chật */
        box-shadow: 0 8px 16px rgba(0,0,0,0.2) !important;
        padding: 10px 0 !important;
        margin: 5px 0 0 0 !important;
        list-style: none !important;
        border-radius: 4px !important;
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
        display: flex !important;          /* Dùng flex để icon và chữ nằm thẳng hàng */
        align-items: center !important;    /* Căn giữa icon và chữ theo chiều dọc */
        gap: 10px !important;              /* Khoảng cách giữa icon và text */
        width: 100% !important;
        padding: 10px 15px !important;
        color: #333333 !important;         /* Chữ màu tối trên nền trắng */
        text-decoration: none !important;
        font-size: 0.85rem !important;
        box-sizing: border-box !important;
        text-align: left !important;
        white-space: nowrap !important;    /* CHỐNG VỠ CHỮ: Không cho chữ tự động rớt dòng xuống dưới */
    }

    .admin-submenu li a:hover {
        background-color: #f5f5f5 !important;
    }

    /* 3. KHÓA CHẶT LAYOUT CHO HAMBURGER DROPDOWN (Sửa lỗi tự hiển thị & vỡ chữ) */
    nav.navbar ul li .hamburger-dropdown {
        display: none !important; /* KHÓA ẨN TUYỆT ĐỐI: Ngăn chặn tự động mở ra lúc vừa load trang */
        position: absolute !important;
        top: 100% !important;
        right: 0 !important; /* Căn lề bên phải sát nút ba gạch */
        background-color: #ffffff !important;
        min-width: 210px !important;
        box-shadow: 0 8px 16px rgba(0,0,0,0.2) !important;
        padding: 10px 0 !important;
        margin: 5px 0 0 0 !important;
        border-radius: 4px !important;
        z-index: 100000 !important;
    }

    /* Ép các thẻ liên kết bên trong Hamburger xếp hàng dọc */
    .hamburger-dropdown a,
    .hamburger-dropdown .menu-item {
        display: flex !important;
        align-items: center !important;
        gap: 10px !important;
        width: 100% !important;
        padding: 10px 15px !important;
        color: #333333 !important;
        text-decoration: none !important;
        font-size: 0.85rem !important;
        box-sizing: border-box !important;
        text-align: left !important;
        white-space: nowrap !important;    /* CHỐNG VỠ CHỮ: Khóa chặt chữ trên một hàng duy nhất */
    }

    .hamburger-dropdown a:hover,
    .hamburger-dropdown .menu-item:hover {
        background-color: #f5f5f5 !important;
    }

    /* Lớp kích hoạt hiển thị: CHỈ khi được JS kích hoạt thì mới biến thành block */
    nav.navbar ul li .admin-submenu.show,
    nav.navbar ul li .hamburger-dropdown.show {
        display: block !important;
    }
</style>

<nav class="navbar" id="mainNavbar">
    <div class="logo" onclick="location.href='${pageContext.request.contextPath}/home.jsp'" style="cursor: pointer;">
        <span style="color: #fff; font-weight: bold; font-size: 1.4rem; letter-spacing: 1px;">VERDELLE</span>
        <span style="color: #00bcd4; font-size: 0.85rem; display: block; margin-top: -4px;">Hotel</span>
    </div>

    <ul style="display: flex; list-style: none; gap: 30px; margin: 0; align-items: center; padding: 0;">
        <li><a href="${pageContext.request.contextPath}/ActivityController" style="color: #fff; text-decoration: none; font-size: 0.95rem;">Hoạt động</a></li>

        <li><a href="#" style="color: #fff; text-decoration: none; font-size: 0.95rem;">Liên hệ</a></li>

        <c:if test="${sessionScope.userRole == 'admin'}">
            <li class="admin-dropdown-container" style="position: relative;">
                <button class="admin-dropdown-btn" id="adminDropdownBtn">
                    Quản lý <i class="fa-solid fa-chevron-down" style="font-size: 0.7rem;"></i>
                </button>
                <ul class="admin-submenu" id="adminSubmenu">
                    <li>
                        <a href="${pageContext.request.contextPath}/quan-ly-tai-khoan">
                            <i class="fa-solid fa-users-gear" style="color: #00bcd4;"></i> Quản lý người dùng
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/quan-ly-hoa-hong">
                            <i class="fa-solid fa-comments-dollar" style="color: #ff9800;"></i> Quản lý hoa hồng
                        </a>
                    </li>
                </ul>
            </li>
        </c:if>

        <c:if test="${sessionScope.userRole == 'partner' || sessionScope.userRole == 'hotel partner'}">
            <li class="admin-dropdown-container" style="position: relative;">
                <button class="admin-dropdown-btn" id="partnerDropdownBtn" style="background-color: transparent; color: #fff; border: none; cursor: pointer; font-size: 0.95rem;">
                    Quản lý khách sạn <i class="fa-solid fa-chevron-down" style="font-size: 0.7rem;"></i>
                </button>
                <ul class="admin-submenu" id="partnerSubmenu">
                    <li>
                        <a href="${pageContext.request.contextPath}/quan-ly-phong">
                            <i class="fa-solid fa-bed" style="color: #4caf50;"></i> Quản lý danh sách phòng
                        </a>
                    </li>
                </ul>
            </li>
        </c:if>

        <c:choose>
            <c:when test="${not empty sessionScope.firstName}">
                <li class="user-profile-header">
                    <a href="${pageContext.request.contextPath}/profile" class="nav-user-profile-link" style="display: flex; align-items: center; gap: 8px; text-decoration: none;">
                        <img id="navAvatarPreview"
                             src="${not empty sessionScope.avatarUrl ? pageContext.request.contextPath.concat('/').concat(sessionScope.avatarUrl) : 'https://cdn-icons-png.flaticon.com/512/1144/1144760.png'}"
                             class="user-avatar-circle"
                             style="width: 30px; height: 30px; border-radius: 50%; object-fit: cover;"
                             alt="Avatar">
                        <div style="font-size: 0.85rem; color: #fff;">
                            <strong>${sessionScope.firstName}</strong>
                        </div>
                    </a>
                </li>
            </c:when>
            <c:otherwise>
                <li class="user-profile-header">
                    <a href="${pageContext.request.contextPath}/login.jsp" class="nav-user-profile-link">
                        <img src="https://cdn-icons-png.flaticon.com/512/1144/1144760.png" class="user-avatar-circle" style="width: 30px; height: 30px; border-radius: 50%; " alt="Default User">
                    </a>
                </li>
            </c:otherwise>
        </c:choose>

        <li class="hamburger-menu-container" style="position: relative;">
            <button class="hamburger-icon-btn" id="hamburgerBtn" aria-label="Menu" style="background: transparent; border: none; color: #fff; font-size: 1.1rem; cursor: pointer;">
                <i class="fa-solid fa-bars"></i>
            </button>
            <div class="hamburger-dropdown" id="hamburgerMenu">
                <a href="#">
                    <i class="fa-regular fa-comments" style="color: #00bcd4;"></i> Liên hệ CSKH
                </a>
                <a href="#">
                    <i class="fa-solid fa-gear" style="color: #7f8c8d;"></i> Cài đặt hệ thống
                </a>
                <div class="menu-item" id="themeToggleBtn" style="display: flex !important; justify-content: space-between; align-items: center; cursor: pointer;">
                    <span><i class="fa-regular fa-moon" style="color: #f1c40f;"></i> Đêm</span>
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
            } else {
                toggleIcon.className = "fa-solid fa-toggle-off";
            }
        }

        if (themeToggleBtn) {
            themeToggleBtn.addEventListener('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                const isDark = document.body.classList.toggle('dark-mode');
                if (isDark) {
                    localStorage.setItem('theme', 'dark');
                    if (toggleIcon) toggleIcon.className = "fa-solid fa-toggle-on";
                } else {
                    localStorage.setItem('theme', 'light');
                    if (toggleIcon) toggleIcon.className = "fa-solid fa-toggle-off";
                }
            });
        }

        // Logic toggle đóng mở sạch sẽ bằng click chuột, chặn đứng xung đột hiển thị
        if (adminDropdownBtn && adminSubmenu) {
            adminDropdownBtn.addEventListener('click', function(e) {
                e.stopPropagation();
                adminSubmenu.classList.toggle('show');
                if (partnerSubmenu) partnerSubmenu.classList.remove('show');
                if (hamburgerMenu) hamburgerMenu.classList.remove('show');
            });
        }

        if (partnerDropdownBtn && partnerSubmenu) {
            partnerDropdownBtn.addEventListener('click', function(e) {
                e.stopPropagation();
                partnerSubmenu.classList.toggle('show');
                if (adminSubmenu) adminSubmenu.classList.remove('show');
                if (hamburgerMenu) hamburgerMenu.classList.remove('show');
            });
        }

        if (hamburgerBtn && hamburgerMenu) {
            hamburgerBtn.addEventListener('click', function(e) {
                e.stopPropagation();
                hamburgerMenu.classList.toggle('show');
                if (adminSubmenu) adminSubmenu.classList.remove('show');
                if (partnerSubmenu) partnerSubmenu.classList.remove('show');
            });
        }

        // Click ra ngoài vùng Dropdown tự đóng gọn gàng
        document.addEventListener('click', function(e) {
            if (adminSubmenu && adminDropdownBtn && !adminDropdownBtn.contains(e.target)) {
                adminSubmenu.classList.remove('show');
            }
            if (partnerSubmenu && partnerDropdownBtn && !partnerDropdownBtn.contains(e.target)) {
                partnerSubmenu.classList.remove('show');
            }
            if (hamburgerMenu && !hamburgerBtn.contains(e.target) && !hamburgerMenu.contains(e.target)) {
                hamburgerMenu.classList.remove('show');
            }
        });
    });
</script>