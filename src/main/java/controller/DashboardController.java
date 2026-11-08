package controller;

import dao.BookingDAO;
import model.Booking;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "DashboardController", urlPatterns = {"/dashboard"})
public class DashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 🔥 ĐÃ THÊM: Ép trình duyệt dọn sạch cache (Sửa triệt để lỗi bấm nút load lại vẫn hiện "Đang chờ")
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1.
        response.setHeader("Pragma", "no-cache"); // HTTP 1.0.
        response.setDateHeader("Expires", 0); // Proxies.

        BookingDAO bookingDAO = new BookingDAO();

        // 1. Nạp số liệu thống kê vào bộ nhớ đệm Request
        request.setAttribute("availableRooms", bookingDAO.countAvailableRooms());
        request.setAttribute("bookedRooms", bookingDAO.countBookedRooms());
        request.setAttribute("dirtyRooms", bookingDAO.countDirtyRooms());
        request.setAttribute("incomingCheckins", bookingDAO.countIncomingCheckinsToday());

        // 2. Lấy danh sách khách hàng check-in hôm nay
        List<Booking> todayBookings = bookingDAO.getTodayCheckins();
        request.setAttribute("todayBookings", todayBookings);

        // 3. Gọi trực tiếp file giao diện hiển thị của cậu
        request.getRequestDispatcher("reception.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}