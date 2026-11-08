package model;

import jakarta.persistence.*;
import java.sql.Timestamp;

@Entity
@Table(name = "Invoices")
public class Invoice {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "InvoiceID")
    private int invoiceId;

    @Column(name = "BookingID")
    private int bookingId;

    @Column(name = "BaseTotal")
    private double baseTotal;

    @Column(name = "ExtraFeesTotal")
    private double extraFeesTotal;

    @Column(name = "DiscountApplied")
    private double discountApplied;

    @Column(name = "DepositPaid")
    private double depositPaid;

    @Column(name = "RefundAmount")
    private double refundAmount;

    @Column(name = "FinalAmountDue")
    private double finalAmountDue;

    @Column(name = "PaymentMethod")
    private String paymentMethod;

    @Column(name = "PaymentStatus")
    private String paymentStatus;

    @Column(name = "VATPercent")
    private int vatPercent;

    @Column(name = "IssuedDate")
    private Timestamp issuedDate;

    @Column(name = "ConfirmedByStaff")
    private Integer confirmedByStaff;

    // Constructors
    public Invoice() {
    }

    public Invoice(int invoiceId, int bookingId, double baseTotal, double extraFeesTotal,
                   double discountApplied, double depositPaid, double refundAmount,
                   double finalAmountDue, String paymentMethod, String paymentStatus,
                   int vatPercent, Timestamp issuedDate, Integer confirmedByStaff) {
        this.invoiceId = invoiceId;
        this.bookingId = bookingId;
        this.baseTotal = baseTotal;
        this.extraFeesTotal = extraFeesTotal;
        this.discountApplied = discountApplied;
        this.depositPaid = depositPaid;
        this.refundAmount = refundAmount;
        this.finalAmountDue = finalAmountDue;
        this.paymentMethod = paymentMethod;
        this.paymentStatus = paymentStatus;
        this.vatPercent = vatPercent;
        this.issuedDate = issuedDate;
        this.confirmedByStaff = confirmedByStaff;
    }

    // Getters and Setters
    public int getInvoiceId() {
        return invoiceId;
    }

    public void setInvoiceId(int invoiceId) {
        this.invoiceId = invoiceId;
    }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public double getBaseTotal() {
        return baseTotal;
    }

    public void setBaseTotal(double baseTotal) {
        this.baseTotal = baseTotal;
    }

    public double getExtraFeesTotal() {
        return extraFeesTotal;
    }

    public void setExtraFeesTotal(double extraFeesTotal) {
        this.extraFeesTotal = extraFeesTotal;
    }

    public double getDiscountApplied() {
        return discountApplied;
    }

    public void setDiscountApplied(double discountApplied) {
        this.discountApplied = discountApplied;
    }

    public double getDepositPaid() {
        return depositPaid;
    }

    public void setDepositPaid(double depositPaid) {
        this.depositPaid = depositPaid;
    }

    public double getRefundAmount() {
        return refundAmount;
    }

    public void setRefundAmount(double refundAmount) {
        this.refundAmount = refundAmount;
    }

    public double getFinalAmountDue() {
        return finalAmountDue;
    }

    public void setFinalAmountDue(double finalAmountDue) {
        this.finalAmountDue = finalAmountDue;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public int getVatPercent() {
        return vatPercent;
    }

    // ALIAS GIÚP TƯƠNG THÍCH VỚI CONTROLLER (VIẾT HOA 3 CHỮ VAT)
    public int getVATPercent() {
        return vatPercent;
    }

    public void setVatPercent(int vatPercent) {
        this.vatPercent = vatPercent;
    }

    public void setVATPercent(int vatPercent) {
        this.vatPercent = vatPercent;
    }

    public Timestamp getIssuedDate() {
        return issuedDate;
    }

    public void setIssuedDate(Timestamp issuedDate) {
        this.issuedDate = issuedDate;
    }

    public Integer getConfirmedByStaff() {
        return confirmedByStaff;
    }

    public void setConfirmedByStaff(Integer confirmedByStaff) {
        this.confirmedByStaff = confirmedByStaff;
    }
}