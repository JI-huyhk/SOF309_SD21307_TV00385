package dao;

import context.DBConnect;
import model.Voucher;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class VoucherDAO {

    // 1. Lấy danh sách Voucher khả dụng dựa trên Rank của khách hàng
    public List<Voucher> getEligibleVouchers(String userRank) {
        List<Voucher> list = new ArrayList<>();
        if (userRank == null) userRank = "Member";

        String sql = "SELECT * FROM Vouchers";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Voucher v = null;
                try {
                    v = mapResultSetToVoucher(rs);
                } catch (Exception ex) {
                    continue; // Nếu có lỗi map dòng này, bỏ qua
                }

                if (v == null) continue;

                // 1. Kiểm tra IsActive
                if (!v.isActive()) continue;

                java.util.Date today = new java.util.Date();

                // 2. CHỈ QUAN TÂM VALID TO: Kiểm tra ngày hết hạn
                if (v.getExpiryDate() != null) {
                    if (v.getExpiryDate().before(today) && !isSameDay(v.getExpiryDate(), today)) {
                        continue; // Mã đã quá hạn -> Bỏ qua
                    }
                }

                // 3. Kiểm tra Hạng (Rank)
                if (isRankEligible(userRank, v.getRequiredRank())) {
                    list.add(v);
                }
            }

            // Sắp xếp giảm dần theo DiscountPercent
            list.sort((v1, v2) -> Double.compare(v2.getDiscountPercent(), v1.getDiscountPercent()));

        } catch (Exception e) {
            System.out.println("Lỗi tại getEligibleVouchers: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    // Hàm phụ trợ so sánh ngày
    private boolean isSameDay(java.util.Date date1, java.util.Date date2) {
        java.util.Calendar cal1 = java.util.Calendar.getInstance();
        cal1.setTime(date1);
        java.util.Calendar cal2 = java.util.Calendar.getInstance();
        cal2.setTime(date2);
        return cal1.get(java.util.Calendar.YEAR) == cal2.get(java.util.Calendar.YEAR) &&
                cal1.get(java.util.Calendar.DAY_OF_YEAR) == cal2.get(java.util.Calendar.DAY_OF_YEAR);
    }

    // So sánh Hạng (Khách rank cao hơn dùng được Voucher rank thấp hơn)
    private boolean isRankEligible(String userRank, String requiredRank) {
        if (requiredRank == null || requiredRank.trim().isEmpty() || requiredRank.equalsIgnoreCase("Member") || requiredRank.equalsIgnoreCase("All")) {
            return true;
        }
        if (userRank == null) userRank = "Member";

        int userLevel = getRankLevel(userRank);
        int requiredLevel = getRankLevel(requiredRank);

        return userLevel >= requiredLevel;
    }

    private int getRankLevel(String rank) {
        if (rank == null) return 0;
        switch (rank.trim().toUpperCase()) {
            case "DIAMOND": return 3;
            case "GOLD":    return 2;
            case "SILVER":  return 1;
            case "MEMBER":
            default:        return 0;
        }
    }

    // 2. Lấy chi tiết Voucher theo Mã
    public Voucher getVoucherByCode(String voucherCode) {
        if (voucherCode == null || voucherCode.trim().isEmpty()) return null;
        String sql = "SELECT * FROM Vouchers WHERE VoucherCode = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, voucherCode.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToVoucher(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Ánh xạ ResultSet SIÊU AN TOÀN (Bọc Try-Catch mọi cột, bao gồm cả DiscountPercent)
    private Voucher mapResultSetToVoucher(ResultSet rs) {
        Voucher v = new Voucher();

        try { v.setVoucherCode(rs.getString("VoucherCode")); }
        catch (Exception e) { try { v.setVoucherCode(rs.getString("voucher_code")); } catch (Exception ex) {} }

        try { v.setDiscountPercent(rs.getDouble("DiscountPercent")); }
        catch (Exception e) {
            try { v.setDiscountPercent(rs.getDouble("Discount")); }
            catch (Exception ex) {
                try { v.setDiscountPercent(rs.getDouble("discount_percent")); } catch (Exception ex2) {}
            }
        }

        try { v.setMaxDiscountAmount(rs.getDouble("MaxDiscountAmount")); }
        catch (Exception e) { try { v.setMaxDiscountAmount(rs.getDouble("MaxDiscount")); } catch (Exception ex) {} }

        try { v.setMinLoyaltyPoints(rs.getInt("MinLoyaltyPoints")); }
        catch (Exception e) { v.setMinLoyaltyPoints(0); }

        try { v.setRequiredRank(rs.getString("RequiredRank")); }
        catch (Exception e) {
            try { v.setRequiredRank(rs.getString("RankRequired")); }
            catch (Exception ex) { v.setRequiredRank("Member"); }
        }

        // 💡 FIX LỖI TẠI ĐÂY: Ưu tiên đọc cột ValidTo như bạn mô tả trong database thay vì ExpiryDate
        try { v.setExpiryDate(rs.getDate("ValidTo")); }
        catch (Exception e) {
            try { v.setExpiryDate(rs.getDate("ExpiryDate")); } // Dự phòng nếu có DB khác vẫn dùng ExpiryDate
            catch (Exception ex) { v.setExpiryDate(null); }
        }

        try { v.setActive(rs.getBoolean("IsActive")); }
        catch (Exception e) {
            try { v.setActive(rs.getInt("IsActive") == 1); }
            catch (Exception ex) { v.setActive(true); }
        }

        return v;
    }

    // 3. Tính số tiền được giảm
    public double calculateDiscount(String voucherCode, double originalPrice) {
        if (voucherCode == null || voucherCode.trim().isEmpty()) return 0;
        Voucher v = getVoucherByCode(voucherCode);
        if (v == null) return 0;

        double discount = originalPrice * (v.getDiscountPercent() / 100.0);
        if (v.getMaxDiscountAmount() > 0 && discount > v.getMaxDiscountAmount()) {
            discount = v.getMaxDiscountAmount();
        }
        return discount;
    }
}