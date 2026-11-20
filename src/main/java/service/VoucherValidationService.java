package service;

import model.Voucher;
import java.sql.Date;

/**
 * =========================================================================
 * VoucherValidationService - Lớp nghiệp vụ xác thực và tính toán Voucher
 *
 * Mục đích: Tách riêng logic kiểm tra voucher ra khỏi DAO để Unit Test thuần.
 * Ánh xạ với: VoucherController.java và VoucherDAO.isRankEligible / calculateDiscount
 * =========================================================================
 */
public class VoucherValidationService {

    private static final int[] RANK_LEVELS = {0, 1, 2, 3}; // Member=0, Silver=1, Gold=2, Diamond=3

    /**
     * Lấy cấp bậc số của Rank (giống VoucherDAO.getRankLevel)
     */
    public int getRankLevel(String rank) {
        if (rank == null) return 0;
        switch (rank.trim().toUpperCase()) {
            case "DIAMOND": return 3;
            case "GOLD":    return 2;
            case "SILVER":  return 1;
            case "MEMBER":
            default:        return 0;
        }
    }

    /**
     * Kiểm tra khách hàng đủ điều kiện dùng Voucher theo Rank
     * (Khách rank cao hơn dùng được Voucher rank thấp hơn)
     */
    public boolean isRankEligible(String userRank, String requiredRank) {
        if (requiredRank == null || requiredRank.trim().isEmpty()
                || requiredRank.equalsIgnoreCase("Member")
                || requiredRank.equalsIgnoreCase("All")) {
            return true;
        }
        return getRankLevel(userRank) >= getRankLevel(requiredRank);
    }

    /**
     * Kiểm tra Voucher còn hạn hay không
     */
    public boolean isVoucherValid(Voucher voucher) {
        if (voucher == null) return false;
        if (!voucher.isActive()) return false;
        if (voucher.getExpiryDate() == null) return true; // Không có ngày hết hạn = còn hiệu lực
        Date today = new Date(System.currentTimeMillis());
        return !voucher.getExpiryDate().before(today);
    }

    /**
     * Tính số tiền được giảm từ Voucher (có áp dụng giới hạn tối đa)
     */
    public double calculateDiscount(Voucher voucher, double originalPrice) {
        if (voucher == null || originalPrice <= 0) return 0;
        double discount = originalPrice * (voucher.getDiscountPercent() / 100.0);
        if (voucher.getMaxDiscountAmount() > 0 && discount > voucher.getMaxDiscountAmount()) {
            discount = voucher.getMaxDiscountAmount();
        }
        return discount;
    }

    /**
     * Xác định hạng thành viên dựa trên điểm tích lũy
     */
    public String determineMembershipRank(int loyaltyPoints) {
        if (loyaltyPoints >= 1500) return "Diamond";
        if (loyaltyPoints >= 1000) return "Gold";
        if (loyaltyPoints >= 500)  return "Silver";
        return "Member";
    }
}
