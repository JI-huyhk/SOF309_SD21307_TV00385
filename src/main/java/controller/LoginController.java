package controller;

import Utils.PasswordUtil;
import dao.UserDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "LoginController", urlPatterns = {"/LoginController"})
public class LoginController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String phone = request.getParameter("phone");
        String password = request.getParameter("password");

        UserDAO userDAO = new UserDAO();
        HttpSession session = request.getSession();


        // 1. Kiểm tra số điện thoại tồn tại
        boolean isPhoneExists = userDAO.checkPhoneExists(phone);
        if (!isPhoneExists) {
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=userNotFound");
            return;
        }

        // 2. ĐỒNG BỘ TỪ FILE 2: Mã hóa mật khẩu vừa nhập để đi so khớp với DB
        String hashedInputPassword = PasswordUtil.hashPassword(password);

        // 3. Kiểm tra mật khẩu (Sử dụng mật khẩu đã được mã hóa)
        boolean isPasswordCorrect = userDAO.validatePassword(phone, hashedInputPassword);
        if (!isPasswordCorrect) {
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=wrongPassword");
            return;
        }

        // 4. Lấy thông tin user nếu đăng nhập thành công
        int userId = userDAO.getUserIdByPhone(phone);
        System.out.println(">>> DEBUG LOGIN: SĐT " + phone + " có UserID là: " + userId); // Add dòng này
        String firstName = userDAO.getFirstNameByPhone(phone);
        String email = userDAO.getEmailByPhone(phone);

        String role = userDAO.getRoleByPhone(phone);
        if (role != null) {
            role = role.trim().toLowerCase();
        }

        // 5. Lưu thông tin vào Session
        session.setAttribute("userId", userId);
        session.setAttribute("userPhone", phone);
        session.setAttribute("firstName", firstName);
        session.setAttribute("userEmail", email);
        session.setAttribute("userRole", role);

        User currentUser = new User();
        currentUser.setId(userId);
        currentUser.setPhoneNumber(phone);
        currentUser.setFirstName(firstName);
        currentUser.setEmail(email);
        currentUser.setRole(role);

        session.setAttribute("currentUser", currentUser);
        session.setAttribute("user", currentUser);
        session.setAttribute("status", "User");
        // 6. Điều hướng theo quyền
        if ("admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/quan-ly-tai-khoan");
        } else if ("hotelmanager".equals(role) || "partner".equals(role) || "hotel partner".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/home.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/home.jsp");
    }
}