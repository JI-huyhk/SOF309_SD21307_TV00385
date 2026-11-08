package controller;

import context.DBConnect;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/api/check-booking-status")
public class CheckBookingStatusController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        boolean hasWaitingBooking = false;
        List<String> dirtyRooms = new ArrayList<>();

        // 1. Kiểm tra đơn đặt phòng đang chờ (Confirmed)
        String sqlBooking = "SELECT COUNT(*) FROM Bookings WHERE BookingStatus = 'Confirmed'";

        // 🔥 ĐÃ SỬA: Thay 'RoomStatus' thành 'Condition' cho đúng chuẩn file SQL của ông
        String sqlRooms = "SELECT RoomNumber FROM Rooms WHERE Condition = 'Dirty'";

        try (Connection conn = new DBConnect().getConnection()) {
            // Check đơn hàng chờ
            try (PreparedStatement ps = conn.prepareStatement(sqlBooking);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    hasWaitingBooking = true;
                }
            }

            // Check danh sách phòng dơ
            try (PreparedStatement ps = conn.prepareStatement(sqlRooms);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    dirtyRooms.add(rs.getString("RoomNumber"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Gộp kết quả trả về dạng chuỗi JSON
        String dirtyRoomsStr = String.join(", ", dirtyRooms);
        String jsonResult = "{\"hasWaiting\":" + hasWaitingBooking + ", \"dirtyRooms\":\"" + dirtyRoomsStr + "\"}";

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(jsonResult);
    }
}