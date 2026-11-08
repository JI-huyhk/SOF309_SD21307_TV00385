package dao;

import context.DBConnect;
import model.Booking;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    // =========================================================================
    // 1. CÁC HÀM TẠO BOOKING VÀ ĐỒNG BỘ HÓA ĐƠN VÀO BẢNG INVOICES
    // =========================================================================

    public boolean createBookingWithInvoice(Integer customerId, int roomId, LocalDate checkIn, LocalDate checkOut, double totalAmount, String bookingCode, String paymentMethod, String customerNote, String voucherCode, String bookingStatus) {
        // Cập nhật câu SQL chèn thêm BookingStatus
        String insertBookingSQL = "INSERT INTO Bookings (BookingCode, CustomerID, RoomID, CheckInDate, CheckOutDate, TotalPrice, Note, VoucherCode, BookingStatus, CreatedAt) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE())";
        // Bỏ fix cứng N'Paid' và thay bằng dấu ?
        String insertInvoiceSQL = "INSERT INTO Invoices (BookingID, BaseTotal, ExtraFeesTotal, DiscountApplied, DepositPaid, RefundAmount, FinalAmountDue, PaymentMethod, PaymentStatus, VATPercent) VALUES (?, ?, 0, ?, ?, 0, ?, ?, ?, 10)";

        Connection conn = null;
        PreparedStatement psBooking = null;
        PreparedStatement psInvoice = null;

        try {
            conn = DBConnect.getConnection();
            conn.setAutoCommit(false);

            psBooking = conn.prepareStatement(insertBookingSQL, Statement.RETURN_GENERATED_KEYS);
            psBooking.setString(1, bookingCode);
            if (customerId != null) {
                psBooking.setInt(2, customerId);
            } else {
                psBooking.setNull(2, java.sql.Types.INTEGER);
            }
            psBooking.setInt(3, roomId);
            psBooking.setDate(4, java.sql.Date.valueOf(checkIn));
            psBooking.setDate(5, java.sql.Date.valueOf(checkOut));
            psBooking.setBigDecimal(6, java.math.BigDecimal.valueOf(totalAmount));
            psBooking.setString(7, customerNote);

            // Xử lý: Nếu không có voucher hoặc gửi chữ "null" thì set SQL NULL
            if (voucherCode == null || voucherCode.trim().isEmpty() || voucherCode.equalsIgnoreCase("null")) {
                psBooking.setNull(8, java.sql.Types.VARCHAR);
            } else {
                psBooking.setString(8, voucherCode);
            }

            psBooking.setString(9, bookingStatus); // NÂNG CẤP: Ghi nhận trạng thái booking vào DB

            psBooking.executeUpdate();

            int generatedBookingId = -1;
            try (ResultSet rsKeys = psBooking.getGeneratedKeys()) {
                if (rsKeys.next()) {
                    generatedBookingId = rsKeys.getInt(1);
                }
            }

            if (generatedBookingId == -1) {
                throw new Exception("Không lấy được BookingID tự tăng từ hệ thống database.");
            }

            // Tính số tiền giảm giá thực tế từ Voucher
            double discountApplied = 0.0;
            double deposit = 0.0;
            double finalDue = totalAmount;

            // NÂNG CẤP: Xử lý trạng thái Hóa đơn logic (Nếu đang chờ thanh toán tiền mặt thì Invoice = Unpaid)
            String invoiceStatus = "Chờ thanh toán".equalsIgnoreCase(bookingStatus) ? "Unpaid" : "Paid";

            psInvoice = conn.prepareStatement(insertInvoiceSQL);
            psInvoice.setInt(1, generatedBookingId);
            psInvoice.setBigDecimal(2, java.math.BigDecimal.valueOf(totalAmount));
            psInvoice.setBigDecimal(3, java.math.BigDecimal.valueOf(discountApplied));
            psInvoice.setBigDecimal(4, java.math.BigDecimal.valueOf(deposit));
            psInvoice.setBigDecimal(5, java.math.BigDecimal.valueOf(finalDue));
            psInvoice.setString(6, paymentMethod);
            psInvoice.setString(7, invoiceStatus); // Lưu trạng thái hóa đơn

            psInvoice.executeUpdate();
            conn.commit();
            return true;
        } catch (Exception e) {
            try { if (conn != null) conn.rollback(); } catch (Exception ex) { ex.printStackTrace(); }
            e.printStackTrace();
        } finally {
            try {
                if (psBooking != null) psBooking.close();
                if (psInvoice != null) psInvoice.close();
                if (conn != null) { conn.setAutoCommit(true); conn.close(); }
            } catch (Exception e) { e.printStackTrace(); }
        }
        return false;
    }

    public boolean insertBooking(Integer customerId, int roomId, LocalDate checkIn, LocalDate checkOut, int totalNights, double totalAmount, String paymentMethod, String customerNote, String bookingCode, String voucherCode) {
        String insertBookingSQL = "INSERT INTO Bookings (BookingCode, CustomerID, RoomID, CheckInDate, CheckOutDate, TotalPrice, Note, VoucherCode, BookingStatus, CreatedAt) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'Pending', GETDATE())";
        String insertInvoiceSQL = "INSERT INTO Invoices (BookingID, BaseTotal, ExtraFeesTotal, DiscountApplied, DepositPaid, RefundAmount, FinalAmountDue, PaymentMethod, PaymentStatus, VATPercent, IssuedDate) VALUES (?, ?, 0, ?, ?, 0, ?, ?, N'Paid', 10, GETDATE())";

        Connection conn = null;
        PreparedStatement psBooking = null;
        PreparedStatement psInvoice = null;

        try {
            conn = DBConnect.getConnection();
            conn.setAutoCommit(false);

            psBooking = conn.prepareStatement(insertBookingSQL, Statement.RETURN_GENERATED_KEYS);
            psBooking.setString(1, bookingCode);
            if (customerId != null) {
                psBooking.setInt(2, customerId);
            } else {
                psBooking.setNull(2, java.sql.Types.INTEGER);
            }
            psBooking.setInt(3, roomId);
            psBooking.setDate(4, java.sql.Date.valueOf(checkIn));
            psBooking.setDate(5, java.sql.Date.valueOf(checkOut));
            psBooking.setBigDecimal(6, java.math.BigDecimal.valueOf(totalAmount));
            psBooking.setString(7, customerNote);
            psBooking.setString(8, voucherCode);

            psBooking.executeUpdate();

            int generatedBookingId = -1;
            try (ResultSet rsKeys = psBooking.getGeneratedKeys()) {
                if (rsKeys.next()) {
                    generatedBookingId = rsKeys.getInt(1);
                }
            }

            if (generatedBookingId == -1) {
                throw new Exception("Không lấy được BookingID tự tăng từ database.");
            }

            double deposit = 0;
            if (paymentMethod != null && paymentMethod.equals("qr")) {
                deposit = totalAmount;
            } else if (paymentMethod != null && paymentMethod.equals("direct")) {
                deposit = totalAmount * 0.5;
            } else {
                deposit = totalAmount * 0.2;
            }

            // Tính số tiền giảm giá từ VoucherCode
            double discountApplied = new VoucherDAO().calculateDiscount(voucherCode, totalAmount);

            psInvoice = conn.prepareStatement(insertInvoiceSQL);
            psInvoice.setInt(1, generatedBookingId);
            psInvoice.setBigDecimal(2, java.math.BigDecimal.valueOf(totalAmount));
            psInvoice.setBigDecimal(3, java.math.BigDecimal.valueOf(discountApplied)); // DiscountApplied
            psInvoice.setBigDecimal(4, java.math.BigDecimal.valueOf(deposit));

            double finalDue = totalAmount - deposit - discountApplied;
            psInvoice.setBigDecimal(5, java.math.BigDecimal.valueOf(finalDue > 0 ? finalDue : 0));
            psInvoice.setString(6, paymentMethod);

            psInvoice.executeUpdate();
            conn.commit();
            return true;
        } catch (Exception e) {
            try { if (conn != null) conn.rollback(); } catch (Exception ex) { ex.printStackTrace(); }
            e.printStackTrace();
        } finally {
            try {
                if (psBooking != null) psBooking.close();
                if (psInvoice != null) psInvoice.close();
                if (conn != null) { conn.setAutoCommit(true); conn.close(); }
            } catch (Exception e) { e.printStackTrace(); }
        }
        return false;
    }

    // =========================================================================
    // 2. LẤY LỊCH SỬ ĐẶT PHÒNG CỦA MỘT KHÁCH HÀNG & LẤY ĐẦY ĐỦ THÔNG TIN
    // =========================================================================

    public List<Booking> getBookingHistory(Integer customerId) {
        List<Booking> list = new ArrayList<>();
        if (customerId == null) return list;

        String sql = "SELECT b.BookingID, b.BookingCode, b.CheckInDate, b.CheckOutDate, b.TotalPrice, b.CreatedAt, "
                + "u.LastName, u.FirstName, u.PhoneNumber, u.Email, "
                + "r.RoomID, r.RoomNumber, r.RoomType, "
                + "CASE "
                + "  WHEN cp.CancelID IS NOT NULL THEN 'cancelled' "
                + "  WHEN co.SurchargeID IS NOT NULL THEN 'completed' "
                + "  WHEN ci.CheckInID IS NOT NULL THEN 'checkedin' "
                + "  ELSE 'pending' "
                + "END AS DerivedStatus "
                + "FROM Bookings b "
                + "JOIN Users u ON b.CustomerID = u.UserID "
                + "LEFT JOIN Rooms r ON b.RoomID = r.RoomID "
                + "LEFT JOIN Cancelled_Penalties cp ON b.BookingCode = cp.BookingCode "
                + "LEFT JOIN CheckIn_Points ci ON b.BookingCode = ci.BookingCode "
                + "LEFT JOIN CheckOut_Surcharges co ON b.BookingCode = co.BookingCode "
                + "WHERE b.CustomerID = ? "
                + "ORDER BY b.CheckInDate DESC";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking b = new Booking();
                    b.setId(rs.getInt("BookingID"));
                    b.setBookingCode(rs.getString("BookingCode"));
                    b.setCheckInDate(rs.getDate("CheckInDate"));
                    b.setCheckOutDate(rs.getDate("CheckOutDate"));
                    b.setRoomId(rs.getInt("RoomID"));
                    b.setTotalPrice((long) rs.getDouble("TotalPrice"));
                    b.setCreatedAt(rs.getTimestamp("CreatedAt"));

                    String status = rs.getString("DerivedStatus");
                    // Trả về đúng trạng thái thực tế: pending, checkedin, completed, cancelled
                    b.setStatus(status.toLowerCase());
                    list.add(b);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }


    public List<Booking> getBookingHistoryWithRoomInfo(Integer customerId) {
        List<Booking> list = new ArrayList<>();
        if (customerId == null) return list;

        String sql = "SELECT b.BookingID, b.BookingCode, b.CheckInDate, b.CheckOutDate, b.TotalPrice, u.LastName, u.FirstName, u.PhoneNumber, u.Email, "
                + "r.RoomID, r.RoomNumber, r.RoomType, "
                + "CASE "
                + "  WHEN cp.CancelID IS NOT NULL THEN 'cancelled' "
                + "  WHEN co.SurchargeID IS NOT NULL THEN 'completed' "
                + "  WHEN ci.CheckInID IS NOT NULL THEN 'checkedin' "
                + "  ELSE 'pending' "
                + "END AS DerivedStatus "
                + "FROM Bookings b "
                + "JOIN Users u ON b.CustomerID = u.UserID "
                + "LEFT JOIN Rooms r ON b.RoomID = r.RoomID "
                + "LEFT JOIN Cancelled_Penalties cp ON b.BookingCode = cp.BookingCode "
                + "LEFT JOIN CheckIn_Points ci ON b.BookingCode = ci.BookingCode "
                + "LEFT JOIN CheckOut_Surcharges co ON b.BookingCode = co.BookingCode "
                + "WHERE b.CustomerID = ? "
                + "ORDER BY b.CheckInDate DESC";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking b = new Booking();
                    b.setId(rs.getInt("BookingID"));
                    b.setCheckInDate(rs.getDate("CheckInDate"));
                    b.setCheckOutDate(rs.getDate("CheckOutDate"));
                    b.setRoomId(rs.getInt("RoomID"));
                    b.setTotalPrice((long) rs.getDouble("TotalPrice"));

                    String fullName = rs.getString("LastName") + " " + rs.getString("FirstName");
                    b.setCustomerName(fullName);
                    b.setPhone(rs.getString("PhoneNumber"));

                    String roomNumber = rs.getString("RoomNumber");
                    String roomType = rs.getString("RoomType");
                    b.setStatus(roomNumber != null ? (roomNumber + " - " + roomType) : "Chưa xếp phòng");

                    String dbEmail = rs.getString("Email");
                    b.setEmail(dbEmail != null && !dbEmail.isEmpty() ? dbEmail : "khachhang" + b.getId() + "@gmail.com");

                    b.setBookingCode(rs.getString("DerivedStatus"));

                    list.add(b);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // =========================================================================
    // 3. LẤY THÔNG TIN CHI TIẾT CỦA 1 BOOKING THEO ID (HIỆN ĐẦY ĐỦ THÔNG TIN)
    // =========================================================================

    public Booking getBookingById(int bookingId) {
        // Đã thay thế việc lấy cột BookingStatus bằng CASE WHEN chuẩn 4 trạng thái như activity cũ
        String sql = "SELECT b.*, u.FirstName, u.LastName, u.PhoneNumber, u.Email, r.RoomNumber, " +
                "CASE " +
                "  WHEN cp.CancelID IS NOT NULL THEN 'cancelled' " +
                "  WHEN co.SurchargeID IS NOT NULL THEN 'completed' " +
                "  WHEN ci.CheckInID IS NOT NULL THEN 'checkedin' " +
                "  ELSE 'pending' " +
                "END AS DerivedStatus " +
                "FROM Bookings b " +
                "LEFT JOIN Users u ON b.CustomerID = u.UserID " +
                "LEFT JOIN Rooms r ON b.RoomID = r.RoomID " +
                "LEFT JOIN Cancelled_Penalties cp ON b.BookingCode = cp.BookingCode " +
                "LEFT JOIN CheckIn_Points ci ON b.BookingCode = ci.BookingCode " +
                "LEFT JOIN CheckOut_Surcharges co ON b.BookingCode = co.BookingCode " +
                "WHERE b.BookingID = ?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Booking b = new Booking();
                    b.setId(rs.getInt("BookingID"));

                    String code = rs.getString("BookingCode");
                    b.setBookingCode(code != null && !code.isEmpty() ? code : "BK-" + b.getId());

                    b.setCustomerId(rs.getInt("CustomerID"));
                    b.setRoomId(rs.getInt("RoomID"));
                    b.setCheckInDate(rs.getTimestamp("CheckInDate"));
                    b.setCheckOutDate(rs.getTimestamp("CheckOutDate"));

                    // Lấy thời gian tạo đơn để CancelController tính phút không bị lỗi Null
                    b.setCreatedAt(rs.getTimestamp("CreatedAt"));

                    b.setTotalPrice((long) rs.getDouble("TotalPrice"));

                    // Map thông tin từ bảng Users (FirstName + LastName)
                    String firstName = rs.getString("FirstName");
                    String lastName = rs.getString("LastName");
                    String fullName = ((lastName != null ? lastName : "") + " " + (firstName != null ? firstName : "")).trim();
                    b.setCustomerName(fullName.isEmpty() ? "Khách vãng lai" : fullName);

                    b.setPhone(rs.getString("PhoneNumber"));
                    b.setEmail(rs.getString("Email"));
                    b.setRoomNumber(rs.getString("RoomNumber"));

                    // Dùng DerivedStatus trả về đúng 'pending', 'cancelled', 'checkedin', 'completed'
                    b.setStatus(rs.getString("DerivedStatus"));

                    return b;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // =========================================================================
    // 4. HỦY PHÒNG VÀ TÍNH ĐIỂM PHẠT KHÁCH HÀNG (GIỮ NGUYÊN FILE 2)
    // =========================================================================

    public boolean cancelBookingTransaction(Integer bookingId, String bookingCode, Integer customerId) {
        if (bookingId == null || bookingCode == null || customerId == null) return false;

        String insertCancel = "INSERT INTO Cancelled_Penalties (BookingCode, CustomerID, PenaltyPoints, CancelReason, CreatedAt) VALUES (?, ?, 20, N'Hủy phòng quá hạn an toàn', GETDATE())";
        String updateUser = "UPDATE Users SET LoyaltyPoints = LoyaltyPoints - 20, CredibilityScore = CredibilityScore - 20 WHERE UserID = ?";
        String updateRank = "UPDATE Users SET MembershipRank = CASE " +
                "   WHEN (LoyaltyPoints) >= 1500 THEN 'Diamond' " +
                "   WHEN (LoyaltyPoints) >= 1000 THEN 'Gold' " +
                "   WHEN (LoyaltyPoints) >= 500 THEN 'Silver' " +
                "   ELSE 'Member' END WHERE UserID = ?";
        String updateBookingStatus = "UPDATE Bookings SET BookingStatus = 'Cancelled' WHERE BookingID = ?"; // FIX THÊM DÒNG NÀY

        Connection conn = null;
        try {
            conn = DBConnect.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement ps1 = conn.prepareStatement(insertCancel)) {
                ps1.setString(1, bookingCode);
                ps1.setInt(2, customerId);
                ps1.executeUpdate();
            }
            try (PreparedStatement ps2 = conn.prepareStatement(updateUser)) {
                ps2.setInt(1, customerId);
                ps2.executeUpdate();
            }
            try (PreparedStatement ps3 = conn.prepareStatement(updateRank)) {
                ps3.setInt(1, customerId);
                ps3.executeUpdate();
            }
            // UPDATE TRỰC TIẾP TRẠNG THÁI BOOKING VÀO DB
            try (PreparedStatement ps4 = conn.prepareStatement(updateBookingStatus)) {
                ps4.setInt(1, bookingId);
                ps4.executeUpdate();
            }
            conn.commit();
            return true;
        } catch (Exception e) {
            try { if (conn != null) conn.rollback(); } catch (Exception ex) { ex.printStackTrace(); }
            e.printStackTrace();
        } finally {
            try { if (conn != null) { conn.setAutoCommit(true); conn.close(); } } catch (Exception e) { e.printStackTrace(); }
        }
        return false;
    }

    public boolean cancelBookingWithPenalty(int bookingId, String cancelReason, int penaltyPoints) {
        String getBookingSql = "SELECT BookingCode, CustomerID FROM Bookings WHERE BookingID = ?";
        String insertPenaltySql = "INSERT INTO Cancelled_Penalties (BookingCode, CustomerID, PenaltyPoints, CancelReason, CreatedAt) VALUES (?, ?, ?, ?, GETDATE())";
        String updateUserPointsSql = "UPDATE Users SET "
                + "CredibilityScore = CASE WHEN ISNULL(CredibilityScore, 100) - ? < 0 THEN 0 ELSE ISNULL(CredibilityScore, 100) - ? END, "
                + "LoyaltyPoints = CASE WHEN ISNULL(LoyaltyPoints, 0) - ? < 0 THEN 0 ELSE ISNULL(LoyaltyPoints, 0) - ? END "
                + "WHERE UserID = ?";
        String updateUserRankSql = "UPDATE Users SET MembershipRank = CASE "
                + "WHEN ISNULL(LoyaltyPoints, 0) >= 1500 THEN N'Diamond' "
                + "WHEN ISNULL(LoyaltyPoints, 0) >= 1000 THEN N'Gold' "
                + "WHEN ISNULL(LoyaltyPoints, 0) >= 500 THEN N'Silver' "
                + "ELSE N'Member' END WHERE UserID = ?";
        String updateBookingStatus = "UPDATE Bookings SET BookingStatus = 'Cancelled' WHERE BookingID = ?"; // FIX THÊM DÒNG NÀY

        Connection conn = null;
        try {
            conn = DBConnect.getConnection();
            conn.setAutoCommit(false);

            String bookingCode = null;
            int customerId = -1;

            try (PreparedStatement psGet = conn.prepareStatement(getBookingSql)) {
                psGet.setInt(1, bookingId);
                try (ResultSet rs = psGet.executeQuery()) {
                    if (rs.next()) {
                        bookingCode = rs.getString("BookingCode");
                        customerId = rs.getInt("CustomerID");
                    }
                }
            }

            if (bookingCode == null || customerId == -1) {
                conn.rollback();
                return false;
            }

            try (PreparedStatement psPenalty = conn.prepareStatement(insertPenaltySql)) {
                psPenalty.setString(1, bookingCode);
                psPenalty.setInt(2, customerId);
                psPenalty.setInt(3, penaltyPoints);
                psPenalty.setString(4, cancelReason != null ? cancelReason : "Khách hàng hủy đơn phòng");
                psPenalty.executeUpdate();
            }

            try (PreparedStatement psUserPoints = conn.prepareStatement(updateUserPointsSql)) {
                psUserPoints.setInt(1, penaltyPoints);
                psUserPoints.setInt(2, penaltyPoints);
                psUserPoints.setInt(3, penaltyPoints);
                psUserPoints.setInt(4, penaltyPoints);
                psUserPoints.setInt(5, customerId);
                psUserPoints.executeUpdate();
            }

            try (PreparedStatement psUserRank = conn.prepareStatement(updateUserRankSql)) {
                psUserRank.setInt(1, customerId);
                psUserRank.executeUpdate();
            }

            // UPDATE TRỰC TIẾP TRẠNG THÁI BOOKING VÀO DB
            try (PreparedStatement psStatus = conn.prepareStatement(updateBookingStatus)) {
                psStatus.setInt(1, bookingId);
                psStatus.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (Exception e) {
            try { if (conn != null) conn.rollback(); } catch (Exception ex) { ex.printStackTrace(); }
            e.printStackTrace();
        } finally {
            try { if (conn != null) { conn.setAutoCommit(true); conn.close(); } } catch (Exception e) { e.printStackTrace(); }
        }
        return false;
    }

    public boolean cancelBooking(int bookingId) {
        String getBookingSql = "SELECT BookingCode, CustomerID FROM Bookings WHERE BookingID = ?";
        String insertCancelSql = "INSERT INTO Cancelled_Penalties (BookingCode, CustomerID, CancelReason, CreatedAt) VALUES (?, ?, N'Khách hàng hủy đơn phòng', GETDATE())";
        String updateStatusSql = "UPDATE Bookings SET BookingStatus = 'Cancelled' WHERE BookingID = ?"; // FIX THÊM DÒNG NÀY

        Connection conn = null;
        try {
            conn = DBConnect.getConnection();
            conn.setAutoCommit(false); // Dùng Transaction để tránh lệch data
            String bCode = null; int cId = -1;

            try (PreparedStatement ps1 = conn.prepareStatement(getBookingSql)) {
                ps1.setInt(1, bookingId);
                try(ResultSet rs = ps1.executeQuery()) {
                    if(rs.next()){ bCode = rs.getString("BookingCode"); cId = rs.getInt("CustomerID"); }
                }
            }
            if(bCode != null) {
                try (PreparedStatement ps2 = conn.prepareStatement(insertCancelSql);
                     PreparedStatement ps3 = conn.prepareStatement(updateStatusSql)) {

                    ps2.setString(1, bCode);
                    ps2.setInt(2, cId);
                    ps2.executeUpdate();

                    ps3.setInt(1, bookingId);
                    ps3.executeUpdate();

                    conn.commit();
                    return true;
                } catch (Exception ex) {
                    conn.rollback();
                    ex.printStackTrace();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (conn != null) { conn.setAutoCommit(true); conn.close(); } } catch (Exception e) { e.printStackTrace(); }
        }
        return false;
    }

    public boolean cancelBookingWithAdvancedPolicy(int bookingId, int customerId, double penaltyFee, int penaltyPoints, String reason) {
        String getBookingSql = "SELECT BookingCode FROM Bookings WHERE BookingID = ?";
        String insertCancelSql = "INSERT INTO Cancelled_Penalties (BookingCode, CustomerID, PenaltyFee, PenaltyPoints, CancelReason, CreatedAt) VALUES (?, ?, ?, ?, ?, GETDATE())";
        String updateUserSql = "UPDATE Users SET "
                + "CredibilityScore = CASE WHEN ISNULL(CredibilityScore, 100) - ? < 0 THEN 0 ELSE ISNULL(CredibilityScore, 100) - ? END, "
                + "LoyaltyPoints = CASE WHEN ISNULL(LoyaltyPoints, 0) - ? < 0 THEN 0 ELSE ISNULL(LoyaltyPoints, 0) - ? END "
                + "WHERE UserID = ?";
        String updateStatusSql = "UPDATE Bookings SET BookingStatus = 'Cancelled' WHERE BookingID = ?"; // FIX THÊM DÒNG NÀY

        Connection conn = null;
        try {
            conn = DBConnect.getConnection();
            conn.setAutoCommit(false);

            String bookingCode = null;
            try (PreparedStatement psGet = conn.prepareStatement(getBookingSql)) {
                psGet.setInt(1, bookingId);
                try (ResultSet rs = psGet.executeQuery()) {
                    if (rs.next()) bookingCode = rs.getString("BookingCode");
                }
            }

            if (bookingCode != null) {
                try (PreparedStatement ps1 = conn.prepareStatement(insertCancelSql)) {
                    ps1.setString(1, bookingCode);
                    ps1.setInt(2, customerId);
                    ps1.setBigDecimal(3, java.math.BigDecimal.valueOf(penaltyFee));
                    ps1.setInt(4, penaltyPoints);
                    ps1.setString(5, reason);
                    ps1.executeUpdate();
                }

                if (penaltyPoints > 0) {
                    try (PreparedStatement ps2 = conn.prepareStatement(updateUserSql)) {
                        ps2.setInt(1, penaltyPoints);
                        ps2.setInt(2, penaltyPoints);
                        ps2.setInt(3, penaltyPoints);
                        ps2.setInt(4, penaltyPoints);
                        ps2.setInt(5, customerId);
                        ps2.executeUpdate();
                    }
                }

                // UPDATE TRỰC TIẾP TRẠNG THÁI BOOKING VÀO DB
                try (PreparedStatement ps3 = conn.prepareStatement(updateStatusSql)) {
                    ps3.setInt(1, bookingId);
                    ps3.executeUpdate();
                }

                conn.commit();
                return true;
            }
        } catch (Exception e) {
            try { if (conn != null) conn.rollback(); } catch (Exception ex) { ex.printStackTrace(); }
            e.printStackTrace();
        } finally {
            try { if (conn != null) { conn.setAutoCommit(true); conn.close(); } } catch (Exception e) { e.printStackTrace(); }
        }
        return false;
    }

    // =========================================================================
    // 5. HÀM ĐẾM THỐNG KÊ
    // =========================================================================

    public int countAvailableRooms() {
        String sql = "SELECT COUNT(*) FROM Rooms WHERE Status = 'Available'";
        return executeCount(sql);
    }

    public int countBookedRooms() {
        String sql = "SELECT COUNT(*) FROM Rooms WHERE Status = 'Occupied'";
        return executeCount(sql);
    }

    public int countDirtyRooms() {
        String sql = "SELECT COUNT(*) FROM Rooms WHERE Condition = 'Dirty'";
        return executeCount(sql);
    }

    public int countTodayIncoming() {
        String sql = "SELECT COUNT(*) FROM Bookings b "
                + "LEFT JOIN Cancelled_Penalties cp ON b.BookingCode = cp.BookingCode "
                + "LEFT JOIN CheckIn_Points ci ON b.BookingCode = ci.BookingCode "
                + "WHERE b.CheckInDate = CAST(GETDATE() AS DATE) AND cp.CancelID IS NULL AND ci.CheckInID IS NULL";
        return executeCount(sql);
    }

    public int countIncomingCheckinsToday() {
        return countTodayIncoming();
    }

    private int executeCount(String sql) {
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    // =========================================================================
    // 6. LẤY DANH SÁCH CHI TIẾT KHÁCH HÀNG CHECK-IN & CHECK-OUT TRONG NGÀY
    // =========================================================================

    public List<Booking> getTodayCheckins() {
        return getTodayCheckinsBase();
    }

    public List<Booking> getTodayCheckinsWithRoomInfo() {
        return getTodayCheckinsBase();
    }

    private List<Booking> getTodayCheckinsBase() {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.BookingID, b.BookingCode, u.LastName, u.FirstName, u.PhoneNumber, u.Email, "
                + "r.RoomID, r.RoomNumber, r.RoomType, "
                + "CASE "
                + "  WHEN cp.CancelID IS NOT NULL THEN 'cancelled' "
                + "  WHEN co.SurchargeID IS NOT NULL THEN 'completed' "
                + "  WHEN ci.CheckInID IS NOT NULL THEN 'checkedin' "
                + "  ELSE 'pending' "
                + "END AS DerivedStatus "
                + "FROM Bookings b "
                + "JOIN Users u ON b.CustomerID = u.UserID "
                + "LEFT JOIN Rooms r ON b.RoomID = r.RoomID "
                + "LEFT JOIN Cancelled_Penalties cp ON b.BookingCode = cp.BookingCode "
                + "LEFT JOIN CheckIn_Points ci ON b.BookingCode = ci.BookingCode "
                + "LEFT JOIN CheckOut_Surcharges co ON b.BookingCode = co.BookingCode "
                + "WHERE CAST(b.CheckInDate AS DATE) = CAST(GETDATE() AS DATE) "
                + "OR (ci.CheckInID IS NOT NULL AND co.SurchargeID IS NULL)";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Booking b = new Booking();
                b.setId(rs.getInt("BookingID"));

                // 1. SỬA CHÍNH XÁC MÃ BOOKING: Lấy từ cột BookingCode trong DB
                String code = rs.getString("BookingCode");
                b.setBookingCode(code != null && !code.isEmpty() ? code : "BK-" + b.getId());

                b.setCustomerName(rs.getString("LastName") + " " + rs.getString("FirstName"));
                b.setPhone(rs.getString("PhoneNumber"));
                b.setRoomId(rs.getInt("RoomID"));

                // 2. SỬA TRẠNG THÁI: Gán DerivedStatus vào Status
                b.setStatus(rs.getString("DerivedStatus"));

                String dbEmail = rs.getString("Email");
                b.setEmail(dbEmail != null && !dbEmail.isEmpty() ? dbEmail : "khachhang" + b.getId() + "@gmail.com");

                list.add(b);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // =========================================================================
    // 7. THỰC HIỆN THỦ TỤC CHECK-IN
    // =========================================================================

//    public boolean processCheckIn(int bookingId, int roomId) {
//        String getBookingSql = "SELECT BookingCode, CustomerID FROM Bookings WHERE BookingID = ?";
//        String updateBooking = "UPDATE Bookings SET RoomID = ? WHERE BookingID = ?";
//        String updateRoom = "UPDATE Rooms SET Status = N'Occupied' WHERE RoomID = ?";
//        String insertCheckIn = "INSERT INTO CheckIn_Points (BookingCode, CustomerID) VALUES (?, ?)";
//
//        try (Connection conn = DBConnect.getConnection()) {
//            conn.setAutoCommit(false);
//
//            String bCode = null; int cId = -1;
//            try(PreparedStatement psGet = conn.prepareStatement(getBookingSql)) {
//                psGet.setInt(1, bookingId);
//                try(ResultSet rs = psGet.executeQuery()) {
//                    if(rs.next()){ bCode = rs.getString("BookingCode"); cId = rs.getInt("CustomerID"); }
//                }
//            }
//
//            if(bCode != null) {
//                try (PreparedStatement ps1 = conn.prepareStatement(updateBooking);
//                     PreparedStatement ps2 = conn.prepareStatement(updateRoom);
//                     PreparedStatement ps3 = conn.prepareStatement(insertCheckIn)) {
//
//                    ps1.setInt(1, roomId);
//                    ps1.setInt(2, bookingId);
//                    ps1.executeUpdate();
//
//                    ps2.setInt(1, roomId);
//                    ps2.executeUpdate();
//
//                    ps3.setString(1, bCode);
//                    ps3.setInt(2, cId);
//                    ps3.executeUpdate();
//
//                    conn.commit();
//                    return true;
//                } catch (Exception e) {
//                    conn.rollback();
//                    e.printStackTrace();
//                }
//            }
//        } catch (Exception e) { e.printStackTrace(); }
//        return false;
//    }

    // =========================================================================
    // 8. CẬP NHẬT TRẠNG THÁI BOOKING HOẶC PHÂN PHÒNG
    // =========================================================================

    public boolean updateStatus(int bookingId, String newStatus) {
        if ("ReadyCheckIn".equalsIgnoreCase(newStatus)) {
            return true;
        }

        if ("CheckedIn".equalsIgnoreCase(newStatus)) {
            String getRoomSql = "SELECT RoomID FROM Bookings WHERE BookingID = ?";
            int roomId = -1;
            try (Connection conn = DBConnect.getConnection();
                 PreparedStatement ps = conn.prepareStatement(getRoomSql)) {
                ps.setInt(1, bookingId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) roomId = rs.getInt("RoomID");
                }
            } catch (Exception e) { e.printStackTrace(); }

            if (roomId <= 0) {
                String findRoomSql = "SELECT TOP 1 RoomID FROM Rooms WHERE Status = 'Available'";
                try (Connection conn = DBConnect.getConnection();
                     PreparedStatement ps = conn.prepareStatement(findRoomSql);
                     ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        roomId = rs.getInt("RoomID");
                        String updateRoomSql = "UPDATE Bookings SET RoomID = ? WHERE BookingID = ?";
                        try (PreparedStatement psUp = conn.prepareStatement(updateRoomSql)) {
                            psUp.setInt(1, roomId);
                            psUp.setInt(2, bookingId);
                            psUp.executeUpdate();
                        }
                    }
                } catch (Exception e) { e.printStackTrace(); }
            }

            if (roomId > 0) {
                return processCheckIn(bookingId, roomId);
            }
        }

        if ("CheckedOut".equalsIgnoreCase(newStatus) || "Completed".equalsIgnoreCase(newStatus)) {
            String getBooking = "SELECT BookingCode, CustomerID, RoomID FROM Bookings WHERE BookingID = ?";
            String insertCheckOut = "INSERT INTO CheckOut_Surcharges (BookingCode, CustomerID) VALUES (?, ?)";
            String updateRoom = "UPDATE Rooms SET Status = 'Available', Condition = 'Dirty' WHERE RoomID = ?";

            // Đã bỏ IsActive = 1
            String unlockUser = "UPDATE Users SET "
                    + "CredibilityScore = CASE WHEN ISNULL(CredibilityScore, 0) + 25 > 100 THEN 100 ELSE ISNULL(CredibilityScore, 0) + 25 END, "
                    + "LoyaltyPoints = ISNULL(LoyaltyPoints, 0) + 100, "
                    + "MembershipRank = CASE "
                    + "   WHEN (ISNULL(LoyaltyPoints, 0) + 100) >= 1500 THEN 'Diamond' "
                    + "   WHEN (ISNULL(LoyaltyPoints, 0) + 100) >= 1000 THEN 'Gold' "
                    + "   WHEN (ISNULL(LoyaltyPoints, 0) + 100) >= 500 THEN 'Silver' "
                    + "   ELSE 'Member' END "
                    + "WHERE UserID = ?";

            try (Connection conn = DBConnect.getConnection()) {
                conn.setAutoCommit(false);
                String bCode = null; int cId = -1; int rId = -1;

                try(PreparedStatement psGet = conn.prepareStatement(getBooking)) {
                    psGet.setInt(1, bookingId);
                    try(ResultSet rs = psGet.executeQuery()) {
                        if(rs.next()){
                            bCode = rs.getString("BookingCode");
                            cId = rs.getInt("CustomerID");
                            rId = rs.getInt("RoomID");
                        }
                    }
                }

                if(bCode != null) {
                    try (PreparedStatement ps1 = conn.prepareStatement(insertCheckOut);
                         PreparedStatement ps2 = conn.prepareStatement(updateRoom);
                         PreparedStatement ps3 = conn.prepareStatement(unlockUser)) {

                        ps1.setString(1, bCode);
                        ps1.setInt(2, cId);
                        ps1.executeUpdate();

                        ps2.setInt(1, rId);
                        ps2.executeUpdate();

                        ps3.setInt(1, cId);
                        ps3.executeUpdate();

                        conn.commit();
                        return true;
                    } catch (Exception ex) { conn.rollback(); ex.printStackTrace(); }
                }
            } catch (Exception e) { e.printStackTrace(); }
        }
        return false;
    }

    public boolean updateTotalPrice(int bookingId, double grandTotal) {
        String sql = "UPDATE Bookings SET TotalPrice = ? WHERE BookingID = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setBigDecimal(1, java.math.BigDecimal.valueOf(grandTotal));
            ps.setInt(2, bookingId);

            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // =========================================================================
    // 9. LẤY LỊCH SỬ & FILTER ĐƠN ĐẶT PHÒNG THEO TRẠNG THÁI, GIÁ, NGÀY THÁNG
    // =========================================================================

    public List<Booking> getCheckedOutBookingsByDateFilter(String fromDate, String toDate) {
        List<Booking> list = new ArrayList<>();

        String sql = "SELECT b.BookingID, b.BookingCode, b.CheckInDate, b.CheckOutDate, b.TotalPrice, "
                + "       u.FirstName, u.LastName, r.RoomNumber "
                + "FROM Bookings b "
                + "JOIN Users u ON b.CustomerID = u.UserID "
                + "LEFT JOIN Rooms r ON b.RoomID = r.RoomID "
                + "JOIN CheckOut_Surcharges co ON b.BookingCode = co.BookingCode "
                + "WHERE b.CheckOutDate >= ? AND b.CheckOutDate <= ? "
                + "ORDER BY b.CheckOutDate DESC";

        java.sql.Date sqlFrom;
        java.sql.Date sqlTo;

        if (fromDate == null || fromDate.trim().isEmpty() || toDate == null || toDate.trim().isEmpty()) {
            java.time.LocalDate today = java.time.LocalDate.now();
            java.time.LocalDate oneMonthAgo = today.minusMonths(1);
            sqlFrom = java.sql.Date.valueOf(oneMonthAgo);
            sqlTo = java.sql.Date.valueOf(today.plusDays(1));
        } else {
            sqlFrom = java.sql.Date.valueOf(fromDate);
            sqlTo = java.sql.Date.valueOf(toDate);
        }

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDate(1, sqlFrom);
            ps.setDate(2, sqlTo);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking b = new Booking();
                    b.setId(rs.getInt("BookingID"));
                    b.setBookingCode(rs.getString("BookingCode"));

                    String fullName = rs.getString("LastName") + " " + rs.getString("FirstName");
                    b.setCustomerName(fullName);
                    b.setRoomId(rs.getInt("RoomNumber"));

                    java.sql.Date checkIn = rs.getDate("CheckInDate");
                    java.sql.Date checkOut = rs.getDate("CheckOutDate");
                    if (checkIn != null) b.setCheckInDate(new java.util.Date(checkIn.getTime()));
                    if (checkOut != null) b.setCheckOutDate(new java.util.Date(checkOut.getTime()));

                    java.math.BigDecimal total = rs.getBigDecimal("TotalPrice");
                    if (total != null) {
                        b.setTotalPrice(total.longValue());
                    }

                    b.setStatus("completed");
                    list.add(b);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Booking> getBookingsByFilter(String statusFilter, Double minPrice, Double maxPrice, String fromDate, String toDate) {
        List<Booking> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT * FROM ( ")
                .append("  SELECT b.BookingID, b.BookingCode, b.CheckInDate, b.CheckOutDate, b.TotalPrice, b.CreatedAt, ")
                .append("         u.LastName, u.FirstName, u.PhoneNumber, u.Email, ")
                .append("         r.RoomID, r.RoomNumber, r.RoomType, ")
                .append("         CASE ")
                .append("           WHEN cp.CancelID IS NOT NULL THEN 'cancelled' ")
                .append("           WHEN co.SurchargeID IS NOT NULL THEN 'completed' ")
                .append("           WHEN ci.CheckInID IS NOT NULL THEN 'checkedin' ")
                .append("           ELSE 'pending' ")
                .append("         END AS DerivedStatus ")
                .append("  FROM Bookings b ")
                .append("  JOIN Users u ON b.CustomerID = u.UserID ")
                .append("  LEFT JOIN Rooms r ON b.RoomID = r.RoomID ")
                .append("  LEFT JOIN Cancelled_Penalties cp ON b.BookingCode = cp.BookingCode ")
                .append("  LEFT JOIN CheckIn_Points ci ON b.BookingCode = ci.BookingCode ")
                .append("  LEFT JOIN CheckOut_Surcharges co ON b.BookingCode = co.BookingCode ")
                .append(") AS FilteredBookings WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"all".equalsIgnoreCase(statusFilter)) {
            sql.append("AND DerivedStatus = ? ");
            params.add(statusFilter.trim().toLowerCase());
        }

        if (minPrice != null) {
            sql.append("AND TotalPrice >= ? ");
            params.add(minPrice);
        }

        if (maxPrice != null) {
            sql.append("AND TotalPrice <= ? ");
            params.add(maxPrice);
        }

        if (fromDate != null && !fromDate.trim().isEmpty()) {
            sql.append("AND CheckInDate >= ? ");
            params.add(java.sql.Date.valueOf(fromDate));
        }

        if (toDate != null && !toDate.trim().isEmpty()) {
            sql.append("AND CheckOutDate <= ? ");
            params.add(java.sql.Date.valueOf(toDate));
        }

        sql.append("ORDER BY CheckInDate DESC");

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) ps.setString(i + 1, (String) param);
                else if (param instanceof Double) ps.setDouble(i + 1, (Double) param);
                else if (param instanceof java.sql.Date) ps.setDate(i + 1, (java.sql.Date) param);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking b = new Booking();
                    b.setId(rs.getInt("BookingID"));
                    b.setBookingCode(rs.getString("BookingCode"));
                    b.setCheckInDate(rs.getDate("CheckInDate"));
                    b.setCheckOutDate(rs.getDate("CheckOutDate"));
                    b.setRoomId(rs.getInt("RoomID"));
                    b.setTotalPrice((long) rs.getDouble("TotalPrice"));
                    b.setCustomerName(rs.getString("LastName") + " " + rs.getString("FirstName"));
                    b.setPhone(rs.getString("PhoneNumber"));

                    String roomNumber = rs.getString("RoomNumber");
                    String roomType = rs.getString("RoomType");
                    b.setStatus(roomNumber != null ? (roomNumber + " - " + roomType) : "Chưa xếp phòng");

                    String dbEmail = rs.getString("Email");
                    b.setEmail(dbEmail != null && !dbEmail.isEmpty() ? dbEmail : "khachhang" + b.getId() + "@gmail.com");

                    list.add(b);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
    public List<Booking> getTodayPendingCheckins() {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.BookingID, b.BookingCode, b.CustomerID, b.RoomID, b.CheckInDate, b.CheckOutDate, b.TotalPrice, "
                + "       u.LastName, u.FirstName, u.PhoneNumber, u.Email, "
                + "       r.RoomNumber, r.RoomType "
                + "FROM Bookings b "
                + "LEFT JOIN Users u ON b.CustomerID = u.UserID "
                + "LEFT JOIN Rooms r ON b.RoomID = r.RoomID "
                + "LEFT JOIN Cancelled_Penalties cp ON b.BookingCode = cp.BookingCode "
                + "LEFT JOIN CheckIn_Points ci ON b.BookingCode = ci.BookingCode "
                + "WHERE cp.CancelID IS NULL "
                + "  AND ci.CheckInID IS NULL "
                + "  AND CAST(b.CheckInDate AS DATE) <= CAST(GETDATE() AS DATE) "
                + "ORDER BY b.CheckInDate ASC";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapBookingPendingFromRS(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Booking> searchPendingCheckins(String searchKey) {
        List<Booking> list = new ArrayList<>();
        if (searchKey == null || searchKey.trim().isEmpty()) {
            return getTodayPendingCheckins();
        }

        String sql = "SELECT b.BookingID, b.BookingCode, b.CustomerID, b.RoomID, b.CheckInDate, b.CheckOutDate, b.TotalPrice, "
                + "       u.LastName, u.FirstName, u.PhoneNumber, u.Email, "
                + "       r.RoomNumber, r.RoomType "
                + "FROM Bookings b "
                + "LEFT JOIN Users u ON b.CustomerID = u.UserID "
                + "LEFT JOIN Rooms r ON b.RoomID = r.RoomID "
                + "LEFT JOIN Cancelled_Penalties cp ON b.BookingCode = cp.BookingCode "
                + "LEFT JOIN CheckIn_Points ci ON b.BookingCode = ci.BookingCode "
                + "WHERE cp.CancelID IS NULL "
                + "  AND ci.CheckInID IS NULL "
                + "  AND (b.BookingCode LIKE ? "
                + "       OR u.LastName LIKE ? "
                + "       OR u.FirstName LIKE ? "
                + "       OR (ISNULL(u.LastName,'') + ' ' + ISNULL(u.FirstName,'')) LIKE ? "
                + "       OR u.PhoneNumber LIKE ? "
                + "       OR r.RoomNumber LIKE ?) "
                + "ORDER BY b.CheckInDate ASC";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            String keyword = "%" + searchKey.trim() + "%";
            for (int i = 1; i <= 6; i++) {
                ps.setString(i, keyword);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapBookingPendingFromRS(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Hàm phụ trợ map dữ liệu từ ResultSet sang Object Booking
    private Booking mapBookingPendingFromRS(ResultSet rs) throws Exception {
        Booking b = new Booking();
        b.setId(rs.getInt("BookingID"));

        String code = rs.getString("BookingCode");
        b.setBookingCode(code != null && !code.isEmpty() ? code : "BK-" + b.getId());

        b.setCustomerId(rs.getInt("CustomerID"));
        b.setRoomId(rs.getInt("RoomID"));
        b.setCheckInDate(rs.getDate("CheckInDate"));
        b.setCheckOutDate(rs.getDate("CheckOutDate"));

        java.math.BigDecimal total = rs.getBigDecimal("TotalPrice");
        if (total != null) {
            b.setTotalPrice(total.longValue());
        }

        String lastName = rs.getString("LastName");
        String firstName = rs.getString("FirstName");
        String fullName = ((lastName != null ? lastName : "") + " " + (firstName != null ? firstName : "")).trim();
        b.setCustomerName(fullName.isEmpty() ? "Khách vãng lai" : fullName);

        b.setPhone(rs.getString("PhoneNumber"));
        b.setEmail(rs.getString("Email"));

        String roomNumber = rs.getString("RoomNumber");
        String roomType = rs.getString("RoomType");

        // BỔ SUNG: Gán roomNumber cho đối tượng Booking
        b.setRoomNumber(roomNumber);

        b.setStatus(roomNumber != null ? (roomNumber + " - " + roomType) : "Chưa xếp phòng");

        return b;
    }

    // 1. Thực hiện Check-in: Cập nhật BookingStatus, chèn CheckIn_Points và đổi trạng thái phòng
    public boolean processCheckIn(int bookingId, int roomId) {
        String updateBookingSql = "UPDATE Bookings SET BookingStatus = 'CheckedIn' WHERE BookingID = ?";
        String getBookingSql = "SELECT BookingCode, CustomerID FROM Bookings WHERE BookingID = ?";
        String insertCheckInPointSql = "INSERT INTO [dbo].[CheckIn_Points] ([BookingCode], [CustomerID], [BonusPoints], [Note], [CreatedAt]) "
                + "VALUES (?, ?, 10, N'Điểm thưởng Check-in thành công', GETDATE())";;
        String updateRoomSql = "UPDATE Rooms SET Status = 'Occupied' WHERE RoomID = ?";

        Connection conn = null;
        try {
            conn = DBConnect.getConnection();
            conn.setAutoCommit(false); // Bắt đầu Transaction để đảm bảo tính toàn vẹn dữ liệu

            // Cập nhật trạng thái đơn thành CheckedIn
            try (PreparedStatement ps1 = conn.prepareStatement(updateBookingSql)) {
                ps1.setInt(1, bookingId);
                ps1.executeUpdate();
            }

            String bookingCode = null;
            int customerId = 0;
            try (PreparedStatement psGet = conn.prepareStatement(getBookingSql)) {
                psGet.setInt(1, bookingId);
                try (ResultSet rs = psGet.executeQuery()) {
                    if (rs.next()) {
                        bookingCode = rs.getString("BookingCode");
                        customerId = rs.getInt("CustomerID");
                    }
                }
            }

            // Chèn bản ghi vào bảng CheckIn_Points
            try (PreparedStatement ps = conn.prepareStatement(insertCheckInPointSql)) {
                ps.setString(1, bookingCode); // Truyền BookingCode (String)
                ps.setInt(2, customerId);     // Truyền CustomerID (int)
                ps.executeUpdate();
            }

            // Cập nhật phòng thành 'Occupied' (Đang có khách ở)
            if (roomId > 0) {
                try (PreparedStatement ps3 = conn.prepareStatement(updateRoomSql)) {
                    ps3.setInt(1, roomId);
                    ps3.executeUpdate();
                }
            }

            conn.commit(); // Hoàn tất Transaction
            return true;
        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (Exception ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (Exception ex) { ex.printStackTrace(); }
            }
        }
    }

    // 2. Lấy danh sách các đơn đã Check-in (đang ở) phục vụ cho trang Check-out
    public List<Booking> getCheckedInBookings(String searchKey) {
        List<Booking> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT b.*, u.FirstName, u.LastName, u.PhoneNumber, u.Email, r.RoomNumber " +
                        "FROM Bookings b " +
                        "LEFT JOIN Users u ON b.CustomerID = u.UserID " +
                        "LEFT JOIN Rooms r ON b.RoomID = r.RoomID " +
                        "WHERE b.BookingStatus = 'CheckedIn' "
        );

        if (searchKey != null && !searchKey.trim().isEmpty()) {
            sql.append("AND (b.BookingCode LIKE ? OR u.FirstName LIKE ? OR u.LastName LIKE ? OR r.RoomNumber LIKE ?) ");
        }
        sql.append("ORDER BY b.CheckInDate DESC");

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            if (searchKey != null && !searchKey.trim().isEmpty()) {
                String kw = "%" + searchKey.trim() + "%";
                ps.setString(1, kw);
                ps.setString(2, kw);
                ps.setString(3, kw);
                ps.setString(4, kw);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking b = new Booking();
                    b.setId(rs.getInt("BookingID"));
                    String code = rs.getString("BookingCode");
                    b.setBookingCode(code != null && !code.isEmpty() ? code : "BK-" + b.getId());
                    b.setCustomerId(rs.getInt("CustomerID"));
                    b.setRoomId(rs.getInt("RoomID"));
                    b.setCheckInDate(rs.getTimestamp("CheckInDate"));
                    b.setCheckOutDate(rs.getTimestamp("CheckOutDate"));
                    b.setTotalPrice(rs.getLong("TotalPrice"));

                    String firstName = rs.getString("FirstName");
                    String lastName = rs.getString("LastName");
                    String fullName = ((firstName != null ? firstName : "") + " " + (lastName != null ? lastName : "")).trim();
                    b.setCustomerName(fullName.isEmpty() ? "Khách vãng lai" : fullName);

                    b.setPhone(rs.getString("PhoneNumber"));
                    b.setEmail(rs.getString("Email"));
                    b.setRoomNumber(rs.getString("RoomNumber"));
                    b.setStatus(rs.getString("BookingStatus"));

                    list.add(b);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Booking> getAllBookingsWithStatus(String fromDate, String toDate) {
        List<Booking> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT b.BookingID, b.BookingCode, b.CheckInDate, b.CheckOutDate, ")
                .append("       ISNULL(i.BaseTotal + i.ExtraFeesTotal, b.TotalPrice) AS TotalPrice, b.VoucherCode, ")
                .append("       ISNULL(u.LastName + ' ' + u.FirstName, N'Khách vãng lai') AS CustomerName, ")
                .append("       r.RoomNumber, history.Status ")
                .append("FROM Bookings b ")
                .append("INNER JOIN (")
                .append("   SELECT DISTINCT BookingCode, 'completed' AS Status FROM CheckOut_Surcharges ")
                .append("   UNION ALL ")
                .append("   SELECT DISTINCT BookingCode, 'cancelled' AS Status FROM Cancelled_Penalties ")
                .append(") history ON b.BookingCode = history.BookingCode ")
                .append("LEFT JOIN Invoices i ON b.BookingID = i.BookingID ")
                .append("LEFT JOIN Users u ON b.CustomerID = u.UserID ")
                .append("LEFT JOIN Rooms r ON b.RoomID = r.RoomID ")
                .append("WHERE 1=1 ");

        List<String> params = new ArrayList<>();
        if (fromDate != null && !fromDate.trim().isEmpty()) {
            sql.append("AND CAST(b.CheckInDate AS DATE) >= CAST(? AS DATE) ");
            params.add(fromDate);
        }
        if (toDate != null && !toDate.trim().isEmpty()) {
            sql.append("AND CAST(b.CheckInDate AS DATE) <= CAST(? AS DATE) ");
            params.add(toDate);
        }
        sql.append("ORDER BY b.CheckInDate DESC");

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setString(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking b = new Booking();
                    b.setId(rs.getInt("BookingID"));
                    b.setBookingCode(rs.getString("BookingCode"));
                    b.setCheckInDate(rs.getDate("CheckInDate"));
                    b.setCheckOutDate(rs.getDate("CheckOutDate"));
                    b.setTotalPrice(rs.getLong("TotalPrice"));
                    try { b.setVoucherCode(rs.getString("VoucherCode")); } catch (Exception ignored) {}
                    b.setCustomerName(rs.getString("CustomerName"));
                    b.setRoomNumber(rs.getString("RoomNumber"));
                    b.setStatus(rs.getString("Status"));

                    list.add(b);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean processCheckOut(int bookingId, String bookingCode, int roomId, double totalSurcharge, String note, String roomCondition) {
        Connection conn = null;
        try {
            conn = DBConnect.getConnection();
            conn.setAutoCommit(false); // Bắt đầu Transaction

            // 1. Lưu thông tin lịch sử phụ phí
            String insertSurchargeSql = "INSERT INTO CheckOut_Surcharges (BookingCode, SurchargeAmount, CreatedAt) VALUES (?, ?, GETDATE())";
            try (PreparedStatement ps = conn.prepareStatement(insertSurchargeSql)) {
                ps.setString(1, bookingCode);
                ps.setDouble(2, totalSurcharge);
                ps.executeUpdate();
            }

            // 2. Cập nhật Hóa Đơn trong bảng Invoices
            String updateInvoiceSql = "UPDATE Invoices SET "
                    + "ExtraFeesTotal = ISNULL(ExtraFeesTotal, 0) + ?, "
                    + "FinalAmountDue = (ISNULL(BaseTotal, 0) + ISNULL(ExtraFeesTotal, 0) + ?) - ISNULL(DepositPaid, 0) - ISNULL(DiscountApplied, 0), "
                    + "PaymentStatus = N'Paid', "
                    + "IssuedDate = GETDATE() "
                    + "WHERE BookingID = ?";

            int rowsUpdated = 0;
            try (PreparedStatement ps = conn.prepareStatement(updateInvoiceSql)) {
                ps.setDouble(1, totalSurcharge);
                ps.setDouble(2, totalSurcharge);
                ps.setInt(3, bookingId);
                rowsUpdated = ps.executeUpdate();
            }

            // Fallback Insert nếu chưa có Invoice
            if (rowsUpdated == 0) {
                double bookingPrice = 0;
                String getPriceSql = "SELECT TotalPrice FROM Bookings WHERE BookingID = ?";
                try (PreparedStatement psPrice = conn.prepareStatement(getPriceSql)) {
                    psPrice.setInt(1, bookingId);
                    try (ResultSet rs = psPrice.executeQuery()) {
                        if (rs.next()) {
                            bookingPrice = rs.getDouble("TotalPrice");
                        }
                    }
                }

                String insertInvoiceSql = "INSERT INTO Invoices ("
                        + "BookingID, BaseTotal, ExtraFeesTotal, DiscountApplied, "
                        + "DepositPaid, RefundAmount, FinalAmountDue, PaymentMethod, "
                        + "PaymentStatus, VATPercent, IssuedDate"
                        + ") VALUES (?, ?, ?, 0, 0, 0, ?, 'qr', N'Paid', 10, GETDATE())";

                try (PreparedStatement psInsert = conn.prepareStatement(insertInvoiceSql)) {
                    psInsert.setInt(1, bookingId);
                    psInsert.setDouble(2, bookingPrice);
                    psInsert.setDouble(3, totalSurcharge);
                    psInsert.setDouble(4, bookingPrice + totalSurcharge);
                    psInsert.executeUpdate();
                }
            }

            // 3. Đổi trạng thái đơn Booking sang 'Completed'
            String updateBookingSql = "UPDATE Bookings SET BookingStatus = 'Completed' WHERE BookingID = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateBookingSql)) {
                ps.setInt(1, bookingId);
                ps.executeUpdate();
            }

            // 4. 🔥 CẬP NHẬT TRẠNG THÁI & TÌNH TRẠNG PHÒNG (Rooms)
            // Status luôn đưa về 'Available', Condition nhận giá trị dirty / damaged / underrepair
            String updateRoomSql = "UPDATE Rooms SET Status = 'Available', Condition = ? WHERE RoomID = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateRoomSql)) {
                ps.setString(1, roomCondition);
                ps.setInt(2, roomId);
                ps.executeUpdate();
            }

            // 5. Lấy CustomerID và CỘNG +25 Điểm Uy Tín +100 Điểm Thành Viên
            String getCustomerSql = "SELECT CustomerID FROM Bookings WHERE BookingID = ?";
            int customerId = -1;
            try (PreparedStatement psCust = conn.prepareStatement(getCustomerSql)) {
                psCust.setInt(1, bookingId);
                try (ResultSet rsCust = psCust.executeQuery()) {
                    if (rsCust.next()) {
                        customerId = rsCust.getInt("CustomerID");
                    }
                }
            }

            if (customerId > 0) {
                String updateUserSql = "UPDATE Users SET "
                        + "CredibilityScore = CASE WHEN ISNULL(CredibilityScore, 0) + 25 > 100 THEN 100 ELSE ISNULL(CredibilityScore, 0) + 25 END, "
                        + "LoyaltyPoints = ISNULL(LoyaltyPoints, 0) + 100, "
                        + "MembershipRank = CASE "
                        + "   WHEN (ISNULL(LoyaltyPoints, 0) + 100) >= 1500 THEN 'Diamond' "
                        + "   WHEN (ISNULL(LoyaltyPoints, 0) + 100) >= 1000 THEN 'Gold' "
                        + "   WHEN (ISNULL(LoyaltyPoints, 0) + 100) >= 500 THEN 'Silver' "
                        + "   ELSE 'Member' END "
                        + "WHERE UserID = ?";

                try (PreparedStatement psUser = conn.prepareStatement(updateUserSql)) {
                    psUser.setInt(1, customerId);
                    psUser.executeUpdate();
                }
            }

            conn.commit();
            return true;
        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (Exception ex) {}
            }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (Exception ex) {}
            }
        }
    }
}