<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Verdelle Hotel - Chỉnh Sửa Thông Tin Phòng</title>
    <link rel="stylesheet" href="css/HeaderStyle.css">
    <link rel="stylesheet" href="css/NavStyle.css">
    <link rel="stylesheet" href="css/FooterStyle.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --bg-color: #f4f7f6; --card-bg: #ffffff; --text-color: #333333; --border-color: #e0e0e0; --primary-color: #00bcd4; }
        body.dark-mode { --bg-color: #1a1a1a; --card-bg: #2d2d2d; --text-color: #ffffff; --border-color: #444444; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: var(--bg-color); color: var(--text-color); margin: 0; padding: 0; transition: background-color 0.3s, color 0.3s; }
        .container { max-width: 600px; margin: 40px auto; padding: 0 20px; }
        .form-card { background-color: var(--card-bg); border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); padding: 30px; border: 1px solid var(--border-color); }
        .form-card h2 { margin-top: 0; color: var(--primary-color); font-size: 1.5rem; border-bottom: 2px solid var(--border-color); padding-bottom: 10px; display: flex; align-items: center; gap: 10px; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; font-weight: 600; margin-bottom: 8px; font-size: 0.9rem; }
        .form-control { width: 100%; padding: 10px 12px; border: 1px solid var(--border-color); border-radius: 6px; background-color: var(--bg-color); color: var(--text-color); font-size: 0.9rem; box-sizing: border-box; transition: border-color 0.3s; }
        .form-control:focus { outline: none; border-color: var(--primary-color); }
        .row-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; }
        .btn-group { display: flex; justify-content: flex-end; gap: 12px; margin-top: 25px; }
        .btn { padding: 10px 20px; border-radius: 6px; font-weight: bold; font-size: 0.9rem; cursor: pointer; text-decoration: none; display: inline-flex; align-items: center; gap: 6px; border: none; transition: all 0.3s; }
        .btn-cancel { background-color: transparent; color: var(--text-color); border: 1px solid var(--border-color); }
        .btn-cancel:hover { background-color: rgba(0,0,0,0.05); }
        body.dark-mode .btn-cancel:hover { background-color: rgba(255,255,255,0.05); }
        .btn-submit { background-color: var(--primary-color); color: white; }
        .btn-submit:hover { opacity: 0.9; transform: translateY(-1px); }
    </style>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="container">
    <div class="form-card">
        <h2><i class="fa-solid fa-pen-to-square"></i> Cập Nhật Thông Tin Phòng</h2>

        <form action="quan-ly-phong?action=update" method="POST">
            <input type="hidden" name="roomId" value="${room.roomId}">

            <div class="form-group">
                <label>Mã cấu hình phòng (Room ID)</label>
                <input type="text" class="form-control" value="${room.roomId}" readonly style="background-color: rgba(0,0,0,0.06); cursor: not-allowed; font-weight: bold;">
            </div>

            <div class="form-group">
                <label>Loại phòng (Room Type)</label>
                <input type="text" name="roomTypeName" class="form-control" value="${room.roomTypeName}" required>
            </div>

            <div class="row-grid">
                <div class="form-group">
                    <label>Diện tích (m²)</label>
                    <input type="number" name="area" class="form-control" value="${room.area}" min="1" required>
                </div>
                <div class="form-group">
                    <label>Giá phòng / Đêm (₫)</label>
                    <input type="number" name="price" class="form-control" value="${room.price}" min="0" required>
                </div>
            </div>

            <div class="form-group">
                <label>Sức chứa tối đa (Người)</label>
                <input type="number" name="maxPeople" class="form-control" value="${room.maxPeople}" min="1" required>
            </div>

            <div class="form-group">
                <label>Trạng thái phòng</label>
                <select name="status" class="form-control">
                    <option value="Available" ${room.status == 'Available' ? 'selected' : ''}>Sẵn sàng đón khách</option>
                    <option value="Unavailable" ${room.status != 'Available' ? 'selected' : ''}>Đang bảo trì 🛠️</option>
                </select>
            </div>

            <div class="btn-group">
                <a href="quan-ly-phong" class="btn btn-cancel">Hủy bỏ</a>
                <button type="submit" class="btn btn-submit">
                    <i class="fa-solid fa-floppy-disk"></i> Lưu thay đổi
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    if (localStorage.getItem('theme') === 'dark') { document.body.classList.add('dark-mode'); }
    window.addEventListener('storage', function() {
        if (localStorage.getItem('theme') === 'dark') { document.body.classList.add('dark-mode'); }
        else { document.body.classList.remove('dark-mode'); }
    });
</script>
</body>
<footer>
    <jsp:include page="footer.jsp" />
</footer>
</html>