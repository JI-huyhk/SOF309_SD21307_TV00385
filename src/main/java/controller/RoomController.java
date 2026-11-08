package controller;

import dao.RoomDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Room;

import java.io.IOException;
import java.util.List;

@WebServlet("/room-controller")
public class RoomController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        RoomDAO roomDAO = new RoomDAO();

        // Gọi hàm DAO lấy danh sách phòng từ Database
        List<Room> list = roomDAO.getRoomsByPartner(0);

        // Đẩy danh sách phòng sang JSP qua Request Attribute
        request.setAttribute("roomList", list);

        // Chuyển tiếp (Forward) ngầm đến file giao diện.
        request.getRequestDispatcher("room_management.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Đảm bảo không bị lỗi font chữ tiếng Việt khi truyền nhận dữ liệu
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        // 🌟 BẮT SỰ KIỆN: Xử lý lệnh cập nhật tình trạng vệ sinh từ AJAX gửi lên
        if ("updateCondition".equals(action)) {
            try {
                // Lấy các tham số từ thuộc tính "data" của AJAX
                int roomId = Integer.parseInt(request.getParameter("roomId"));
                String condition = request.getParameter("condition"); // Giá trị: clean, dirty, damage, underrepair

                RoomDAO roomDAO = new RoomDAO();

                // Chạy lệnh update xuống SQL Server thông qua hàm trong RoomDAO
                boolean isUpdated = roomDAO.updateRoomCondition(roomId, condition);

                if (isUpdated) {
                    // Trả về kết quả chuỗi plain text "success" cho bên JSP nhận diện ổn thỏa
                    response.setContentType("text/plain");
                    response.getWriter().write("success");
                } else {
                    // Trả về lỗi hệ thống nếu database không thực thi thành công
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Cập nhật vào Database thất bại!");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
            }
            return; // 🌟 NGẮT LUỒNG TẠI ĐÂY: Chặn đứng không cho lệnh lọt xuống hàm doGet ở phía dưới
        }

        // Nếu là các request POST bình thường khác (nếu có sau này) thì xử lý như GET
        doGet(request, response);
    }
}