    package model;
    
    import java.sql.Date;
    
    public class Voucher {
        private String voucherCode;
        private double discountPercent;
        private double maxDiscountAmount; // Đã đổi từ maxDiscount -> maxDiscountAmount để khớp DB
        private int minLoyaltyPoints;
        private String requiredRank;
        private Date expiryDate;
        private boolean isActive;
    
        public Voucher() {}
    
        public Voucher(String voucherCode, double discountPercent, double maxDiscountAmount, int minLoyaltyPoints, String requiredRank, Date expiryDate, boolean isActive) {
            this.voucherCode = voucherCode;
            this.discountPercent = discountPercent;
            this.maxDiscountAmount = maxDiscountAmount;
            this.minLoyaltyPoints = minLoyaltyPoints;
            this.requiredRank = requiredRank;
            this.expiryDate = expiryDate;
            this.isActive = isActive;
        }
    
        public String getVoucherCode() { return voucherCode; }
        public void setVoucherCode(String voucherCode) { this.voucherCode = voucherCode; }
    
        public double getDiscountPercent() { return discountPercent; }
        public void setDiscountPercent(double discountPercent) { this.discountPercent = discountPercent; }
    
        public double getMaxDiscountAmount() { return maxDiscountAmount; }
        public void setMaxDiscountAmount(double maxDiscountAmount) { this.maxDiscountAmount = maxDiscountAmount; }
    
        public int getMinLoyaltyPoints() { return minLoyaltyPoints; }
        public void setMinLoyaltyPoints(int minLoyaltyPoints) { this.minLoyaltyPoints = minLoyaltyPoints; }
    
        public String getRequiredRank() { return requiredRank; }
        public void setRequiredRank(String requiredRank) { this.requiredRank = requiredRank; }
    
        public Date getExpiryDate() { return expiryDate; }
        public void setExpiryDate(Date expiryDate) { this.expiryDate = expiryDate; }
    
        public boolean isActive() { return isActive; }
        public void setActive(boolean active) { isActive = active; }
    }