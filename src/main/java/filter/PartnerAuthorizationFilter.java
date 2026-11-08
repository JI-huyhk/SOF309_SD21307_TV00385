package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(urlPatterns = {"/quan-ly-phong", "/PartnerRoomController"})
public class PartnerAuthorizationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String role = (session != null) ? (String) session.getAttribute("userRole") : null;

        // Chỉ cho phép "partner" hoặc "hotel partner" đi qua
        if (role == null || (!"hotel-manager".equals(role))) {
            if (session != null) {
                session.setAttribute("errorMessage", "Khu vực này chỉ dành cho Đối tác khách sạn!");
            }
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/home.jsp");
            return;
        }

        chain.doFilter(request, response);
    }
}