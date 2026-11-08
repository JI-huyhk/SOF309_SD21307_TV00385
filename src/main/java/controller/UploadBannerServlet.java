package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;

@WebServlet("/profile/upload-banner")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 10, // 10MB
        maxFileSize = 1024 * 1024 * 50,      // 50MB - Banner thường rất nặng nên cần mở rộng hẳn ra
        maxRequestSize = 1024 * 1024 * 100   // 100MB
)
public class UploadBannerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Part filePart = request.getPart("bannerFile");
            String fileName = filePart.getSubmittedFileName();

            if (fileName != null && !fileName.isEmpty()) {
                // SỬA LỖI: Đồng bộ chữ thường cho đuôi mở rộng
                String extension = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();

                if (extension.equals(".jpg") || extension.equals(".jpeg") || extension.equals(".png") || extension.equals(".webp") || extension.equals(".gif")) {

                    String newBannerName = "banner_" + System.currentTimeMillis() + extension;

                    String buildPath = getServletContext().getRealPath("");
                    File projectDir = new File(buildPath).getParentFile().getParentFile();

                    String targetPath = projectDir.getAbsolutePath() + File.separator + "src"
                            + File.separator + "main" + File.separator + "webapp"
                            + File.separator + "imgs";
                    String tempPath = buildPath + File.separator + "imgs";

                    new File(targetPath).mkdirs();
                    new File(tempPath).mkdirs();

                    filePart.write(targetPath + File.separator + newBannerName);
                    filePart.write(tempPath + File.separator + newBannerName);

                    HttpSession session = request.getSession();
                    session.setAttribute("bannerUrl", "imgs/" + newBannerName);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/profile");
    }
}