package dao;

import model.Commission;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CommissionDAO {

    private final String url = "jdbc:sqlserver://localhost:1433;databaseName=HotelManagement;encrypt=true;trustServerCertificate=true;";
    private final String username = "sa";
    private final String password = "097a8z50";

    private Connection getConnection() throws Exception {
        // Driver cho SQL Server
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        return DriverManager.getConnection(url, username, password);
    }

    // Hàm lấy toàn bộ danh sách hoa hồng từ Database
    public List<Commission> getAllCommissions() {
        List<Commission> list = new ArrayList<>();
        String sql = "SELECT * FROM Commissions";

        // Sử dụng try-with-resources để tự động đóng kết nối khi chạy xong, tránh rò rỉ bộ nhớ
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Commission c = new Commission(
                        rs.getString("booking_id"),
                        rs.getString("customer_name"),
                        rs.getDate("booking_date"),
                        rs.getDate("payment_date"),
                        rs.getDouble("total_amount"),
                        rs.getDouble("commission_rate"),
                        rs.getDouble("commission_amount"),
                        rs.getString("status")
                );
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}