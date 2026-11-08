package model;

import java.util.Date;

public class Commission {
    private String bookingId;
    private String customerName;
    private Date bookingDate;
    private Date paymentDate;
    private double totalAmount;
    private double commissionRate;
    private double commissionAmount;
    private String status;

    // Constructor mặc định
    public Commission() {}

    // Constructor đầy đủ
    public Commission(String bookingId, String customerName, Date bookingDate, Date paymentDate,
                      double totalAmount, double commissionRate, double commissionAmount, String status) {
        this.bookingId = bookingId;
        this.customerName = customerName;
        this.bookingDate = bookingDate;
        this.paymentDate = paymentDate;
        this.totalAmount = totalAmount;
        this.commissionRate = commissionRate;
        this.commissionAmount = commissionAmount;
        this.status = status;
    }

    // Getter và Setter
    public String getBookingId() { return bookingId; }
    public void setBookingId(String bookingId) { this.bookingId = bookingId; }
    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
    public Date getBookingDate() { return bookingDate; }
    public void setBookingDate(Date bookingDate) { this.bookingDate = bookingDate; }
    public Date getPaymentDate() { return paymentDate; }
    public void setPaymentDate(Date paymentDate) { this.paymentDate = paymentDate; }
    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }
    public double getCommissionRate() { return commissionRate; }
    public void setCommissionRate(double commissionRate) { this.commissionRate = commissionRate; }
    public double getCommissionAmount() { return commissionAmount; }
    public void setCommissionAmount(double commissionAmount) { this.commissionAmount = commissionAmount; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
