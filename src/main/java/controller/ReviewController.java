package controller;

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

@WebServlet("/ReviewController")
public class ReviewController extends HttpServlet {

    public static class ReviewModel {
        public String customerName;
        public String comment;
        public int rating;

        public ReviewModel(String customerName, String comment, int rating) {
            this.customerName = customerName;
            this.comment = comment;
            this.rating = rating;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String roomIdStr = request.getParameter("roomId");
        if (roomIdStr == null || roomIdStr.trim().isEmpty()) {
            roomIdStr = "1"; // Mặc định hiển thị RoomID = 1 nếu không truyền param
        }
        int roomId = Integer.parseInt(roomIdStr);

        List<ReviewModel> realReviews = new ArrayList<>();
        String roomNumber = "101"; // Biến lưu mã số phòng thực tế (Ví dụ: 101, 102, 201)
        String roomType = "Standard"; // Biến lưu loại phòng (Ví dụ: Standard, Deluxe, Suite VIP)

        try (Connection conn = context.DBConnect.getConnection()) {

            // 1. TRUY VẤN LẤY ROOMNUMBER VÀ ROOMTYPE TỪ BẢNG ROOMS
            String sqlRoom = "SELECT RoomNumber, RoomType FROM Rooms WHERE RoomID = ?";
            try (PreparedStatement psRoom = conn.prepareStatement(sqlRoom)) {
                psRoom.setInt(1, roomId);
                try (ResultSet rsRoom = psRoom.executeQuery()) {
                    if (rsRoom.next()) {
                        roomNumber = rsRoom.getString("RoomNumber");
                        roomType = rsRoom.getString("RoomType");
                    }
                }
            }

            // 2. TRUY VẤN LẤY DANH SÁCH REVIEW TỪ BẢNG REVIEWS
            String sqlReviews = "SELECT CustomerName, Comment, Rating FROM Reviews WHERE RoomID = ?";
            try (PreparedStatement psReviews = conn.prepareStatement(sqlReviews)) {
                psReviews.setInt(1, roomId);
                try (ResultSet rs = psReviews.executeQuery()) {
                    while (rs.next()) {
                        String name = rs.getString("CustomerName");
                        if (name == null || name.trim().isEmpty()) {
                            name = "Khách hàng";
                        }
                        String comment = rs.getString("Comment");
                        int rating = rs.getInt("Rating");
                        realReviews.add(new ReviewModel(name, comment, rating));
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        // TRUYỀN ĐẦY ĐỦ THÔNG TIN SANG FILE JSP
        request.setAttribute("roomId", roomId);
        request.setAttribute("roomNumber", roomNumber); // Mã phòng như "101", "201"
        request.setAttribute("roomType", roomType);     // Hạng phòng như "Deluxe", "Suite VIP"
        request.setAttribute("reviews", realReviews);

        request.getRequestDispatcher("room_reviews.jsp").forward(request, response);
    }
}