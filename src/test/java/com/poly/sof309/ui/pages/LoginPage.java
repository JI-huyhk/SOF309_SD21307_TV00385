package com.poly.sof309.ui.pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;

/**
 * =========================================================================
 * [Y4] PAGE OBJECT MODEL (POM) CHO TRANG ĐĂNG NHẬP VERDELLE HOTEL
 * =========================================================================
 */
public class LoginPage {
    private WebDriver driver;
    private WebDriverWait wait;

    // 1. Locators hỗ trợ cả tìm theo name lẫn id trong form đăng nhập
    private By txtPhone = By.xpath("//input[@name='phone' or @name='phoneNumber' or @id='phone' or @id='phoneNumber' or @type='tel' or @name='username']");
    private By txtPassword = By.xpath("//input[@name='password' or @id='password' or @type='password']");
    private By btnLogin = By.xpath("//button[@type='submit'] | //input[@type='submit']");
    private By lblErrorMessage = By.xpath("//*[contains(@class, 'alert') or contains(@class, 'error') or @id='error-message']");

    public LoginPage(WebDriver driver) {
        this.driver = driver;
        this.wait = new WebDriverWait(driver, Duration.ofSeconds(5));
    }

    // 2. Thao tác nghiệp vụ
    public void enterPhone(String phone) {
        WebElement element = wait.until(ExpectedConditions.visibilityOfElementLocated(txtPhone));
        element.clear();
        element.sendKeys(phone);
    }

    public void enterPassword(String password) {
        WebElement element = wait.until(ExpectedConditions.visibilityOfElementLocated(txtPassword));
        element.clear();
        element.sendKeys(password);
    }

    public void clickLogin() {
        WebElement element = wait.until(ExpectedConditions.elementToBeClickable(btnLogin));
        element.click();
    }

    public void login(String phone, String password) {
        enterPhone(phone);
        enterPassword(password);
        clickLogin();
    }

    public String getErrorMessage() {
        try {
            WebElement error = wait.until(ExpectedConditions.visibilityOfElementLocated(lblErrorMessage));
            return error.getText();
        } catch (Exception e) {
            return "";
        }
    }
}