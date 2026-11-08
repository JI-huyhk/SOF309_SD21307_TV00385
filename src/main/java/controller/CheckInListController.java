package controller;

import dao.BookingDAO;
import model.Booking;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/checkin-list")
public class CheckInListController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            BookingDAO bookingDAO = new BookingDAO();

            String searchKey = req.getParameter("searchKey");
            String bookingIdParam = req.getParameter("bookingId");

            List<Booking> checkinList = new ArrayList<>();

            if (bookingIdParam != null && !bookingIdParam.trim().isEmpty()) {
                int bookingId = Integer.parseInt(bookingIdParam);
                Booking b = bookingDAO.getBookingById(bookingId);
                if (b != null) {
                    checkinList.add(b);
                }
            } else if (searchKey != null && !searchKey.trim().isEmpty()) {
                checkinList = bookingDAO.searchPendingCheckins(searchKey);
            } else {
                checkinList = bookingDAO.getTodayPendingCheckins();
            }

            req.setAttribute("checkinList", checkinList);
            req.getRequestDispatcher("/checkin_confirm.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Lỗi Server khi tải danh sách: " + e.getMessage());
            req.getRequestDispatcher("/checkin_confirm.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}