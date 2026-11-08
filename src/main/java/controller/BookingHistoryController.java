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

@WebServlet("/booking-history")
public class BookingHistoryController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");

        // Làm sạch chuỗi: nếu rỗng hoặc toàn khoảng trắng thì gán về null
        if (fromDate != null && fromDate.trim().isEmpty()) fromDate = null;
        if (toDate != null && toDate.trim().isEmpty()) toDate = null;

        String dateRegex = "^\\d{4}-\\d{2}-\\d{2}$";
        if (fromDate != null && !fromDate.trim().matches(dateRegex)) fromDate = null;
        if (toDate != null && !toDate.trim().matches(dateRegex)) toDate = null;

        BookingDAO bookingDAO = new BookingDAO();

        // Gọi DAO lấy danh sách
        List<Booking> historyList = bookingDAO.getAllBookingsWithStatus(fromDate, toDate);

        // In ra Console máy chủ để kiểm tra xem Java đã đọc được bao nhiêu đơn
        System.out.println("=== [DEBUG] So luong don tim thay trong DB: " + (historyList != null ? historyList.size() : 0));

        request.setAttribute("historyList", historyList);
        request.setAttribute("fromDate", fromDate);
        request.setAttribute("toDate", toDate);

        request.getRequestDispatcher("/booking-history.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}