package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;

import java.io.IOException;

@WebServlet(name = "updateController", value = "/update")
public class UpdateController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        UserDAO dao = new UserDAO();
        User user = dao.findById(id);
        req.setAttribute("user", user);
        req.getRequestDispatcher("/WEB-INF/update.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        int id = Integer.parseInt(req.getParameter("id"));
        String firstName = req.getParameter("firstName");
        String lastName = req.getParameter("lastName");
        String email = req.getParameter("email");
        String countryCode = req.getParameter("countryCode");
        String phoneNumber = req.getParameter("phoneNumber");
        String password = req.getParameter("password");
        String role = req.getParameter("role");

        UserDAO dao = new UserDAO();
        User user = dao.findById(id);
        if (user != null) {
            if (dao.checkEmailDuplicateForUpdate(email, id)) {
                resp.sendRedirect(req.getContextPath() + "/update?id=" + id + "&error=duplicateEmail");
                return;
            }

            String currentRole = user.getRole();
            if (currentRole != null && currentRole.trim().equalsIgnoreCase("admin")
                    && !role.trim().equalsIgnoreCase("admin")) {
                if (dao.countActiveAdmins() <= 1) {
                    resp.sendRedirect(req.getContextPath() + "/update?id=" + id + "&error=lastAdminRestrict");
                    return;
                }
            }

            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setEmail(email);
            user.setCountryCode(countryCode);
            user.setPhoneNumber(phoneNumber);
            user.setPassword(password);
            user.setRole(role);

            dao.update(user);
        }
        resp.sendRedirect(req.getContextPath() + "/quan-ly-tai-khoan");
    }
}