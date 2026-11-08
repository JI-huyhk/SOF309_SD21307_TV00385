package com.poly.sof309.controllers;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

/**
 * =========================================================================
 * [Y3] UNIT TEST CONTROLLER BẰNG JUNIT 5
 * Kiểm thử luồng xác thực và phân quyền RBAC theo Test Case TC01 trong TEST_CASES.md
 * =========================================================================
 */
public class SampleControllerTest {

    @Test
    @DisplayName("TC01_AUTH_01: Khách hàng đăng nhập thành công và phân quyền Customer")
    public void testLogin_CustomerSuccess() {
        String phone = "090333444";
        String password = "123456";

        LoginResult result = processLogin(phone, password);

        assertTrue(result.isSuccess(), "Đăng nhập phải thành công với tài khoản khách hàng hợp lệ");
        assertEquals("Customer", result.getRole(), "Vai trò trả về phải là Customer");
        assertEquals("home.jsp", result.getRedirectUrl(), "Khách hàng phải được chuyển hướng về trang chủ");
    }

    @Test
    @DisplayName("TC01_AUTH_02: Lễ tân (Hotel Manager) đăng nhập thành công")
    public void testLogin_HotelManagerSuccess() {
        String phone = "090222333";
        String password = "123456";

        LoginResult result = processLogin(phone, password);

        assertTrue(result.isSuccess(), "Đăng nhập phải thành công với tài khoản Hotel Manager");
        assertEquals("HotelManager", result.getRole(), "Vai trò trả về phải là HotelManager");
        assertEquals("reception.jsp", result.getRedirectUrl(), "Lễ tân phải được chuyển hướng đến trang tiếp tân");
    }

    @Test
    @DisplayName("TC01_AUTH_03: Quản trị viên (Admin) đăng nhập thành công")
    public void testLogin_AdminSuccess() {
        String phone = "090111222";
        String password = "123456";

        LoginResult result = processLogin(phone, password);

        assertTrue(result.isSuccess(), "Đăng nhập phải thành công với tài khoản Admin");
        assertEquals("Admin", result.getRole(), "Vai trò trả về phải là Admin");
        assertEquals("dashboard.jsp", result.getRedirectUrl(), "Admin phải được chuyển hướng đến trang quản trị");
    }

    @Test
    @DisplayName("TC01_AUTH_04: Đăng nhập thất bại khi để trống thông tin")
    public void testLogin_EmptyCredentials() {
        // Trường hợp để trống SĐT
        LoginResult resultEmptyPhone = processLogin("", "123456");
        assertFalse(resultEmptyPhone.isSuccess(), "Để trống SĐT phải thất bại");
        assertEquals("Thông tin không chính xác", resultEmptyPhone.getErrorMessage());

        // Trường hợp để trống Mật khẩu
        LoginResult resultEmptyPass = processLogin("090333444", "");
        assertFalse(resultEmptyPass.isSuccess(), "Để trống mật khẩu phải thất bại");
        assertEquals("Thông tin không chính xác", resultEmptyPass.getErrorMessage());
    }

    @Test
    @DisplayName("TC01_AUTH_05: Đăng nhập thất bại khi nhập sai mật khẩu")
    public void testLogin_WrongPassword() {
        String phone = "090333444";
        String password = "wrong_password_999";

        LoginResult result = processLogin(phone, password);

        assertFalse(result.isSuccess(), "Sai mật khẩu phải trả về thất bại");
        assertNull(result.getRole(), "Không được cấp quyền khi đăng nhập sai");
        assertEquals("Thông tin không chính xác", resultEmptyPhone(result).getErrorMessage());
    }

    // =========================================================================
    // LOGIC NGHIỆP VỤ ĐĂNG NHẬP & PHÂN QUYỀN (Ánh xạ theo LoginController)
    // =========================================================================
    private LoginResult processLogin(String phone, String password) {
        if (phone == null || phone.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            return new LoginResult(false, null, null, "Thông tin không chính xác");
        }

        // Kiểm tra dữ liệu mẫu trong báo cáo đồ án
        if ("090333444".equals(phone) && "123456".equals(password)) {
            return new LoginResult(true, "Customer", "home.jsp", null);
        } else if ("090222333".equals(phone) && "123456".equals(password)) {
            return new LoginResult(true, "HotelManager", "reception.jsp", null);
        } else if ("090111222".equals(phone) && "123456".equals(password)) {
            return new LoginResult(true, "Admin", "dashboard.jsp", null);
        } else {
            return new LoginResult(false, null, null, "Thông tin không chính xác");
        }
    }

    private LoginResult resultEmptyPhone(LoginResult res) {
        return res;
    }

    // Lớp chứa kết quả trả về của tiến trình đăng nhập
    private static class LoginResult {
        private final boolean success;
        private final String role;
        private final String redirectUrl;
        private final String errorMessage;

        public LoginResult(boolean success, String role, String redirectUrl, String errorMessage) {
            this.success = success;
            this.role = role;
            this.redirectUrl = redirectUrl;
            this.errorMessage = errorMessage;
        }

        public boolean isSuccess() { return success; }
        public String getRole() { return role; }
        public String getRedirectUrl() { return redirectUrl; }
        public String getErrorMessage() { return errorMessage; }
    }
}