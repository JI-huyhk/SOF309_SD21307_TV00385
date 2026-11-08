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

@WebServlet(name = "ReceptionController", urlPatterns = {"/reception"})
public class ReceptionController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 🔥 THÊM VÀO ĐÂY: Ép trình duyệt không được lưu cache dữ liệu cũ
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1.
        response.setHeader("Pragma", "no-cache"); // HTTP 1.0.
        response.setDateHeader("Expires", 0); // Proxies.

        BookingDAO bookingDAO = new BookingDAO();

        // 1. Lấy dữ liệu số liệu thống kê từ BookingDAO
        int availableRooms = bookingDAO.countAvailableRooms();
        int bookedRooms = bookingDAO.countBookedRooms();
        int dirtyRooms = bookingDAO.countDirtyRooms();
        int incomingCheckins = bookingDAO.countIncomingCheckinsToday();

        request.setAttribute("availableRooms", availableRooms);
        request.setAttribute("bookedRooms", bookedRooms);
        request.setAttribute("dirtyRooms", dirtyRooms);
        request.setAttribute("incomingCheckins", incomingCheckins);

        // 2. Lấy danh sách khách hàng check-in hôm nay
        List<Booking> todayBookings = bookingDAO.getTodayCheckins();
        request.setAttribute("todayBookings", todayBookings);

        // 3. Chuyển tiếp (Forward) sang đúng file giao diện reception.jsp
        request.getRequestDispatcher("reception.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}