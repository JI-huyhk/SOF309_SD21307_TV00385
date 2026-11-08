package controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

@WebServlet(name = "GoogleLoginController", value = "/GoogleLoginController")
public class GoogleLoginController extends HttpServlet {

    private final String CLIENT_ID = "919945983221-5dd3uvtnqlquvtuj9vrqrj6jcqemo6us.apps.googleusercontent.com";
    private final String CLIENT_SECRET = "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";
    private final String REDIRECT_URI = "http://localhost:8080/ASM2_JAV101_SD2001_war/GoogleLoginController";
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String code = request.getParameter("code");
        if (code == null || code.isEmpty()) {
            response.sendRedirect("index.jsp?error=googleAuthFailed");
            return;
        }

        try {
            // 1. Đổi "code" lấy Access Token từ Google sử dụng HttpClient thuần của Java
            HttpClient client = HttpClient.newHttpClient();
            String tokenUrl = "https://oauth2.googleapis.com/token";
            String params = String.format("code=%s&client_id=%s&client_secret=%s&redirect_uri=%s&grant_type=authorization_code",
                    code, CLIENT_ID, CLIENT_SECRET, REDIRECT_URI);

            HttpRequest tokenRequest = HttpRequest.newBuilder()
                    .uri(URI.create(tokenUrl))
                    .header("Content-Type", "application/x-www-form-urlencoded")
                    .POST(HttpRequest.BodyPublishers.ofString(params))
                    .build();

            HttpResponse<String> tokenResponse = client.send(tokenRequest, HttpResponse.BodyHandlers.ofString());
            JsonObject jsonToken = new Gson().fromJson(tokenResponse.body(), JsonObject.class);
            String accessToken = jsonToken.get("access_token").getAsString();

            // 2. Dùng Access Token lấy thông tin người dùng (Email, Name)
            String userInfoUrl = "https://www.googleapis.com/oauth2/v3/userinfo?access_token=" + accessToken;
            HttpRequest infoRequest = HttpRequest.newBuilder().uri(URI.create(userInfoUrl)).GET().build();
            HttpResponse<String> infoResponse = client.send(infoRequest, HttpResponse.BodyHandlers.ofString());

            JsonObject userInfo = new Gson().fromJson(infoResponse.body(), JsonObject.class);
            String email = userInfo.get("email").getAsString();
            String givenName = userInfo.has("given_name") ? userInfo.get("given_name").getAsString() : ""; // Tên
            String familyName = userInfo.has("family_name") ? userInfo.get("family_name").getAsString() : ""; // Họ

            // 3. Xử lý Logic đối chiếu với Database thông qua UserDAO
            UserDAO userDAO = new UserDAO();

            boolean isEmailExists = userDAO.checkEmailExists(email);

            HttpSession session = request.getSession();

            if (isEmailExists) {
                // TRƯỜNG HỢP 1: ĐÃ CÓ TÀI KHOẢN -> TỰ ĐỘNG ĐĂNG NHẬP LUÔN
                String phone = userDAO.getPhoneByEmail(email);
                String role = userDAO.getRoleByPhone(phone);

                session.setAttribute("userPhone", phone);
                session.setAttribute("firstName", givenName);
                session.setAttribute("userEmail", email);
                session.setAttribute("userRole", role != null ? role.trim().toLowerCase() : "user");

                response.sendRedirect("home.jsp");
            } else {
                // TRƯỜNG HỢP 2: CHƯA CÓ TÀI KHOẢN -> LƯU TẠM THÔNG TIN RỒI ĐÁ SANG TRANG BỔ SUNG SỐ ĐIỆN THOẠI
                session.setAttribute("ggEmail", email);
                session.setAttribute("ggFirstName", givenName);
                session.setAttribute("ggLastName", familyName);

                response.sendRedirect("google-phone.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp?error=googleSystemError");
        }
    }
}