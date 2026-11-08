<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Kết quả tìm kiếm - Verdelle Hotel</title>
  <link rel="stylesheet" href="css/style.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/NavStyle.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HotelListStyle.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/FooterStyle.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/litepicker/dist/css/litepicker.css">
  <script src="https://cdn.jsdelivr.net/npm/litepicker/dist/litepicker.js"></script>
</head>
<body>

<jsp:include page="header.jsp" />

<%-- LOGIC BÓC TÁCH YÊU CẦU PHÒNG ĐỂ FILTER KHÁCH SẠN --%>
<c:set var="reqRoomsStr" value="${not empty param.guestsRooms ? param.guestsRooms : '1 Phòng'}" />
<c:set var="requiredRoomCount" value="1" />
<c:set var="reqRoomType" value="Any" />

<c:set var="roomPartStr" value="${fn:split(reqRoomsStr, ',')[0]}" />
<c:set var="cleanedRoomsStr" value="${fn:trim(roomPartStr).replaceAll('[^0-9]', '')}" />
<c:if test="${not empty cleanedRoomsStr}">
  <c:set var="requiredRoomCount" value="${cleanedRoomsStr}" />
</c:if>

<c:if test="${fn:contains(reqRoomsStr, 'Phòng Đơn')}"><c:set var="reqRoomType" value="Single" /></c:if>
<c:if test="${fn:contains(reqRoomsStr, 'Phòng Đôi')}"><c:set var="reqRoomType" value="Double" /></c:if>
<c:if test="${fn:contains(reqRoomsStr, 'Phòng VIP') || fn:contains(reqRoomsStr, 'Family')}"><c:set var="reqRoomType" value="Family" /></c:if>

<div class="top-filter-wrapper">
  <form action="SearchController" method="GET" id="searchFilterForm" class="filter-form-mini">
    <div class="mini-input-box">
      <i class="fa-solid fa-magnifying-glass"></i>
      <input type="text" name="destination" value="${not empty param.destination ? param.destination : searchKeyword}" placeholder="Bạn muốn đi đâu?">
    </div>
    <div class="mini-input-box">
      <i class="fa-solid fa-calendar-days"></i>
      <input type="text" id="datePickerMini" name="dateRange" value="${not empty param.dateRange ? param.dateRange : '01/06/2026 - 05/06/2026'}" placeholder="Chọn ngày nhận - trả phòng" readonly>
    </div>
    <div class="mini-input-box">
      <i class="fa-solid fa-users"></i>
      <input type="text" name="guestsRooms" value="${not empty param.guestsRooms ? param.guestsRooms : '1 Phòng - 1 Người lớn'}" placeholder="Số lượng phòng / người">
    </div>
    <input type="hidden" name="minPriceFilter" value="${param.minPriceFilter}">
    <input type="hidden" name="maxPriceFilter" value="${param.maxPriceFilter}">
    <button type="submit" class="btn-update-mini">Cập nhật</button>
  </form>
</div>

<div class="main-content-container">
  <div class="promo-banner-pink">
    <div class="icon-percent"><i class="fa-solid fa-percent"></i></div>
    <div>
      <h4 style="margin: 0 0 4px 0; color: #c62828; font-size: 1rem; font-weight: bold;">Phòng ngon giá tốt nhất:</h4>
      <c:choose>
        <c:when test="${not empty hotels}">
          <c:set var="topHotel" value="${hotels[0]}" />
          <div class="promo-meta-info">
            <span class="promo-hotel-tag">${topHotel.name}</span>
            <span style="color: #ffb300; font-size: 0.85rem;">
               <c:forEach begin="1" end="${topHotel.stars != null ? topHotel.stars : 5}">★</c:forEach>
            </span>
            <span style="font-size: 0.85rem; margin-left: 5px;">- Đặt ngay để nhận mức giá ưu đãi độc quyền hấp dẫn !!!</span>
          </div>
        </c:when>
        <c:otherwise>
          <p style="margin: 0; font-size: 0.88rem;">Hệ thống tự động ưu tiên hiển thị khách sạn rẻ nhất!</p>
        </c:otherwise>
      </c:choose>
    </div>
  </div>

  <div class="billboard-container">
    <div class="billboard-led">
      <i class="fa-solid fa-circle-dot led-status-dot"></i>
      <span>KẾT QUẢ TÌM KIẾM KHU VỰC:</span>
      <span class="billboard-keyword">${not empty param.destination ? param.destination.toUpperCase() : (not empty searchKeyword ? searchKeyword.toUpperCase() : 'TẤT CẢ')}</span>
    </div>
  </div>

  <div class="split-results-layout">
    <aside class="left-map-sidebar">
      <div class="star-filter-card">
        <div class="filter-title"><i class="fa-solid fa-star" style="color: #ffb300;"></i> Lọc theo hạng sao</div>
        <div class="star-badge-status" id="starStatusLabel">Đang lọc: Từ ${not empty param.starFilter ? param.starFilter : '1.0'} ★ trở lên</div>
        <div class="star-range-container">
          <input type="range" class="star-slider" id="starRangeSlider" min="1.0" max="5.0" step="0.5" value="${not empty param.starFilter ? param.starFilter : '1.0'}">
          <div class="star-ticks">
            <span class="tick-label" onclick="setSliderValue(1.0)">1</span>
            <span class="tick-label" onclick="setSliderValue(2.0)">2</span>
            <span class="tick-label" onclick="setSliderValue(3.0)">3</span>
            <span class="tick-label" onclick="setSliderValue(4.0)">4</span>
            <span class="tick-label" onclick="setSliderValue(5.0)">5</span>
          </div>
        </div>
      </div>
    </aside>

    <section class="right-hotels-list" id="hotelsListSection">
      <c:set var="visibleHotelsCount" value="0" />

      <c:forEach var="h" items="${hotels}">
        <c:set var="isEligible" value="false" />
        <c:choose>
          <c:when test="${reqRoomType == 'Single' && h.availableSingleRooms >= requiredRoomCount}"><c:set var="isEligible" value="true" /></c:when>
          <c:when test="${reqRoomType == 'Double' && h.availableDoubleRooms >= requiredRoomCount}"><c:set var="isEligible" value="true" /></c:when>
          <c:when test="${reqRoomType == 'Family' && h.availableFamilyRooms >= requiredRoomCount}"><c:set var="isEligible" value="true" /></c:when>
          <c:when test="${reqRoomType == 'Any' && (h.availableSingleRooms + h.availableDoubleRooms + h.availableFamilyRooms) >= requiredRoomCount}"><c:set var="isEligible" value="true" /></c:when>
        </c:choose>

        <c:if test="${isEligible}">
          <c:set var="visibleHotelsCount" value="${visibleHotelsCount + 1}" />
          <div class="hotel-card" data-stars="${h.stars != null ? h.stars : 5.0}" data-min-price="${h.minPrice}">
            <div class="hotel-card-img">
              <img src="https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400" alt="Hotel Photo">
              <div class="badge-sale">SALE</div>
            </div>
            <div class="hotel-card-info">
              <div>
                <h4 style="margin: 0 0 5px 0; font-size: 1.1rem; font-weight: bold;">${h.name}</h4>
                <div style="color: #ffb300; font-size: 0.8rem; margin-bottom: 8px;">
                  <c:forEach begin="1" end="${h.stars != null ? h.stars : 5}">★</c:forEach>
                </div>
                <p style="margin: 0 0 8px 0; font-size: 0.85rem;"><i class="fa-solid fa-city" style="color: #00bcd4; width: 16px;"></i> Thành phố: <strong>${h.city}</strong></p>

                <p style="margin: 0; font-size: 0.82rem; color: var(--sub-text); line-height: 1.6; display: flex; align-items: center; flex-wrap: wrap; gap: 8px;">
                  <span><i class="fa-solid fa-location-dot" style="width: 16px;"></i> Địa chỉ: ${h.address}</span>
                  <a href="https://www.google.com/maps/search/?api=1&query=$${h.name} ${h.address}" target="_blank" rel="noopener noreferrer" style="display: inline-flex; align-items: center; gap: 4px; background: #e0f7fa; color: #00838f; text-decoration: none; padding: 2px 8px; border-radius: 4px; font-size: 0.75rem; font-weight: bold; transition: 0.2s;" onmouseover="this.style.background='#b2ebf2'" onmouseout="this.style.background='#e0f7fa'">
                    <i class="fa-solid fa-map-marked-alt"></i> Xem bản đồ
                  </a>
                </p>

                <div class="room-availability-tags" style="margin-top: 12px; display: flex; gap: 8px; flex-wrap: wrap;">
                  <span style="background: #e8f5e9; color: #2e7d32; padding: 4px 10px; border-radius: 4px; font-size: 0.75rem; font-weight: bold; display: inline-flex; align-items: center; gap: 5px; border: 1px solid #c8e6c9;">
                    <i class="fa-solid fa-user"></i> Đơn: ${h.availableSingleRooms}
                  </span>
                  <span style="background: #e3f2fd; color: #1565c0; padding: 4px 10px; border-radius: 4px; font-size: 0.75rem; font-weight: bold; display: inline-flex; align-items: center; gap: 5px; border: 1px solid #bbdefb;">
                    <i class="fa-solid fa-user-group"></i> Đôi: ${h.availableDoubleRooms}
                  </span>
                  <span style="background: #fff3e0; color: #e65100; padding: 4px 10px; border-radius: 4px; font-size: 0.75rem; font-weight: bold; display: inline-flex; align-items: center; gap: 5px; border: 1px solid #ffe0b2;">
                    <i class="fa-solid fa-people-roof"></i> VIP/Family: ${h.availableFamilyRooms}
                  </span>
                </div>
              </div>
            </div>

            <div class="hotel-card-price-action">
              <span style="font-size: 0.75rem; color: var(--sub-text);">Giá mỗi đêm từ</span>
              <div style="margin: 3px 0 12px 0;">
                <span style="font-size: 1.2rem; font-weight: bold; color: #e65100;">
                  <fmt:formatNumber value="${h.minPrice}" type="number" groupingUsed="true"/> đ
                </span>
              </div>
              <a href="SearchController?action=viewRooms&hotelId=${h.id}&dateRange=${not empty param.dateRange ? param.dateRange : '01/06/2026 - 05/06/2026'}&guestsRooms=${not empty param.guestsRooms ? param.guestsRooms : '1 Phòng - 1 Người lớn'}" style="background: #00bcd4; color: #fff; text-decoration: none; padding: 8px 0; width: 100%; text-align: center; border-radius: 4px; font-weight: bold; font-size: 0.85rem;">
                Xem phòng
              </a>
            </div>
          </div>
        </c:if>
      </c:forEach>

      <div id="jspEmptyMsg" style="display: ${visibleHotelsCount == 0 ? 'block' : 'none'}; background: var(--card-bg); padding: 40px; text-align: center; border-radius: 8px;">
        <p style="font-weight: bold; color: var(--text-color);">Không có khách sạn nào đáp ứng đủ số lượng loại phòng bạn yêu cầu.</p>
        <p style="font-size: 0.9rem; color: var(--sub-text);">Vui lòng thử chọn loại phòng khác hoặc thay đổi số lượng người.</p>
      </div>
    </section>
  </div>
</div>

<jsp:include page="footer.jsp" />

<script>
  function setSliderValue(val) {
    const slider = document.getElementById('starRangeSlider');
    if(slider) {
      slider.value = val;
      slider.dispatchEvent(new Event('input'));
    }
  }

  function filterHotels() {
    const starSlider = document.getElementById('starRangeSlider');
    const starStatusLabel = document.getElementById('starStatusLabel');
    const targetStar = starSlider ? parseFloat(starSlider.value) : 1.0;

    if(starStatusLabel) {
      starStatusLabel.textContent = `Đang lọc: Từ \${targetStar.toFixed(1)} ★ trở lên`;
    }

    const urlParams = new URLSearchParams(window.location.search);
    const minPrice = parseInt(urlParams.get('minPriceFilter')) || 0;
    const maxPrice = parseInt(urlParams.get('maxPriceFilter')) || 5000000;

    const hotelCards = document.querySelectorAll('.hotel-card');
    let visibleCount = 0;
    hotelCards.forEach(card => {
      const cardStars = parseFloat(card.getAttribute('data-stars') || '5.0');
      const cardPrice = parseInt(card.getAttribute('data-min-price') || '0');

      if(cardStars >= targetStar && cardPrice >= minPrice && cardPrice <= maxPrice) {
        card.style.display = 'flex';
        visibleCount++;
      } else {
        card.style.display = 'none';
      }
    });

    let jsEmptyMsg = document.getElementById('jsEmptyMsg');
    const jspEmptyMsg = document.getElementById('jspEmptyMsg');

    if(visibleCount === 0 && jspEmptyMsg.style.display === 'none') {
      if(!jsEmptyMsg) {
        jsEmptyMsg = document.createElement('div');
        jsEmptyMsg.id = 'jsEmptyMsg';
        jsEmptyMsg.style.cssText = 'background: var(--card-bg); padding: 40px; text-align: center; border-radius: 8px; margin-top: 20px;';
        jsEmptyMsg.innerHTML = '<p style="font-weight: bold; color: var(--text-color);">Không có khách sạn nào đáp ứng bộ lọc Sao & Giá của bạn.</p><p style="font-size: 0.9rem; color: var(--sub-text);">Vui lòng hạ mức sao hoặc nới lỏng mức giá.</p>';
        document.getElementById('hotelsListSection').appendChild(jsEmptyMsg);
      }
      jsEmptyMsg.style.display = 'block';
    } else if (jsEmptyMsg) {
      jsEmptyMsg.style.display = 'none';
    }
  }

  document.addEventListener("DOMContentLoaded", function() {
    const datePickerInput = document.getElementById('datePickerMini');
    if(datePickerInput){
      new Litepicker({
        element: datePickerInput, singleMode: false, numberOfMonths: 2, numberOfColumns: 2,
        minDate: new Date(), format: 'DD/MM/YYYY', dropdowns: {"minYear": 2026, "maxYear": null, "months": true, "years": true},
        setup: (picker) => {
          picker.on('selected', (date1, date2) => {
            datePickerInput.value = date1.format('DD/MM/YYYY') + ' - ' + date2.format('DD/MM/YYYY');
          });
        }
      });
    }

    const starSlider = document.getElementById('starRangeSlider');
    if(starSlider) starSlider.addEventListener('input', filterHotels);
    filterHotels();

    const hamburgerBtn = document.getElementById('hamburgerBtn');
    const hamburgerMenu = document.getElementById('hamburgerMenu');
    if(hamburgerBtn && hamburgerMenu) {
      hamburgerBtn.addEventListener('click', function(e) { e.stopPropagation(); hamburgerMenu.classList.toggle('show'); });
      document.addEventListener('click', function() { hamburgerMenu.classList.remove('show'); });
    }
  });
</script>
</body>
</html>