package controller;

import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Timestamp;

@WebServlet("/SubmitReviewController")
public class SubmitReviewController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain;charset=UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("UNAUTHORIZED");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        User user = (User) session.getAttribute("user");

        if (userId == null && user != null) {
            userId = user.getId();
        }

        if (userId == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("UNAUTHORIZED");
            return;
        }

        String customerName = (String) session.getAttribute("firstName");
        if (customerName == null || customerName.trim().isEmpty()) {
            if (user != null && user.getFirstName() != null) {
                customerName = user.getFirstName();
            } else {
                customerName = "Khách hàng #" + userId;
            }
        }

        String roomIdStr = request.getParameter("roomId");
        String bookingIdStr = request.getParameter("bookingId");
        String bookingCodeStr = request.getParameter("bookingCode");
        String ratingStr = request.getParameter("rating");
        String comment = request.getParameter("comment");

        if (roomIdStr != null && !roomIdStr.trim().isEmpty() && ratingStr != null && !ratingStr.trim().isEmpty()) {
            try {
                int roomId = Integer.parseInt(roomIdStr.trim());
                int rating = Integer.parseInt(ratingStr.trim());
                Timestamp now = new Timestamp(System.currentTimeMillis());

                try (Connection conn = context.DBConnect.getConnection()) {
                    // Cập nhật lưu thêm BookingCode
                    String sqlInsert = "INSERT INTO Reviews (RoomID, CustomerName, Comment, Rating, CreatedAt, BookingID) VALUES (?, ?, ?, ?, ?, ?)";

                    try (PreparedStatement ps = conn.prepareStatement(sqlInsert)) {
                        ps.setInt(1, roomId);
                        ps.setString(2, customerName);
                        ps.setString(3, comment != null ? comment : "");
                        ps.setInt(4, rating);
                        ps.setTimestamp(5, now);

                        // 2. Truyền bookingId (kiểu int) vào cột BookingID thay vì bookingCode (chuỗi)
                        if (bookingIdStr != null && !bookingIdStr.trim().isEmpty()) {
                            ps.setInt(6, Integer.parseInt(bookingIdStr.trim()));
                        } else {
                            ps.setNull(6, java.sql.Types.INTEGER);
                        }

                        ps.executeUpdate();
                    }

                    // Cập nhật IsReviewed = 1 trong bảng Bookings để chặn đánh giá lần 2
                    if (bookingIdStr != null && !bookingIdStr.trim().isEmpty()) {
                        String sqlUpdateBooking = "UPDATE Bookings SET IsReviewed = 1 WHERE BookingID = ?";
                        try (PreparedStatement psB = conn.prepareStatement(sqlUpdateBooking)) {
                            psB.setInt(1, Integer.parseInt(bookingIdStr));
                            psB.executeUpdate();
                        } catch (Exception ignored) {
                            // Bỏ qua nếu bảng Bookings chưa có cột IsReviewed
                        }
                    }
                }

                response.setStatus(HttpServletResponse.SC_OK);
                return;

            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("INVALID_INPUT_NUMBER");
                return;
            } catch (Exception e) {
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                return;
            }
        }

        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
    }
}