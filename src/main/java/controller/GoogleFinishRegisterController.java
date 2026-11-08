package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "GoogleFinishRegisterController", value = "/GoogleFinishRegisterController")
public class GoogleFinishRegisterController extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String phoneNumber = request.getParameter("phone");

        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("ggEmail");
        String firstName = (String) session.getAttribute("ggFirstName");
        String lastName = (String) session.getAttribute("ggLastName");

        // Mật khẩu cho tài khoản Google có thể tạo ngẫu nhiên hoặc để mặc định vì họ luôn đăng nhập bằng nút Google
        String defaultPassword = "VerdelleGoogleAuth123@";

        UserDAO userDAO = new UserDAO();

        // Kiểm tra xem số điện thoại nhập vào có bị trùng với ai khác không
        if (userDAO.checkPhoneExists(phoneNumber)) {
            response.sendRedirect("index.jsp?error=1"); // Báo lỗi trùng số điện thoại
            return;
        }

        // Đăng ký tài khoản chính thức vào DB
        boolean isSuccess = userDAO.registerUser(firstName, lastName, email, "+84", phoneNumber, defaultPassword);

        if (isSuccess) {
            // Đăng ký xong nạp session và cho vào trang chủ luôn nhen Mint
            session.setAttribute("userPhone", phoneNumber);
            session.setAttribute("firstName", firstName);
            session.setAttribute("userEmail", email);
            session.setAttribute("userRole", "user");

            // Xóa bộ nhớ tạm Google
            session.removeAttribute("ggEmail");
            session.removeAttribute("ggFirstName");
            session.removeAttribute("ggLastName");

            response.sendRedirect("home.jsp");
        } else {
            response.sendRedirect("index.jsp?error=systemError");
        }
    }
}