package controller;

import dao.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Random;

@WebServlet("/FinalizeBookingController")
public class FinalizeBookingController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Cấu hình UTF-8 nhận dữ liệu Tiếng Việt không bị lỗi font (Giữ của Mint)
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        // 2. Hứng phương thức thanh toán linh hoạt từ Form hoặc Session
        String paymentMethod = request.getParameter("paymentMethod");
        if (paymentMethod == null && session.getAttribute("paymentMethod") != null) {
            paymentMethod = session.getAttribute("paymentMethod").toString();
        }

        // Mặc định ban đầu nếu không truyền là Cash (Tiền mặt) để khớp với DB
        if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
            paymentMethod = "Cash";
        }

        // 🔍 DEBUG TRẠNG THÁI
        System.out.println("=================================================");
        System.out.println("👉 PHƯƠNG THỨC THANH TOÁN ĐANG NHẬN ĐƯỢC: [" + paymentMethod + "]");
        System.out.println("=================================================");

        // Mặc định ban đầu là Pending để đồng bộ chuẩn 4 trạng thái của Database
        String bookingStatus = "Pending";

        // BỘ LỌC AN TOÀN MỞ RỘNG: Quét sạch các từ khóa Tiếng Việt + Tiếng Anh của cả 2 bên
        String methodLower = paymentMethod.toLowerCase().trim();
        if (methodLower.contains("hotel") ||
                methodLower.contains("khach_san") ||
                methodLower.contains("khách sạn") ||
                methodLower.contains("cash") ||
                methodLower.contains("offline") ||
                methodLower.contains("direct")) {

            // Nếu là tiền mặt/trả sau cũng mặc định lưu là Pending để hệ thống xử lý chuẩn
            bookingStatus = "Pending";
        }

        // Lưu trạng thái chuẩn vào Session để gửi Mail sau này
        session.setAttribute("paymentStatus", bookingStatus);

        // 3. Hứng toàn bộ tham số của cả 2 phiên bản phục vụ lưu DB
        String roomIdStr = request.getParameter("roomId");
        String customerName = request.getParameter("customerName");
        String hotelName = request.getParameter("hotelName");
        String roomName = request.getParameter("roomName");
        String totalNightsStr = request.getParameter("totalNights");
        String finalPriceStr = request.getParameter("finalPrice");
        String dateRange = request.getParameter("dateRange");

        if (roomIdStr == null) roomIdStr = (String) session.getAttribute("roomId");
        if (customerName == null) customerName = (String) session.getAttribute("customerName");
        if (hotelName == null) hotelName = (String) session.getAttribute("hotelName");
        if (roomName == null) roomName = (String) session.getAttribute("roomName");
        if (totalNightsStr == null && session.getAttribute("totalNights") != null) {
            totalNightsStr = session.getAttribute("totalNights").toString();
        }
        if (finalPriceStr == null && session.getAttribute("finalPrice") != null) {
            finalPriceStr = session.getAttribute("finalPrice").toString();
        }
        if (dateRange == null) dateRange = (String) session.getAttribute("dateRange");

        int roomId = Integer.parseInt(roomIdStr != null ? roomIdStr : "1");
        int totalNights = Integer.parseInt(totalNightsStr != null ? totalNightsStr : "1");
        double finalPrice = Double.parseDouble(finalPriceStr != null ? finalPriceStr : "0");

        // Xử lý ghi chú khách hàng (Bản số 2)
        String customerNote = request.getParameter("customerNoteFinal");
        if (customerNote == null || customerNote.trim().isEmpty()) {
            customerNote = (String) session.getAttribute("customerNote");
        } else {
            session.setAttribute("customerNote", customerNote);
        }

        // 4. Xử lý linh hoạt chuỗi phân cách ngày " - " hoặc " to " từ phía Frontend
        LocalDate checkInDate = LocalDate.now();
        LocalDate checkOutDate = LocalDate.now().plusDays(1);
        try {
            if (dateRange != null) {
                String[] dates = null;
                if (dateRange.contains(" to ")) {
                    dates = dateRange.split(" to ");
                } else if (dateRange.contains(" - ")) {
                    dates = dateRange.split(" - ");
                }

                if (dates != null && dates.length == 2) {
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
                    checkInDate = LocalDate.parse(dates[0].trim(), formatter);
                    checkOutDate = LocalDate.parse(dates[1].trim(), formatter);
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi parse ngày tháng: " + e.getMessage());
        }

        // Mock UserID tạm thời
        // Lấy CustomerID chuẩn từ Session do PaymentController đẩy sang
        Integer customerId = null;
        if (session.getAttribute("customerId") != null) {
            customerId = (Integer) session.getAttribute("customerId");
        }

        // Sinh mã booking ngẫu nhiên
        Random rand = new Random();
        int codeSuffix = 1000 + rand.nextInt(9000);
        String bookingCode = "BK-2026-" + codeSuffix;

        // 5. THỰC HIỆN GỌI DAO LƯU DATABASE (ĐÃ NÂNG CẤP GỌI TRỰC TIẾP & BỔ SUNG VOUCHER)
        BookingDAO bookingDAO = new BookingDAO();
        boolean isSaved = false;

        try {
            // Lấy voucherCode từ request hoặc session (nếu có)
            String voucherCode = request.getParameter("voucherCode");
            if (voucherCode == null && session.getAttribute("voucherCode") != null) {
                voucherCode = session.getAttribute("voucherCode").toString();
            }

            // Gọi trực tiếp (Bỏ Reflection để tránh lỗi sai lệch tham số NoSuchMethodException)
            // Truyền đẩy đủ bookingStatus và voucherCode xuống DAO
            isSaved = bookingDAO.createBookingWithInvoice(
                    customerId,
                    roomId,
                    checkInDate,
                    checkOutDate,
                    finalPrice,
                    bookingCode,
                    paymentMethod,
                    customerNote,
                    voucherCode,
                    bookingStatus // Thêm trạng thái booking
            );
            System.out.println("👉 Đã gọi thành công createBookingWithInvoice trực tiếp!");

        } catch (Exception e) {
            System.out.println("❌ Lỗi thực thi gọi hàm DAO lưu Database: " + e.getMessage());
            e.printStackTrace();
        }
        // 6. PHẢN HỒI KẾT QUẢ VỀ GIAO DIỆN (Hỗ trợ hiển thị cho cả 2 bên)
        if (isSaved) {
            // Đẩy toàn bộ thuộc tính cần thiết lên Request để trang thành công hiển thị trơn tru
            request.setAttribute("bookingId", bookingCode);
            request.setAttribute("customerName", customerName);
            request.setAttribute("hotelName", hotelName);
            request.setAttribute("roomName", roomName);
            request.setAttribute("totalNights", totalNightsStr != null ? totalNightsStr : String.valueOf(totalNights));
            request.setAttribute("finalPrice", finalPriceStr != null ? finalPriceStr : finalPrice);
            request.setAttribute("requiredRooms", session.getAttribute("requiredRooms"));

            // Dọn dẹp trạng thái ảo trong Session & Application Scope từ cả hai phía
            session.removeAttribute("roomId");
            getServletContext().removeAttribute("payment_status_" + roomId);

            String successJSP = "booking_success.jsp";
            request.getRequestDispatcher(successJSP).forward(request, response);
        } else {
            // Thiết lập thông báo lỗi chi tiết lên session
            session.setAttribute("errorMessage", "Hệ thống gặp sự cố khi xử lý đặt phòng vào cơ sở dữ liệu. Vui lòng thử lại!");
            response.sendRedirect(request.getContextPath() + "/payment.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
}