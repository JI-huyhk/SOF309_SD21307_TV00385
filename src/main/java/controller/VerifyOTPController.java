package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "VerifyOTPController", value = "/VerifyOTPController")
public class VerifyOTPController extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String inputOtp = request.getParameter("otpInput");
        HttpSession session = request.getSession();

        String secretOtp = (String) session.getAttribute("otpSecret");
        Long expiryTime = (Long) session.getAttribute("otpExpiry");

        // 1. Kiểm tra hết hạn mã
        if (expiryTime == null || System.currentTimeMillis() > expiryTime) {
            request.setAttribute("openOTPModal", true);
            request.setAttribute("otpError", "Mã OTP đã hết hạn! Vui lòng ấn Gửi lại mã.");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
            return;
        }

        // 2. Kiểm tra tính chính xác của mã số
        if (secretOtp != null && secretOtp.equals(inputOtp)) {
            // Lấy toàn bộ thông tin đăng ký tạm thời ra để ghi vào Database
            String firstName = (String) session.getAttribute("tempFirstName");
            String lastName = (String) session.getAttribute("tempLastName");
            String email = (String) session.getAttribute("tempEmail");
            String countryCode = (String) session.getAttribute("tempCountry");
            String phoneNumber = (String) session.getAttribute("tempPhone");
            String password = (String) session.getAttribute("tempPassword");

            UserDAO userDAO = new UserDAO();
            boolean isSuccess = userDAO.registerUser(firstName, lastName, email, countryCode, phoneNumber, password);

            if (isSuccess) {
                // Xóa sạch bộ nhớ tạm trong Session sau khi hoàn thành mục đích
                session.removeAttribute("otpSecret");
                session.removeAttribute("otpExpiry");
                session.removeAttribute("tempPassword");

                // Điều hướng về trang đăng nhập kèm thông báo xanh lá thành công
                response.sendRedirect("index.jsp?status=registerSuccess");
            } else {
                response.sendRedirect("signup.jsp?error=1");
            }
        } else {
            // Nhập sai mã OTP, giữ nguyên trạng thái mở popup và hiển thị báo lỗi đỏ
            request.setAttribute("openOTPModal", true);
            request.setAttribute("otpError", "Mã xác thực OTP không chính xác. Thử lại nhé!");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
        }
    }
}