package controller;

import dao.BookingDAO;
import model.Booking;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/ActivityController")
public class ActivityController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        // BẠN LƯU Ý: Thay "userId" bằng đúng key session ID khách hàng mà hệ thống bạn đang dùng khi Login
        Integer customerId = (Integer) session.getAttribute("userId");

        if (customerId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        BookingDAO dao = new BookingDAO();
        List<Booking> list = dao.getBookingHistory(customerId);

        request.setAttribute("bookingHistory", list);
        request.getRequestDispatcher("activity.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}