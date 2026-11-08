package controller;

import dao.BookingDAO;
import dao.ServiceDAO;
import dao.ServiceDAO.HotelService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/checkout-action")
public class CheckOutActionController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        // BƯỚC 1: Nếu bấm từ trang danh sách (action = "checkout"), mở trang kê khai phụ phí JSP
        if ("checkout".equals(action)) {
            request.getRequestDispatcher("/checkout_billing.jsp").forward(request, response);
            return;
        }

        // BƯỚC 2: Nếu bấm nút "Xác nhận phụ phí" từ trang kê khai (action = "checkout_final")
        if ("checkout_final".equals(action)) {
            try {
                int bookingId = Integer.parseInt(request.getParameter("bookingId"));
                String bookingCode = request.getParameter("bookingCode");
                int roomId = Integer.parseInt(request.getParameter("roomId"));

                ServiceDAO serviceDAO = new ServiceDAO();
                BookingDAO bookingDAO = new BookingDAO();

                double totalServiceSurcharge = 0.0;
                double totalDamageSurcharge = 0.0;

                // 2.1. LƯU VÀO BẢNG BookingServices (Minibar / Dịch vụ)
                String[] selectedServices = request.getParameterValues("selectedServices");
                if (selectedServices != null) {
                    List<HotelService> activeServices = serviceDAO.getAllActiveServices();
                    Map<Integer, Double> priceMap = new HashMap<>();
                    for (HotelService s : activeServices) {
                        priceMap.put(s.serviceId, s.price);
                    }

                    for (String serviceIdStr : selectedServices) {
                        int serviceId = Integer.parseInt(serviceIdStr);
                        String qtyStr = request.getParameter("qty_svc_" + serviceId);
                        int qty = (qtyStr != null && !qtyStr.trim().isEmpty()) ? Integer.parseInt(qtyStr) : 1;

                        double unitPrice = priceMap.getOrDefault(serviceId, 0.0);
                        double itemTotal = unitPrice * qty;

                        serviceDAO.insertBookingService(bookingId, serviceId, qty, itemTotal);
                        totalServiceSurcharge += itemTotal;
                    }
                }

                // 2.2. LƯU VÀO BẢNG BookingFurnitureDamage (Hư hỏng vật tư & kết cấu)
                String roomCondition = "Dirty"; // Viết hoa chữ D chuẩn DB (Clean, Dirty, Damaged)

                String[] selectedFurniture = request.getParameterValues("selectedFurniture");
                if (selectedFurniture != null) {
                    for (String furnIdStr : selectedFurniture) {
                        int furnitureId = Integer.parseInt(furnIdStr);
                        int qty = 1;
                        double penaltyAmount = 0.0;

                        if (furnitureId == 1) {
                            String qtyStr = request.getParameter("qty_furn_1");
                            qty = (qtyStr != null && !qtyStr.trim().isEmpty()) ? Integer.parseInt(qtyStr) : 1;
                            penaltyAmount = 2800000.0 * qty;
                            if (!roomCondition.equals("Underrepair")) roomCondition = "Damage";
                        } else if (furnitureId == 2) { // Mức 1 (Nhẹ)
                            penaltyAmount = 4000000.0;
                            if (!roomCondition.equals("Underrepair")) roomCondition = "Damage";
                        } else if (furnitureId == 3) { // Mức 2 (Vừa)
                            penaltyAmount = 7000000.0;
                            if (!roomCondition.equals("Underrepair")) roomCondition = "Damage";
                        } else if (furnitureId == 4) { // Mức 3 (Nặng)
                            penaltyAmount = 15000000.0;
                            roomCondition = "Underrepair";
                        }

                        if (penaltyAmount > 0) {
                            serviceDAO.insertFurnitureDamage(bookingId, furnitureId, qty, penaltyAmount);
                            totalDamageSurcharge += penaltyAmount;
                        }
                    }
                }

                // 2.3. TÍNH TỔNG PHỤ PHÍ VÀ HOÀN TẤT CHECK-OUT
                double totalSurcharge = totalServiceSurcharge + totalDamageSurcharge;

                boolean isSuccess = bookingDAO.processCheckOut(
                        bookingId,
                        bookingCode,
                        roomId,
                        totalSurcharge,
                        "Check-out hoàn tất kê khai phụ phí",
                        roomCondition
                );

                if (isSuccess) {
                    response.sendRedirect(request.getContextPath() + "/checkout-list?status=success");
                } else {
                    response.sendRedirect(request.getContextPath() + "/checkout-list?status=error");
                }

            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/checkout-list?status=error");
            }
        }
    }
}