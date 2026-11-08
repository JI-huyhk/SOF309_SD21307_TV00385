package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/PaymentController")
public class PaymentController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Cấu hình giải mã UTF-8 để nhận dữ liệu chuỗi Tiếng Việt không bị lỗi font
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();

        // 2. Hứng các dữ liệu thông tin cá nhân và cấu hình phòng từ form ẩn trang booking đẩy sang
        String roomId = request.getParameter("roomId");
        String dateRange = request.getParameter("dateRange");
        String customerName = request.getParameter("customerName");
        String customerEmail = request.getParameter("customerEmail");
        String customerPhone = request.getParameter("customerPhone");
        // Ưu tiên 1: Lấy trực tiếp từ Session người dùng đang đăng nhập (Hỗ trợ cả String lẫn Integer)
        Integer customerId = null;
        Object sessionUserId = session.getAttribute("userId");
        if (sessionUserId == null) {
            sessionUserId = session.getAttribute("customerId"); // Backup tìm cả tên customerId trong Session
        }

        if (sessionUserId != null) {
            try {
                customerId = Integer.parseInt(sessionUserId.toString().trim());
            } catch (NumberFormatException e) {
                System.out.println("Lỗi parse customerId từ session: " + e.getMessage());
            }
        }

        // Ưu tiên 2 (Backup): Nếu Session không có (chưa đăng nhập), mới thử lấy từ Form gửi sang
        if (customerId == null) {
            String customerIdParam = request.getParameter("customerId");
            if (customerIdParam != null && !customerIdParam.trim().isEmpty() && !customerIdParam.equals("null")) {
                try {
                    customerId = Integer.parseInt(customerIdParam.trim());
                } catch (NumberFormatException e) {
                    System.out.println("Lỗi parse customerId từ Form: " + e.getMessage());
                }
            }
        }

// Nếu vẫn null thì yêu cầu người dùng đăng nhập lại
        if (customerId == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=notLoggedIn");
            return;
        }

        // CÁC TRƯỜNG DỮ LIỆU MỚI ĐƯỢC BỔ SUNG TỪ GIAO DIỆN
        String customerCCCD = request.getParameter("customerCCCD");
        String isBookingForOther = request.getParameter("isBookingForOther");
        String customerNote = request.getParameter("customerNote");
        String specialReqs = request.getParameter("specialReqs");

        // 3. Logic xử lý tính toán giá tiền & Giả lập thông tin hạng phòng
        String hotelName = request.getParameter("hotelName");
        String roomName = request.getParameter("roomName");
        String voucherCode = request.getParameter("voucherCode");


        long basePrice = 1;
        int totalNights = 1;
        int requiredRooms = 1;

        try {
            if (request.getParameter("basePrice") != null) basePrice = Long.parseLong(request.getParameter("basePrice"));
            if (request.getParameter("totalNights") != null) totalNights = Integer.parseInt(request.getParameter("totalNights"));
            if (request.getParameter("requiredRooms") != null) requiredRooms = Integer.parseInt(request.getParameter("requiredRooms"));
        } catch (Exception e) {
            System.out.println("Lỗi Parse Số: " + e.getMessage());
        }

        // Công thức chốt sổ
        long rawTotal = basePrice * requiredRooms * totalNights;
        long taxAndFees = (long) (rawTotal * 0.1);
        long priceWithVAT = rawTotal + taxAndFees;

        // LẤY GIÁ CUỐI CÙNG TỪ GIAO DIỆN ĐẨY SANG ĐỂ KHỚP VỚI MỌI LOẠI VOUCHER
        long finalPrice = priceWithVAT;
        String priceParam = request.getParameter("price");
        if (priceParam != null && !priceParam.trim().isEmpty()) {
            try {
                // Xử lý an toàn: Chống crash khi JS frontend đẩy sang số có dấu phẩy hoặc thập phân
                String cleanPrice = priceParam.replace(",", ""); // Xóa dấu phẩy
                if (cleanPrice.contains(".")) {
                    cleanPrice = cleanPrice.substring(0, cleanPrice.indexOf(".")); // Cắt bỏ phần thập phân, chỉ lấy phần nguyên
                }
                finalPrice = Long.parseLong(cleanPrice);
            } catch (NumberFormatException e) {
                System.out.println("Lỗi parse final price: " + e.getMessage() + " - Dữ liệu gốc từ Frontend: " + priceParam);
            }
        }

        // Tính ngược lại số tiền được giảm
        long discount = priceWithVAT - finalPrice;

        // 4. Đẩy toàn bộ thuộc tính dữ liệu đóng gói sang Request / Session Scope
        session.setAttribute("customerId", customerId);
        session.setAttribute("roomId", roomId);
        session.setAttribute("dateRange", dateRange != null ? dateRange : "01/06/2026 to 05/06/2026");
        session.setAttribute("customerName", customerName);
        session.setAttribute("customerEmail", customerEmail);
        session.setAttribute("customerPhone", customerPhone);

        // Hứng thêm số lượng khách từ booking.jsp
        String qtyAdults = request.getParameter("qtyAdults");
        String qtyChildren = request.getParameter("qtyChildren");
        session.setAttribute("qtyAdults", qtyAdults != null ? qtyAdults : "2");
        session.setAttribute("qtyChildren", qtyChildren != null ? qtyChildren : "0");

        // LƯU CÁC TRƯỜNG MỚI ĐỂ FINALIZE DÙNG LẠI
        session.setAttribute("customerCCCD", customerCCCD);
        session.setAttribute("isBookingForOther", isBookingForOther);
        session.setAttribute("customerNote", customerNote);
        session.setAttribute("specialReqs", specialReqs);

        session.setAttribute("hotelName", hotelName);
        session.setAttribute("roomName", roomName);
        session.setAttribute("totalNights", totalNights);
        session.setAttribute("requiredRooms", requiredRooms);
        session.setAttribute("voucherCode", voucherCode);

        session.setAttribute("basePrice", basePrice);
        session.setAttribute("rawTotal", rawTotal);
        session.setAttribute("priceWithVAT", priceWithVAT);
        session.setAttribute("discount", discount);
        session.setAttribute("taxAndFees", taxAndFees);
        session.setAttribute("finalPrice", finalPrice);

        // 5. Chuyển tiếp luồng giao diện xử lý sang payment.jsp (trang quét QR)
        request.getRequestDispatcher("payment.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
}