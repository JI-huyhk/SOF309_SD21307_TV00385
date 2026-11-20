package com.poly.sof309.controllers;

import controller.CheckInActionController;
import controller.CheckOutListController;
import controller.DashboardController;
import controller.UpdateController;
import dao.BookingDAO;
import dao.UserDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Timeout;
import org.junit.jupiter.api.extension.ExtendWith;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import org.mockito.Mock;
import org.mockito.MockedConstruction;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Collections;
import java.util.concurrent.TimeUnit;

import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.anyList;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class ReceptionAndAdminControllerTest {

    @Mock private HttpServletRequest request;
    @Mock private HttpServletResponse response;
    @Mock private RequestDispatcher dispatcher;

    @ParameterizedTest(name = "Case {index}: action={0}, bookingId={1}, daoResult={2} => redirect={3}")
    @DisplayName("Kiểm tra xử lý Check-in thành công, thất bại và sai action")
    @CsvSource({
            "checkin, 15, true, /checkout-list",
            "checkin, 15, false, /checkin-list",
            "other, 15, true, /checkin-list"
    })
    void testCheckInActionController(String action, String bookingId, boolean daoSuccess,
                                     String expectedRedirect) throws Exception {
        when(request.getMethod()).thenReturn("POST");
        when(request.getContextPath()).thenReturn("");
        when(request.getParameter("action")).thenReturn(action);
        when(request.getParameter("bookingId")).thenReturn(bookingId);
        when(request.getParameter("roomId")).thenReturn("201");

        try (MockedConstruction<BookingDAO> ignored = mockConstruction(BookingDAO.class, (mock, ctx) -> {
            lenient().when(mock.processCheckIn(15, 201)).thenReturn(daoSuccess);
        })) {
            CheckInActionController controller = new CheckInActionController();
            controller.service((ServletRequest) request, response);

            verify(response).sendRedirect(expectedRedirect);
        }
    }

    @Test
    @DisplayName("Kiểm tra tải danh sách phòng đang Checked-in trong CheckOutListController")
    void testCheckOutListController() throws Exception {
        when(request.getMethod()).thenReturn("GET");
        when(request.getParameter("searchKey")).thenReturn("201");
        when(request.getRequestDispatcher("/checkout_confirm.jsp")).thenReturn(dispatcher);

        try (MockedConstruction<BookingDAO> ignored = mockConstruction(BookingDAO.class, (mock, ctx) -> {
            when(mock.getCheckedInBookings("201")).thenReturn(Collections.emptyList());
        })) {
            CheckOutListController controller = new CheckOutListController();
            controller.service((ServletRequest) request, response);

            verify(request).setAttribute(eq("checkoutList"), anyList());
            verify(dispatcher).forward(request, response);
        }
    }

    @Test
    @Timeout(value = 2, unit = TimeUnit.SECONDS)
    @DisplayName("Kiểm tra nạp số liệu thống kê lễ tân trên DashboardController dưới 2 giây")
    void testDashboardControllerTimeout() throws Exception {
        when(request.getMethod()).thenReturn("GET");
        when(request.getRequestDispatcher("reception.jsp")).thenReturn(dispatcher);

        try (MockedConstruction<BookingDAO> ignored = mockConstruction(BookingDAO.class, (mock, ctx) -> {
            when(mock.countAvailableRooms()).thenReturn(12);
            when(mock.countBookedRooms()).thenReturn(8);
            when(mock.countDirtyRooms()).thenReturn(2);
            when(mock.countIncomingCheckinsToday()).thenReturn(5);
            when(mock.getTodayCheckins()).thenReturn(Collections.emptyList());
        })) {
            DashboardController controller = new DashboardController();
            controller.service((ServletRequest) request, response);

            verify(request).setAttribute("availableRooms", 12);
            verify(request).setAttribute("bookedRooms", 8);
            verify(dispatcher).forward(request, response);
        }
    }

    @ParameterizedTest(name = "Case {index}: dupEmail={0}, oldRole={1}, newRole={2}, adminCount={3} => {4}")
    @DisplayName("Kiểm tra nghiệp vụ cập nhật tài khoản (trùng email, hạ quyền admin cuối cùng, hợp lệ)")
    @CsvSource({
            "true, user, user, 2, /update?id=5&error=duplicateEmail",
            "false, admin, user, 1, /update?id=5&error=lastAdminRestrict",
            "false, user, staff, 2, /quan-ly-tai-khoan"
    })
    void testUpdateControllerBusinessRules(boolean isDupEmail, String oldRole, String newRole,
                                           int activeAdmins, String expectedRedirect) throws Exception {
        when(request.getMethod()).thenReturn("POST");
        when(request.getContextPath()).thenReturn("");
        when(request.getParameter("id")).thenReturn("5");
        when(request.getParameter("firstName")).thenReturn("Khanh");
        when(request.getParameter("lastName")).thenReturn("Huy");
        when(request.getParameter("email")).thenReturn("huy@gmail.com");
        when(request.getParameter("countryCode")).thenReturn("+84");
        when(request.getParameter("phoneNumber")).thenReturn("0909123456");
        when(request.getParameter("password")).thenReturn("123456");
        when(request.getParameter("role")).thenReturn(newRole);

        User existingUser = new User();
        existingUser.setId(5);
        existingUser.setRole(oldRole);

        try (MockedConstruction<UserDAO> ignored = mockConstruction(UserDAO.class, (mock, ctx) -> {
            when(mock.findById(5)).thenReturn(existingUser);
            when(mock.checkEmailDuplicateForUpdate("huy@gmail.com", 5)).thenReturn(isDupEmail);
            lenient().when(mock.countActiveAdmins()).thenReturn(activeAdmins);
        })) {
            UpdateController controller = new UpdateController();
            controller.service((ServletRequest) request, response);

            verify(response).sendRedirect(expectedRedirect);
        }
    }

    @Test
    @DisplayName("Ném ngoại lệ NumberFormatException khi id truyền vào UpdateController không phải số")
    void testUpdateControllerInvalidIdThrowsException() {
        when(request.getMethod()).thenReturn("GET");
        when(request.getParameter("id")).thenReturn("sai_dinh_dang");

        UpdateController controller = new UpdateController();
        assertThrows(NumberFormatException.class, () -> {
            controller.service((ServletRequest) request, response);
        });
    }
}