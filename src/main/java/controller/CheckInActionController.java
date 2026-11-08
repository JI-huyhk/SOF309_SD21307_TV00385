package controller;

import dao.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/checkin-action")
public class CheckInActionController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String action = req.getParameter("action");
            String bookingIdParam = req.getParameter("bookingId");
            String roomIdParam = req.getParameter("roomId");

            if ("checkin".equals(action) && bookingIdParam != null && !bookingIdParam.trim().isEmpty()) {
                int bookingId = Integer.parseInt(bookingIdParam);
                int roomId = (roomIdParam != null && !roomIdParam.trim().isEmpty()) ? Integer.parseInt(roomIdParam) : 0;

                BookingDAO bookingDAO = new BookingDAO();
                boolean success = bookingDAO.processCheckIn(bookingId, roomId);

                if (success) {
                    // Check-in thành công -> Chuyển hướng thẳng sang trang Danh Sách Check-out
                    resp.sendRedirect(req.getContextPath() + "/checkout-list");
                    return;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        // Nếu thất bại thì quay lại trang danh sách Check-in
        resp.sendRedirect(req.getContextPath() + "/checkin-list");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.sendRedirect(req.getContextPath() + "/checkin-list");
    }
}