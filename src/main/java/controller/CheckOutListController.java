package controller;

import dao.BookingDAO;
import model.Booking;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/checkout-list")
public class CheckOutListController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            BookingDAO bookingDAO = new BookingDAO();
            String searchKey = req.getParameter("searchKey");

            // Lấy danh sách các đơn đã CheckedIn
            List<Booking> checkoutList = bookingDAO.getCheckedInBookings(searchKey);

            req.setAttribute("checkoutList", checkoutList);
            req.getRequestDispatcher("/checkout_confirm.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Lỗi Server khi tải danh sách Check-out: " + e.getMessage());
            req.getRequestDispatcher("/checkout_confirm.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}