<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ page import="java.util.List" %>
<%@ page import="dao.ServiceDAO" %>
<%@ page import="dao.ServiceDAO.HotelService" %>
<%
    String bookingIdStr = request.getParameter("bookingId");
    String bookingCodeStr = request.getParameter("bookingCode");
    String roomIdStr = request.getParameter("roomId");

    if (bookingIdStr == null || bookingIdStr.trim().isEmpty()) {
%>
<h3 style='color:white;text-align:center;margin-top:50px;'>Không tìm thấy mã đơn phòng (BookingID)!</h3>
<%
        return;
    }

    int bookingId = Integer.parseInt(bookingIdStr.trim());
    String displayBookingCode = (bookingCodeStr != null && !bookingCodeStr.trim().isEmpty())
            ? bookingCodeStr.trim() : ("BK-" + bookingId);

    ServiceDAO dao = new ServiceDAO();
    List<HotelService> serviceList = dao.getAllActiveServices();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Kê Khai Phụ Phí - Verdelle Luxury</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --bg-color: #0b0b0e;
            --panel-bg: #14141a;
            --text-light: #9a9aab;
            --text-dark: #f5f5f7;
            --gold-primary: #d4af37;
            --gold-hover: #b89327;
            --border-color: #22222a;
        }
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: var(--bg-color);
            color: var(--text-dark);
            margin: 0; padding: 40px;
            display: flex; justify-content: center;
        }
        .container { width: 850px; background: var(--panel-bg); border-radius: 12px; border: 1px solid var(--border-color); padding: 35px; box-shadow: 0 10px 30px rgba(0,0,0,0.5); }
        h2 { color: #fff; font-weight: 400; margin-top: 0; letter-spacing: 1px; display: flex; align-items: center; gap: 10px; }
        h2 i { color: var(--gold-primary); }
        .meta-info { display: flex; gap: 30px; background: rgba(255,255,255,0.02); padding: 15px; border-radius: 8px; border: 1px solid var(--border-color); margin-bottom: 25px; }
        .meta-info span { font-size: 0.95rem; color: var(--text-light); }
        .meta-info strong { color: var(--gold-primary); }
        h3 { font-size: 1.1rem; color: var(--gold-primary); border-bottom: 1px solid var(--border-color); padding-bottom: 10px; margin-top: 30px; }
        .item-row { display: flex; align-items: center; justify-content: space-between; padding: 12px 0; border-bottom: 1px solid rgba(255,255,255,0.02); }
        .item-left { display: flex; align-items: center; gap: 12px; }
        .item-name { font-weight: 500; }
        .item-desc { font-size: 0.8rem; color: var(--text-light); display: block; margin-top: 2px; }
        .item-right { display: flex; align-items: center; gap: 20px; }
        .price-tag { color: var(--text-dark); font-size: 0.95rem; min-width: 100px; text-align: right; }
        .qty-input { width: 60px; background: #0b0b0e; border: 1px solid var(--border-color); color: #fff; padding: 6px; border-radius: 4px; text-align: center; }
        .qty-input:disabled { opacity: 0.3; }
        .summary-box { background: rgba(212, 175, 55, 0.05); border: 1px solid rgba(212, 175, 55, 0.2); padding: 20px; border-radius: 8px; margin-top: 35px; display: flex; justify-content: space-between; align-items: center; }
        .summary-box span { font-size: 1.1rem; font-weight: 500; }
        .total-price { font-size: 1.6rem; color: var(--gold-primary); font-weight: 600; }
        .btn-submit { background: linear-gradient(135deg, var(--gold-primary) 0%, var(--gold-hover) 100%); color: #000; border: none; padding: 14px 30px; border-radius: 6px; font-weight: 600; font-size: 1rem; cursor: pointer; display: block; width: 100%; margin-top: 25px; transition: all 0.3s; }
        .btn-submit:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(212,175,55,0.2); }
    </style>
</head>
<body>

<div class="container">
    <h2><i class="fa-solid fa-calculator"></i> Kê Khai Phụ Phí Sử Dụng &amp; Thiệt Hại</h2>

    <div class="meta-info">
        <span>Mã hóa đơn: <strong>#<%= displayBookingCode %></strong></span>
        <span>Mã phòng: <strong>Room-<%= (roomIdStr != null) ? roomIdStr : "N/A" %></strong></span>
    </div>

    <!-- Gửi form về lại CheckOutActionController để lưu DB -->
    <form action="${pageContext.request.contextPath}/checkout-action" method="POST">
        <input type="hidden" name="action" value="checkout_final">
        <input type="hidden" name="bookingId" value="<%= bookingId %>">
        <input type="hidden" name="bookingCode" value="<%= displayBookingCode %>">
        <input type="hidden" name="roomId" value="<%= (roomIdStr != null) ? roomIdStr : "0" %>">

        <h3><i class="fa-solid fa-wine-glass"></i> 1. Tiêu thụ Minibar &amp; Dịch vụ phát sinh</h3>
        <% if (serviceList == null || serviceList.isEmpty()) { %>
        <p style="color: var(--text-light); font-size: 0.9rem;">Không có dịch vụ nào khả dụng.</p>
        <% } else {
            for (HotelService s : serviceList) {
                int maxQty = (s.serviceName != null && s.serviceName.toLowerCase().contains("xe máy")) ? 5 : 30;
        %>
        <div class="item-row">
            <div class="item-left">
                <input type="checkbox" name="selectedServices" value="<%= s.serviceId %>" id="svc_<%= s.serviceId %>" onchange="toggleQty('svc_qty_<%= s.serviceId %>', this); calculateTotal();">
                <label for="svc_<%= s.serviceId %>" style="cursor: pointer;">
                    <span class="item-name"><%= s.serviceName %></span>
                    <span class="item-desc"><%= (s.description != null) ? s.description : "" %></span>
                </label>
            </div>
            <div class="item-right">
                <span class="price-tag"><%= String.format("%,.0f", s.price) %> VNĐ / <%= (s.unit != null) ? s.unit : "lần" %></span>
                <input type="number" name="qty_svc_<%= s.serviceId %>" id="svc_qty_<%= s.serviceId %>" class="qty-input" value="1" min="1" max="<%= maxQty %>" disabled onchange="calculateTotal()">
            </div>
        </div>
        <% } } %>

        <h3><i class="fa-solid fa-triangle-exclamation"></i> 2. Phí đền bù thiệt hại vật tư &amp; kết cấu phòng (Theo DB)</h3>

        <!-- Furniture ID = 1 -->
        <div class="item-row">
            <div class="item-left">
                <input type="checkbox" name="selectedFurniture" value="1" id="furn_1" onchange="toggleQty('furn_qty_1', this); calculateTotal();">
                <label for="furn_1" style="cursor: pointer;">
                    <span class="item-name" style="color: #ff6666;">Chi phí nội thất hư hỏng (Tiền đền bù)</span>
                    <span class="item-desc">Phạt hư hỏng trang thiết bị, sofa, giường, gương, tivi...</span>
                </label>
            </div>
            <div class="item-right">
                <span class="price-tag" style="color: #ff6666;">2,800,000 VNĐ</span>
                <input type="number" name="qty_furn_1" id="furn_qty_1" class="qty-input" value="1" min="1" max="5" disabled onchange="calculateTotal()">
            </div>
        </div>

        <div class="item-row" style="background: rgba(255, 102, 102, 0.05); padding: 15px 12px; border-radius: 6px; margin: 15px 0 10px 0; border: 1px dashed rgba(255, 102, 102, 0.2);">
            <div class="item-left">
                <input type="checkbox" name="mainRoomDamage" value="true" id="main_room_damage" onchange="toggleRoomDamageSection(this)">
                <label for="main_room_damage" style="cursor: pointer;">
                    <span class="item-name" style="color: #ff4444; font-weight: 600;">Phát sinh thiệt hại kết cấu phòng cho thuê</span>
                    <span class="item-desc">Tích chọn nếu cấu trúc phòng (tường, kính, sàn, trần điện...) bị hư hỏng</span>
                </label>
            </div>
        </div>

        <div id="room-damage-sub-levels" style="display: none; padding-left: 25px; border-left: 2px dashed #ff6666; margin-bottom: 20px;">
            <div class="item-row">
                <div class="item-left">
                    <input type="radio" name="selectedFurniture" value="2" id="furn_2" disabled onchange="calculateTotal()">
                    <label for="furn_2" style="cursor: pointer;">
                        <span class="item-name" style="color: #ff6666;">Đền bù thiệt hại phòng - Mức 1 (Nhẹ)</span>
                        <span class="item-desc">Tường bị bong tróc, thủng lỗ nhỏ, xước sát bề mặt...</span>
                    </label>
                </div>
                <div class="item-right">
                    <span class="price-tag" style="color: #ff6666; min-width: 180px;">4,000,000 VNĐ</span>
                </div>
            </div>

            <div class="item-row">
                <div class="item-left">
                    <input type="radio" name="selectedFurniture" value="3" id="furn_3" disabled onchange="calculateTotal()">
                    <label for="furn_3" style="cursor: pointer;">
                        <span class="item-name" style="color: #ff6666;">Đền bù thiệt hại phòng - Mức 2 (Vừa)</span>
                        <span class="item-desc">Khách sơn xịt, vẽ bậy, làm bẩn diện tích lớn trên tường...</span>
                    </label>
                </div>
                <div class="item-right">
                    <span class="price-tag" style="color: #ff6666; min-width: 180px;">7,000,000 VNĐ</span>
                </div>
            </div>

            <div class="item-row">
                <div class="item-left">
                    <input type="radio" name="selectedFurniture" value="4" id="furn_4" disabled onchange="calculateTotal()">
                    <label for="furn_4" style="cursor: pointer;">
                        <span class="item-name" style="color: #ff6666;">Đền bù thiệt hại phòng - Mức 3 (Nặng - Như nổ bom)</span>
                        <span class="item-desc">Hư hại nghiêm trọng kết cấu, vỡ nát mảng tường, hỏng sàn, ngập nước...</span>
                    </label>
                </div>
                <div class="item-right">
                    <span class="price-tag" style="color: #ff6666; min-width: 180px;">15,000,000 VNĐ</span>
                </div>
            </div>
        </div>

        <div class="summary-box">
            <span>Tổng chi phí phát sinh bổ sung:</span>
            <span class="total-price" id="displayTotal">0 VNĐ</span>
        </div>

        <button type="submit" class="btn-submit">Xác nhận phụ phí &amp; Xuất hóa đơn tổng hợp <i class="fa-solid fa-arrow-right"></i></button>
    </form>
</div>

<script>
    const prices = {
        'furn_qty_1': 2800000,
        'furn_fixed_2': 4000000,
        'furn_fixed_3': 7000000,
        'furn_fixed_4': 15000000
    };

    <% if (serviceList != null) {
        for(HotelService s : serviceList) { %>
    prices['svc_qty_<%= s.serviceId %>'] = <%= s.price %>;
    <%  }
    } %>

    function toggleRoomDamageSection(mainCheckbox) {
        const subLevelsContainer = document.getElementById('room-damage-sub-levels');
        const radios = document.querySelectorAll('#room-damage-sub-levels input[type="radio"]');

        if (mainCheckbox.checked) {
            subLevelsContainer.style.display = 'block';
            radios.forEach(r => r.disabled = false);

            let hasSelection = Array.from(radios).some(r => r.checked);
            if (!hasSelection) {
                document.getElementById('furn_2').checked = true;
            }
        } else {
            subLevelsContainer.style.display = 'none';
            radios.forEach(radio => {
                radio.checked = false;
                radio.disabled = true;
            });
        }

        calculateTotal();
    }

    function toggleQty(qtyInputId, checkbox) {
        const input = document.getElementById(qtyInputId);
        if (input) {
            input.disabled = !checkbox.checked;
            if (!checkbox.checked) {
                input.value = 1;
            }
        }
    }

    function calculateTotal() {
        let grandTotal = 0;

        const qtyInputs = document.querySelectorAll('.qty-input');
        qtyInputs.forEach(input => {
            if (!input.disabled) {
                const qty = parseInt(input.value) || 0;
                const price = prices[input.id] || 0;
                grandTotal += (qty * price);
            }
        });

        const mainDamage = document.getElementById('main_room_damage');
        if (mainDamage && mainDamage.checked) {
            const selectedRadio = document.querySelector('#room-damage-sub-levels input[type="radio"]:checked');
            if (selectedRadio) {
                const levelValue = selectedRadio.value;
                grandTotal += prices['furn_fixed_' + levelValue] || 0;
            }
        }

        document.getElementById('displayTotal').innerText = grandTotal.toLocaleString('vi-VN') + " VNĐ";
    }

    document.querySelectorAll('input[type="number"]').forEach(input => {
        input.addEventListener('input', function() {
            let max = parseInt(this.max);
            let min = parseInt(this.min) || 1;
            let value = parseInt(this.value);

            if (value > max) this.value = max;
            if (value < min) this.value = min;
            calculateTotal();
        });
    });
</script>
</body>
</html>