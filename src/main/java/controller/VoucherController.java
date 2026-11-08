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
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@WebServlet(name = "VoucherController", urlPatterns = {"/quan-ly-voucher"})
public class VoucherController extends HttpServlet {

    public static class VoucherItem {
        private String voucherCode;
        private int discountPercent;
        private double maxDiscountAmount;
        private String requiredRank;
        private Date validFrom;
        private Date validTo;
        private boolean isActive;

        public VoucherItem(String voucherCode, int discountPercent, double maxDiscountAmount, String requiredRank, Date validFrom, Date validTo, boolean isActive) {
            this.voucherCode = voucherCode;
            this.discountPercent = discountPercent;
            this.maxDiscountAmount = maxDiscountAmount;
            this.requiredRank = requiredRank;
            this.validFrom = validFrom;
            this.validTo = validTo;
            this.isActive = isActive;
        }

        public String getVoucherCode() { return voucherCode; }
        public int getDiscountPercent() { return discountPercent; }
        public double getMaxDiscountAmount() { return maxDiscountAmount; }
        public String getRequiredRank() { return requiredRank; }
        public Date getValidFrom() { return validFrom; }
        public Date getValidTo() { return validTo; }
        public boolean isIsActive() { return isActive; }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        List<VoucherItem> listVouchers = new ArrayList<>();

        String sqlList = "SELECT VoucherCode, DiscountPercent, MaxDiscountAmount, RequiredRank, ValidFrom, ValidTo, IsActive "
                + "FROM Vouchers ORDER BY ValidTo DESC";

        try (Connection conn = context.DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlList);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                listVouchers.add(new VoucherItem(
                        rs.getString("VoucherCode"),
                        rs.getInt("DiscountPercent"),
                        rs.getDouble("MaxDiscountAmount"),
                        rs.getString("RequiredRank"),
                        rs.getTimestamp("ValidFrom"),
                        rs.getTimestamp("ValidTo"),
                        rs.getBoolean("IsActive")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("listVouchers", listVouchers);
        request.getRequestDispatcher("/WEB-INF/voucher.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("create".equalsIgnoreCase(action)) {
            String code = request.getParameter("voucherCode");
            String discountStr = request.getParameter("discountPercent");
            String maxAmountStr = request.getParameter("maxDiscountAmount");
            String requiredRank = request.getParameter("requiredRank");
            String validFromStr = request.getParameter("validFrom");
            String validToStr = request.getParameter("validTo");

            try {
                if (code != null) code = code.trim().toUpperCase();
                int discount = Integer.parseInt(discountStr);
                double maxAmount = Double.parseDouble(maxAmountStr);

                // Validation server-side khoá dữ liệu
                if (discount <= 0 || discount > 100 || maxAmount < 0) {
                    request.getSession().setAttribute("errorMessage", "Phần trăm giảm phải từ 1-100% và số tiền tối đa không âm!");
                    response.sendRedirect(request.getContextPath() + "/quan-ly-voucher");
                    return;
                }

                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
                Timestamp validFrom = new Timestamp(sdf.parse(validFromStr).getTime());
                Timestamp validTo = new Timestamp(sdf.parse(validToStr).getTime());

                if (validTo.before(validFrom)) {
                    request.getSession().setAttribute("errorMessage", "Ngày kết thúc phải lớn hơn ngày bắt đầu!");
                    response.sendRedirect(request.getContextPath() + "/quan-ly-voucher");
                    return;
                }

                String sqlInsert = "INSERT INTO Vouchers (VoucherCode, DiscountPercent, MaxDiscountAmount, RequiredRank, ValidFrom, ValidTo, IsActive) "
                        + "VALUES (?, ?, ?, ?, ?, ?, 1)";

                try (Connection conn = context.DBConnect.getConnection();
                     PreparedStatement ps = conn.prepareStatement(sqlInsert)) {
                    ps.setString(1, code);
                    ps.setInt(2, discount);
                    ps.setDouble(3, maxAmount);
                    ps.setString(4, requiredRank);
                    ps.setTimestamp(5, validFrom);
                    ps.setTimestamp(6, validTo);
                    ps.executeUpdate();
                    request.getSession().setAttribute("successMessage", "Tạo Voucher mới thành công!");
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.getSession().setAttribute("errorMessage", "Lỗi: Mã Voucher đã tồn tại hoặc định dạng dữ liệu không hợp lệ!");
            }
        } else if ("deactivate".equalsIgnoreCase(action)) {
            String code = request.getParameter("voucherCode");
            String sqlDeactivate = "UPDATE Vouchers SET IsActive = 0 WHERE VoucherCode = ?";

            try (Connection conn = context.DBConnect.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sqlDeactivate)) {
                ps.setString(1, code);
                ps.executeUpdate();
                request.getSession().setAttribute("successMessage", "Đã vô hiệu hóa Voucher thành công!");
            } catch (Exception e) {
                e.printStackTrace();
                request.getSession().setAttribute("errorMessage", "Không thể vô hiệu hóa Voucher này!");
            }
        }

        response.sendRedirect(request.getContextPath() + "/quan-ly-voucher");
    }
}