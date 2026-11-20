package com.poly.sof309.controllers;

import controller.ActivityController;
import controller.BookingHistoryController;
import controller.UserdetailController;
import dao.BookingDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
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
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class BookingControllerTest {

    @Mock private HttpServletRequest request;
    @Mock private HttpServletResponse response;
    @Mock private HttpSession session;
    @Mock private RequestDispatcher dispatcher;

    @ParameterizedTest(name = "Case {index}: from={0}, to={1}")
    @DisplayName("Kiểm tra chuẩn hóa định dạng ngày lọc lịch sử đặt phòng")
    @CsvSource(value = {
            "2026-11-01, 2026-11-20, 2026-11-01, 2026-11-20",
            "'   ', '', null, null",
            "20-11-2026, invalid-date, null, null"
    }, nullValues = "null")
    void testBookingHistoryDateValidation(String rawFrom, String rawTo,
                                          String expectedFrom, String expectedTo) throws Exception {
        when(request.getMethod()).thenReturn("GET");
        when(request.getParameter("fromDate")).thenReturn(rawFrom);
        when(request.getParameter("toDate")).thenReturn(rawTo);
        when(request.getRequestDispatcher("/booking-history.jsp")).thenReturn(dispatcher);

        try (MockedConstruction<BookingDAO> ignored = mockConstruction(BookingDAO.class, (mock, context) -> {
            when(mock.getAllBookingsWithStatus(expectedFrom, expectedTo))
                    .thenReturn(Collections.emptyList());
        })) {
            BookingHistoryController controller = new BookingHistoryController();
            controller.service((ServletRequest) request, response);

            verify(request).setAttribute("fromDate", expectedFrom);
            verify(request).setAttribute("toDate", expectedTo);
            verify(dispatcher).forward(request, response);
        }
    }

    @Test
    @DisplayName("Ném ngoại lệ NumberFormatException khi tham số id chi tiết user không phải số")
    void testUserDetailInvalidIdThrowsException() {
        when(request.getMethod()).thenReturn("GET");
        when(request.getParameter("id")).thenReturn("abc_khong_phai_so");

        UserdetailController controller = new UserdetailController();
        assertThrows(NumberFormatException.class, () -> {
            controller.service((ServletRequest) request, response);
        });
    }

    @Test
    @Timeout(value = 2, unit = TimeUnit.SECONDS)
    @DisplayName("Chuyển hướng về login.jsp nếu chưa đăng nhập khi xem lịch sử hoạt động")
    void testActivityControllerRedirectWhenNotLoggedIn() throws Exception {
        when(request.getMethod()).thenReturn("GET");
        when(request.getSession()).thenReturn(session);
        when(session.getAttribute("userId")).thenReturn(null);

        ActivityController controller = new ActivityController();
        controller.service((ServletRequest) request, response);

        verify(response).sendRedirect("login.jsp");
    }
}