package service;

/**
 * =========================================================================
 * AuthValidationService - Lớp nghiệp vụ xác thực dữ liệu đăng nhập / đăng ký
 *
 * Mục đích: Tách riêng logic kiểm tra dữ liệu (validation) ra khỏi Servlet
 * để có thể viết Unit Test thuần mà không cần kết nối DB / Servlet Container.
 *
 * Ánh xạ với: LoginController.java, RegisterController.java
 * =========================================================================
 */
public class AuthValidationService {

    // =========== HẰNG SỐ QUI TẮC NGHIỆP VỤ ===========
    public static final int PHONE_MIN_LENGTH = 10;
    public static final int PHONE_MAX_LENGTH = 11;
    public static final int PASSWORD_MIN_LENGTH = 6;
    public static final int PASSWORD_MAX_LENGTH = 32;
    public static final int FIRSTNAME_MAX_LENGTH = 50;
    public static final int LASTNAME_MAX_LENGTH = 50;

    /**
     * Kiểm tra số điện thoại hợp lệ:
     * - Không được null/rỗng
     * - Chỉ chứa chữ số
     * - Độ dài 10-11 chữ số
     * - Bắt đầu bằng "0"
     */
    public boolean isValidPhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) return false;
        String trimmed = phone.trim();
        if (!trimmed.matches("\\d+")) return false;
        if (trimmed.length() < PHONE_MIN_LENGTH || trimmed.length() > PHONE_MAX_LENGTH) return false;
        if (!trimmed.startsWith("0")) return false;
        return true;
    }

    /**
     * Kiểm tra mật khẩu hợp lệ:
     * - Không được null/rỗng
     * - Độ dài từ 6 đến 32 ký tự
     */
    public boolean isValidPassword(String password) {
        if (password == null || password.trim().isEmpty()) return false;
        int len = password.length();
        return len >= PASSWORD_MIN_LENGTH && len <= PASSWORD_MAX_LENGTH;
    }

    /**
     * Kiểm tra xác nhận mật khẩu khớp nhau
     */
    public boolean isPasswordConfirmed(String password, String confirmPassword) {
        if (password == null || confirmPassword == null) return false;
        return password.equals(confirmPassword);
    }

    /**
     * Kiểm tra email hợp lệ (đơn giản - chứa @ và dấu chấm sau @)
     */
    public boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) return false;
        String trimmed = email.trim();
        int atIdx = trimmed.indexOf('@');
        if (atIdx <= 0) return false;
        String domain = trimmed.substring(atIdx + 1);
        return domain.contains(".");
    }

    /**
     * Kiểm tra tên hợp lệ (firstName / lastName):
     * - Không được null/rỗng
     * - Không vượt quá 50 ký tự
     * - Không chứa số
     */
    public boolean isValidName(String name) {
        if (name == null || name.trim().isEmpty()) return false;
        if (name.trim().length() > FIRSTNAME_MAX_LENGTH) return false;
        if (name.matches(".*\\d.*")) return false;
        return true;
    }

    /**
     * Kiểm tra toàn bộ form đăng nhập:
     * @return "" nếu hợp lệ, mã lỗi nếu sai
     */
    public String validateLoginForm(String phone, String password) {
        if (phone == null || phone.trim().isEmpty()) return "PHONE_EMPTY";
        if (password == null || password.trim().isEmpty()) return "PASSWORD_EMPTY";
        if (!isValidPhone(phone)) return "PHONE_INVALID";
        if (!isValidPassword(password)) return "PASSWORD_TOO_SHORT";
        return "";
    }

    /**
     * Kiểm tra toàn bộ form đăng ký:
     * @return "" nếu hợp lệ, mã lỗi nếu sai
     */
    public String validateRegisterForm(String firstName, String lastName,
                                        String email, String phone,
                                        String password, String confirmPassword) {
        if (firstName == null || firstName.trim().isEmpty()) return "FIRSTNAME_EMPTY";
        if (lastName == null || lastName.trim().isEmpty()) return "LASTNAME_EMPTY";
        if (!isValidName(firstName)) return "FIRSTNAME_INVALID";
        if (!isValidName(lastName)) return "LASTNAME_INVALID";
        if (!isValidEmail(email)) return "EMAIL_INVALID";
        if (!isValidPhone(phone)) return "PHONE_INVALID";
        if (!isValidPassword(password)) return "PASSWORD_TOO_SHORT";
        if (!isPasswordConfirmed(password, confirmPassword)) return "PASSWORD_MISMATCH";
        return "";
    }

    /**
     * Ánh xạ vai trò (role) sang URL redirect đích
     * Ánh xạ theo đúng logic trong LoginController.java
     */
    public String resolveRedirectUrl(String role) {
        if (role == null) return "/home.jsp";
        switch (role.trim().toLowerCase()) {
            case "admin":        return "/quan-ly-tai-khoan";
            case "hotelmanager":
            case "partner":
            case "hotel partner": return "/dashboard";
            default:             return "/home.jsp";
        }
    }
}
