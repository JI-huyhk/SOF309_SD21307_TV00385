package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/FakeBankController")
public class FakeBankController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String roomId = request.getParameter("roomId");
        String amount = request.getParameter("amount");

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<meta charset='UTF-8'>");
        out.println("<meta name='viewport' content='width=device-width, initial-scale=1.0'>");
        out.println("<title>Smart Banking Demo</title>");
        out.println("<style>");
        out.println("  body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; text-align: center; padding: 20px; background: #f4f6f9; margin: 0; }");
        out.println("  .card { background: #fff; padding: 30px 20px; border-radius: 16px; box-shadow: 0 4px 15px rgba(0,0,0,0.08); max-width: 400px; margin: 40px auto; }");
        out.println("  h2 { color: #0288d1; margin-bottom: 5px; font-size: 22px; }");
        out.println("  p { color: #555; font-size: 14px; margin-bottom: 25px; }");
        out.println("  .amount-box { background: #fff8e1; border: 1px dashed #ffe082; padding: 15px; border-radius: 8px; margin-bottom: 30px; }");
        out.println("  .amount-title { font-size: 13px; color: #ff8f00; font-weight: bold; margin: 0; }");
        out.println("  .amount-value { color: #e65100; font-size: 24px; font-weight: 900; margin: 5px 0 0 0; }");
        out.println("  .btn { background: #0288d1; color: #fff; padding: 16px; border: none; border-radius: 12px; font-size: 16px; font-weight: bold; cursor: pointer; width: 100%; box-shadow: 0 4px 10px rgba(2,136,209,0.3); transition: 0.2s; }");
        out.println("  .btn:active { background: #01579b; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");

        out.println("<div class='card'>");
        out.println("  <h2>SMART BANKING DEMO</h2>");
        out.println("  <p>Thanh toán đơn đặt phòng tại <b>Verdelle Hotel</b></p>");

        out.println("  <div class='amount-box'>");
        out.println("    <p class='amount-title'>SỐ TIỀN CẦN CHUYỂN KHOẢN</p>");
        out.println("    <p class='amount-value'>" + (amount != null ? amount : "0") + " đ</p>");
        out.println("  </div>");

        out.println("  <form method='POST' action='" + request.getContextPath() + "/FakeBankController'>");
        out.println("    <input type='hidden' name='roomId' value='" + (roomId != null ? roomId : "") + "'>");
        out.println("    <button type='submit' class='btn'>XÁC NHẬN CHUYỂN TIỀN</button>");
        out.println("  </form>");
        out.println("</div>");

        out.println("</body>");
        out.println("</html>");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String roomId = request.getParameter("roomId");

        if (roomId != null && !roomId.trim().isEmpty()) {
            getServletContext().setAttribute("payment_status_" + roomId, true);
        }

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<meta charset='UTF-8'>");
        out.println("<meta name='viewport' content='width=device-width, initial-scale=1.0'>");
        out.println("<style>");
        out.println("  body { text-align: center; padding-top: 80px; font-family: sans-serif; background: #f4f6f9; }");
        out.println("  .success-box { background: #fff; max-width: 400px; margin: 0 auto; padding: 40px 20px; border-radius: 16px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }");
        out.println("  .icon { font-size: 50px; color: #4caf50; margin-bottom: 10px; }");
        out.println("  h1 { font-size: 20px; color: #333; margin: 0 0 10px 0; }");
        out.println("  p { color: #777; font-size: 14px; margin: 0; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        out.println("  <div class='success-box'>");
        out.println("    <div class='icon'>✔</div>");
        out.println("    <h1>CHUYỂN TIỀN THÀNH CÔNG!</h1>");
        out.println("    <p>Hệ thống máy tính đang xử lý dữ liệu...</p>");
        out.println("  </div>");
        out.println("</body>");
        out.println("</html>");
    }
}