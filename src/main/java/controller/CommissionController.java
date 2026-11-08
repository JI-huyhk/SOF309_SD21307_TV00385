package controller;

import dao.CommissionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Commission;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

@WebServlet("/quan-ly-hoa-hong")
public class CommissionController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        // 1. Gọi DAO lấy toàn bộ dữ liệu thực tế từ Database xuống
        CommissionDAO dao = new CommissionDAO();
        List<Commission> list = dao.getAllCommissions();

        // 2. Thu thập các tham số lọc từ JSP gửi lên
        String dateRange = request.getParameter("dateRange");
        String[] statuses = request.getParameterValues("status");
        String bookingId = request.getParameter("bookingId");
        String searchAction = request.getParameter("searchAction");

        List<Commission> filteredList = new ArrayList<>();

        // 3. Tiến hành lọc dữ liệu động nếu người dùng nhấn nút Lọc
        if ("filter".equals(searchAction)) {
            // SỬA BUG 1: Thay YYYY thành yyyy để Java parse đúng ngày lịch
            SimpleDateFormat pickerSdf = new SimpleDateFormat("dd/MM/yyyy");
            Date startDate = null;
            Date endDate = null;

            if (dateRange != null && dateRange.contains(" - ")) {
                try {
                    String[] parts = dateRange.split(" - ");
                    startDate = pickerSdf.parse(parts[0].trim());
                    endDate = pickerSdf.parse(parts[1].trim());

                    // Đặt mốc kết thúc ở cuối ngày (23:59:59)
                    Calendar cal = Calendar.getInstance();
                    cal.setTime(endDate);
                    cal.set(Calendar.HOUR_OF_DAY, 23);
                    cal.set(Calendar.MINUTE, 59);
                    cal.set(Calendar.SECOND, 59);
                    endDate = cal.getTime();
                } catch (ParseException e) {
                    System.out.println("Lỗi ép kiểu chuỗi ngày Litepicker: " + e.getMessage());
                }
            }

            for (Commission c : list) {
                boolean match = true;

                // Lấy dữ liệu an toàn từ đối tượng, xóa bỏ khoảng trắng thừa từ DB (SỬA BUG 2)
                String dbBookingId = c.getBookingId() != null ? c.getBookingId().trim() : "";
                String dbStatus = c.getStatus() != null ? c.getStatus().trim().toLowerCase() : "";

                // 🌟 Lọc theo Mã Booking
                if (bookingId != null && !bookingId.trim().isEmpty()) {
                    if (!dbBookingId.equalsIgnoreCase(bookingId.trim())) {
                        match = false;
                    }
                }

                // 🌟 Lọc theo Checkbox Trạng thái (SỬA BUG 3: So khớp thông minh theo từ khóa)
                if (statuses != null && statuses.length > 0) {
                    boolean statusMatch = false;
                    for (String s : statuses) {
                        String filterStatus = s.trim().toLowerCase();

                        // Chấp nhận khớp hoàn toàn HOẶC khớp thông minh qua từ khóa "chờ" / "đã"
                        if (dbStatus.equals(filterStatus)
                                || (filterStatus.contains("chờ") && dbStatus.contains("chờ"))
                                || (filterStatus.contains("đã") && dbStatus.contains("đã"))) {
                            statusMatch = true;
                            break;
                        }
                    }
                    if (!statusMatch) match = false;
                } else {
                    // Nếu bấm nút lọc mà không chọn checkbox nào -> ẩn hết dữ liệu
                    match = false;
                }

                // 🌟 Lọc theo Khoảng ngày đặt phòng
                if (startDate != null && endDate != null) {
                    Date itemDate = c.getBookingDate();
                    if (itemDate != null) {
                        if (itemDate.before(startDate) || itemDate.after(endDate)) {
                            match = false;
                        }
                    }
                }

                if (match) {
                    filteredList.add(c);
                }
            }
        } else {
            // Lần đầu tiên load trang, hiển thị toàn bộ danh sách gốc từ DB
            filteredList = list;
        }

        // 4. Tái tính toán các con số tổng hợp dựa trên danh sách kết quả sau lọc
        double totalReceived = 0;
        double totalPending = 0;
        double totalRate = 0;

        for (Commission c : filteredList) {
            String dbStatus = c.getStatus() != null ? c.getStatus().trim() : "";
            // Đồng bộ kiểm tra trạng thái linh hoạt cho Dashboard
            if (dbStatus.equalsIgnoreCase("Đã thanh toán") || dbStatus.toLowerCase().contains("đã")) {
                totalReceived += c.getCommissionAmount();
            } else {
                totalPending += c.getCommissionAmount();
            }
            totalRate += c.getCommissionRate();
        }

        String avgRateStr = "0%";
        if (!filteredList.isEmpty()) {
            double avgRate = totalRate / filteredList.size();
            avgRateStr = String.format("%.0f%%", avgRate);
        }

        // 5. Đẩy ngược dữ liệu sạch về request attribute
        request.setAttribute("commissionList", filteredList);
        request.setAttribute("totalReceived", totalReceived);
        request.setAttribute("totalPending", totalPending);
        request.setAttribute("avgRate", avgRateStr);

        // Chuyển tiếp luồng hiển thị sang file JSP
        request.getRequestDispatcher("/WEB-INF/commission.jsp").forward(request, response);
    }
}