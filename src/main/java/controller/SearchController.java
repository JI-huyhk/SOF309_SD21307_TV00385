package controller;

import dao.RoomDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Room;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet("/SearchController")
public class SearchController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        RoomDAO roomDAO = new RoomDAO();

        try {
            String dateRange = request.getParameter("dateRange");
            String minPriceStr = request.getParameter("minPrice");
            String maxPriceStr = request.getParameter("maxPrice");
            String qtyAdultsStr = request.getParameter("qtyAdults");
            String qtyChildrenStr = request.getParameter("qtyChildren");

            // Xử lý an toàn các số lượng (Bọc Try-Catch chống lỗi 500)
            int adults = 1;
            int children = 0;
            try {
                if (qtyAdultsStr != null && !qtyAdultsStr.trim().isEmpty()) adults = Integer.parseInt(qtyAdultsStr);
            } catch (NumberFormatException e) { System.err.println("Lỗi parse người lớn"); }

            try {
                if (qtyChildrenStr != null && !qtyChildrenStr.trim().isEmpty()) children = Integer.parseInt(qtyChildrenStr);
            } catch (NumberFormatException e) { System.err.println("Lỗi parse trẻ em"); }

            Double minPrice = null;
            Double maxPrice = null;

            if (minPriceStr != null && !minPriceStr.trim().isEmpty()) {
                minPrice = Double.parseDouble(minPriceStr.replaceAll("[^0-9]", ""));
            }
            if (maxPriceStr != null && !maxPriceStr.trim().isEmpty()) {
                maxPrice = Double.parseDouble(maxPriceStr.replaceAll("[^0-9]", ""));
            }

            // Xử lý ngày tháng an toàn
            LocalDate checkIn = null;
            LocalDate checkOut = null;
            if (dateRange != null && dateRange.contains(" to ")) {
                String[] dates = dateRange.split(" to ");
                if (dates.length == 2) {
                    String startStr = dates[0].trim();
                    String endStr = dates[1].trim();
                    if (startStr.contains("-")) {
                        checkIn = LocalDate.parse(startStr);
                        checkOut = LocalDate.parse(endStr);
                    } else if (startStr.contains("/")) {
                        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
                        checkIn = LocalDate.parse(startStr, formatter);
                        checkOut = LocalDate.parse(endStr, formatter);
                    }
                }
            } else {
                // FIX LỖI 2: Nếu URL không có ngày (hoặc bỏ trống), tự động lấy hôm nay và ngày mai
                // Lúc này DAO sẽ luôn check SQL Bookings, phòng 101 lập tức bị đá bay!
                checkIn = LocalDate.now();
                checkOut = LocalDate.now().plusDays(1);
                DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy");
                dateRange = checkIn.format(fmt) + " to " + checkOut.format(fmt);
            }

            // Gọi truy vấn CSDL
            List<Room> cleanAvailableRooms = roomDAO.searchRoomsAdvanced(checkIn, checkOut, adults, children, minPrice, maxPrice);

            request.setAttribute("rooms", cleanAvailableRooms);
            request.setAttribute("dateRange", dateRange);
            request.setAttribute("minPrice", minPriceStr);
            request.setAttribute("maxPrice", maxPriceStr);
            request.setAttribute("qtyAdults", adults);
            request.setAttribute("qtyChildren", children);

            request.getRequestDispatcher("/room_list.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<div style='color:#ff4d4d; font-family:sans-serif; padding:40px; text-align:center;'>");
            response.getWriter().println("<h2>⚠️ Lỗi Hệ Thống (SearchController)</h2>");
            response.getWriter().println("<p>Chi tiết: " + e.getMessage() + "</p></div>");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}