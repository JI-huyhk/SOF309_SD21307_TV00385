package controller;

import dao.UserDAO;
import model.User;
import Utils.EmailService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.UUID;

@WebServlet("/ForgotPasswordController")
public class ForgotPasswordController extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    // Xử lý khi người dùng click vào Link xác nhận trong Gmail gửi về
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("verify".equals(action)) {
            String token = request.getParameter("token");

            // Tìm xem token này có khớp với User nào trong DB không
            User user = userDAO.findByResetToken(token);

            // Kiểm tra token tồn tại và còn hạn sử dụng (trước thời gian hết hạn)
            if (user != null && user.getTokenExpiry() != null && user.getTokenExpiry().isAfter(LocalDateTime.now())) {
                // Token hợp lệ, chuyển hướng về trang chủ kèm lệnh kích hoạt hiển thị Pop-up đổi mật khẩu mới
                response.sendRedirect(request.getContextPath() + "/index.jsp?action=showResetPopup&token=" + token);
            } else {
                // Token lỡ bị sai hoặc hết hạn
                response.sendRedirect(request.getContextPath() + "/index.jsp?error=tokenInvalidOrExpired");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }

    // Xử lý gửi chuỗi Token yêu cầu và Tiến hành cập nhật mật khẩu mới
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        // Bước 1: Người dùng gửi Email yêu cầu cấp lại mật khẩu
        if ("requestToken".equals(action)) {
            String email = request.getParameter("email");
            User user = userDAO.findByEmail(email); // Hàm tìm user bằng email trong DAO

            if (user != null) {
                // Tạo chuỗi mã hóa Token ngẫu nhiên không trùng lặp và set thời gian hết hạn là 15 phút
                String token = UUID.randomUUID().toString();
                LocalDateTime expiry = LocalDateTime.now().plusMinutes(15);

                // Lưu Token và thời gian hết hạn này vào tài khoản User dưới DB
                userDAO.updateResetToken(email, token, expiry);

                // Tự động lấy cấu hình tên miền hệ thống để sinh Link động gửi vào mail
                String scheme = request.getScheme();
                String serverName = request.getServerName();
                int serverPort = request.getServerPort();
                String contextPath = request.getContextPath();
                String baseUrl = scheme + "://" + serverName + ":" + serverPort + contextPath;

                // Link dẫn thẳng tới hàm doGet ở trên của Controller này kèm mã token bảo mật
                String resetLink = baseUrl + "/ForgotPasswordController?action=verify&token=" + token;

                // Thiết kế nội dung Email gửi đi
                String subject = "[Verdelle Hotel] Xác nhận yêu cầu đặt lại mật khẩu của cậu";
                String content = "<div style='font-family: Arial, sans-serif; padding: 20px; color: #333;'>"
                        + "<h3>Chào cậu,</h3>"
                        + "<p>Tụi mình nhận được yêu cầu hỗ trợ đặt lại mật khẩu cho tài khoản liên kết với Email này tại <b>Verdelle Hotel</b>.</p>"
                        + "<p>Cậu vui lòng click vào nút bên dưới để tiến hành thiết lập lại mật khẩu mới nha. Link này sẽ hết hạn an toàn sau 15 phút:</p>"
                        + "<div style='margin: 25px 0;'>"
                        + "  <a href='" + resetLink + "' style='display:inline-block; padding:12px 24px; color:white; background-color:#1e62d0; text-decoration:none; border-radius:8px; font-weight:bold; box-shadow: 0 4px 6px rgba(0,0,0,0.1);'>Đặt lại mật khẩu mới</a>"
                        + "</div>"
                        + "<p>Nếu cậu không thực hiện yêu cầu này, cậu cứ an tâm bỏ qua email này nha, mật khẩu cũ vẫn sẽ được giữ an toàn tuyệt đối.</p>"
                        + "<p>Thân mến,<br>Đội ngũ Verdelle Hotel</p>"
                        + "</div>";

                try {
                    // Gọi hàm gửi Mail HTML từ EmailService
                    EmailService.sendEmail(email, subject, content);
                    // Gửi mail thành công, quay về trang chủ
                    response.sendRedirect(request.getContextPath() + "/index.jsp?status=emailSent");
                } catch (Exception e) {
                    e.printStackTrace();
                    response.sendRedirect(request.getContextPath() + "/index.jsp?error=emailSendFailed");
                }
            } else {
                // Email nhập vào không tồn tại trong hệ thống
                response.sendRedirect(request.getContextPath() + "/index.jsp?error=emailNotFound");
            }

            // Bước 3: Người dùng điền mật khẩu mới từ Pop-up gửi lên hệ thống
        } else if ("resetPassword".equals(action)) {
            String token = request.getParameter("token");
            String newPassword = request.getParameter("newPassword");

            User user = userDAO.findByResetToken(token);

            // Kiểm tra bảo mật lần cuối trước khi ghi đè mật khẩu mới vào DB
            if (user != null && user.getTokenExpiry() != null && user.getTokenExpiry().isAfter(LocalDateTime.now())) {
                // Hợp lệ -> Thực hiện đổi mật khẩu mới (và tự động clear các trường token về null)
                userDAO.updatePassword(token, newPassword);
                response.sendRedirect(request.getContextPath() + "/index.jsp?status=resetSuccess");
            } else {
                // Đổi mật khẩu thất bại do token hết hạn giữa chừng hoặc chỉnh sửa bậy bạ
                response.sendRedirect(request.getContextPath() + "/index.jsp?error=resetFailed");
            }
        }
    }
}