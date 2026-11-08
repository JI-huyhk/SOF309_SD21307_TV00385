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
import java.util.Date;
import java.util.List;

@WebServlet(name = "RevenueController", urlPatterns = {"/quan-ly-doanh-thu"})
public class RevenueController extends HttpServlet {

    // DTO nội bộ để chứa dữ liệu hiển thị lên Bảng Doanh Thu
    public static class RevenueItem {
        private int id;
        private String customerName;
        private String bookingCode;
        private Date checkInDate;
        private double amount; // Số tiền hiển thị chuẩn (PenaltyFee nếu Hủy, FinalAmountDue nếu có Invoice)
        private String status;

        public RevenueItem(int id, String customerName, String bookingCode, Date checkInDate, double amount, String status) {
            this.id = id;
            this.customerName = customerName;
            this.bookingCode = bookingCode;
            this.checkInDate = checkInDate;
            this.amount = amount;
            this.status = status;
        }

        public int getId() { return id; }
        public String getCustomerName() { return customerName; }
        public String getBookingCode() { return bookingCode; }
        public Date getCheckInDate() { return checkInDate; }
        public double getAmount() { return amount; }
        public String getStatus() { return status; }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        List<RevenueItem> listRevenue = new ArrayList<>();

        double totalReceived = 0.0;
        double totalPending = 0.0;
        int totalOrders = 0;

        // SQL LẤY BẢNG HIỂN THỊ: Nếu Hủy -> lấy PenaltyFee, Nếu có Invoice -> lấy FinalAmountDue, còn lại lấy TotalPrice
        String sqlList = "SELECT "
                + "    b.BookingID, "
                + "    ISNULL(u.LastName + ' ' + u.FirstName, N'Khách vãng lai') AS FullName, "
                + "    b.BookingCode, "
                + "    b.CheckInDate, "
                + "    b.BookingStatus, "
                + "    CASE "
                + "        WHEN b.BookingStatus = 'Cancelled' THEN ISNULL(cp.PenaltyFee, 0) "
                + "        WHEN i.InvoiceID IS NOT NULL THEN i.FinalAmountDue "
                + "        ELSE b.TotalPrice "
                + "    END AS ActualAmount "
                + "FROM Bookings b "
                + "LEFT JOIN Users u ON b.CustomerID = u.UserID "
                + "LEFT JOIN Invoices i ON b.BookingID = i.BookingID "
                + "LEFT JOIN Cancelled_Penalties cp ON b.BookingCode = cp.BookingCode "
                + "ORDER BY b.BookingID ASC";

        try (Connection conn = context.DBConnect.getConnection()) {
            // 1. Lấy danh sách hiển thị cho bảng
            try (PreparedStatement ps = conn.prepareStatement(sqlList);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    listRevenue.add(new RevenueItem(
                            rs.getInt("BookingID"),
                            rs.getString("FullName"),
                            rs.getString("BookingCode"),
                            rs.getTimestamp("CheckInDate"),
                            rs.getDouble("ActualAmount"),
                            rs.getString("BookingStatus")
                    ));
                }
            }
            totalOrders = listRevenue.size();

            // 2. Tính Doanh Thu Thực Thu (Invoices 'Paid' + Tiền phạt Cancelled_Penalties)
            String sqlInvoice = "SELECT ISNULL(SUM(FinalAmountDue), 0) FROM Invoices WHERE PaymentStatus = 'Paid'";
            try (PreparedStatement psInv = conn.prepareStatement(sqlInvoice);
                 ResultSet rsInv = psInv.executeQuery()) {
                if (rsInv.next()) totalReceived += rsInv.getDouble(1);
            }

            String sqlPenalty = "SELECT ISNULL(SUM(PenaltyFee), 0) FROM Cancelled_Penalties";
            try (PreparedStatement psPen = conn.prepareStatement(sqlPenalty);
                 ResultSet rsPen = psPen.executeQuery()) {
                if (rsPen.next()) totalReceived += rsPen.getDouble(1);
            }

            // 3. Tính Doanh Thu Treo (Chờ duyệt / chưa xong)
            for (RevenueItem item : listRevenue) {
                String st = item.getStatus() != null ? item.getStatus().trim() : "";
                if (!"Confirmed".equalsIgnoreCase(st)
                        && !"Completed".equalsIgnoreCase(st)
                        && !"CheckedOut".equalsIgnoreCase(st)
                        && !"Cancelled".equalsIgnoreCase(st)) {
                    totalPending += item.getAmount();
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("listRevenue", listRevenue);
        request.setAttribute("totalReceived", totalReceived);
        request.setAttribute("totalPending", totalPending);
        request.setAttribute("totalOrders", totalOrders);

        request.getRequestDispatcher("/WEB-INF/revenue.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}