package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;

import java.io.IOException;

@WebServlet(name = "userdetailController", value = "/userdetail")
public class UserdetailController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        UserDAO dao = new UserDAO();
        User user = dao.findById(id);
        req.setAttribute("user", user);
        req.getRequestDispatcher("/WEB-INF/userdetail.jsp").forward(req, resp);
    }
}