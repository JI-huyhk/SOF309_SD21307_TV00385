package controller;

import dao.UserDAO;
import Utils.EmailService;
import Utils.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Random;

@WebServlet(name = "RegisterController", value = "/RegisterController")
public class RegisterController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String countryCode = request.getParameter("country");
        String phoneNumber = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (password == null || !password.equals(confirmPassword)) {
            response.sendRedirect("signup.jsp?error=passwordMismatch");
            return;
        }

        UserDAO userDAO = new UserDAO();
        if (userDAO.checkPhoneExists(phoneNumber)) {
            response.sendRedirect("signup.jsp?error=1");
            return;
        }

        if (userDAO.checkEmailExists(email)) {
            response.sendRedirect("signup.jsp?error=duplicateEmailRegister");
            return;
        }

        // TẠO MÃ OTP 6 SỐ NGẪU NHIÊN
        String otpCode = String.format("%06d", new Random().nextInt(1000000));
        long expiryTime = System.currentTimeMillis() + (2 * 60 * 1000); // Hết hạn sau 2 phút (120 giây)

        // GỬI EMAIL
        boolean mailSent = EmailService.sendOTP(email, otpCode);

        if (mailSent) {
            // Lưu toàn bộ dữ liệu đăng ký tạm thời vào Session để chờ xác nhận
            HttpSession session = request.getSession();
            session.setAttribute("tempFirstName", firstName);
            session.setAttribute("tempLastName", lastName);
            session.setAttribute("tempEmail", email);
            session.setAttribute("tempCountry", countryCode);
            session.setAttribute("tempPhone", phoneNumber);
            session.setAttribute("tempPassword", password);

            // Mã hóa mật khẩu trước khi đưa vào Session chờ kích hoạt
            String securePasswordHash = PasswordUtil.hashPassword(password);
            session.setAttribute("tempPassword", securePasswordHash);

            // Lưu mã OTP và thời gian hết hạn để đối chiếu
            session.setAttribute("otpSecret", otpCode);
            session.setAttribute("otpExpiry", expiryTime);

            // Đẩy ngược lại trang signup và kích hoạt hiện popup bằng Attribute
            request.setAttribute("openOTPModal", true);
            request.getRequestDispatcher("signup.jsp").forward(request, response);
        } else {
            // Lỗi hệ thống không gửi được mail
            response.sendRedirect("signup.jsp?error=mailError");
        }
    }
}