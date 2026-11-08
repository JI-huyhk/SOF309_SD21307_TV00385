package com.poly.sof309.ui.tests;

import com.poly.sof309.ui.pages.LoginPage;
import org.junit.jupiter.api.*;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;

/**
 * =========================================================================
 * [Y4] KỊCH BẢN KIỂM THỬ TỰ ĐỘNG GIAO DIỆN (SELENIUM WEBDRIVER)
 * Ánh xạ theo các ca kiểm thử đăng nhập trong docs/TEST_CASES.md
 * =========================================================================
 */
public class LoginTest {
    private WebDriver driver;
    private LoginPage loginPage;

    // Điều chỉnh port hoặc context path nếu chạy qua Tomcat (ví dụ: http://localhost:8080/ hoặc http://localhost:8080/login)
    private final String BASE_URL = "http://localhost:8080/login";

    @BeforeEach
    public void setUp() {
        ChromeOptions options = new ChromeOptions();

        // Tự động kích hoạt chế độ Headless khi chạy trên GitHub Actions (CI/CD)
        if (Boolean.parseBoolean(System.getenv("CI"))) {
            options.addArguments("--headless=new");
            options.addArguments("--no-sandbox");
            options.addArguments("--disable-dev-shm-usage");
        }

        driver = new ChromeDriver(options);
        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(5));
        driver.manage().window().maximize();
        loginPage = new LoginPage(driver);
    }

    @AfterEach
    public void tearDown() {
        if (driver != null) {
            driver.quit();
        }
    }

    @Test
    @DisplayName("TC01_AUTH_01: UI - Khách hàng đăng nhập thành công chuyển về trang chủ")
    @Disabled("Bỏ @Disabled khi server Tomcat local đang chạy để bật trình duyệt kiểm thử thực tế")
    public void testLoginSuccessCustomerUI() {
        driver.get(BASE_URL);

        // Đăng nhập bằng số điện thoại khách hàng hợp lệ
        loginPage.login("090333444", "123456");

        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(5));
        wait.until(ExpectedConditions.or(
                ExpectedConditions.urlContains("home"),
                ExpectedConditions.urlContains("index")
        ));

        String currentUrl = driver.getCurrentUrl();
        Assertions.assertTrue(currentUrl.contains("home") || currentUrl.contains("index"),
                "Khách hàng đăng nhập thành công phải được điều hướng về trang chủ");
    }

    @Test
    @DisplayName("TC01_AUTH_04: UI - Đăng nhập thất bại khi để trống thông tin")
    @Disabled("Bỏ @Disabled khi server Tomcat local đang chạy để bật trình duyệt kiểm thử thực tế")
    public void testLoginEmptyCredentialsUI() {
        driver.get(BASE_URL);

        // Bỏ trống cả số điện thoại và mật khẩu
        loginPage.login("", "");

        String currentUrl = driver.getCurrentUrl();
        // Hệ thống không được chuyển trang khi thông tin rỗng
        Assertions.assertTrue(currentUrl.contains("login") || currentUrl.endsWith("/"),
                "Để trống dữ liệu hệ thống phải giữ nguyên trang đăng nhập");
    }

    @Test
    @DisplayName("TC01_AUTH_05: UI - Báo lỗi khi nhập sai mật khẩu")
    @Disabled("Bỏ @Disabled khi server Tomcat local đang chạy để bật trình duyệt kiểm thử thực tế")
    public void testLoginWrongPasswordUI() {
        driver.get(BASE_URL);

        // Nhập đúng số điện thoại nhưng sai mật khẩu
        loginPage.login("090333444", "sai_mat_khau_123");

        String currentUrl = driver.getCurrentUrl();
        Assertions.assertFalse(currentUrl.contains("dashboard") && !currentUrl.contains("home"),
                "Không được cấp phép vào dashboard/home khi sai mật khẩu");
    }
}