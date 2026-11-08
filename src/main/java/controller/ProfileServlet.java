package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/profile") // Nhận yêu cầu khi user click vào link trên Navbar
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Lấy session hiện tại ra để kiểm tra xem ai đang đăng nhập
        HttpSession session = request.getSession();
        String phone = (String) session.getAttribute("userPhone");

        if (phone != null) {
            // 2. Gọi DAO để lấy toàn bộ đối tượng User từ cơ sở dữ liệu lên
            dao.UserDAO userDAO = new dao.UserDAO();
            model.User userObj = userDAO.getUserByPhone(phone); // Đảm bảo hàm này trả về Object User nhen

            // 3. Đẩy nguyên chiếc Object "user" này vào session cho profile.jsp xài
            session.setAttribute("user", userObj);
        }

        // Chuyển hướng sang giao diện profile.jsp
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getSession().setAttribute("updateStatus", "success");
        response.sendRedirect(request.getContextPath() + "/profile");
    }
}
