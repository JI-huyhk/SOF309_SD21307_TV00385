package controller;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.Properties;

@WebServlet(name = "SendEmailController", value = "/SendEmailController")
public class SendEmailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // 1. Tự động lấy email của người đang đăng nhập từ Session để làm người nhận
        String toEmail = (String) session.getAttribute("userEmail");
        String bookingId = request.getParameter("bookingId");

        // BẢO VỆ: Nếu chưa đăng nhập hoặc không tìm thấy email, quay về trang trước báo lỗi
        if (toEmail == null || toEmail.trim().isEmpty()) {
            System.out.println("⚠️ LỖI: Không tìm thấy userEmail trong Session. Code tự động dừng.");
            response.sendRedirect(request.getHeader("referer") + "?status=emailNotLoggedIn");
            return;
        }

        String hotelName = (String) session.getAttribute("hotelName");
        String roomName = (String) session.getAttribute("roomName");
        String voucherCode = (String) session.getAttribute("voucherCode");

        String paymentStatus = (String) session.getAttribute("paymentStatus");
        if (paymentStatus == null) {
            paymentStatus = "Đã thanh toán"; // Dự phòng nếu session bị trống
        }

        // Dùng ép kiểu an toàn thông qua toString() phòng hờ sai lệch kiểu số
        int totalNights = 1;
        int requiredRooms = 1;
        long finalPrice = 0;

        try {
            if (session.getAttribute("totalNights") != null) {
                totalNights = Integer.parseInt(session.getAttribute("totalNights").toString());
            }
            if (session.getAttribute("requiredRooms") != null) {
                requiredRooms = Integer.parseInt(session.getAttribute("requiredRooms").toString());
            }
            if (session.getAttribute("finalPrice") != null) {
                finalPrice = Long.parseLong(session.getAttribute("finalPrice").toString());
            }
        } catch (Exception e) {
            System.out.println("⚠️ Lỗi parse số lượng hoặc giá tiền trong Email: " + e.getMessage());
        }

        // Tạo chuỗi định dạng tiền tệ (Ví dụ: 15400000 -> 15,400,000)
        String formattedPrice = String.format("%,d", finalPrice);

        // Thiết lập giá trị mặc định phòng hờ session bị mất
        if (hotelName == null) hotelName = "Verdelle Premium Resort & Hotel";
        if (roomName == null) roomName = "Deluxe Room";

        final String fromEmail = "mintringuyen1008@gmail.com";
        final String appPassword = "ncjj hdlo pzzg hxyc"; // Mật khẩu ứng dụng của cậu

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session mailSession = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, appPassword);
            }
        });

        try {
            // 4. Tạo nội dung Email dạng HTML động
            Message message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress(fromEmail, "Verdelle Premium Resort & Hotel"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));

            // Tiêu đề Email chứa mã booking thật
            message.setSubject("[Verdelle Hotel] Xác nhận đặt phòng thành công " + bookingId);

            // Giao diện hóa đơn HTML - KHÔNG CÒN HARDCODE GIÁ VÀ PHÒNG
            String htmlContent = "<div style='font-family: Arial, sans-serif; padding: 20px; border: 1px solid #ddd; max-width: 600px; margin: 0 auto;'>"
                    + "<h2 style='color: #1a73e8; text-align: center;'>CẢM ƠN BẠN ĐÃ ĐẶT PHÒNG TẠI VERDELLE!</h2>"
                    + "<p>Chào bạn, yêu cầu đặt phòng của bạn đã được hệ thống xác nhận thành công.</p>"
                    + "<div style='background-color: #f8f9fa; padding: 15px; border-radius: 5px; margin: 15px 0;'>"
                    + "<p><b>Mã xác nhận:</b> <span style='font-size: 18px; color: #1a73e8; font-weight: bold;'>" + bookingId + "</span></p>"
                    + "<p><b>Khách sạn:</b> " + hotelName + "</p>"
                    + "<p><b>Chi tiết:</b> " + requiredRooms + " x phòng " + roomName + " (" + totalNights + " đêm)</p>"
                    + ""
                    + "<p><b>Trạng thái:</b> " + paymentStatus + (voucherCode != null && !voucherCode.isEmpty() ? " - Mã áp dụng: " + voucherCode : "") + "</p>"
                    + "</div>"
                    + "<h3 style='color: #d93025;'>Tổng cộng: " + formattedPrice + " đ</h3>"
                    + "<hr>"
                    + "<p style='font-size: 12px; color: #777; text-align: center;'>Mọi thắc mắc xin vui lòng liên hệ Hotline: 0834178906.</p>"
                    + "</div>";

            message.setContent(htmlContent, "text/html; charset=UTF-8");

            // 5. Gửi mail
            System.out.println("🚀 Đang gửi mail từ " + fromEmail + " tới " + toEmail + "...");
            Transport.send(message);
            System.out.println("✅ GỬI MAIL THÀNH CÔNG! Check hộp thư đến ngay!");

            response.sendRedirect("home.jsp?status=emailSent");

        } catch (Exception e) {
            System.out.println("❌ GỬI MAIL THẤT BẠI!");
            e.printStackTrace();
            response.sendRedirect("home.jsp?status=emailFailed");
        }
    }
}