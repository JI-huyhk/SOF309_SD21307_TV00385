<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.Comparator" %>
<%
  // --- LẤY GIÁ CAO NHẤT TỪ DATABASE CHO THANH KÉO GIÁ ---
  dao.RoomDAO priceDao = new dao.RoomDAO();
  double maxDbPrice = priceDao.getMaxRoomPrice();
  request.setAttribute("maxDbPrice", maxDbPrice);

  // 1. Lấy dữ liệu từ Session hoặc Controller
  if (request.getSession().getAttribute("rooms") != null) {
    request.setAttribute("rooms", request.getSession().getAttribute("rooms"));
    request.getSession().removeAttribute("rooms");
  }

  if (request.getAttribute("rooms") == null) {
    try {
      dao.RoomDAO roomDao = new dao.RoomDAO(); // ✅ Đổi từ UserDAO thành RoomDAO
      List<model.Room> directRooms = roomDao.getAvailableRooms();
      request.setAttribute("rooms", directRooms);
    } catch (Exception e) {
      e.printStackTrace();
    }
  }

  // =========================================================================
  // 2. BỘ LỌC CỨNG (HARD FILTER) BẰNG JAVA NGAY TẠI JSP
  // Đã fix lỗi kẹt giá do chuỗi gửi lên dính định dạng (chữ ₫, dấu chấm, phẩy)
  // =========================================================================

  // Lấy tham số giá trị từ Request hoặc Session
  String paramMinP = request.getParameter("minPrice");
  if (paramMinP == null && request.getSession().getAttribute("minPrice") != null) {
    paramMinP = request.getSession().getAttribute("minPrice").toString();
  }

  String paramMaxP = request.getParameter("maxPrice");
  if (paramMaxP == null && request.getSession().getAttribute("maxPrice") != null) {
    paramMaxP = request.getSession().getAttribute("maxPrice").toString();
  }

  // Gán giá trị mặc định siêu rộng (0đ đến 500 triệu đ) để nếu khách không lọc giá thì vẫn hiện đủ phòng
  double minPriceFilter = 0;
  double maxPriceFilter = 500000000;

  // Xử lý làm sạch chuỗi (Chỉ giữ lại đúng các con số từ 0-9)
  try {
    if (paramMinP != null && !paramMinP.trim().isEmpty()) {
      String cleanMin = paramMinP.replaceAll("[^0-9]", "");
      if (!cleanMin.isEmpty()) {
        minPriceFilter = Double.parseDouble(cleanMin);
      }
    }
    if (paramMaxP != null && !paramMaxP.trim().isEmpty()) {
      String cleanMax = paramMaxP.replaceAll("[^0-9]", "");
      if (!cleanMax.isEmpty()) {
        maxPriceFilter = Double.parseDouble(cleanMax);
      }
    }
  } catch (Exception e) {
    System.out.println("Lỗi parse giá trị bộ lọc: " + e.getMessage());
  }

  // Tiến hành lọc danh sách phòng
  List<model.Room> allRooms = (List<model.Room>) request.getAttribute("rooms");
  if (allRooms != null) {
    List<model.Room> filteredRooms = new ArrayList<>();
    for (model.Room r : allRooms) {
      // Kiểm tra thêm trạng thái phòng phải là Available hoặc null (phòng trống)
      boolean isAvailable = (r.getStatus() == null || r.getStatus().equalsIgnoreCase("Available"));
      // Kiểm tra Điều kiện vệ sinh/bảo trì (Phải là Clean)
      boolean isClean = (r.getCondition() == null || r.getCondition().equalsIgnoreCase("Clean"));

      if (isAvailable && isClean && r.getPrice() >= minPriceFilter && r.getPrice() <= maxPriceFilter) {
        filteredRooms.add(r);
      }
    }
    // Gán lại danh sách đã lọc để HTML in ra
    request.setAttribute("rooms", filteredRooms);
  }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Giao diện Đặt Phòng Khách Sạn</title>
  <link rel="stylesheet" href="css/RoomListStyle.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
  <link rel="stylesheet" type="text/css" href="https://npmcdn.com/flatpickr/dist/themes/dark.css">
  <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>

  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/nouislider/dist/nouislider.min.css">
  <script src="https://cdn.jsdelivr.net/npm/nouislider/dist/nouislider.min.js"></script>

  <style>
    /* ========================================================================= */
    /* KHỐI CSS BỔ SUNG: HIỆU ỨNG TÌM KIẾM & HIGHLIGHT PHÒNG RẺ NHẤT (LUXURY) */
    /* ========================================================================= */
    @keyframes goldGlowAnimation {
      0% { box-shadow: 0 0 10px #dfb76c, inset 0 0 5px #dfb76c; border-color: #dfb76c; }
      50% { box-shadow: 0 0 30px #dfb76c, inset 0 0 15px #dfb76c; border-color: #f3e1bd; }
      100% { box-shadow: 0 0 10px rgba(223, 183, 108, 0.4); border-color: #aa8443; }
    }
    .cheapest-room-highlight {
      animation: goldGlowAnimation 2.5s ease-in-out infinite alternate !important;
      border: 2px solid #dfb76c !important;
      transform: scale(1.025);
      z-index: 2;
      box-shadow: 0 15px 30px rgba(0,0,0,0.8);
    }
    .cheapest-room-highlight::before {
      content: "✨ ĐỀ XUẤT: GIÁ TỐT NHẤT";
      position: absolute;
      top: 15px;
      left: -5px;
      background: linear-gradient(135deg, #aa8443, #dfb76c);
      color: #000;
      font-weight: 800;
      font-size: 0.75rem;
      padding: 6px 15px;
      border-radius: 0 4px 4px 0;
      z-index: 10;
      box-shadow: 0 4px 15px rgba(223, 183, 108, 0.4);
      letter-spacing: 0.5px;
    }

    #loading-overlay {
      position: fixed; top: 0; left: 0; width: 100%; height: 100%;
      background-color: rgba(11, 11, 11, 0.95); z-index: 999999;
      display: flex; flex-direction: column; justify-content: center; align-items: center;
      opacity: 0; visibility: hidden; transition: all 0.4s ease;
      backdrop-filter: blur(10px);
    }
    #loading-overlay.show { opacity: 1; visibility: visible; }
    .luxury-spinner {
      width: 70px; height: 70px; border: 4px solid rgba(223, 183, 108, 0.1);
      border-left-color: #dfb76c; border-top-color: #dfb76c; border-radius: 50%;
      animation: spinLuxury 0.8s cubic-bezier(0.55, 0.085, 0.68, 0.53) infinite; margin-bottom: 30px;
    }
    @keyframes spinLuxury { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
    .loading-text { color: #dfb76c; font-size: 1.2rem; letter-spacing: 3px; text-transform: uppercase; font-weight: 600; text-shadow: 0 0 10px rgba(223, 183, 108, 0.5); }
    /* ========================================================================= */

    /* CSS hỗ trợ Sub-menu hiển thị đè lên thẻ phòng */
    .room-card {
      position: relative;
      overflow: hidden;
    }
    .room-details {
      cursor: pointer;
      transition: background 0.3s ease;
    }
    .room-details:hover {
      background: rgba(0, 0, 0, 0.8) !important;
    }
    .room-submenu {
      display: none;
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: rgba(0, 0, 0, 0.85);
      backdrop-filter: blur(5px);
      z-index: 10;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      gap: 15px;
      border-radius: 8px;
    }
    .btn-submenu-action {
      background: #ffca28;
      color: #000;
      border: none;
      padding: 12px 24px;
      font-weight: bold;
      border-radius: 4px;
      cursor: pointer;
      width: 60%;
      text-align: center;
      font-size: 1rem;
      transition: background 0.2s;
    }
    .btn-submenu-action:hover {
      background: #ffa000;
    }
    .btn-submenu-close {
      background: rgba(255, 255, 255, 0.2);
      color: #fff;
      border: none;
      padding: 8px 20px;
      border-radius: 4px;
      cursor: pointer;
      width: 60%;
    }
    .btn-submenu-close:hover {
      background: rgba(255, 255, 255, 0.4);
    }

    /* CSS bổ sung cho thanh trượt giá */
    .price-slider-container {
      margin-top: 10px;
      padding: 0 10px;
    }
    .noUi-connect {
      background: #ffca28 !important;
    }
    .noUi-horizontal {
      height: 6px !important;
    }
    .noUi-handle {
      width: 18px !important;
      height: 18px !important;
      border-radius: 50% !important;
      background: #fff !important;
      cursor: pointer !important;
      box-shadow: 0 2px 5px rgba(0,0,0,0.3) !important;
      top: -6px !important;
    }
    .noUi-handle::before, .noUi-handle::after {
      display: none !important;
    }
    .price-values {
      display: flex;
      justify-content: space-between;
      font-size: 0.85rem;
      color: #ffca28;
      margin-top: 8px;
      font-weight: bold;
    }

    /* ================= CSS FIX LỖI SUB-MENU PHÒNG & NGƯỜI ================= */
    .select-custom-wrapper {
      position: relative;
      width: 100%;
    }

    .occupancy-dropdown {
      display: none;
      position: absolute;
      top: calc(100% + 8px);
      right: 0;
      width: 320px;
      background: #ffffff !important;
      border-radius: 8px;
      box-shadow: 0 10px 25px rgba(0,0,0,0.5);
      z-index: 99999 !important;
      padding: 15px;
      box-sizing: border-box;
    }

    .occupancy-row {
      display: flex !important;
      justify-content: space-between !important;
      align-items: center !important;
      margin-bottom: 15px !important;
      width: 100% !important;
    }

    .occupancy-label {
      display: flex !important;
      flex-direction: column !important;
      align-items: flex-start !important;
      text-align: left !important;
      flex: 1;
    }

    .occupancy-label .occ-title {
      font-weight: bold !important;
      font-size: 0.95rem !important;
      color: #111111 !important;
      margin: 0 !important;
    }

    .occupancy-label .occ-subtitle {
      font-size: 0.75rem !important;
      color: #666666 !important;
      margin: 0 !important;
    }

    .occupancy-counter {
      display: flex !important;
      align-items: center !important;
      gap: 12px !important;
    }

    .counter-btn {
      width: 30px !important;
      height: 30px !important;
      border-radius: 50% !important;
      border: 1px solid #26a69a !important;
      background: #ffffff !important;
      color: #26a69a !important;
      font-size: 1.2rem !important;
      font-weight: bold !important;
      cursor: pointer !important;
      display: flex !important;
      align-items: center !important;
      justify-content: center !important;
      box-sizing: border-box;
    }

    .counter-btn:hover {
      background: #26a69a !important;
      color: #ffffff !important;
    }

    .counter-value {
      font-weight: bold !important;
      font-size: 1rem !important;
      color: #111111 !important;
      min-width: 15px;
      text-align: center;
    }

    .room-type-select {
      width: 90% !important;
      padding: 6px !important;
      margin-top: 5px !important;
      border-radius: 4px !important;
      border: 1px solid #ccc !important;
      font-size: 0.85rem !important;
      background: #fff !important;
      color: #333 !important;
    }

    .child-age-section {
      border-top: 1px dashed #eee;
      padding-top: 10px;
      margin-top: 10px;
    }

    .child-age-row {
      display: flex !important;
      justify-content: space-between !important;
      align-items: center !important;
      font-size: 0.85rem !important;
      color: #333333 !important;
      width: 100%;
    }

    .child-age-select-dynamic {
      width: 50% !important;
      padding: 5px !important;
      border-radius: 4px !important;
      border: 1px solid #ccc !important;
      font-size: 0.85rem !important;
      background: #fff !important;
      color: #333 !important;
    }

    .btn-done {
      width: 100% !important;
      background: #26a69a !important;
      color: #ffffff !important;
      border: none !important;
      padding: 10px !important;
      border-radius: 4px !important;
      cursor: pointer !important;
      font-weight: bold !important;
      font-size: 0.95rem !important;
    }

    .search-box {
      position: relative;
      z-index: 100;
    }

    html, body {
      margin: 0;
      padding: 0;
      height: 100%;
    }

    body {
      display: flex;
      flex-direction: column;
    }

    .content-section {
      flex: 1 0 auto;
      padding-bottom: 50px;
    }

    footer {
      flex-shrink: 0;
      width: 100%;
    }

    /* ĐỊNH NGHĨA KEYFRAMES HỆ THỐNG HIỆU ỨNG QUÉT MÀU */
    @keyframes shineGoldBlack {
      0% { background-position: 200% center; }
      100% { background-position: -200% center; }
    }
    .room-title-shine-active {
      background: linear-gradient(120deg, #ffca28 30%, #121212 50%, #ffca28 70%) !important;
      background-size: 200% auto !important;
      color: transparent !important;
      -webkit-background-clip: text !important;
      background-clip: text !important;
      animation: shineGoldBlack 1.2s linear infinite !important;
      font-weight: 800 !important;
    }
  </style>
</head>
<body>

<div id="loading-overlay">
  <div class="luxury-spinner"></div>
  <div class="loading-text">Hệ thống đang rà soát phòng khả dụng...</div>
</div>

<jsp:include page="header2.jsp" />

<div class="video-bg-content">
  <video autoplay="autoplay" loop="loop" opacity="0.5" muted="muted" playsinline="playsinline">
    <source src="videos/" type="video/mp4">
  </video>
</div>

<div class="header-banner"></div>

<div class="content-section">
  <div class="main-container">

    <div class="search-box">
      <div class="top-meta">
        <div class="toggle-tabs">
          <button class="tab-btn active">Phòng</button>
        </div>
      </div>

      <form action="${pageContext.request.contextPath}/SearchController" method="GET" class="search-form" id="mainSearchForm" style="display: flex; width: 100%; flex-wrap: wrap; gap: 10px;">
        <input type="hidden" name="action" value="viewRooms">
        <input type="hidden" name="destination" value="${destination}">

        <div class="form-group col-3">
          <label class="input-label">Nhận phòng - Trả phòng</label>
          <div class="date-range-picker" style="display: flex; align-items: center; background: rgba(255, 255, 255, 0.1);">
            <i class="fa-solid fa-calendar-days" style="margin-right: 10px; color: #ffca28; padding-left: 5px;"></i>
            <input type="text" id="bookingDateRange" name="dateRange" value="${not empty dateRange ? dateRange : ''}" class="input-text" placeholder="Chọn ngày..." style="background: transparent; border: none; color: #fff; width: 100%; padding: 0; cursor: pointer;">
          </div>
        </div>

        <div class="form-group col-4">
          <label class="input-label">Khoảng giá (VNĐ)</label>
          <div class="price-slider-container">
            <div id="price-slider"></div>
            <div class="price-values">
              <span id="price-min">0đ</span>
              <span id="price-max">0đ</span> <!-- JS sẽ tự render số đẹp -->
            </div>
          </div>
          <input type="hidden" name="minPrice" id="minPrice" value="0">
          <input type="hidden" name="maxPrice" id="maxPrice" value="<%= Math.round((Double)request.getAttribute("maxDbPrice")) %>">
        </div>

        <div class="form-group col-3" style="position: relative;">
          <label class="input-label">Phòng & Người</label>

          <div class="select-custom-wrapper">
            <div class="select-custom" id="occupancyTrigger" style="display: flex; justify-content: space-between; align-items: center; background: rgba(255, 255, 255, 0.1); padding: 10px; border-radius: 4px; cursor: pointer; color: #fff;">
              <span id="occupancyInputText">
    ${not empty param.qtyRooms ? param.qtyRooms : '1'} Phòng,
    ${(not empty qtyAdults ? qtyAdults : 2) + (not empty qtyChildren ? qtyChildren : 0)} Người
</span>
              <i class="fa-solid fa-plus" style="color: #ffca28;"></i>
            </div>

            <div class="occupancy-dropdown" id="occupancyDropdown">
              <div class="occupancy-row">
                <div class="occupancy-label">
                  <span class="occ-title">Người lớn</span>
                  <span class="occ-subtitle">18 tuổi trở lên (Bắt buộc)</span>
                </div>
                <div class="occupancy-counter">
                  <button type="button" class="counter-btn" onclick="changeQty('adult', -1)">-</button>
                  <span class="counter-value" id="count-adult">${not empty qtyAdults ? qtyAdults : 2}</span>
                  <button type="button" class="counter-btn" onclick="changeQty('adult', 1)">+</button>
                </div>
              </div>

              <div class="occupancy-row">
                <div class="occupancy-label">
                  <span class="occ-title">Trẻ em</span>
                  <span class="occ-subtitle">0 - 17 tuổi</span>
                </div>
                <div class="occupancy-counter">
                  <button type="button" class="counter-btn" onclick="changeQty('child', -1)">-</button>
                  <span class="counter-value" id="count-child">${not empty qtyChildren ? qtyChildren : 0}</span>
                  <button type="button" class="counter-btn" onclick="changeQty('child', 1)">+</button>
                </div>
              </div>

              <div class="child-age-section" id="childAgeSection" style="display: none;">
                <div class="occupancy-label" style="margin-bottom: 8px;">
                  <span class="occ-title" style="font-size:0.85rem;">Độ tuổi của trẻ em</span>
                </div>
                <div id="childAgesContainer" style="display: flex; flex-direction: column; gap: 8px;"></div>
              </div>

              <div style="margin-top: 15px;">
                <button type="button" class="btn-done" id="btnOccupancyDone">Xong</button>
              </div>
            </div>
          </div>

          <input type="hidden" name="qtyRooms" id="hiddenRooms" value="1">
          <input type="hidden" name="qtyAdults" id="hiddenAdults" value="${not empty qtyAdults ? qtyAdults : 2}">
          <input type="hidden" name="qtyChildren" id="hiddenChildren" value="${not empty qtyChildren ? qtyChildren : 0}">
        </div>

        <div class="form-group col-2">
          <button type="submit" class="btn-search" style="width: 100%;">Tìm kiếm</button>
        </div>
      </form>
    </div>

    <!-- THANH NÚT SẮP XẾP PHÒNG -->
    <div class="sort-bar" style="margin: 0 0 20px 0; display: flex; align-items: center; gap: 10px; flex-wrap: wrap; background: rgba(0,0,0,0.6); padding: 12px 20px; border-radius: 8px; border: 1px solid rgba(255,202,40,0.3);">
      <span style="color: #ffca28; font-weight: bold; font-size: 0.95rem; margin-right: 5px;">
        <i class="fa-solid fa-sort"></i> Sắp xếp:
      </span>
      <button type="button" class="btn-sort" onclick="sortRooms('price-asc', this)" style="background: rgba(255,255,255,0.1); color: #fff; border: 1px solid #ffca28; padding: 7px 15px; border-radius: 20px; cursor: pointer; font-size: 0.85rem; transition: all 0.3s; font-weight: 500;">
        <i class="fa-solid fa-arrow-up-1-9"></i> Giá: Thấp đến Cao
      </button>
      <button type="button" class="btn-sort" onclick="sortRooms('price-desc', this)" style="background: rgba(255,255,255,0.1); color: #fff; border: 1px solid #ffca28; padding: 7px 15px; border-radius: 20px; cursor: pointer; font-size: 0.85rem; transition: all 0.3s; font-weight: 500;">
        <i class="fa-solid fa-arrow-down-9-1"></i> Giá: Cao xuống Thấp
      </button>
      <button type="button" class="btn-sort" onclick="sortRooms('room-asc', this)" style="background: rgba(255,255,255,0.1); color: #fff; border: 1px solid #ffca28; padding: 7px 15px; border-radius: 20px; cursor: pointer; font-size: 0.85rem; transition: all 0.3s; font-weight: 500;">
        <i class="fa-solid fa-arrow-down-short-wide"></i> Số phòng (101 → 505)
      </button>
      <button type="button" class="btn-sort" onclick="sortRooms('room-desc', this)" style="background: rgba(255,255,255,0.1); color: #fff; border: 1px solid #ffca28; padding: 7px 15px; border-radius: 20px; cursor: pointer; font-size: 0.85rem; transition: all 0.3s; font-weight: 500;">
        <i class="fa-solid fa-arrow-up-wide-short"></i> Số phòng (505 → 101)
      </button>
    </div>

    <div id="rooms-section" class="rooms-grid">
      <%
        List<model.Room> roomsList = (List<model.Room>) request.getAttribute("rooms");
        if (roomsList == null || roomsList.isEmpty()) {
      %>
      <div style="grid-column: 1 / -1; background: rgba(255,255,255,0.1); backdrop-filter: blur(10px); padding: 40px; text-align: center; border-radius: 8px; color: #fff;">
        <p style="font-weight: bold; font-size: 1.2rem;">Rất tiếc, hiện tại khách sạn đã kín phòng hoặc không tìm thấy phòng phù hợp.</p>
        <p style="font-size: 0.9rem; opacity: 0.8;">Vui lòng thử tìm kiếm lại với một ngày khác hoặc nới rộng khoảng giá.</p>
      </div>
      <%
      } else {
        // ĐÃ THÊM LOGIC ĐỂ ĐÁNH DẤU PHÒNG RẺ NHẤT (VỊ TRÍ ĐẦU TIÊN KHI SQL ĐÃ ORDER BY PRICE)
        int roomIndex = 0;
        for (model.Room r : roomsList) {
          String highlightClass = (roomIndex == 0) ? "cheapest-room-highlight" : "";
          roomIndex++;
      %>
      <div class="room-card <%= highlightClass %>" data-price="<%= r.getPrice() %>" data-room-number="<%= r.getRoomNumber() %>">
        <% if (r.getStatus() != null && !r.getStatus().equals("Available")) { %>
        <span class="room-badge"><%= r.getStatus() %></span>
        <% } %>

        <div class="room-thumb">
          <%
            String imgUrl = r.getImage();
            if(imgUrl == null || imgUrl.trim().isEmpty()) {
              imgUrl = "https://images.unsplash.com/photo-1611892440504-42a792e24d32?auto=format&fit=crop&w=500&q=80";
            }
          %>
          <img src="<%= imgUrl %>" alt="Room Image">
          <button class="slide-btn prev-btn"><i class="fa-solid fa-chevron-left"></i></button>
          <button class="slide-btn next-btn"><i class="fa-solid fa-chevron-right"></i></button>
        </div>

        <div class="room-details" onclick="openSubMenu(this)" style="padding: 15px; color: #fff; background: rgba(0, 0, 0, 0.6);">
          <h3 style="margin: 0 0 8px 0; font-size: 1.2rem;">Số phòng: <%= r.getRoomNumber() %></h3>
          <h4 style="margin: 0 0 10px 0; font-size: 1rem; color: #ffca28;"><%= r.getRoomTypeName() %></h4>

          <p style="margin: 0 0 8px 0; font-size: 0.85rem; opacity: 0.9;">
            <i class="fa-solid fa-maximize"></i> Diện tích: <%= r.getArea() %> m²
          </p>

          <div style="display: flex; gap: 15px; font-size: 0.85rem; margin-bottom: 12px; border-bottom: 1px dashed rgba(255,255,255,0.2); padding-bottom: 10px;">
            <span><i class="fa-solid fa-user-tie" style="color: #ffca28;"></i> Tối đa Lớn: <strong><%= r.getMaxAdults() > 0 ? r.getMaxAdults() : r.getMaxPeople() %></strong></span>
            <span><i class="fa-solid fa-child-reaching" style="color: #ffca28;"></i> Tối đa Trẻ: <strong><%= r.getMaxChildren() %></strong></span>
          </div>

          <div style="margin-top: 15px; display: flex; justify-content: space-between; align-items: center;">
            <div>
              <span style="font-size: 0.75rem; display: block; opacity: 0.7;">Giá mỗi đêm:</span>
              <span style="font-size: 1.2rem; font-weight: bold; color: #ff7043;">
                    <%= String.format("%,.0f", r.getPrice()) %> đ
              </span>
            </div>

            <form action="${pageContext.request.contextPath}/BookingController" method="GET" onclick="triggerBookingWithEffect(this, event);">
              <input type="hidden" name="roomId" value="<%= r.getRoomId() %>">
              <input type="hidden" name="roomNumber" value="<%= r.getRoomNumber() %>">
              <input type="hidden" name="price" value="<%= r.getPrice() %>">
              <input type="hidden" name="roomTypeName" value="<%= r.getRoomTypeName() %>">
              <input type="hidden" name="dateRange" value="<%= request.getParameter("dateRange") != null ? request.getParameter("dateRange") : (request.getSession().getAttribute("dateRange") != null ? request.getSession().getAttribute("dateRange") : "") %>">
              <input type="hidden" name="qtyAdults" value="<%= request.getParameter("qtyAdults") != null ? request.getParameter("qtyAdults") : (request.getSession().getAttribute("qtyAdults") != null ? request.getSession().getAttribute("qtyAdults") : "2") %>">
              <input type="hidden" name="qtyChildren" value="<%= request.getParameter("qtyChildren") != null ? request.getParameter("qtyChildren") : (request.getSession().getAttribute("qtyChildren") != null ? request.getSession().getAttribute("qtyChildren") : "0") %>">

              <button type="submit" class="btn-book-room" style="background: #ff7043; color: white; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer; font-weight: bold;">
                Đặt ngay
              </button>
            </form>
          </div>
        </div>

        <div class="room-submenu">
          <button class="btn-submenu-action" onclick="goToReviews('<%= r.getRoomId() %>', event)">
            <i class="fa-solid fa-star"></i> Xem đánh giá
          </button>
          <button class="btn-submenu-close" onclick="closeSubMenu(this, event)">
            Đóng menu
          </button>
        </div>

      </div>
      <%
          }
        }
      %>
    </div>

    <div id="packages-section" class="rooms-grid" style="display: none;">
      <div class="room-card" style="border: 1px solid #ffca28;">
        <span class="room-badge" style="background: #ffca28; color: #000;">Hot Deal Mùa Hè</span>
        <div class="room-thumb">
          <img src="https://images.unsplash.com/photo-1506929562872-bb421503ef21?auto=format&fit=crop&w=600&q=80" alt="Summer Package">
        </div>
        <div class="room-details" style="padding: 20px; color: #fff; background: rgba(0, 0, 0, 0.75);">
          <h3 style="margin: 0 0 5px 0; font-size: 1.4rem; color: #ffca28;">
            <i class="fa-solid fa-sun"></i> Combo Trọn Gói Mùa Hè Rực Rỡ
          </h3>
          <p style="margin: 0 0 15px 0; font-size: 0.9rem; color: #aaa; font-style: italic;">
            Thời gian lưu trú áp dụng: Trọn gói 1 tuần (7 ngày 6 đêm)
          </p>
          <div style="font-size: 0.9rem; line-height: 1.6; margin-bottom: 20px;">
            <div style="margin-bottom: 8px;"><i class="fa-solid fa-hotel" style="color: #ffca28; width: 20px;"></i> <strong>Lưu trú:</strong> 1 tuần nghỉ dưỡng tại hệ thống phòng Suite hướng biển.</div>
            <div style="margin-bottom: 8px;"><i class="fa-solid fa-utensils" style="color: #ffca28; width: 20px;"></i> <strong>Ẩm thực:</strong> Phục vụ đầy đủ trọn gói 3 bữa ăn mỗi ngày.</div>
            <div style="margin-bottom: 8px;"><i class="fa-solid fa-spa" style="color: #ffca28; width: 20px;"></i> <strong>Thư giãn:</strong> Miễn phí dịch vụ Spa & Massage trị liệu phục hồi.</div>
            <div style="margin-bottom: 8px;"><i class="fa-solid fa-gamepad" style="color: #ffca28; width: 20px;"></i> <strong>Giải trí:</strong> Tự do tham gia mọi hoạt động giải trí độc quyền.</div>
          </div>
          <div style="border-top: 1px solid rgba(255,255,255,0.1); padding-top: 15px; display: flex; justify-content: space-between; align-items: center;">
            <div>
              <span style="font-size: 0.75rem; display: block; opacity: 0.7;">Giá trọn gói:</span>
              <span style="font-size: 1.5rem; font-weight: bold; color: #ff7043;">24,000,000 đ</span>
            </div>
            <form action="${pageContext.request.contextPath}/BookingController" method="POST" onclick="event.stopPropagation();">
              <input type="hidden" name="packageId" value="SUMMER_PACKAGE_01">
              <input type="hidden" name="packageName" value="Combo Mua He">
              <input type="hidden" name="price" value="24000000">
              <button type="submit" class="btn-book-room" style="background: #ff7043; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; font-weight: bold; font-size: 1rem;">Đặt Combo</button>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<div style="clear: both;"></div>

<footer><jsp:include page="footer.jsp" /></footer>

<script>
  function openSubMenu(detailsElement) {
    const card = detailsElement.closest('.room-card');
    document.querySelectorAll('.room-submenu').forEach(menu => {
      menu.style.display = 'none';
    });
    const submenu = card.querySelector('.room-submenu');
    if(submenu) submenu.style.display = 'flex';
  }

  function triggerBookingWithEffect(formElement, event) {
    event.preventDefault();
    event.stopPropagation();

    // 1. CHẶN VALIDATE BẮT BUỘC PHẢI CÓ NGÀY
    // 1. CHẶN VALIDATE BẮT BUỘC PHẢI CÓ NGÀY VÀ ĐỦ KHOẢNG THỜI GIAN
    const dateInput = document.getElementById('bookingDateRange').value;
    // Thêm điều kiện !dateInput.includes(" to ") để bắt buộc phải có ngày đi và ngày về
    if (!dateInput || dateInput.trim() === "" || !dateInput.includes(" to ")) {
      alert("⚠️ Lỗi chọn ngày: Bạn phải chọn đầy đủ cả 'Ngày Nhận' và 'Ngày Trả' phòng (Ví dụ: 07/07/2026 to 08/07/2026)!");
      document.getElementById('bookingDateRange').focus();
      return; // Dừng lại, chặn không cho chuyển trang
    }

    // 2. ĐỒNG BỘ DỮ LIỆU TỪ THANH TÌM KIẾM VÀO FORM NÀY (Đề phòng khách đổi ngày/người mà quên bấm nút Tìm kiếm)
    formElement.querySelector('input[name="dateRange"]').value = dateInput;
    formElement.querySelector('input[name="qtyAdults"]').value = document.getElementById('hiddenAdults').value;
    formElement.querySelector('input[name="qtyChildren"]').value = document.getElementById('hiddenChildren').value;

    // 3. KIỂM TRA VÀ GOM TUỔI TRẺ EM TRUYỀN SANG TRANG BOOKING.JSP
    const childInputs = document.querySelectorAll('.child-age-input-dynamic');
    let hasChildAgeError = false;

    // Xóa các input tuổi trẻ em cũ trong form (nếu click nhiều lần)
    formElement.querySelectorAll('.child-age-hidden').forEach(el => el.remove());

    childInputs.forEach((input, index) => {
      const ageString = input.value.trim();
      const isOnlyDigits = /^\d+$/.test(ageString); // Bắt buộc 100% phải là chữ số
      const ageVal = Number(ageString);

      // Thêm cờ !isOnlyDigits vào if
      if (!isOnlyDigits || isNaN(ageVal) || ageVal < 0 || ageVal > 17) {
        hasChildAgeError = true;
        input.style.borderColor = "red";
      } else {
        input.style.borderColor = "#ccc";
        // Tạo input ẩn nhét vào form để mang qua trang booking.jsp
        const hiddenChildAge = document.createElement('input');
        hiddenChildAge.type = 'hidden';
        hiddenChildAge.name = 'childAge_' + (index + 1);
        hiddenChildAge.value = input.value;
        hiddenChildAge.className = 'child-age-hidden';
        formElement.appendChild(hiddenChildAge);
      }
    });

    if (hasChildAgeError) {
      alert("⚠️ Vui lòng nhập đầy đủ và chính xác độ tuổi trẻ em (0-17) trên thanh tìm kiếm!");
      document.getElementById('occupancyDropdown').style.display = 'block';
      return; // Dừng lại
    }

    // 4. HIỆU ỨNG VÀ SUBMIT CHUYỂN QUA BOOKING.JSP
    const card = formElement.closest('.room-card');
    const roomTitle = card.querySelector('.room-details h3');
    if (roomTitle) {
      roomTitle.classList.add('room-title-shine-active');
    }

    setTimeout(() => {
      formElement.submit();
    }, 450);
  }

  function closeSubMenu(buttonElement, event) {
    event.stopPropagation();
    buttonElement.closest('.room-submenu').style.display = 'none';
  }

  function goToReviews(roomId, event) {
    event.stopPropagation();
    window.location.href = "${pageContext.request.contextPath}/ReviewController?roomId=" + roomId;
  }

  // --- 1. Khởi tạo Flatpickr ---
  flatpickr("#bookingDateRange", {
    mode: "range",
    dateFormat: "d/m/Y", // FIX LỖI CRASH: Phải đổi từ "dd/MM/yyyy" thành "d/m/Y"
    minDate: "today",
    locale: { rangeSeparator: " to " }
  });

  // --- 2. Khởi tạo noUiSlider ---
  const slider = document.getElementById('price-slider');
  const minPriceInput = document.getElementById('minPrice');
  const maxPriceInput = document.getElementById('maxPrice');
  const priceMinTxt = document.getElementById('price-min');
  const priceMaxTxt = document.getElementById('price-max');

  // Dòng 505 - Khởi tạo thanh kéo giá động theo Database
  const maxDBPrice = <%= Math.round((Double)request.getAttribute("maxDbPrice")) %>;

  noUiSlider.create(slider, {
    start: [0, maxDBPrice],
    connect: true,
    step: 500000,
    range: { 'min': 0, 'max': maxDBPrice }
  });

  function formatMoney(value) {
    return parseInt(value).toLocaleString('vi-VN') + 'đ';
  }

  slider.noUiSlider.on('update', function (values, handle) {
    const minVal = Math.round(values[0]);
    const maxVal = Math.round(values[1]);
    priceMinTxt.innerText = formatMoney(minVal);
    priceMaxTxt.innerText = formatMoney(maxVal);
    minPriceInput.value = minVal;
    maxPriceInput.value = maxVal;
  });


  // --- 4. XỬ LÝ ẨN/HIỆN VÀ TĂNG GIẢM SỐ NGƯỜI ---
  const occupancyTrigger = document.getElementById('occupancyTrigger');
  const occupancyDropdown = document.getElementById('occupancyDropdown');
  const btnOccupancyDone = document.getElementById('btnOccupancyDone');

  occupancyTrigger.addEventListener('click', function(e) {
    e.stopPropagation();
    const isVisible = occupancyDropdown.style.display === 'block';
    occupancyDropdown.style.display = isVisible ? 'none' : 'block';
  });

  occupancyDropdown.addEventListener('click', function(e) {
    e.stopPropagation();
  });

  document.addEventListener('click', function() {
    occupancyDropdown.style.display = 'none';
  });

  btnOccupancyDone.addEventListener('click', function() {
    occupancyDropdown.style.display = 'none';
  });

  function changeQty(type, change) {
    const countEl = document.getElementById('count-' + type);
    let currentVal = parseInt(countEl.innerText);
    let newVal = currentVal + change;

    if (type === 'room' && newVal < 1) return;
    if (type === 'adult' && newVal < 1) return;
    if (type === 'child' && newVal < 0) return;
    countEl.innerText = newVal;

    if(type === 'room') document.getElementById('hiddenRooms').value = newVal;
    if(type === 'adult') document.getElementById('hiddenAdults').value = newVal;

    if(type === 'child') {
      document.getElementById('hiddenChildren').value = newVal;
      const childAgeSec = document.getElementById('childAgeSection');
      const container = document.getElementById('childAgesContainer');

      // Hiện/ẩn khu vực chọn tuổi
      if (newVal > 0) {
        childAgeSec.style.display = 'block';
      } else {
        childAgeSec.style.display = 'none';
      }

      // Đếm số lượng input tuổi trẻ em đang có hiện tại
      const currentRows = container.querySelectorAll('.child-age-row').length;

      // NẾU TĂNG SỐ TRẺ EM -> Chỉ append thêm row mới, không xóa/ghi đè row cũ
      if (newVal > currentRows) {
        for (let i = currentRows + 1; i <= newVal; i++) {
          const row = document.createElement('div');
          row.className = 'child-age-row';
          row.style.cssText = "display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px; width: 100%; color: #333;";

          row.innerHTML = `
  <span style="font-size: 0.85rem; font-weight: 500; color: #111;">Tuổi trẻ em thứ ` + i + `:</span>
  <input type="number"
         name="childAge_` + i + `"
         class="child-age-input-dynamic"
         value=""
         min="0"
         max="17"
         placeholder="0 - 17"
         style="width: 45%; padding: 6px 10px; border: 1px solid #ccc; border-radius: 4px; font-size: 0.85rem; box-sizing: border-box; outline: none; background: #fff; color: #333;"
         oninput="this.value = this.value.replace(/[^0-9]/g, ''); if(this.value > 17) this.value = 17; if(this.value !== '' && this.value < 0) this.value = 0;">
`;
          container.appendChild(row);
        }
      }
      // NẾU GIẢM SỐ TRẺ EM -> Chỉ xóa bớt row cuối cùng
      else if (newVal < currentRows) {
        for (let i = currentRows; i > newVal; i--) {
          container.lastElementChild.remove();
        }
      }
    }

    const rCount = document.getElementById('count-room').innerText;
    const aCount = parseInt(document.getElementById('count-adult').innerText);
    const cCount = parseInt(document.getElementById('count-child').innerText);
    const totalPeople = aCount + cCount;

    document.getElementById('occupancyInputText').innerText = rCount + " Phòng, " + totalPeople + " Người";
  }

  // =========================================================================
  // ĐOẠN JS ĐƯỢC THÊM MỚI: BẮT SỰ KIỆN SUBMIT FORM TÌM KIẾM ĐỂ VALIDATE & HIỆN LOADING
  // =========================================================================
  document.addEventListener("DOMContentLoaded", function() {

    // =========================================================================
    // THÊM MỚI BẮT ĐẦU TỪ ĐÂY: PHỤC HỒI CÁC Ô NHẬP TUỔI TRẺ EM KHI LOAD TRANG
    // =========================================================================
    const initialChildren = parseInt(document.getElementById('hiddenChildren').value) || 0;

    if (initialChildren > 0) {
      document.getElementById('childAgeSection').style.display = 'block';
      const container = document.getElementById('childAgesContainer');
      container.innerHTML = ""; // Đảm bảo dọn dẹp trước khi vẽ

      // Khai báo đối tượng để đọc các tham số trên URL (như childAge_1, childAge_2...)
      const urlParams = new URLSearchParams(window.location.search);

      for (let i = 1; i <= initialChildren; i++) {
        const row = document.createElement('div');
        row.className = 'child-age-row';
        row.style.cssText = "display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px; width: 100%; color: #333;";

        // Lấy lại tuổi đã nhập trên URL, nếu không có thì để trống
        let pastAge = urlParams.get('childAge_' + i) || "";

        row.innerHTML = `
          <span style="font-size: 0.85rem; font-weight: 500; color: #111;">Tuổi trẻ em thứ ` + i + `:</span>
          <input type="number"
                 name="childAge_` + i + `"
                 class="child-age-input-dynamic"
                 value="` + pastAge + `"
                 min="0"
                 max="17"
                 placeholder="0 - 17"
                 style="width: 45%; padding: 6px 10px; border: 1px solid #ccc; border-radius: 4px; font-size: 0.85rem; box-sizing: border-box; outline: none; background: #fff; color: #333;"
                 oninput="this.value = this.value.replace(/[^0-9]/g, ''); if(this.value > 17) this.value = 17; if(this.value !== '' && this.value < 0) this.value = 0;">
        `;
        container.appendChild(row);
      }
    }
    const mainSearchForm = document.getElementById('mainSearchForm');
    if (mainSearchForm) {
      mainSearchForm.addEventListener('submit', function(e) {
        const dateInput = document.getElementById('bookingDateRange').value;
        // Kiểm tra bắt buộc phải có chuỗi " to "
        if (!dateInput || dateInput.trim() === "" || !dateInput.includes(" to ")) {
          e.preventDefault(); // Chặn load trang
          alert("⚠️ Lỗi tìm kiếm: Vui lòng click chọn 2 ngày khác nhau trên lịch để xác định rõ Ngày Nhận và Ngày Trả phòng!");
          document.getElementById('bookingDateRange').focus();
          return; // Dừng thực thi code bên dưới
        }
        // Lấy tất cả các ô nhập tuổi trẻ em được sinh ra bằng JS
        const childAgeInputs = document.querySelectorAll('.child-age-input-dynamic');
        let isFormValid = true;

        childAgeInputs.forEach(input => {
          const ageString = input.value.trim();
          const isOnlyDigits = /^\d+$/.test(ageString);
          const ageVal = Number(ageString);

          // Kiểm tra nếu để trống, sai định dạng (có chữ), nhỏ hơn 0 hoặc lớn hơn 17
          if (!isOnlyDigits || isNaN(ageVal) || ageVal < 0 || ageVal > 17) {
            isFormValid = false;
            input.style.borderColor = "red";
            input.style.boxShadow = "0 0 5px rgba(255, 0, 0, 0.5)";
          } else {
            input.style.borderColor = "#ccc";
            input.style.boxShadow = "none";
          }
        });

        // Nếu bắt được lỗi, chặn ngay việc submit form
        if (!isFormValid) {
          e.preventDefault();
          alert("⚠️ Cảnh báo từ Verdelle Hotel:\nĐộ tuổi của trẻ em đi cùng bắt buộc phải nằm trong quy định từ 0 đến 17 tuổi. Vui lòng nhập lại chính xác để chúng tôi chuẩn bị phòng tốt nhất cho gia đình bạn!");
          return;
        }

        // Nếu dữ liệu sạch và chuẩn, hiển thị màn hình chờ Luxury Loading Overlay
        document.getElementById('loading-overlay').classList.add('show');
      });
    }
  });

  // =========================================================================
  // BỔ SUNG: HÀM XỬ LÝ SẮP XẾP PHÒNG TỰ ĐỘNG (PRICE & ROOM NUMBER SORTING)
  // =========================================================================
  function sortRooms(criteria, btnElement) {
    const container = document.getElementById('rooms-section');
    if (!container) return;

    const cards = Array.from(container.querySelectorAll('.room-card'));
    if (cards.length === 0) return;

    // Đổi màu highlight cho nút đang được chọn
    document.querySelectorAll('.btn-sort').forEach(btn => {
      btn.style.background = 'rgba(255,255,255,0.1)';
      btn.style.color = '#fff';
    });
    if (btnElement) {
      btnElement.style.background = '#ffca28';
      btnElement.style.color = '#000';
    }

    // Thực hiện sắp xếp danh sách phòng
    cards.sort((a, b) => {
      const priceA = parseFloat(a.getAttribute('data-price')) || 0;
      const priceB = parseFloat(b.getAttribute('data-price')) || 0;

      const roomStrA = (a.getAttribute('data-room-number') || '').trim();
      const roomStrB = (b.getAttribute('data-room-number') || '').trim();

      if (criteria === 'price-asc') {
        return priceA - priceB;
      } else if (criteria === 'price-desc') {
        return priceB - priceA;
      } else if (criteria === 'room-asc') {
        return roomStrA.localeCompare(roomStrB, undefined, { numeric: true, sensitivity: 'base' });
      } else if (criteria === 'room-desc') {
        return roomStrB.localeCompare(roomStrA, undefined, { numeric: true, sensitivity: 'base' });
      }
      return 0;
    });

    // Cập nhật lại vị trí hiển thị trên màn hình
    cards.forEach(card => container.appendChild(card));
  }
</script>

</body>
</html>