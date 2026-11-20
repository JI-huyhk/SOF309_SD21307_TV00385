package com.poly.sof309.controllers;

import controller.BookingController;
import controller.FinalizeBookingController;
import dao.BookingDAO;
import dao.UserDAO;
import dao.VoucherDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletContext;
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
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;

import java.time.LocalDate;
import java.util.Collections;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
public class BookingFlowControllerTest {

    @Mock private HttpServletRequest request;
    @Mock private HttpServletResponse response;
    @Mock private HttpSession session;
    @Mock private RequestDispatcher dispatcher;
    @Mock private ServletContext servletContext;

    @ParameterizedTest(name = "Case {index}: dateRange={0}, reqRooms={1}, guests={2} => nights={3}, rooms={4}")
    @DisplayName("Kiểm tra thuật toán tính số đêm, số phòng và tổng tiền trong BookingController")
    @CsvSource({
            "'01/11/2026 - 04/11/2026 (3 ngày)', '2', '4 người, 2 phòng', 3, 2",
            "'1/11/2026 to 5/11/2026', '', '2 người, 3 phòng', 4, 3",
            "'01/11/2026 - 03/11/2026', '', '', 2, 1",
            "'invalid-date', 'abc', '', 1, 1"
    })
    void testBookingControllerCalculation(String dateRange, String reqRooms, String guestsRooms,
                                          int expectedNights, int expectedRooms) throws Exception {
        when(request.getMethod()).thenReturn("GET");
        when(request.getParameter("roomId")).thenReturn("101");
        when(request.getParameter("roomName")).thenReturn("Deluxe King");
        when(request.getParameter("price")).thenReturn("1000000.00");
        when(request.getParameter("dateRange")).thenReturn(dateRange);
        when(request.getParameter("requiredRooms")).thenReturn(reqRooms);
        when(request.getParameter("guestsRooms")).thenReturn(guestsRooms);
        when(request.getSession()).thenReturn(session);
        when(session.getAttribute("userId")).thenReturn(1);
        when(request.getRequestDispatcher("booking.jsp")).thenReturn(dispatcher);

        try (MockedConstruction<UserDAO> ignoredUser = mockConstruction(UserDAO.class, (mock, ctx) -> {
            when(mock.getUserPoints(1)).thenReturn(Map.of("rank", "Gold", "loyalPoint", 500));
        });
             MockedConstruction<VoucherDAO> ignoredVoucher = mockConstruction(VoucherDAO.class, (mock, ctx) -> {
                 when(mock.getEligibleVouchers("Gold")).thenReturn(Collections.emptyList());
             })) {

            BookingController controller = new BookingController();
            controller.service((ServletRequest) request, response);

            verify(request).setAttribute("totalNights", expectedNights);
            verify(request).setAttribute("requiredRooms", expectedRooms);
            verify(request).setAttribute("rank", "Gold");
            verify(dispatcher).forward(request, response);
        }
    }

    @ParameterizedTest(name = "Case {index}: paymentMethod={0}, isSaved={1}")
    @DisplayName("Kiểm tra luồng lưu đơn hàng thành công và thất bại trong FinalizeBookingController")
    @CsvSource({
            "Cash, true",
            "VNPay, true",
            "hotel, false"
    })
    void testFinalizeBookingFlow(String paymentMethod, boolean isSaved) throws Exception {
        when(request.getMethod()).thenReturn("POST");
        when(request.getContextPath()).thenReturn("");
        when(request.getSession()).thenReturn(session);
        when(request.getParameter("paymentMethod")).thenReturn(paymentMethod);
        when(request.getParameter("roomId")).thenReturn("101");
        when(request.getParameter("totalNights")).thenReturn("2");
        when(request.getParameter("finalPrice")).thenReturn("2000000");
        when(request.getParameter("dateRange")).thenReturn("01/11/2026 - 03/11/2026");

        if (isSaved) {
            when(request.getRequestDispatcher("booking_success.jsp")).thenReturn(dispatcher);
        }

        try (MockedConstruction<BookingDAO> ignored = mockConstruction(BookingDAO.class, (mock, ctx) -> {
            when(mock.createBookingWithInvoice(
                    any(), anyInt(), any(LocalDate.class), any(LocalDate.class),
                    anyDouble(), anyString(), anyString(), any(), any(), anyString()
            )).thenReturn(isSaved);
        })) {
            FinalizeBookingController controller = spy(new FinalizeBookingController());
            doReturn(servletContext).when(controller).getServletContext();

            controller.service((ServletRequest) request, response);

            if (isSaved) {
                verify(session).removeAttribute("roomId");
                verify(servletContext).removeAttribute("payment_status_101");
                verify(dispatcher).forward(request, response);
            } else {
                verify(session).setAttribute(eq("errorMessage"), anyString());
                verify(response).sendRedirect("/payment.jsp");
            }
        }
    }

    @Test
    @Timeout(value = 2, unit = TimeUnit.SECONDS)
    @DisplayName("Ném ngoại lệ NumberFormatException khi tham số finalPrice không hợp lệ")
    void testFinalizeBookingInvalidPriceThrowsException() {
        when(request.getMethod()).thenReturn("POST");
        when(request.getSession()).thenReturn(session);
        when(request.getParameter("roomId")).thenReturn("101");
        when(request.getParameter("totalNights")).thenReturn("2");
        when(request.getParameter("finalPrice")).thenReturn("khong_phai_so");

        FinalizeBookingController controller = new FinalizeBookingController();
        assertThrows(NumberFormatException.class, () -> {
            controller.service((ServletRequest) request, response);
        });
    }
}