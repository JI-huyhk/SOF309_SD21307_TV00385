package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(urlPatterns = {"/*"})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();

        // Chuyển về chữ thường để so sánh không lo sai hoa/thường
        String path = requestURI.substring(contextPath.length()).toLowerCase();

        // Bắt theo cả đường dẫn thư mục và đuôi file
        boolean isStaticResource = path.startsWith("/css/")
                || path.startsWith("/imgs/")
                || path.startsWith("/videos/")
                || path.startsWith("/js/")
                || path.startsWith("/assets/")
                || path.endsWith(".css")
                || path.endsWith(".js")
                || path.endsWith(".png")
                || path.endsWith(".jpg")
                || path.endsWith(".jpeg")
                || path.endsWith(".gif")
                || path.endsWith(".mp4")
                || path.endsWith(".svg")
                || path.endsWith(".ico");

        if (isStaticResource) {
            chain.doFilter(request, response);
            return; // Cho đi thẳng, không cần kiểm tra Login
        }

        // Danh sách trang và controller
        boolean isPublicPage = path.equals("/")
                || path.equals("/index.jsp")
                || path.equals("/home.jsp")
                || path.equals("/login.jsp")
                || path.equals("/signup.jsp")
                || path.equals("/forgotpassword.jsp")
                || path.equals("/about.jsp")
                || path.equals("/activity.jsp")
                || path.equals("/room_list.jsp")
                || path.equals("/gallery.jsp")
                || path.contains("logincontroller")
                || path.contains("forgotpasswordcontroller")
                || path.contains("googlelogincontroller")
                || path.contains("fakebankcontroller")
                || path.contains("paymentcontroller")
                || path.contains("reviewcontroller")
                || path.contains("sepaywebhook");

        // KIỂM TRA ĐĂNG NHẬP (Đồng bộ cả 'currentUser', 'user' và 'Guest')
        HttpSession session = httpRequest.getSession(false);
        boolean isLoggedIn = false;

        if (session != null) {
            Object userObj = session.getAttribute("currentUser");
            if (userObj == null) {
                userObj = session.getAttribute("user"); // Kiểm tra thêm thuộc tính 'user'
            }

            String status = (String) session.getAttribute("status");

            // Chỉ tính là đã đăng nhập nếu có đối tượng User VÀ trạng thái KHÔNG PHẢI là Guest
            isLoggedIn = (userObj != null) && !"Guest".equalsIgnoreCase(status);
        }

        // =========================================================================
        // 4. XỬ LÝ ĐIỀU HƯỚNG
        // =========================================================================
        if (isLoggedIn || isPublicPage) {
            // Hợp lệ -> Cho qua
            chain.doFilter(request, response);
        } else {
            // Cố tình vào trang riêng tư khi chưa đăng nhập / đang là Guest -> Đá về Login
            httpResponse.sendRedirect(contextPath + "/index.jsp");
        }
    }

    @Override
    public void destroy() {}
}