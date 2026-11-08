package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@WebServlet("/SepayWebhook")
public class SepayWebhookController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Đọc toàn bộ chuỗi JSON do SePay gửi sang
        StringBuilder buffer = new StringBuilder();
        BufferedReader reader = request.getReader();
        String line;
        while ((line = reader.readLine()) != null) {
            buffer.append(line);
        }
        String payload = buffer.toString();

        // Bật log để xem SePay gửi gì sang (Rất quan trọng khi Debug)
        System.out.println("========== SEPAY WEBHOOK START ==========");
        System.out.println("Payload nhận được: " + payload);

        // 2. Tìm nội dung chuyển khoản trong JSON (Tìm chữ "transferContent")
        String transferContent = "";
        // Biểu thức regex này tìm chính xác giá trị nằm sau "content", "description" hoặc "transferContent"
        // 💡 Bổ sung \s* để linh hoạt bỏ qua khoảng trắng mà ngân hàng/SePay chèn vào
        // Đồng thời thêm transactionContent vào list tìm kiếm để quét sạch mọi format
        Pattern contentPattern = Pattern.compile("\"(?:content|description|transferContent|transactionContent)\"\\s*:\\s*\"([^\"]+)\"");
        Matcher contentMatcher = contentPattern.matcher(payload);

        if (contentMatcher.find()) {
            transferContent = contentMatcher.group(1).toUpperCase(); // Chuyển hết thành chữ hoa
            System.out.println("Nội dung chuyển khoản bóc tách được: " + transferContent);
        } else {
            System.out.println("Không tìm thấy trường 'transferContent' trong JSON.");
        }

        // 3. Tìm mã VD... trong nội dung chuyển khoản
        Pattern roomPattern = Pattern.compile("VD(\\d+)");
        Matcher roomMatcher = roomPattern.matcher(transferContent);

        if (roomMatcher.find()) {
            // Lấy được ID phòng (phần số sau chữ VD)
            String roomId = roomMatcher.group(1);

            // 4. Bật đèn xanh cho JSP
            getServletContext().setAttribute("payment_status_" + roomId, true);
            System.out.println("=> Đã MỞ KHÓA thành công cho phòng: " + roomId);

            // Phản hồi OK cho SePay
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("{\"success\": true}");
        } else {
            System.out.println("=> Giao dịch không hợp lệ (Không có chữ VD)");
            // Vẫn trả về 200 OK để SePay không gửi lại lần nữa (vì đây là giao dịch không liên quan đến web)
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("{\"success\": false, \"message\": \"Ignored\"}");
        }
        System.out.println("========== SEPAY WEBHOOK END ==========");
    }
}