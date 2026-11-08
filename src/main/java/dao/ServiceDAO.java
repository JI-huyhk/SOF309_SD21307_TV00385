package dao;

import context.DBConnect;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ServiceDAO {

    // 1. Đối tượng thực thể ánh xạ chuẩn 100% với bảng Services
    public static class HotelService {
        public int serviceId;
        public String serviceName;
        public double price;
        public String unit;
        public String description;
    }

    // 2. Cấu trúc thực thể đại diện cho mục đền bù (Gồm cả chi phí sửa thực tế lưu nội bộ)
    public static class RoomFurniture {
        public int furnitureId;
        public String furnitureName;
        public double damagePenalty;    // Tiền phạt thu của khách (2tr8, 4tr, 7tr, 15tr)
        public String description;
        public double actualRepairCost; // Chi phí sửa chữa thực tế
    }

    // =========================================================================
    // CÁC HÀM TRUY VẤN DỮ LIỆU (SELECT)
    // =========================================================================

    // Hàm quét toàn bộ mặt hàng tiêu thụ đang kích hoạt (Minibar)
    public List<HotelService> getAllActiveServices() {
        List<HotelService> list = new ArrayList<>();
        String sql = "SELECT ServiceID, ServiceName, Price, Unit, Description FROM Services WHERE IsActive = 1";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                HotelService s = new HotelService();
                s.serviceId = rs.getInt("ServiceID");
                s.serviceName = rs.getString("ServiceName");
                s.price = rs.getDouble("Price");
                s.unit = rs.getString("Unit");
                s.description = rs.getString("Description");
                list.add(s);
            }
        } catch (Exception e) {
            System.out.println("Lỗi lấy danh sách mặt hàng Services: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    // Hàm lấy danh sách các hạng mục phạt đền bù theo BookingID (Tự động map 3 mức độ phạt mới)
    public List<RoomFurniture> getFurnitureByBooking(int bookingId) {
        List<RoomFurniture> list = new ArrayList<>();
        String sql = "SELECT f.FurnitureID, f.FurnitureName, f.DamagePenalty, f.Description " +
                "FROM Furniture f " +
                "JOIN RoomTypeFurniture rtf ON f.FurnitureID = rtf.FurnitureID " +
                "JOIN Rooms r ON rtf.RoomTypeID = r.RoomTypeID " +
                "JOIN Bookings b ON r.RoomID = b.RoomID " +
                "WHERE b.BookingID = ?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RoomFurniture f = new RoomFurniture();
                    f.furnitureId = rs.getInt("FurnitureID");
                    f.furnitureName = rs.getString("FurnitureName");
                    f.damagePenalty = rs.getDouble("DamagePenalty");
                    f.description = rs.getString("Description");
                    f.actualRepairCost = 0; // Mặc định lúc quét tính tiền check-out chưa sửa nên bằng 0
                    list.add(f);
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi quét danh mục phạt theo Booking: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    // =========================================================================
    // 📊 BỔ SUNG: CÁC HÀM TÍNH TỔNG TIỀN ĐỂ ĐỒNG BỘ CHECK-OUT BILL
    // =========================================================================

    // 1. Hàm tính tổng tiền các dịch vụ (Minibar, ăn uống...) mà khách đã dùng theo BookingID
    public double getTotalServiceCostByBooking(int bookingId) {
        String sql = "SELECT SUM(TotalPrice) FROM BookingServices WHERE BookingID = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble(1); // Trả về tổng tiền SUM thu được
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi tính tổng tiền dịch vụ trong ServiceDAO: " + e.getMessage());
            e.printStackTrace();
        }
        return 0.0;
    }

    // 2. Hàm tính tổng tiền phạt đền bù hư hại vật tư theo BookingID
    public double getTotalDamageCostByBooking(int bookingId) {
        String sql = "SELECT SUM(PenaltyPaid) FROM BookingFurnitureDamage WHERE BookingID = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble(1); // Trả về tổng tiền phạt SUM thu được
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi tính tổng tiền đền bù vật tư trong ServiceDAO: " + e.getMessage());
            e.printStackTrace();
        }
        return 0.0;
    }

    // =========================================================================
    // CÁC HÀM LƯU DỮ LIỆU XUỐNG DATABASE (INSERT)
    // =========================================================================

    // Hàm lưu vết món minibar ăn uống khách đã dùng
    public void insertBookingService(int bookingId, int serviceId, int qty, double totalPrice) {
        String sql = "INSERT INTO BookingServices (BookingID, ServiceID, Quantity, TotalPrice, UsedDate) VALUES (?, ?, ?, ?, GETDATE())";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ps.setInt(2, serviceId);
            ps.setInt(3, qty);
            ps.setDouble(4, totalPrice);
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("Lỗi chèn Booking Dịch vụ: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Hàm lưu vết danh mục phạt và cấp độ thiệt hại khách làm hỏng
    public void insertFurnitureDamage(int bookingId, int furnitureId, int qty, double totalPenalty) {
        String sql = "INSERT INTO BookingFurnitureDamage (BookingID, FurnitureID, Quantity, PenaltyPaid, ActualRepairCost) VALUES (?, ?, ?, ?, 0)";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ps.setInt(2, furnitureId);
            ps.setInt(3, qty);
            ps.setDouble(4, totalPenalty);
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("Lỗi chèn Thiệt hại vật tư: " + e.getMessage());
            e.printStackTrace();
        }
    }
}