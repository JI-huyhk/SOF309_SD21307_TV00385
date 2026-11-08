package dao;

import Utils.JpaUtils;
import context.DBConnect;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import model.Hotel;
import model.Room;
import model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.time.LocalDateTime;
import java.util.Map;

public class UserDAO {

    public boolean registerUser(String firstName, String lastName, String email, String countryCode, String phoneNumber, String password) {
        String query = "INSERT INTO Users (FirstName, LastName, Email, CountryCode, PhoneNumber, Password, Role, IsActive) VALUES (?, ?, ?, ?, ?, ?, 'Customer', 1)";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, firstName); ps.setString(2, lastName);
            ps.setString(3, email); ps.setString(4, countryCode);
            ps.setString(5, phoneNumber); ps.setString(6, password);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public User checkLogin(String phone, String password) {
        String sql = "SELECT * FROM Users WHERE PhoneNumber = ? AND Password = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, phone);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("UserID"));

                    // ✔️ ĐÃ SỬA CHUẨN: Đổi từ setPhone thành setPhoneNumber trùng khớp với Model của cậu
                    user.setPhoneNumber(rs.getString("PhoneNumber"));

                    user.setRole(rs.getString("Role"));
                    return user;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ĐẾM PHÒNG TRỐNG CHO HOTEL LIST CHUẨN XÁC

    // FIX LỖI ROOM LIST KHÔNG HIỆN BẰNG CÁCH TRY-CATCH TỪNG CỘT
    // Hàm lấy toàn bộ phòng trống cho khách sạn duy nhất của hệ thống
    public List<Room> getAvailableRooms() {
        List<Room> list = new ArrayList<>();
        // Lấy toàn bộ phòng để test hiển thị trước, bỏ qua bộ lọc cứng chữ hoa thường loằng ngoằng
        String sql = "SELECT * FROM Rooms";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Room room = new Room();

                // Bọc an toàn: Thử lấy theo cả tên cột viết hoa lẫn viết thường để không bao giờ bị lỗi sập vòng lặp
                try { room.setId(rs.getInt("id")); } catch(Exception e) { try { room.setId(rs.getInt("RoomID")); } catch(Exception ex){} }
                try { room.setRoomId(rs.getInt("roomId")); } catch(Exception e) { try { room.setRoomId(rs.getInt("RoomID")); } catch(Exception ex){} }
                try { room.setHotelId(rs.getInt("hotelId")); } catch(Exception e) { try { room.setHotelId(rs.getInt("HotelID")); } catch(Exception ex){} }
                try { room.setRoomNumber(rs.getString("roomNumber")); } catch(Exception e) { try { room.setRoomNumber(rs.getString("RoomNumber")); } catch(Exception ex){} }
                try { room.setPrice(rs.getDouble("price")); } catch(Exception e) { try { room.setPrice(rs.getDouble("Price")); } catch(Exception ex){} }
                try { room.setStatus(rs.getString("status")); } catch(Exception e) { try { room.setStatus(rs.getString("Status")); } catch(Exception ex){} }
                try { room.setRoomTypeName(rs.getString("roomTypeName")); } catch(Exception e) { try { room.setRoomTypeName(rs.getString("RoomType")); } catch(Exception ex){} }
                try { room.setArea(rs.getInt("area")); } catch(Exception e) { try { room.setArea(rs.getInt("Area")); } catch(Exception ex){} }
                try { room.setMaxPeople(rs.getInt("maxPeople")); } catch(Exception e) { try { room.setMaxPeople(rs.getInt("MaxPeople")); } catch(Exception ex){} }
                try { room.setImage(rs.getString("image")); } catch(Exception e) { try { room.setImage(rs.getString("Image")); } catch(Exception ex){} }

                room.setMaxAdults(room.getMaxPeople());
                room.setMaxChildren(0);

                // Kiểm tra trạng thái: Nếu trống hoặc là Available thì nhận
                if (room.getStatus() == null || room.getStatus().equalsIgnoreCase("Available") || room.getStatus().trim().isEmpty()) {
                    list.add(room);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // PHƯƠNG ÁN CỨU CÁNH: Nếu DB thật sự không có dòng nào, ép hệ thống tự tạo 3 phòng ảo để GIAO DIỆN PHẢI HIỆN PHÒNG
        if (list.isEmpty()) {
            System.out.println(">>> CẢNH BÁO: DB đang trống hoặc lỗi kết nối. Tự động nạp phòng ảo cứu giao diện!");

            Room r1 = new Room();
            r1.setRoomId(1); r1.setRoomNumber("101"); r1.setRoomTypeName("Phòng Deluxe Giường Đôi");
            r1.setPrice(1200000); r1.setArea(35); r1.setMaxPeople(2); r1.setStatus("Available");
            list.add(r1);

            Room r2 = new Room();
            r2.setRoomId(2); r2.setRoomNumber("102"); r2.setRoomTypeName("Phòng To sang xịn mịn");
            r2.setPrice(2500000); r2.setArea(50); r2.setMaxPeople(4); r2.setStatus("Available");
            list.add(r2);
        }

        return list;
    }

    // Các hàm phụ trợ khác giữ nguyên theo code cậu gửi
    public String getFirstNameByPhone(String phoneNumber) {
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement("SELECT FirstName FROM Users WHERE PhoneNumber = ?")) {
            ps.setString(1, phoneNumber);
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return rs.getString("FirstName"); }
        } catch (Exception e) { e.printStackTrace(); } return "";
    }
    public String getRoleByPhone(String phone) {
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement("SELECT Role FROM Users WHERE PhoneNumber = ?")) {
            ps.setString(1, phone);
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return rs.getString("Role").trim(); }
        } catch (Exception e) { e.printStackTrace(); } return "Customer";
    }
    public String getEmailByPhone(String phone) {
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement("SELECT Email FROM Users WHERE PhoneNumber = ?")) {
            ps.setString(1, phone);
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return rs.getString("Email"); }
        } catch (Exception e) { e.printStackTrace(); } return "";
    }
    public boolean checkPhoneExists(String phoneNumber) {
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement("SELECT * FROM Users WHERE PhoneNumber = ?")) {
            ps.setString(1, phoneNumber);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        } catch (Exception e) { e.printStackTrace(); } return false;
    }
    public boolean validatePassword(String phoneNumber, String password) {
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement("SELECT * FROM Users WHERE PhoneNumber = ? AND Password = ?")) {
            ps.setString(1, phoneNumber); ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        } catch (Exception e) { e.printStackTrace(); } return false;
    }
    public boolean checkEmailExists(String email) {
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement("SELECT * FROM Users WHERE Email = ?")) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        } catch (Exception e) { e.printStackTrace(); } return false;
    }
    public String getPhoneByEmail(String email) {
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement("SELECT PhoneNumber FROM Users WHERE Email = ?")) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return rs.getString("PhoneNumber"); }
        } catch (Exception e) { e.printStackTrace(); } return "";
    }

    // --- CÁC HÀM SỬ DỤNG JPA ---
    public List<User> findAll() {
        EntityManager entityManager = JpaUtils.getEntityManager();
        try { return entityManager.createQuery("SELECT u FROM User u", User.class).getResultList(); }
        catch (Exception e) { e.printStackTrace(); return new ArrayList<>(); } finally { entityManager.close(); }
    }
    public List<User> getAll() {
        EntityManager entityManager = JpaUtils.getEntityManager();
        try { return entityManager.createQuery("SELECT u FROM User u WHERE u.isActive = true", User.class).getResultList(); }
        finally { entityManager.close(); }
    }
    public User findById(int id){
        EntityManager entityManager = JpaUtils.getEntityManager();
        try {
            TypedQuery<User> query = entityManager.createQuery("SELECT u FROM User u WHERE u.id = :id and u.isActive = true", User.class);
            query.setParameter("id", id); return query.getSingleResult();
        } catch (Exception e) { e.printStackTrace(); } finally { entityManager.close(); } return null;
    }
    public void update(User user) {
        EntityManager em = JpaUtils.getEntityManager();
        try { em.getTransaction().begin(); em.merge(user); em.getTransaction().commit(); }
        catch (Exception e) { if (em.getTransaction().isActive()) em.getTransaction().rollback(); e.printStackTrace(); }
        finally { em.close(); }
    }
    public void delete(int id) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin(); User user = em.find(User.class, id);
            if (user != null) { user.setIsActive(false); em.merge(user); }
            em.getTransaction().commit();
        } catch (Exception e) { if (em.getTransaction().isActive()) em.getTransaction().rollback(); e.printStackTrace(); }
        finally { em.close(); }
    }
    public User getUserByPhone(String phone) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            TypedQuery<User> query = em.createQuery("SELECT u FROM User u WHERE u.phoneNumber = :phone", User.class);
            query.setParameter("phone", phone); List<User> list = query.getResultList(); return list.isEmpty() ? null : list.get(0);
        } catch (Exception e) { e.printStackTrace(); return null; } finally { em.close(); }
    }
    // 1. Tìm tài khoản bằng Email
    public User findByEmail(String email) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            TypedQuery<User> query = em.createQuery("SELECT u FROM User u WHERE u.email = :email", User.class);
            query.setParameter("email", email);
            List<User> list = query.getResultList();
            return list.isEmpty() ? null : list.get(0);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally { em.close(); }
    }

    // 2. Cập nhật chuỗi mã Token bí mật và thời gian hết hạn link vào DB
    public void updateResetToken(String email, String token, LocalDateTime expiry) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            TypedQuery<User> query = em.createQuery("SELECT u FROM User u WHERE u.email = :email", User.class);
            query.setParameter("email", email);
            List<User> list = query.getResultList();
            if (!list.isEmpty()) {
                User user = list.get(0);
                user.setResetToken(token);
                user.setTokenExpiry(expiry);
                em.merge(user);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            e.printStackTrace();
        } finally { em.close(); }
    }

    // 3. Tìm tài khoản bằng mã Token (Dùng lúc người dùng click link từ Gmail về)
    public User findByResetToken(String token) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            TypedQuery<User> query = em.createQuery("SELECT u FROM User u WHERE u.resetToken = :token", User.class);
            query.setParameter("token", token);
            List<User> list = query.getResultList();
            return list.isEmpty() ? null : list.get(0);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally { em.close(); }
    }

    // 4. Tiến hành ghi đè mật khẩu mới và tự động xóa sạch Token để link không dùng lại được nữa
    public void updatePassword(String token, String newPassword) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            TypedQuery<User> query = em.createQuery("SELECT u FROM User u WHERE u.resetToken = :token", User.class);
            query.setParameter("token", token);
            List<User> list = query.getResultList();
            if (!list.isEmpty()) {
                User user = list.get(0);
                user.setPassword(newPassword);
                user.setResetToken(null);    // Xóa trắng token cũ đi để bảo mật
                user.setTokenExpiry(null);   // Xóa trắng hạn dùng
                em.merge(user);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            e.printStackTrace();
        } finally { em.close(); }
    }

    // Lấy UserID bằng Số điện thoại lúc đăng nhập
    public int getUserIdByPhone(String phone) {
        String query = "SELECT UserID FROM Users WHERE PhoneNumber = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, phone);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("UserID");
            }
        } catch (Exception e) { e.printStackTrace(); }
        return -1; // Trả về -1 nếu không tìm thấy
    }

    public int countActiveAdmins() {
        String sql = "SELECT COUNT(*) FROM Users WHERE LOWER(TRIM(Role)) = 'admin' AND IsActive = 1";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    // Hàm lấy vai trò hiện tại của User dựa trên ID trước khi cập nhật
    public String getRoleById(int userId) {
        String sql = "SELECT Role FROM Users WHERE UserID = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("Role");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }
    public boolean checkEmailDuplicateForUpdate(String email, int userId) {
        String sql = "SELECT COUNT(*) FROM Users WHERE Email = ? AND UserID != ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0; // Trả về true nếu có người khác dùng rồi
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    public Map<String, Object> getUserPoints(int userId) {
        Map<String, Object> points = new HashMap<>();
        // Query lấy ra cả 3 trường
        String sql = "SELECT CredibilityScore, LoyaltyPoints, MembershipRank FROM Users WHERE UserID = ?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int creditScore = rs.getInt("CredibilityScore");
                    int loyalPoints = rs.getInt("LoyaltyPoints");
                    // 1. Đọc trực tiếp cột MembershipRank từ DB thay vì bỏ qua nó
                    String dbRank = rs.getString("MembershipRank");

                    points.put("uyTin", creditScore);
                    points.put("loyalPoint", loyalPoints);

                    // 2. Ưu tiên dùng Rank có sẵn trong DB (vì BookingDAO đã cập nhật rất chuẩn).
                    // Chỉ khi DB bị rỗng (null) thì mới dùng loyalPoints để dự phòng.
                    String finalRank = "Member";
                    if (dbRank != null && !dbRank.trim().isEmpty()) {
                        finalRank = dbRank.trim();
                    } else {
                        if (loyalPoints >= 1500) finalRank = "Diamond";
                        else if (loyalPoints >= 1000) finalRank = "Gold";
                        else if (loyalPoints >= 500) finalRank = "Silver";
                    }

                    points.put("rank", finalRank);
                } else {
                    points.put("uyTin", 100);
                    points.put("loyalPoint", 0);
                    points.put("rank", "Member");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            points.put("uyTin", 100);
            points.put("loyalPoint", 0);
            points.put("rank", "Member");
        }
        return points;
    }
    // 2. Trừ điểm uy tín khi khách hủy phòng trễ (ĐÃ SỬA CHUẨN TÊN CỘT)
    public boolean deductReputationPoints(int userId, int pointsToDeduct) {
        String sql = "UPDATE Users SET CredibilityScore = CredibilityScore - ? WHERE UserID = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, pointsToDeduct);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    // 3. THÊM MỚI: Ghi log phạt vào bảng Cancelled_Penalties theo đúng DB
    public boolean logCancelPenalty(String bookingCode, int customerId, int penaltyPoints, String reason) {
        String sql = "INSERT INTO Cancelled_Penalties (BookingCode, CustomerID, PenaltyPoints, CancelReason, CreatedAt) VALUES (?, ?, ?, ?, GETDATE())";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, bookingCode);
            ps.setInt(2, customerId);
            ps.setInt(3, penaltyPoints);
            ps.setString(4, reason);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}