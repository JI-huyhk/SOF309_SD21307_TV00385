package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "deleteController", value = "/delete")
public class DeleteController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 1. Lấy ID của user cần xóa từ URL (?id=...)
        int id = Integer.parseInt(req.getParameter("id"));

        UserDAO dao = new UserDAO();
        HttpSession session = req.getSession();

        // [BẮT ĐẦU ĐOẠN KHÓA AN TOÀN]
        // 2. Kiểm tra xem tài khoản sắp bị xóa có phải là Admin không
        // ✔️ ĐÃ SỬA: Giữ nguyên hàm getRoleById(id) vì trong DAO của bạn đã có sẵn hàm này
        String role = dao.getRoleById(id);

        if (role != null && "Admin".equalsIgnoreCase(role.trim())) {
            // ✔️ ĐÃ SỬA CHUẨN: Đổi từ countAdmins() thành countActiveAdmins() để khớp 100% với hàm trong UserDAO của bạn
            int totalAdmins = dao.countActiveAdmins();

            // Nếu chỉ còn đúng 1 Admin duy nhất, không cho xóa
            if (totalAdmins <= 1) {
                // Lưu thông báo lỗi vào session để hiển thị ở trang danh sách
                session.setAttribute("errorMessage", "Không thể xóa! Đây là tài khoản Admin cuối cùng của hệ thống.");

                // Chuyển hướng ngược lại trang quản lý luôn, không chạy xuống hàm dao.delete(id) nữa
                resp.sendRedirect(req.getContextPath() + "/quan-ly-tai-khoan");
                return; // Kết thúc hàm tại đây
            }
        }
        // [KẾT THÚC ĐOẠN KHÓA AN TOÀN]

        // 3. Nếu vượt qua điều kiện trên (hoặc là xóa các role khác), tiến hành xóa mềm bằng JPA
        dao.delete(id);

        // Lưu thông báo thành công
        session.setAttribute("successMessage", "Xóa thành viên thành công!");

        // 4. Chuyển hướng về trang danh sách quản lý tài khoản
        resp.sendRedirect(req.getContextPath() + "/quan-ly-tai-khoan");
    }
}