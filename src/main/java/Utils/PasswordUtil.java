package Utils;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class PasswordUtil {

    // Chuỗi Salt bí mật của riêng Verdelle Hotel để chống dò mật khẩu
    private static final String SWEET_SALT = "VerdelleHotel_Mint_Sweet_2026";

    public static String hashPassword(String password) {
        try {
            // Sử dụng thuật toán SHA-256
            MessageDigest digest = MessageDigest.getInstance("SHA-256");

            // Kết hợp mật khẩu gốc với chuỗi Salt bí mật
            String saltedPassword = password + SWEET_SALT;
            byte[] hash = digest.digest(saltedPassword.getBytes(StandardCharsets.UTF_8));

            // Chuyển đổi mảng byte thành chuỗi Hex để lưu vào DB
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();

        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Lỗi hệ thống khi mã hóa mật khẩu!", e);
        }
    }
}