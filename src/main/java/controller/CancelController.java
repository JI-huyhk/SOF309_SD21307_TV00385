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
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

@WebServlet("/CancelController")
public class CancelController extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookingIdStr = request.getParameter("bookingId");
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (bookingIdStr != null && !bookingIdStr.isEmpty() && userId != null) {
            try {
                int bookingId = Integer.parseInt(bookingIdStr);
                BookingDAO bookingDAO = new BookingDAO();
                Booking booking = bookingDAO.getBookingById(bookingId);

                // CHỐT CHẶN BACKEND: Chỉ cho phép hủy khi trạng thái là Pending (Chưa Check-in)
                if (booking != null && "pending".equalsIgnoreCase(booking.getStatus())) {

                    // Lấy các mốc thời gian
                    LocalDate checkIn = new java.sql.Date(booking.getCheckInDate().getTime()).toLocalDate();
                    LocalDate checkOut = new java.sql.Date(booking.getCheckOutDate().getTime()).toLocalDate();

                    java.util.Date createdAtDate = booking.getCreatedAt();
                    java.time.LocalDateTime createdAt = (createdAtDate != null) ?
                            new java.sql.Timestamp(createdAtDate.getTime()).toLocalDateTime() :
                            java.time.LocalDateTime.now();

                    java.time.LocalDateTime now = java.time.LocalDateTime.now();

                    // TÍNH TOÁN CÁC ĐIỀU KIỆN TIÊN QUYẾT
                    long daysNotice = ChronoUnit.DAYS.between(createdAt.toLocalDate(), checkIn);
                    long totalNights = ChronoUnit.DAYS.between(checkIn, checkOut);
                    long minutesElapsed = ChronoUnit.MINUTES.between(createdAt, now);

                    double totalPrice = booking.getTotalPrice();
                    double penaltyFee = 0;

                    // QUY TẮC BẤT DI BẤT DỊCH: ĐÃ HỦY LÀ TRỪ 25 ĐIỂM (BẤT KỂ LOẠI KHÁCH NÀO VÀ THỜI GIAN NÀO)
                    int penaltyPoints = 25;

                    String reason = "";
                    boolean canCancel = false;

                    // PHÂN LOẠI KHÁCH HÀNG & CHÍNH SÁCH
                    if (daysNotice >= 2 && totalNights > 10) {
                        // ==========================================
                        // LOẠI 1: KHÁCH VIP / DÀI NGÀY
                        // ==========================================
                        if (minutesElapsed <= 20) {
                            penaltyFee = 0; // Giai đoạn 1: 20 phút đầu miễn phí tiền phòng
                            reason = "Hủy phòng (Loại 1) trong 20 phút an toàn. Miễn phí tiền phòng.";
                            canCancel = true;
                        } else if (minutesElapsed <= 60) {
                            penaltyFee = totalPrice * 0.50; // Giai đoạn 2: Từ 20p đến 1 tiếng phạt 50%
                            reason = "Hủy phòng (Loại 1) trong giai đoạn 1 tiếng. Phạt 50% tổng tiền.";
                            canCancel = true;
                        } else {
                            request.setAttribute("message", "Lỗi: Nút hủy đã bị vô hiệu hóa! Đơn Loại 1 đã vượt quá thời gian 1 giờ.");
                            request.setAttribute("msgType", "error");
                        }
                    } else {
                        // ==========================================
                        // LOẠI 2: KHÁCH TIÊU CHUẨN / NGẮN NGÀY
                        // ==========================================
                        if (minutesElapsed <= 20) {
                            penaltyFee = totalPrice * 0.05; // 20 phút đầu phạt 5%
                            reason = "Hủy phòng (Loại 2) trong 20 phút. Phạt 5% tổng tiền.";
                            canCancel = true;
                        } else {
                            request.setAttribute("message", "Lỗi: Nút hủy đã bị vô hiệu hóa! Đơn Loại 2 đã vượt quá 20 phút.");
                            request.setAttribute("msgType", "error");
                        }
                    }

                    // THỰC THI HỦY
                    if (canCancel) {
                        if (bookingDAO.cancelBookingWithAdvancedPolicy(bookingId, userId, penaltyFee, penaltyPoints, reason)) {
                            // KIỂM TRA ĐIỂM UY TÍN SAU KHI HỦY
                            dao.UserDAO uDao = new dao.UserDAO();
                            java.util.Map<String, Object> pts = uDao.getUserPoints(userId);
                            int currentUyTin = (pts != null && pts.get("uyTin") != null) ? (Integer) pts.get("uyTin") : 100;

                            if (currentUyTin <= 0) {
                                response.sendRedirect("home.jsp");
                                return; // Dừng thực thi để không chạy tới phần forward phía dưới
                            }

                            request.setAttribute("message", "Đã hủy đơn thành công! Phí phạt là " + String.format("%,.0f", penaltyFee) + " VNĐ. Xem chi tiết trong lịch sử.");
                            request.setAttribute("msgType", "success");
                        } else {
                            request.setAttribute("message", "Hệ thống gặp lỗi khi xử lý hủy!");
                            request.setAttribute("msgType", "error");
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("message", "Có lỗi xảy ra: " + e.getMessage());
                request.setAttribute("msgType", "error");
            }
        }
        request.getRequestDispatcher("ActivityController").forward(request, response);
    }
}