package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/BookingController")
public class BookingController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        // 1. Lấy tham số từ URL truyền sang
        String roomId = request.getParameter("roomId");
        String roomNameParam = request.getParameter("roomName");
        String priceParam = request.getParameter("price");
        String dateRange = request.getParameter("dateRange");
        String guestsRooms = request.getParameter("guestsRooms");
        String requiredRoomsStr = request.getParameter("requiredRooms");
        String hotelName = request.getParameter("hotelName");
        String hotelStars = request.getParameter("hotelStars");
        String hotelAddress = request.getParameter("hotelAddress");

        // THUẬT TOÁN TÍNH SỐ ĐÊM TỪ CHUỖI DATERANGE CỦA HOME.JSP
        int totalNights = 1;
        if (dateRange != null && !dateRange.isEmpty()) {
            try {
                if (dateRange.contains("ngày)")) {
                    // Cắt nội dung nằm giữa dấu "(" và chữ " ngày)" để lấy đúng số đêm
                    String daysStr = dateRange.substring(dateRange.indexOf("(") + 1, dateRange.indexOf(" ngày)"));
                    totalNights = Integer.parseInt(daysStr.trim());
                }
                // Xử lý chuỗi " to " từ Flatpickr gửi sang
                else if (dateRange.contains(" to ")) {
                    String[] dates = dateRange.split(" to ");
                    java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("d/M/yyyy");
                    java.time.LocalDate d1 = java.time.LocalDate.parse(dates[0].trim(), formatter);
                    java.time.LocalDate d2 = java.time.LocalDate.parse(dates[1].trim(), formatter);
                    totalNights = (int) java.time.temporal.ChronoUnit.DAYS.between(d1, d2);
                }
                else if (dateRange.contains("-")) {
                    // Backup: Tính thủ công nếu chuỗi gốc chỉ có định dạng "DD/MM/YYYY - DD/MM/YYYY"
                    String[] dates = dateRange.split("-");
                    java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy");
                    java.time.LocalDate d1 = java.time.LocalDate.parse(dates[0].trim(), formatter);
                    java.time.LocalDate d2 = java.time.LocalDate.parse(dates[1].trim().split(" ")[0], formatter);
                    totalNights = (int) java.time.temporal.ChronoUnit.DAYS.between(d1, d2);
                }
            } catch (Exception e) {
                System.out.println("Lỗi tính số đêm tại BookingController: " + e.getMessage());
                totalNights = 1;
            }
        }
        if (totalNights <= 0) totalNights = 1;

        // ÉP KIỂU SỐ PHÒNG
        int requiredRooms = 1;

        // Ưu tiên lấy từ requiredRoomsStr trước
        if (requiredRoomsStr != null && !requiredRoomsStr.isEmpty()) {
            try {
                requiredRooms = Integer.parseInt(requiredRoomsStr.trim());
            } catch (Exception e) {
                System.out.println("Lỗi ép kiểu requiredRoomsStr: " + e.getMessage());
            }
        }

        // Cứu cánh: Lấy từ guestsRooms bằng Regex nếu requiredRooms vẫn là 1
        if (requiredRooms == 1 && guestsRooms != null && !guestsRooms.isEmpty()) {
            try {
                String lowerGuests = guestsRooms.toLowerCase();
                java.util.regex.Matcher m = java.util.regex.Pattern.compile("(\\d+)\\s*phòng").matcher(lowerGuests);
                if (m.find()) {
                    requiredRooms = Integer.parseInt(m.group(1));
                }
            } catch (Exception e) {
                System.out.println("Lỗi parse số phòng từ guestsRooms: " + e.getMessage());
            }
        }

        // TÍNH TOÁN GIÁ TIỀN CHUẨN XÁC: (GIÁ GỐC 1 PHÒNG) * SỐ PHÒNG * SỐ ĐÊM
        long pricePerNight = 1000000; // Giá mặc định phòng hờ

        try {
            if (priceParam != null && !priceParam.isEmpty()) {
                String safePrice = priceParam;
                if (safePrice.contains(".")) {
                    safePrice = safePrice.substring(0, safePrice.indexOf("."));
                }
                pricePerNight = Long.parseLong(safePrice.replaceAll("[^0-9]", ""));
            }
        } catch (Exception e) {
            pricePerNight = 1000000;
        }

        // Tính tổng chi phí chốt đơn
        long finalTotalPrice = pricePerNight * requiredRooms * totalNights;

        // 2. Cập nhật dữ liệu vào Map để đẩy sang JSP
        Map<String, String> roomInfo = new HashMap<>();
        roomInfo.put("roomId", roomId != null ? roomId : "0");
        roomInfo.put("roomName", (roomNameParam != null && !roomNameParam.isEmpty()) ? roomNameParam : "Phòng Tiêu Chuẩn");
        roomInfo.put("basePrice", String.valueOf(pricePerNight));
        roomInfo.put("price", String.valueOf(finalTotalPrice));
        roomInfo.put("hotelName", hotelName != null ? hotelName : "Verdelle Hotel");
        roomInfo.put("hotelStars", hotelStars != null ? hotelStars : "5");
        roomInfo.put("hotelAddress", hotelAddress != null ? hotelAddress : "Việt Nam");
        roomInfo.put("area", "35");
        roomInfo.put("bed", "Giường tiêu chuẩn theo hạng phòng");
        roomInfo.put("image", "https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800");

        // Đẩy thêm các thuộc tính lên Request Scope
        request.setAttribute("selectedRoom", roomInfo);
        request.setAttribute("totalNights", totalNights);
        request.setAttribute("requiredRooms", requiredRooms);
        request.setAttribute("dateRange", dateRange);
        request.setAttribute("guestsRooms", guestsRooms);

        // 3. XỬ LÝ THÔNG TIN KHÁCH HÀNG & RANK ĐỂ LẤY VOUCHER
        HttpSession session = request.getSession();
        int userId = -1;

        // Cố gắng lấy ID người dùng từ session (đề phòng dùng tên biến khác nhau)
        if (session.getAttribute("userId") != null) {
            try { userId = Integer.parseInt(session.getAttribute("userId").toString()); }
            catch (Exception e) { e.printStackTrace(); }
        } else if (session.getAttribute("customerId") != null) {
            try { userId = Integer.parseInt(session.getAttribute("customerId").toString()); }
            catch (Exception e) { e.printStackTrace(); }
        }

        String userRank = "Member"; // Mặc định nếu chưa đăng nhập

        if (userId != -1) {
            try {
                dao.UserDAO userDAO = new dao.UserDAO();
                Map<String, Object> points = userDAO.getUserPoints(userId);

                if (points != null) {
                    // Fix lỗi hoa/thường của SQL Map Keys
                    Object uyTin = points.get("uyTin") != null ? points.get("uyTin") : points.get("UyTin");
                    Object loyalPoint = points.get("loyalPoint") != null ? points.get("loyalPoint") : points.get("LoyalPoint");
                    Object rank = points.get("rank") != null ? points.get("rank") : points.get("Rank");

                    request.setAttribute("uyTin", uyTin);
                    request.setAttribute("loyalPoint", loyalPoint);

                    if (rank != null) {
                        userRank = rank.toString();
                    }

                    request.setAttribute("rank", userRank);
                    session.setAttribute("membershipRank", userRank); // Lưu rank vào session
                }
            } catch (Exception e) {
                System.out.println("Lỗi lấy điểm thành viên: " + e.getMessage());
            }
        }

        // 4. GỌI VOUCHER DAO ĐỂ LẤY DANH SÁCH MÃ GIẢM GIÁ THEO HẠNG
        dao.VoucherDAO voucherDAO = new dao.VoucherDAO();
        java.util.List<model.Voucher> availableVouchers = voucherDAO.getEligibleVouchers(userRank);

        // Đẩy List này sang booking.jsp để vòng lặp <c:forEach> hoạt động
        request.setAttribute("availableVouchers", availableVouchers);

        // 5. Chuyển hướng
        request.getRequestDispatcher("booking.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}