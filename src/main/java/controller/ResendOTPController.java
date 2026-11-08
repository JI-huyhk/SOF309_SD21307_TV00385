package controller;

import Utils.EmailService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Random;

@WebServlet(name = "ResendOTPController", value = "/ResendOTPController")
public class ResendOTPController extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("tempEmail");

        if (email != null) {
            // Tạo lại bộ mã mới
            String newOtp = String.format("%06d", new Random().nextInt(1000000));
            long newExpiry = System.currentTimeMillis() + (2 * 60 * 1000); // 2 phút mới

            session.setAttribute("otpSecret", newOtp);
            session.setAttribute("otpExpiry", newExpiry);

            boolean sent = EmailService.sendOTP(email, newOtp);
            if (sent) {
                response.getWriter().write("success"); // Trả kết quả chữ về cho hàm AJAX nhận diện
                return;
            }
        }
        response.getWriter().write("fail");
    }
}