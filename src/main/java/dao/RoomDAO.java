package dao;

import context.DBConnect;
import model.Room;
import java.sql.*;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

public class RoomDAO {

    // =========================================================================
    // 1. CÁC HÀM QUẢN LÝ PHÒNG CƠ BẢN (Cho Manager)
    // =========================================================================
    public List<Room> getRoomsByPartner(int ownerId) {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT * FROM Rooms WHERE Status <> 'Deleted'";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRoomFromResultSet(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public Room getRoomById(int roomId) {
        String sql = "SELECT * FROM Rooms WHERE RoomID = ? AND Status <> 'Deleted'";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRoomFromResultSet(rs);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public boolean toggleRoomStatus(int roomId, String status, int alternativeParam) {
        String sql = "UPDATE Rooms SET Status = ? WHERE RoomID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status); ps.setInt(2, roomId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); } return false;
    }

    public boolean addRoom(Room room) {
        String sql = "INSERT INTO Rooms (RoomNumber, RoomType, Price, Status, Condition, Area, MaxPeople) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, room.getRoomNumber());
            ps.setString(2, room.getRoomTypeName() != null ? room.getRoomTypeName() : "Phòng Tiêu Chuẩn");
            ps.setDouble(3, room.getPrice());
            ps.setString(4, room.getStatus() != null ? room.getStatus() : "Available");
            ps.setString(5, room.getCondition() != null ? room.getCondition() : "Clean");
            ps.setInt(6, room.getArea() > 0 ? room.getArea() : 35);
            ps.setInt(7, room.getMaxPeople() > 0 ? room.getMaxPeople() : 4);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); } return false;
    }

    public boolean updateRoom(Room room) {
        String sql = "UPDATE Rooms SET RoomNumber = ?, RoomType = ?, Price = ?, Status = ?, Condition = ?, Area = ?, MaxPeople = ? WHERE RoomID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, room.getRoomNumber());
            ps.setString(2, room.getRoomTypeName());
            ps.setDouble(3, room.getPrice());
            ps.setString(4, room.getStatus());
            ps.setString(5, room.getCondition());
            ps.setInt(6, room.getArea());
            ps.setInt(7, room.getMaxPeople());
            ps.setInt(8, room.getRoomId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); } return false;
    }

    public boolean deleteRoom(int roomId) {
        String sql = "UPDATE Rooms SET Status = 'Deleted' WHERE RoomID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId); return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); } return false;
    }

    public int countRoomsByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM Rooms WHERE Status = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return rs.getInt(1); }
        } catch (Exception e) { e.printStackTrace(); } return 0;
    }

    public int countRoomsByCondition(String condition) {
        String sql = "SELECT COUNT(*) FROM Rooms WHERE Condition = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, condition);
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return rs.getInt(1); }
        } catch (Exception e) { e.printStackTrace(); } return 0;
    }

    public boolean updateRoomCondition(int roomId, String condition) {
        String sql = "UPDATE Rooms SET Condition = ? WHERE RoomID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, condition); ps.setInt(2, roomId); return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); } return false;
    }

    // =========================================================================
    // 2. HỆ THỐNG TÌM KIẾM PHÒNG (Cho Customer)
    // =========================================================================

    /**
     * MẸO: Hàm này dành cho lúc khách vừa tải trang JSP lên, chưa nhập filter gì.
     * Nó gọi thẳng hàm tìm kiếm siêu cấp bên dưới, set mặc định ngày hôm nay và 1 người.
     * Nhờ vậy, phòng nào đã Book/UnderRepair hôm nay cũng bị ẩn luôn, không còn tình trạng "tiêu chuẩn kép".
     */
    public List<Room> getAvailableRooms() {
        return searchRoomsAdvanced(LocalDate.now(), LocalDate.now().plusDays(1), 1, 0, null, null);
    }

    public List<Room> searchRoomsAdvanced(LocalDate checkIn, LocalDate checkOut, int adults, int children, Double minPrice, Double maxPrice) {
        List<Room> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT r.* FROM Rooms r " +
                        "WHERE r.Status = 'Available' " +
                        "AND r.Condition <> 'UnderRepair' " + // Dirty vẫn qua ải thành công
                        "AND r.MaxAdults >= ? " +
                        "AND r.MaxChildren >= ? "
        );

        if (checkIn != null && checkOut != null) {
            sql.append("AND NOT EXISTS ( " +
                    "    SELECT 1 FROM Bookings b " +
                    "    WHERE b.RoomID = r.RoomID " +
                    // Chỉ dùng logic so sánh ngày để tìm các đơn trùng lặp
                    "    AND b.CheckInDate < ? " +
                    "    AND b.CheckOutDate > ? " +
                    // Nếu đơn trùng lặp đó KHÔNG NẰM trong bảng Cancelled_Penalties -> Phòng đang bận!
                    "    AND b.BookingStatus NOT IN ('Completed', 'Cancelled', 'CheckedOut') " +
                    "    AND b.BookingCode NOT IN (SELECT c.BookingCode FROM Cancelled_Penalties c) " +
                    ") ");
// ... (phần RoomMaintenance giữ nguyên) ...
            sql.append("AND NOT EXISTS ( " +
                    "    SELECT 1 FROM RoomMaintenance m " +
                    "    WHERE m.RoomID = r.RoomID " +
                    "    AND m.Status NOT IN ('Completed', 'Cancelled') " +
                    "    AND m.StartDate < ? " +
                    "    AND m.EndDate > ? " +
                    ") ");
        }

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = 1;
            ps.setInt(index++, adults);
            ps.setInt(index++, children);

            if (checkIn != null && checkOut != null) {
                ps.setDate(index++, java.sql.Date.valueOf(checkOut));
                ps.setDate(index++, java.sql.Date.valueOf(checkIn));
                ps.setDate(index++, java.sql.Date.valueOf(checkOut));
                ps.setDate(index++, java.sql.Date.valueOf(checkIn));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Room room = mapRoomFromResultSet(rs); // Dùng hàm mapping chung cho gọn code
                    room.setPrice(rs.getDouble("Price")); // Base price
                    list.add(room);
                }
            }

            // Cập nhật giá theo lịch (MARS issue resolved!)
            for (Room room : list) {
                double basePrice = room.getPrice();
                double finalDisplayPrice = basePrice;
                if (checkIn != null && checkOut != null && !checkOut.isBefore(checkIn)) {
                    long nights = ChronoUnit.DAYS.between(checkIn, checkOut);
                    if (nights > 0) {
                        double totalStayPrice = 0;
                        for (LocalDate date = checkIn; date.isBefore(checkOut); date = date.plusDays(1)) {
                            totalStayPrice += getDailyPrice(conn, room.getRoomId(), date, basePrice);
                        }
                        finalDisplayPrice = totalStayPrice / nights;
                    }
                }
                room.setPrice(finalDisplayPrice);
            }

            // Lọc giá sau cùng
            list.removeIf(r -> (minPrice != null && r.getPrice() < minPrice) ||
                    (maxPrice != null && r.getPrice() > maxPrice));

            // SẮP XẾP DANH SÁCH PHÒNG THEO GIÁ (TỪ THẤP ĐẾN CAO) TRƯỚC KHI TRẢ VỀ CHO JSP
            list.sort((r1, r2) -> Double.compare(r1.getPrice(), r2.getPrice()));

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private double getDailyPrice(Connection conn, int roomId, LocalDate date, double basePrice) {
        String sql = "SELECT CustomPrice FROM RoomPricingCalendar WHERE RoomID = ? AND TargetDate = ? AND IsActive = 1";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ps.setDate(2, java.sql.Date.valueOf(date));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getDouble("CustomPrice");
            }
        } catch (Exception e) { e.printStackTrace(); }
        return basePrice;
    }

    // =========================================================================
    // LẤY GIÁ PHÒNG CAO NHẤT TỪ DB CHO THANH KÉO (UI)
    // =========================================================================
    public double getMaxRoomPrice() {
        String sql = "SELECT MAX(Price) FROM Rooms WHERE Status <> 'Deleted'";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                double maxPrice = rs.getDouble(1);
                return maxPrice > 0 ? maxPrice : 15000000;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 15000000; // Giá trị mặc định dự phòng nếu có lỗi
    }

    // Hàm phụ trợ giúp code bớt cồng kềnh
    private Room mapRoomFromResultSet(ResultSet rs) throws SQLException {
        Room room = new Room();
        int roomIdFromDB = rs.getInt("RoomID");
        room.setId(roomIdFromDB);
        room.setRoomId(roomIdFromDB);
        room.setRoomNumber(rs.getString("RoomNumber"));
        room.setPrice(rs.getDouble("Price"));
        room.setStatus(rs.getString("Status"));

        String roomType = rs.getString("RoomType");
        room.setRoomTypeName(roomType != null ? roomType : "Phòng Tiêu Chuẩn");

        try { room.setArea(rs.getInt("Area")); } catch (Exception e) { room.setArea(35); }
        try { room.setMaxPeople(rs.getInt("MaxPeople")); } catch (Exception e) { room.setMaxPeople(4); }
        try { room.setCondition(rs.getString("Condition")); } catch (Exception e) { room.setCondition("Clean"); }
        try { room.setMaxAdults(rs.getInt("MaxAdults")); } catch (Exception e) { room.setMaxAdults(2); }
        try { room.setMaxChildren(rs.getInt("MaxChildren")); } catch (Exception e) { room.setMaxChildren(1); }
        try { room.setImage(rs.getString("Image")); } catch (Exception e) { room.setImage(""); }
        try { room.setDescription(rs.getString("Description")); } catch (Exception e) { room.setDescription(""); }
        try { room.setHasBathtub(rs.getBoolean("HasBathtub")); } catch (Exception e) { room.setHasBathtub(false); }
        try { room.setHasBreakfast(rs.getBoolean("HasBreakfast")); } catch (Exception e) { room.setHasBreakfast(false); }
        try { room.setRecommended(rs.getBoolean("IsRecommended")); } catch (Exception e) { room.setRecommended(false); }
        return room;
    }
}