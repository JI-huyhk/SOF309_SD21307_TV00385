<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Trạng Thái Phòng | Verdelle Desk</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --sidebar-width: 260px;
            --bg-color: #0b0b0e;
            --panel-bg: #14141a;
            --sidebar-bg: #09090c;
            --text-light: #9a9aab;
            --text-dark: #f5f5f7;
            --gold-primary: #d4af37;
            --gold-hover: #b89327;
            --border-color: #22222a;

            --color-clean: #10b981;
            --color-dirty: #e67e22;
            --color-repair: #e74c3c;
            --color-maintenance: #3498db;
        }

        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--bg-color);
            color: var(--text-dark);
            display: flex;
            height: 100vh;
            overflow: hidden;
        }

        /* --- SIDEBAR LAYOUT --- */
        .sidebar {
            width: var(--sidebar-width);
            background-color: var(--sidebar-bg);
            color: white;
            display: flex;
            flex-direction: column;
            border-right: 1px solid var(--border-color);
        }

        .sidebar-header {
            padding: 25px 20px;
            text-align: center;
            border-bottom: 1px solid var(--border-color);
            font-size: 1.2rem;
            font-weight: bold;
            color: var(--gold-primary);
            letter-spacing: 2px;
            text-shadow: 0px 2px 4px rgba(0, 0, 0, 0.5);
        }

        .nav-menu {
            list-style: none;
            padding: 0;
            margin: 20px 0;
            display: flex;
            flex-direction: column;
            height: 100%;
        }

        .nav-item {
            padding: 14px 20px;
            display: flex;
            align-items: center;
            gap: 15px;
            color: var(--text-light);
            text-decoration: none;
            transition: all 0.3s ease;
            font-size: 0.95rem;
        }

        .nav-item i { transition: transform 0.3s ease; }

        .nav-item:hover, .nav-item.active {
            background: linear-gradient(90deg, rgba(212, 175, 55, 0.1) 0%, rgba(20, 20, 26, 0) 100%);
            color: #fff;
            border-left: 4px solid var(--gold-primary);
        }

        .nav-item:hover i, .nav-item.active i {
            color: var(--gold-primary);
            transform: scale(1.1);
        }

        /* --- MAIN CONTENT --- */
        .main-content {
            flex: 1;
            padding: 40px;
            overflow-y: auto;
        }
        .page-title { color: #fff; margin: 0 0 8px 0; font-size: 1.8rem; font-weight: 400; }
        .subtitle { color: var(--text-light); font-size: 0.9rem; margin-bottom: 30px; }

        /* --- STATUS GRID LAYOUT --- */
        .status-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 25px;
            margin-bottom: 35px;
        }

        .status-card {
            background: var(--panel-bg);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 25px;
            display: flex;
            flex-direction: column;
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .status-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.4);
        }

        .status-card.clean { border-color: var(--color-clean); box-shadow: 0 4px 15px rgba(16, 185, 129, 0.05); }
        .status-card.dirty { border-color: var(--color-dirty); box-shadow: 0 4px 15px rgba(230, 126, 34, 0.05); }
        .status-card.repair { border-color: var(--color-repair); box-shadow: 0 4px 15px rgba(231, 76, 60, 0.05); }
        .status-card.maintenance { border-color: var(--color-maintenance); box-shadow: 0 4px 15px rgba(52, 152, 219, 0.05); }

        .card-header-box {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .card-header-box h3 { margin: 0; font-size: 2.2rem; font-weight: 600; }
        .clean h3 { color: var(--color-clean); }
        .dirty h3 { color: var(--color-dirty); }
        .repair h3 { color: var(--color-repair); }
        .maintenance h3 { color: var(--color-maintenance); }

        .card-icon {
            width: 50px;
            height: 50px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
        }
        .clean .card-icon { background: rgba(16, 185, 129, 0.1); color: var(--color-clean); }
        .dirty .card-icon { background: rgba(230, 126, 34, 0.1); color: var(--color-dirty); }
        .repair .card-icon { background: rgba(231, 76, 60, 0.1); color: var(--color-repair); }
        .maintenance .card-icon { background: rgba(52, 152, 219, 0.1); color: var(--color-maintenance); }

        .card-title-text {
            font-size: 0.95rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 600;
            color: #fff;
            margin-bottom: 15px;
        }

        .room-list-container {
            flex: 1;
            border-top: 1px solid var(--border-color);
            padding-top: 15px;
            max-height: 220px;
            overflow-y: auto;
        }

        .room-item-tag {
            background: rgba(255, 255, 255, 0.02);
            border: 1px solid var(--border-color);
            border-radius: 6px;
            padding: 10px 12px;
            margin-bottom: 8px;
            font-size: 0.9rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: all 0.3s ease;
        }

        .room-label { font-weight: 600; color: var(--gold-primary); }

        .damage-level {
            font-size: 0.75rem;
            padding: 2px 6px;
            border-radius: 4px;
            background: rgba(231, 76, 60, 0.1);
            color: var(--color-repair);
            border: 1px solid rgba(231, 76, 60, 0.2);
        }

        .room-table-section {
            background: var(--panel-bg);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 25px;
        }
        .table-header-title {
            font-size: 1rem;
            font-weight: 600;
            color: #fff;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .custom-data-table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
            font-size: 0.9rem;
        }
        .custom-data-table th {
            padding: 15px 12px;
            border-bottom: 2px solid var(--border-color);
            color: var(--text-light);
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.8rem;
            letter-spacing: 0.5px;
        }
        .custom-data-table td {
            padding: 16px 12px;
            border-bottom: 1px solid var(--border-color);
            color: #fff;
        }
        .custom-data-table tbody tr:hover {
            background-color: rgba(255, 255, 255, 0.02);
        }

        .condition-dropdown {
            background: #1b1b24;
            padding: 6px 12px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.85rem;
            font-weight: 600;
            outline: none;
            transition: all 0.25s ease;
            border: 1.5px solid transparent;
        }
        .condition-dropdown:focus {
            box-shadow: 0 0 8px rgba(255, 255, 255, 0.1);
        }

        .condition-dropdown.border-clean { border-color: var(--color-clean); color: var(--color-clean); }
        .condition-dropdown.border-dirty { border-color: var(--color-dirty); color: var(--color-dirty); }
        .condition-dropdown.border-damage { border-color: var(--color-repair); color: var(--color-repair); }
        .condition-dropdown.border-repair { border-color: var(--color-maintenance); color: var(--color-maintenance); }

        .opt-clean { color: var(--color-clean); background: #14141a; }
        .opt-dirty { color: var(--color-dirty); background: #14141a; }
        .opt-damage { color: var(--color-repair); background: #14141a; }
        .opt-repair { color: var(--color-maintenance); background: #14141a; }
    </style>
</head>
<body>

<div class="sidebar">
    <div class="sidebar-header">
        <i class="fa-solid fa-hotel"></i> VERDELLE DESK
    </div>
    <div class="nav-menu">
        <a href="${pageContext.request.contextPath}/reception" class="nav-item">
            <i class="fa-solid fa-bed"></i> Sơ đồ phòng & Đặt phòng
        </a>
        <a href="${pageContext.request.contextPath}/checkin-list" class="nav-item">
            <i class="fa-solid fa-address-card"></i> Làm thủ tục Check-in
        </a>
        <a href="${pageContext.request.contextPath}/checkout-list" class="nav-item">
            <i class="fa-solid fa-right-from-bracket"></i> Làm thủ tục Check-out
        </a>
        <a href="${pageContext.request.contextPath}/room-controller" class="nav-item  active">
            <i class="fa-solid fa-door-closed"></i> Quản lý phòng
        </a>
        <a href="${pageContext.request.contextPath}/booking-history" class="nav-item">
            <i class="fa-solid fa-clock-rotate-left"></i> Lịch sử thuê phòng
        </a>
        <a href="${pageContext.request.contextPath}/logout" class="nav-item" style="color: #e74c3c; margin-top: auto;">
            <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
        </a>
    </div>
</div>

<div class="main-content">
    <h2 class="page-title">Quản Lý Trạng Thái Phòng</h2>
    <div class="subtitle">Phân loại chi tiết tình trạng buồng phòng hiện tại dựa trên dữ liệu thời gian thực.</div>

    <div class="status-grid">

        <div class="status-card clean">
            <div class="card-header-box">
                <h3 id="count-clean">
                    <c:set var="cleanCount" value="0"/>
                    <c:forEach var="r" items="${roomList}">
                        <c:if test="${fn:toLowerCase(r.condition) == 'clean'}">
                            <c:set var="cleanCount" value="${cleanCount + 1}"/>
                        </c:if>
                    </c:forEach>
                    ${cleanCount}
                </h3>
                <div class="card-icon"><i class="fa-solid fa-circle-check"></i></div>
            </div>
            <div class="card-title-text">Phòng Sạch (Sẵn Sàng)</div>
            <div class="room-list-container" id="list-clean">
                <c:forEach var="r" items="${roomList}">
                    <c:if test="${fn:toLowerCase(r.condition) == 'clean'}">
                        <div class="room-item-tag" id="tag-room-${r.id}">
                            <span class="room-label">Phòng ${r.roomNumber}</span>
                            <small style="color: var(--color-clean)">${r.status}</small>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
        </div>

        <div class="status-card dirty">
            <div class="card-header-box">
                <h3 id="count-dirty">
                    <c:set var="dirtyCount" value="0"/>
                    <c:forEach var="r" items="${roomList}">
                        <c:if test="${fn:toLowerCase(r.condition) == 'dirty'}">
                            <c:set var="dirtyCount" value="${dirtyCount + 1}"/>
                        </c:if>
                    </c:forEach>
                    ${dirtyCount}
                </h3>
                <div class="card-icon"><i class="fa-solid fa-broom"></i></div>
            </div>
            <div class="card-title-text">Phòng Dơ (Chờ Dọn)</div>
            <div class="room-list-container" id="list-dirty">
                <c:forEach var="r" items="${roomList}">
                    <c:if test="${fn:toLowerCase(r.condition) == 'dirty'}">
                        <div class="room-item-tag" id="tag-room-${r.id}">
                            <span class="room-label">Phòng ${r.roomNumber}</span>
                            <small style="color: var(--color-dirty)">Chờ dọn</small>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
        </div>

        <div class="status-card repair">
            <div class="card-header-box">
                <h3 id="count-damage">
                    <c:set var="damageCount" value="0"/>
                    <c:forEach var="r" items="${roomList}">
                        <c:if test="${fn:toLowerCase(r.condition) == 'damage'}">
                            <c:set var="damageCount" value="${damageCount + 1}"/>
                        </c:if>
                    </c:forEach>
                    ${damageCount}
                </h3>
                <div class="card-icon"><i class="fa-solid fa-triangle-exclamation"></i></div>
            </div>
            <div class="card-title-text">Phòng Hư Hại</div>
            <div class="room-list-container" id="list-damage">
                <c:forEach var="r" items="${roomList}">
                    <c:if test="${fn:toLowerCase(r.condition) == 'damage'}">
                        <div class="room-item-tag" id="tag-room-${r.id}">
                            <span class="room-label">Phòng ${r.roomNumber}</span>
                            <span class="damage-level">Cần kiểm tra</span>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
        </div>

        <div class="status-card maintenance">
            <div class="card-header-box">
                <h3 id="count-underrepair">
                    <c:set var="repairCount" value="0"/>
                    <c:forEach var="r" items="${roomList}">
                        <c:if test="${fn:toLowerCase(r.condition) == 'underrepair'}">
                            <c:set var="repairCount" value="${repairCount + 1}"/>
                        </c:if>
                    </c:forEach>
                    ${repairCount}
                </h3>
                <div class="card-icon"><i class="fa-solid fa-screwdriver-wrench"></i></div>
            </div>
            <div class="card-title-text">Đang Bảo Trì</div>
            <div class="room-list-container" id="list-underrepair">
                <c:forEach var="r" items="${roomList}">
                    <c:if test="${fn:toLowerCase(r.condition) == 'underrepair'}">
                        <div class="room-item-tag" id="tag-room-${r.id}">
                            <span class="room-label">Phòng ${r.roomNumber}</span>
                            <small style="color: var(--color-maintenance)">Sửa chữa cấu trúc</small>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
        </div>

    </div>

    <div class="room-table-section">
        <div class="table-header-title">
            <i class="fa-solid fa-table-list" style="color: var(--gold-primary);"></i> Danh sách chi tiết cấu hình phòng
        </div>
        <div style="overflow-x: auto;">
            <table class="custom-data-table">
                <thead>
                <tr>
                    <th>Số Phòng</th>
                    <th>Loại Phòng</th>
                    <th>Tình Trạng Vệ Sinh</th>
                    <th>Trạng Thái Thuê</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="r" items="${roomList}">
                    <tr>
                        <td style="font-weight: 600; color: var(--gold-primary);">Room ${r.roomNumber}</td>
                        <td style="color: var(--text-light);">${r.roomTypeName != null ? r.roomTypeName : (r.roomName != null ? r.roomName : 'Standard')}</td>
                        <td>
                            <select class="condition-dropdown
                                    <c:choose>
                                        <c:when test="${fn:toLowerCase(r.condition) == 'clean'}">border-clean</c:when>
                                        <c:when test="${fn:toLowerCase(r.condition) == 'dirty'}">border-dirty</c:when>
                                        <c:when test="${fn:toLowerCase(r.condition) == 'damage'}">border-damage</c:when>
                                        <c:otherwise>border-repair</c:otherwise>
                                    </c:choose>"
                                    data-room-id="${r.id}" data-room-number="${r.roomNumber}" data-room-status="${r.status}">

                                <option value="clean" class="opt-clean" ${fn:toLowerCase(r.condition) == 'clean' ? 'selected' : ''}>Sạch sẽ</option>
                                <option value="dirty" class="opt-dirty" ${fn:toLowerCase(r.condition) == 'dirty' ? 'selected' : ''}>Chờ dọn</option>
                                <option value="damage" class="opt-damage" ${fn:toLowerCase(r.condition) == 'damage' ? 'selected' : ''}>Cần kiểm tra</option>
                                <option value="underrepair" class="opt-repair" ${fn:toLowerCase(r.condition) == 'underrepair' ? 'selected' : ''}>Bảo trì</option>
                            </select>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${fn:toLowerCase(r.status) == 'available' || fn:toLowerCase(r.status) == 'trống'}">
                                    <span style="color: var(--color-clean); font-size: 0.85rem;"><i class="fa-solid fa-circle" style="font-size: 0.4rem; margin-right: 6px;"></i> Trống</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: var(--gold-primary); font-size: 0.85rem;"><i class="fa-solid fa-circle" style="font-size: 0.4rem; margin-right: 6px;"></i> ${r.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(document).ready(function() {
        function changeElementBorderClass($el, value) {
            $el.removeClass('border-clean border-dirty border-damage border-repair');
            if (value === 'clean') $el.addClass('border-clean');
            else if (value === 'dirty') $el.addClass('border-dirty');
            else if (value === 'damage') $el.addClass('border-damage');
            else $el.addClass('border-repair');
        }

        // Cập nhật giao diện động realtime không cần F5/reload
        function updateUIRealtime(roomId, roomNumber, oldVal, newVal, roomStatus) {
            // 1. Giảm đếm số phòng trạng thái cũ
            var $oldCount = $('#count-' + oldVal);
            if ($oldCount.length) {
                var curOld = parseInt($oldCount.text()) || 0;
                $oldCount.text(Math.max(0, curOld - 1));
            }

            // 2. Tăng đếm số phòng trạng thái mới
            var $newCount = $('#count-' + newVal);
            if ($newCount.length) {
                var curNew = parseInt($newCount.text()) || 0;
                $newCount.text(curNew + 1);
            }

            // 3. Xóa tag phòng khỏi danh sách cũ
            $('#tag-room-' + roomId).remove();

            // 4. Tạo tag phòng mới và append vào danh sách mới
            var newTagHtml = '';
            if (newVal === 'clean') {
                newTagHtml = '<div class="room-item-tag" id="tag-room-' + roomId + '">' +
                    '<span class="room-label">Phòng ' + roomNumber + '</span>' +
                    '<small style="color: var(--color-clean)">' + (roomStatus || 'Available') + '</small>' +
                    '</div>';
            } else if (newVal === 'dirty') {
                newTagHtml = '<div class="room-item-tag" id="tag-room-' + roomId + '">' +
                    '<span class="room-label">Phòng ' + roomNumber + '</span>' +
                    '<small style="color: var(--color-dirty)">Chờ dọn</small>' +
                    '</div>';
            } else if (newVal === 'damage') {
                newTagHtml = '<div class="room-item-tag" id="tag-room-' + roomId + '">' +
                    '<span class="room-label">Phòng ' + roomNumber + '</span>' +
                    '<span class="damage-level">Cần kiểm tra</span>' +
                    '</div>';
            } else if (newVal === 'underrepair') {
                newTagHtml = '<div class="room-item-tag" id="tag-room-' + roomId + '">' +
                    '<span class="room-label">Phòng ' + roomNumber + '</span>' +
                    '<small style="color: var(--color-maintenance)">Sửa chữa cấu trúc</small>' +
                    '</div>';
            }

            $('#list-' + newVal).append(newTagHtml);
        }

        $(document).on('focus', '.condition-dropdown', function() {
            $(this).data('prev-val', $(this).val());
        });

        $(document).on('change', '.condition-dropdown', function() {
            var $dropdown = $(this);
            var prevValue = $dropdown.data('prev-val');
            var newValue = $dropdown.val();
            var roomId = $dropdown.data('room-id');
            var roomNumber = $dropdown.data('room-number');
            var roomStatus = $dropdown.data('room-status');
            var selectedText = $dropdown.find('option:selected').text();

            var confirmChange = confirm("Xác nhận thay đổi tình trạng vệ sinh Phòng " + roomNumber + " thành [" + selectedText + "]?");

            if (confirmChange) {
                changeElementBorderClass($dropdown, newValue);

                $.ajax({
                    url: '${pageContext.request.contextPath}/room-controller',
                    type: 'POST',
                    data: {
                        action: 'updateCondition',
                        roomId: roomId,
                        condition: newValue
                    },
                    success: function(response) {
                        $dropdown.data('prev-val', newValue);
                        // Cập nhật DOM trực tiếp mượt mà
                        updateUIRealtime(roomId, roomNumber, prevValue, newValue, roomStatus);
                    },
                    error: function() {
                        alert("Lỗi kết nối database! Không thể lưu trạng thái.");
                        $dropdown.val(prevValue);
                        changeElementBorderClass($dropdown, prevValue);
                    }
                });
            } else {
                $dropdown.val(prevValue);
                changeElementBorderClass($dropdown, prevValue);
            }
        });
    });
</script>

</body>
</html>