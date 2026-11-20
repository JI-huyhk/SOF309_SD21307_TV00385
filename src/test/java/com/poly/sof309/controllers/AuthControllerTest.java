package com.poly.sof309.controllers;

import org.junit.jupiter.api.*;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import org.junit.jupiter.params.provider.NullAndEmptySource;
import org.junit.jupiter.params.provider.ValueSource;
import service.AuthValidationService;

import java.util.concurrent.TimeUnit;

import static org.junit.jupiter.api.Assertions.*;

/**
 * =========================================================================
 * [Y3] UNIT TEST: AuthControllerTest.java
 *
 * Kiểm thử toàn bộ logic nghiệp vụ xác thực người dùng (đăng nhập / đăng ký)
 * trong AuthValidationService - ánh xạ với LoginController & RegisterController.
 *
 * Kỹ thuật áp dụng:
 *  - @ParameterizedTest + @CsvSource: Quét nhiều bộ dữ liệu biên (Lab 2)
 *  - assertThrows(): Bắt ngoại lệ nghiệp vụ (Lab 3)
 *  - @Timeout: Phát hiện hàm bị treo vòng lặp (Lab 3)
 *  - @Nested: Nhóm test theo chức năng
 * =========================================================================
 */
@DisplayName("🔐 AuthControllerTest - Kiểm thử nghiệp vụ Đăng nhập & Đăng ký")
class AuthControllerTest {

    private AuthValidationService authService;

    @BeforeEach
    void setUp() {
        authService = new AuthValidationService();
    }

    // =========================================================================
    // NHÓM 1: KIỂM TRA SỐ ĐIỆN THOẠI (PHÂN VÙNG TƯƠNG ĐƯƠNG & GIÁ TRỊ BIÊN)
    // =========================================================================
    @Nested
    @DisplayName("📱 Nhóm TC-AUTH-01: Kiểm tra Số điện thoại")
    class PhoneValidationTests {

        @ParameterizedTest(name = "[{index}] Phone=''{0}'' → kỳ vọng: {1} ({2})")
        @DisplayName("TC-AUTH-01: Phân vùng tương đương & Giá trị biên số điện thoại")
        @CsvSource({
            // SĐT hợp lệ
            "'0901234567',  true,  'SĐT 10 chữ số bắt đầu 0 - HỢP LỆ'",
            "'09012345678', true,  'SĐT 11 chữ số bắt đầu 0 - HỢP LỆ'",
            // Biên dưới (9 chữ số - không hợp lệ)
            "'090123456',   false, 'SĐT 9 chữ số - QUÁ NGẮN'",
            // Biên trên (12 chữ số - không hợp lệ)
            "'090123456789',false, 'SĐT 12 chữ số - QUÁ DÀI'",
            // Chứa ký tự đặc biệt
            "'090-123-456', false, 'SĐT chứa dấu gạch ngang - KHÔNG HỢP LỆ'",
            "'090 123 456', false, 'SĐT chứa khoảng trắng - KHÔNG HỢP LỆ'",
            // Không bắt đầu bằng 0
            "'1901234567',  false, 'SĐT không bắt đầu bằng 0 - KHÔNG HỢP LỆ'",
            // Chứa chữ cái
            "'090ABC1234',  false, 'SĐT chứa chữ cái - KHÔNG HỢP LỆ'"
        })
        void testPhoneValidation(String phone, boolean expected, String message) {
            assertEquals(expected, authService.isValidPhone(phone), message);
        }

        @ParameterizedTest(name = "[{index}] Phone null/rỗng → phải trả false")
        @DisplayName("TC-AUTH-01b: SĐT null hoặc rỗng phải thất bại")
        @NullAndEmptySource
        void testPhone_NullOrEmpty_ShouldFail(String phone) {
            assertFalse(authService.isValidPhone(phone),
                    "SĐT null/rỗng phải trả về false");
        }
    }

    // =========================================================================
    // NHÓM 2: KIỂM TRA MẬT KHẨU (PHÂN VÙNG TƯƠNG ĐƯƠNG & GIÁ TRỊ BIÊN)
    // =========================================================================
    @Nested
    @DisplayName("🔑 Nhóm TC-AUTH-02: Kiểm tra Mật khẩu")
    class PasswordValidationTests {

        @ParameterizedTest(name = "[{index}] Password=''{0}'' → kỳ vọng: {1} ({2})")
        @DisplayName("TC-AUTH-02: Phân vùng tương đương & Giá trị biên mật khẩu")
        @CsvSource({
            // Hợp lệ: đúng biên dưới (6 ký tự)
            "'123456',                   true,  'Mật khẩu 6 ký tự - biên dưới HỢP LỆ'",
            // Hợp lệ: đúng biên trên (32 ký tự)
            "'12345678901234567890123456789012', true, 'Mật khẩu 32 ký tự - biên trên HỢP LỆ'",
            // Hợp lệ: giữa khoảng
            "'Pass@2026',               true,  'Mật khẩu 10 ký tự hỗn hợp - HỢP LỆ'",
            // Không hợp lệ: quá ngắn (5 ký tự - dưới biên dưới)
            "'12345',                   false, 'Mật khẩu 5 ký tự - QUÁ NGẮN'",
            // Không hợp lệ: quá dài (33 ký tự - trên biên trên)
            "'123456789012345678901234567890123', false, 'Mật khẩu 33 ký tự - QUÁ DÀI'"
        })
        void testPasswordValidation(String password, boolean expected, String message) {
            assertEquals(expected, authService.isValidPassword(password), message);
        }

        @Test
        @DisplayName("TC-AUTH-02b: Mật khẩu null phải trả về false")
        void testPassword_Null_ShouldFail() {
            assertFalse(authService.isValidPassword(null), "Mật khẩu null phải trả false");
        }

        @ParameterizedTest(name = "[{index}] pass=''{0}'' confirm=''{1}'' → khớp: {2}")
        @DisplayName("TC-AUTH-02c: Kiểm tra xác nhận mật khẩu")
        @CsvSource({
            "'Pass@2026', 'Pass@2026',  true,  'Hai mật khẩu giống nhau - KHỚP'",
            "'Pass@2026', 'pass@2026',  false, 'Mật khẩu phân biệt chữ hoa thường - KHÔNG KHỚP'",
            "'Pass@2026', 'Pass@2027',  false, 'Mật khẩu khác nhau - KHÔNG KHỚP'",
            "'123456',    '',           false, 'Xác nhận rỗng - KHÔNG KHỚP'"
        })
        void testPasswordConfirmation(String pass, String confirm, boolean expected, String message) {
            assertEquals(expected, authService.isPasswordConfirmed(pass, confirm), message);
        }
    }

    // =========================================================================
    // NHÓM 3: KIỂM TRA EMAIL
    // =========================================================================
    @Nested
    @DisplayName("📧 Nhóm TC-AUTH-03: Kiểm tra Email")
    class EmailValidationTests {

        @ParameterizedTest(name = "[{index}] Email=''{0}'' → hợp lệ: {1} ({2})")
        @DisplayName("TC-AUTH-03: Phân vùng tương đương email")
        @CsvSource({
            "'user@example.com',     true,  'Email chuẩn - HỢP LỆ'",
            "'test.email@fpt.edu.vn',true,  'Email có dấu chấm - HỢP LỆ'",
            "'user+tag@gmail.com',   true,  'Email có dấu cộng - HỢP LỆ'",
            "'notanemail',           false, 'Không có @ - KHÔNG HỢP LỆ'",
            "'@nodomain.com',        false, 'Không có phần trước @ - KHÔNG HỢP LỆ'",
            "'user@nodot',           false, 'Không có dấu chấm sau @ - KHÔNG HỢP LỆ'",
            "'',                     false, 'Email rỗng - KHÔNG HỢP LỆ'"
        })
        void testEmailValidation(String email, boolean expected, String message) {
            assertEquals(expected, authService.isValidEmail(email), message);
        }
    }

    // =========================================================================
    // NHÓM 4: KIỂM TRA FORM ĐĂNG NHẬP TỔNG THỂ
    // =========================================================================
    @Nested
    @DisplayName("🔓 Nhóm TC-AUTH-04: Kiểm tra Form Đăng nhập")
    class LoginFormTests {

        @ParameterizedTest(name = "[{index}] Phone=''{0}'' Pass=''{1}'' → lỗi: ''{2}''")
        @DisplayName("TC-AUTH-04: Kiểm tra form đăng nhập với các bộ dữ liệu biên")
        @CsvSource({
            // Hợp lệ
            "'0901234567', 'Pass@2026',    '',               'Dữ liệu hợp lệ - KHÔNG LỖI'",
            // Lỗi SĐT rỗng
            "'',           'Pass@2026',    'PHONE_EMPTY',    'SĐT rỗng'",
            // Lỗi mật khẩu rỗng
            "'0901234567', '',             'PASSWORD_EMPTY', 'Mật khẩu rỗng'",
            // SĐT không hợp lệ
            "'123',        'Pass@2026',    'PHONE_INVALID',  'SĐT quá ngắn'",
            // Mật khẩu quá ngắn
            "'0901234567', '123',          'PASSWORD_TOO_SHORT','Mật khẩu quá ngắn'"
        })
        void testValidateLoginForm(String phone, String password, String expectedError, String desc) {
            String error = authService.validateLoginForm(phone, password);
            assertEquals(expectedError, error, desc);
        }

        @Test
        @DisplayName("TC-AUTH-04b: Đăng nhập với SĐT null phải trả lỗi PHONE_EMPTY")
        void testLogin_NullPhone_ShouldReturnError() {
            String error = authService.validateLoginForm(null, "Pass@2026");
            assertEquals("PHONE_EMPTY", error);
        }
    }

    // =========================================================================
    // NHÓM 5: KIỂM TRA FORM ĐĂNG KÝ TỔNG THỂ
    // =========================================================================
    @Nested
    @DisplayName("📝 Nhóm TC-AUTH-05: Kiểm tra Form Đăng ký")
    class RegisterFormTests {

        @ParameterizedTest(name = "[{index}] → lỗi: ''{6}'' ({7})")
        @DisplayName("TC-AUTH-05: Kiểm tra form đăng ký với các bộ dữ liệu biên")
        @CsvSource({
            // Dữ liệu hợp lệ
            "'Nguyen','Van A','test@gmail.com','0901234567','Pass@2026','Pass@2026','','Đăng ký hợp lệ'",
            // Họ rỗng
            "'','Van A','test@gmail.com','0901234567','Pass@2026','Pass@2026','FIRSTNAME_EMPTY','Họ rỗng'",
            // Tên rỗng
            "'Nguyen','','test@gmail.com','0901234567','Pass@2026','Pass@2026','LASTNAME_EMPTY','Tên rỗng'",
            // Email sai
            "'Nguyen','Van A','bademail','0901234567','Pass@2026','Pass@2026','EMAIL_INVALID','Email không hợp lệ'",
            // SĐT sai
            "'Nguyen','Van A','test@gmail.com','123','Pass@2026','Pass@2026','PHONE_INVALID','SĐT không hợp lệ'",
            // Mật khẩu quá ngắn
            "'Nguyen','Van A','test@gmail.com','0901234567','12345','12345','PASSWORD_TOO_SHORT','MK quá ngắn'",
            // Mật khẩu không khớp
            "'Nguyen','Van A','test@gmail.com','0901234567','Pass@2026','Pass@2027','PASSWORD_MISMATCH','MK không khớp'"
        })
        void testValidateRegisterForm(String firstName, String lastName, String email,
                                       String phone, String pass, String confirm,
                                       String expectedError, String desc) {
            String error = authService.validateRegisterForm(firstName, lastName, email, phone, pass, confirm);
            assertEquals(expectedError, error, desc);
        }
    }

    // =========================================================================
    // NHÓM 6: KIỂM TRA PHÂN QUYỀN REDIRECT (RBAC)
    // =========================================================================
    @Nested
    @DisplayName("🔀 Nhóm TC-AUTH-06: Kiểm tra Phân quyền Redirect")
    class RoleRedirectTests {

        @ParameterizedTest(name = "[{index}] Role=''{0}'' → redirect: ''{1}''")
        @DisplayName("TC-AUTH-06: Phân quyền theo Role - ánh xạ LoginController")
        @CsvSource({
            "'admin',         '/quan-ly-tai-khoan', 'Admin → trang quản lý tài khoản'",
            "'hotelmanager',  '/dashboard',         'HotelManager → dashboard'",
            "'partner',       '/dashboard',         'Partner → dashboard'",
            "'hotel partner', '/dashboard',         'Hotel Partner (có khoảng) → dashboard'",
            "'customer',      '/home.jsp',          'Customer → trang chủ'",
            "'',              '/home.jsp',           'Role rỗng → trang chủ (mặc định)'",
            // Kiểm tra không phân biệt hoa thường
            "'ADMIN',         '/quan-ly-tai-khoan', 'ADMIN viết hoa → vẫn được nhận diện'"
        })
        void testResolveRedirectUrl(String role, String expectedUrl, String desc) {
            assertEquals(expectedUrl, authService.resolveRedirectUrl(role), desc);
        }

        @Test
        @DisplayName("TC-AUTH-06b: Role null phải trả về /home.jsp (không ném ngoại lệ)")
        void testResolveRedirect_NullRole_ShouldReturnDefault() {
            String url = authService.resolveRedirectUrl(null);
            assertEquals("/home.jsp", url, "Role null phải trả về /home.jsp");
        }
    }

    // =========================================================================
    // NHÓM 7: TIMEOUT TESTING - PHÁT HIỆN VÒNG LẶP VÔ TẬN
    // =========================================================================
    @Nested
    @DisplayName("⏱️ Nhóm TC-AUTH-07: Timeout Testing")
    class TimeoutTests {

        @Test
        @Timeout(value = 2, unit = TimeUnit.SECONDS)
        @DisplayName("TC-AUTH-07a: validateLoginForm phải hoàn thành trong 2 giây")
        void testValidateLoginForm_ShouldCompleteWithinTimeout() {
            for (int i = 0; i < 1000; i++) {
                authService.validateLoginForm("0901234567", "Pass@2026");
            }
            // Nếu hàm bị treo vòng lặp vô tận, test này sẽ FAIL với TimeoutException
        }

        @Test
        @Timeout(value = 2, unit = TimeUnit.SECONDS)
        @DisplayName("TC-AUTH-07b: validateRegisterForm phải hoàn thành trong 2 giây")
        void testValidateRegisterForm_ShouldCompleteWithinTimeout() {
            for (int i = 0; i < 1000; i++) {
                authService.validateRegisterForm(
                    "Nguyen", "Van A", "test@gmail.com",
                    "0901234567", "Pass@2026", "Pass@2026"
                );
            }
        }

        @Test
        @Timeout(value = 1, unit = TimeUnit.SECONDS)
        @DisplayName("TC-AUTH-07c: isValidPhone phải xử lý 10.000 lần trong 1 giây")
        void testIsValidPhone_HighVolume_ShouldCompleteWithinTimeout() {
            for (int i = 0; i < 10_000; i++) {
                authService.isValidPhone("0901234567");
            }
        }
    }

    // =========================================================================
    // NHÓM 8: EXCEPTION TESTING - BẮT NGOẠI LỆ NGHIỆP VỤ
    // =========================================================================
    @Nested
    @DisplayName("💥 Nhóm TC-AUTH-08: Exception Testing")
    class ExceptionTests {

        @Test
        @DisplayName("TC-AUTH-08a: isPasswordConfirmed với null-null phải trả false (không ném exception)")
        void testPasswordConfirm_BothNull_ShouldReturnFalse() {
            assertFalse(authService.isPasswordConfirmed(null, null),
                    "isPasswordConfirmed(null,null) phải trả false, không được ném exception");
        }

        @Test
        @DisplayName("TC-AUTH-08b: validateRegisterForm với toàn bộ null phải trả lỗi FIRSTNAME_EMPTY")
        void testRegisterForm_AllNull_ShouldReturnFirstError() {
            String error = authService.validateRegisterForm(null, null, null, null, null, null);
            assertEquals("FIRSTNAME_EMPTY", error,
                    "Toàn bộ tham số null phải trả lỗi đầu tiên: FIRSTNAME_EMPTY");
        }

        @Test
        @DisplayName("TC-AUTH-08c: resolveRedirectUrl không ném exception với bất kỳ chuỗi nào")
        void testResolveRedirectUrl_AnyCrazyInput_ShouldNotThrow() {
            String[] crazyInputs = {null, "", "   ", "UNKNOWN_ROLE", "123", "!@#$"};
            for (String input : crazyInputs) {
                assertDoesNotThrow(() -> authService.resolveRedirectUrl(input),
                        "resolveRedirectUrl không được ném exception với input: " + input);
            }
        }
    }
}
