<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hóa Đơn Thanh Toán - Verdelle Luxury</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --bg-color: #0b0b0e;
            --panel-bg: #14141a;
            --gold-primary: #d4af37;
            --text-dark: #f5f5f7;
            --text-light: #9a9aab;
            --border-color: #22222a;
        }
        body {
            background-color: var(--bg-color);
            color: var(--text-dark);
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            padding: 50px;
            display: flex;
            justify-content: center;
        }
        .invoice-box {
            background: var(--panel-bg);
            border: 1px solid var(--border-color);
            padding: 40px;
            border-radius: 12px;
            width: 100%;
            max-width: 700px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.5);
        }
        .invoice-header {
            display: flex;
            justify-content: space-between;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 20px;
            margin-bottom: 30px;
        }
        .brand-name {
            color: var(--gold-primary);
            font-size: 1.6rem;
            font-weight: bold;
            letter-spacing: 2px;
        }
        .invoice-title {
            font-size: 1.4rem;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .item-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
        }
        .item-table th {
            color: var(--text-light);
            text-transform: uppercase;
            font-size: 0.8rem;
            padding: 12px;
            border-bottom: 2px solid var(--border-color);
            text-align: left;
        }
        .item-table td {
            padding: 15px 12px;
            border-bottom: 1px solid var(--border-color);
        }
        .total-row td {
            font-size: 1.2rem;
            font-weight: bold;
            color: var(--gold-primary);
            border-bottom: none;
            padding-top: 25px;
        }
        .btn-group {
            display: flex;
            gap: 15px;
            justify-content: flex-end;
        }
        .btn {
            padding: 10px 24px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            border: none;
            transition: all 0.3s;
        }
        .btn-print {
            background: linear-gradient(135deg, var(--gold-primary) 0%, #b89327 100%);
            color: #000;
        }
        .btn-back {
            background: #22222a;
            color: #fff;
        }
        .btn:hover { transform: translateY(-2px); }
    </style>
</head>
<body>

<div class="invoice-box">
    <div class="invoice-header">
        <div>
            <div class="brand-name"><i class="fa-solid fa-hotel"></i> VERDELLE</div>
            <p style="color: var(--text-light); margin: 5px 0 0 0;">Mã đơn: BK-${bookingId}</p>
        </div>
        <div class="invoice-title">Hóa Đơn Tổng Kết</div>
    </div>

    <table class="item-table">
        <thead>
        <tr>
            <th>Hạng mục chi phí</th>
            <th style="text-align: center;">Số lượng / Số đêm</th>
            <th style="text-align: right;">Thành tiền</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td>Tiền thuê phòng lưu trú</td>
            <td style="text-align: center;">${nights} đêm</td>
            <td style="text-align: right;">
                <fmt:formatNumber value="${roomCost}" type="number" groupingUsed="true"/> VNĐ
            </td>
        </tr>

        <tr>
            <td>Dịch vụ phát sinh (Minibar, Nhà hàng...)</td>
            <td style="text-align: center;">-</td>
            <td style="text-align: right;">
                <fmt:formatNumber value="${serviceCost}" type="number" groupingUsed="true"/> VNĐ
            </td>
        </tr>

        <tr>
            <td style="color: #ff6666;"><i class="fa-solid fa-triangle-exclamation"></i> Phí đền bù thiệt hại vật tư & kết cấu</td>
            <td style="text-align: center;">-</td>
            <td style="text-align: right; color: #ff6666;">
                <c:choose>
                    <c:when test="${not empty damageCost}">
                        <fmt:formatNumber value="${damageCost}" type="number" groupingUsed="true"/> VNĐ
                    </c:when>
                    <c:otherwise>0 VNĐ</c:otherwise>
                </c:choose>
            </td>
        </tr>

        <tr class="total-row">
            <td colspan="2">TỔNG CỘNG THANH TOÁN:</td>
            <td style="text-align: right;">
                <fmt:formatNumber value="${grandTotal}" type="number" groupingUsed="true"/> VNĐ
            </td>
        </tr>
        </tbody>
    </table>

    <div class="btn-group">
        <button class="btn btn-back" onclick="window.location.href='dashboard'">Quay lại Dashboard</button>
        <button class="btn btn-print" onclick="window.print()"><i class="fa-solid fa-print"></i> In hóa đơn</button>
    </div>
</div>

</body>
</html>