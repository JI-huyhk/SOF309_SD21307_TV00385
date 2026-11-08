package controller;

import dao.RoomDAO;
import model.Room;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "PartnerRoomController", value = "/quan-ly-phong")
public class PartnerRoomController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer ownerId = (Integer) session.getAttribute("userId");

        if (ownerId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        RoomDAO roomDAO = new RoomDAO();

        // 1. XỬ LÝ CHỨC NĂNG BẬT/TẮT TRẠNG THÁI NHANH
        if ("toggleStatus".equals(action)) {
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            String currentStatus = request.getParameter("currentStatus");
            String newStatus = "Available".equalsIgnoreCase(currentStatus) ? "Unavailable" : "Available";

            roomDAO.toggleRoomStatus(roomId, newStatus, ownerId);
            response.sendRedirect("quan-ly-phong");
            return;
        }

        // 2. XỬ LÝ MỞ FORM CẬP NHẬT PHÒNG
        if ("editForm".equals(action)) {
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            Room existingRoom = roomDAO.getRoomById(roomId);
            request.setAttribute("room", existingRoom);
            request.getRequestDispatcher("/edit-room.jsp").forward(request, response);
            return;
        }

        // 3. XỬ LÝ MỞ FORM THÊM PHÒNG MỚI
        if ("addForm".equals(action)) {
            request.getRequestDispatcher("/create-room.jsp").forward(request, response);
            return;
        }

        // 4. XỬ LÝ XÓA PHÒNG (XÓA MỀM)
        if ("delete".equals(action)) {
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            boolean isDeleted = roomDAO.deleteRoom(roomId); // Gọi hàm xóa từ DAO xuống DB

            if (isDeleted) {
                response.sendRedirect("quan-ly-phong?msg=deleteSuccess");
            } else {
                response.sendRedirect("quan-ly-phong?msg=deleteFailed");
            }
            return;
        }

        // 5. MẶC ĐỊNH: Tải danh sách phòng lên trang quản lý
        List<Room> partnerRooms = roomDAO.getRoomsByPartner(ownerId);
        request.setAttribute("rooms", partnerRooms);
        request.getRequestDispatcher("/partner-rooms.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer ownerId = (Integer) session.getAttribute("userId");

        if (ownerId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        RoomDAO roomDAO = new RoomDAO();

        // CHỨC NĂNG 1: LƯU DỮ LIỆU KHI BẤM NÚT "LƯU THAY ĐỔI" TRÊN FORM EDIT
        if ("update".equals(action)) {
            String roomIdRaw = request.getParameter("roomId");

            if (roomIdRaw == null || roomIdRaw.trim().isEmpty()) {
                response.sendRedirect("quan-ly-phong?error=missingId");
                return;
            }

            int roomId = Integer.parseInt(roomIdRaw.trim());
            String roomTypeName = request.getParameter("roomTypeName");
            double price = Double.parseDouble(request.getParameter("price"));
            int area = Integer.parseInt(request.getParameter("area"));
            int maxPeople = Integer.parseInt(request.getParameter("maxPeople"));
            String status = request.getParameter("status");

            Room room = new Room();
            room.setRoomId(roomId);
            room.setRoomTypeName(roomTypeName);
            room.setPrice(price);
            room.setArea(area);
            room.setMaxPeople(maxPeople);
            room.setStatus(status);

            roomDAO.updateRoom(room);
            response.sendRedirect("quan-ly-phong");
            return;
        }

        // CHỨC NĂNG 2: LƯU DỮ LIỆU KHI BẤM NÚT "TẠO CẤU HÌNH" TRÊN FORM THÊM MỚI
        if ("create".equals(action)) {
            // ĐÃ BỔ SUNG: Lấy thêm RoomNumber từ form create-room.jsp gửi lên
            String roomNumber = request.getParameter("roomNumber");
            String roomTypeName = request.getParameter("roomTypeName");
            double price = Double.parseDouble(request.getParameter("price"));
            int area = Integer.parseInt(request.getParameter("area"));
            int maxPeople = Integer.parseInt(request.getParameter("maxPeople"));
            String status = request.getParameter("status");

            // Lấy tạm HotelID từ form truyền lên, nếu trống thì để mặc định là 1
            String hotelIdRaw = request.getParameter("hotelId");
            int hotelId = (hotelIdRaw != null && !hotelIdRaw.trim().isEmpty()) ? Integer.parseInt(hotelIdRaw.trim()) : 1;

            Room room = new Room();
            // ĐÃ BỔ SUNG: Gán số phòng vào đối tượng trước khi lưu xuống DB nhằm tránh lỗi NULL
            room.setRoomNumber(roomNumber);
            room.setHotelId(hotelId);
            room.setRoomTypeName(roomTypeName);
            room.setPrice(price);
            room.setArea(area);
            room.setMaxPeople(maxPeople);
            room.setStatus(status);

            roomDAO.addRoom(room); // Gọi hàm lưu vào DB
            response.sendRedirect("quan-ly-phong"); // Tạo xong quay về danh sách phòng
        }
    }
}