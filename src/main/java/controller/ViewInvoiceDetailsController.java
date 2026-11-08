package controller;

import dao.BookingDAO;
import dao.ServiceDAO;
import model.Booking;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/view-invoice-details")
public class ViewInvoiceDetailsController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookingIdStr = request.getParameter("bookingId");

        try {
            if (bookingIdStr != null && !bookingIdStr.trim().isEmpty()) {
                int bookingId = Integer.parseInt(bookingIdStr.trim());

                BookingDAO bookingDAO = new BookingDAO();
                ServiceDAO serviceDAO = new ServiceDAO();

                // 1. Lấy thông tin đơn đặt phòng từ DB
                Booking b = bookingDAO.getBookingById(bookingId);

                if (b != null) {
                    String bookingCode = b.getBookingCode();

                    // 2. Lấy chi tiết các khoản phụ phí (dịch vụ & thiệt hại)
                    double serviceCost = serviceDAO.getTotalServiceCostByBooking(bookingId);
                    double damageCost = serviceDAO.getTotalDamageCostByBooking(bookingId);

                    // 3. Tiền thuê phòng gốc (chính là TotalPrice lưu trong bảng Bookings)
                    double roomCost = b.getTotalPrice();

                    // 4. Tính Tổng tiền thanh toán chuẩn = Tiền phòng gốc + Tiền dịch vụ + Phí phạt
                    double grandTotal = roomCost + serviceCost + damageCost;

                    // 5. Đóng gói dữ liệu gửi sang bill_detail.jsp
                    request.setAttribute("bookingCode", bookingCode);
                    request.setAttribute("roomCost", roomCost);
                    request.setAttribute("serviceCost", serviceCost);
                    request.setAttribute("damageCost", damageCost);
                    request.setAttribute("grandTotal", grandTotal);

                    request.getRequestDispatcher("/bill_detail.jsp").forward(request, response);
                    return;
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi khi xem lại hóa đơn cũ: " + e.getMessage());
            e.printStackTrace();
        }

        // Nếu lỗi hoặc không tìm thấy bookingId -> quay lại trang điều hướng
        response.sendRedirect(request.getContextPath() + "/reception");
    }
}