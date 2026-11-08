package Utils;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.util.Properties;

public class EmailService {
    private static final String FROM_EMAIL = "mintringuyen1008@gmail.com";
    private static final String APP_PASSWORD = "ncjj hdlo pzzg hxyc";

    public static boolean sendOTP(String toEmail, String otpCode) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL, "Verdelle Hotel - Noreply"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Mã xác thực đăng ký tài khoản - Verdelle Hotel");

            // Thiết kế nội dung Email bằng HTML cho ngọt ngào, đáng yêu nè
            String emailContent = "<div style='font-family: Arial, sans-serif; max-width: 500px; margin: 0 auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 10px;'>"
                    + "<h2 style='color: #0097a7; text-align: center;'>VERDELLE HOTEL</h2>"
                    + "<p>Xin chào bạn,</p>"
                    + "<p>Cảm ơn bạn đã lựa chọn đăng ký thành viên tại hệ thống của chúng tôi. Dưới đây là mã xác thực OTP của bạn (có hiệu lực trong <b>2 phút</b>):</p>"
                    + "<div style='text-align: center; margin: 20px 0;'>"
                    + "<span style='font-size: 24px; font-weight: bold; letter-spacing: 5px; color: #ff4d4d; background: #f9f9f9; padding: 10px 20px; border-radius: 5px; border: 1px dashed #ccc;'>" + otpCode + "</span>"
                    + "</div>"
                    + "<p style='font-size: 0.85rem; color: #666;'>Nếu bạn không thực hiện yêu cầu này, vui lòng bỏ qua email này.</p>"
                    + "</div>";

            message.setContent(emailContent, "text/html; charset=UTF-8");
            Transport.send(message);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static void sendEmail(String toEmail, String subject, String content) throws Exception {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
            }
        });

        Message message = new MimeMessage(session);
        // Thiết lập tên người gửi hiển thị ngọt ngào trên hòm thư của khách hàng
        message.setFrom(new InternetAddress(FROM_EMAIL, "Verdelle Hotel - Noreply"));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject(subject);

        // Nhận nội dung giao diện HTML truyền vào từ Controller
        message.setContent(content, "text/html; charset=UTF-8");

        // Tiến hành gửi Mail (Sẽ ném Exception ra ngoài để Controller bắt được nếu lỗi)
        Transport.send(message);
    }
}