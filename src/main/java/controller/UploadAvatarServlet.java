package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;

@WebServlet("/profile/upload-avatar")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 10, // 10MB - Tăng bộ nhớ đệm
        maxFileSize = 1024 * 1024 * 50,      // 50MB - Chấp nhận file ảnh siêu nặng
        maxRequestSize = 1024 * 1024 * 100   // 100MB - Giới hạn toàn bộ request
)
public class UploadAvatarServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Part filePart = request.getPart("avatarFile");
            String fileName = filePart.getSubmittedFileName();

            if (fileName != null && !fileName.isEmpty()) {
                // SỬA LỖI: Chuyển đuôi file về chữ thường để tránh lỗi hệ thống (.JPG -> .jpg)
                String extension = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();

                // Kiểm tra định dạng file cơ bản để tránh upload file lỗi
                if (extension.equals(".jpg") || extension.equals(".jpeg") || extension.equals(".png") || extension.equals(".webp") || extension.equals(".gif")) {

                    String newFileName = "avatar_" + System.currentTimeMillis() + extension;

                    String buildPath = getServletContext().getRealPath("");
                    File projectDir = new File(buildPath).getParentFile().getParentFile();

                    String targetUploadPath = projectDir.getAbsolutePath() + File.separator + "src"
                            + File.separator + "main" + File.separator + "webapp"
                            + File.separator + "imgs";
                    String tempUploadPath = buildPath + File.separator + "imgs";

                    new File(targetUploadPath).mkdirs();
                    new File(tempUploadPath).mkdirs();

                    filePart.write(targetUploadPath + File.separator + newFileName);
                    filePart.write(tempUploadPath + File.separator + newFileName);

                    HttpSession session = request.getSession();
                    session.setAttribute("avatarUrl", "imgs/" + newFileName);
                }
            }
        } catch (Exception e) {
            e.printStackTrace(); // In lỗi ra Console của IntelliJ để bạn dễ theo dõi nếu có sự cố
        }
        response.sendRedirect(request.getContextPath() + "/profile");
    }
}