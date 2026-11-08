package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/CheckPaymentStatusController")
public class CheckPaymentStatusController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String roomId = request.getParameter("roomId");
        Boolean isPaid = (Boolean) getServletContext().getAttribute("payment_status_" + roomId);

        if (isPaid == null) {
            isPaid = false;
        }

        // Đã xóa lệnh removeAttribute ở đây để giữ cờ trạng thái.
        // Cờ này sẽ được xóa an toàn bên trong FinalizeBookingController sau khi lưu DB thành công.

        response.getWriter().write("{\"isPaid\": " + isPaid + "}");
    }
}