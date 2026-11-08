<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi Tiết Hóa Đơn Đã Thanh Toán</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #0d0e12;
            color: #ffffff;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        /* Phóng to và tăng shadow cho khung hóa đơn */
        .invoice-card {
            background-color: #16171e;
            border: 1px solid #23242e;
            border-radius: 16px;
            box-shadow: 0 12px 36px rgba(0,0,0,0.6);
            padding: 45px !important; /* Tăng khoảng cách đệm bên trong */
        }
        /* Tăng khoảng cách dòng trong bảng */
        .table-custom td {
            padding: 24px 16px !important;
            vertical-align: middle;
        }
        /* Hiệu ứng hover nhẹ cho các hàng dữ liệu */
        .table-custom tbody tr:hover {
            background-color: rgba(255, 255, 255, 0.02);
        }
        /* Đảm bảo khi in ra giấy (Ctrl + P) chữ vẫn rõ nét */
        @media print {
            body { background-color: #ffffff; color: #000000; }
            .invoice-card { border: none; box-shadow: none; padding: 0 !important; background: #fff; }
            .btn, i { display: none !important; }
            .table-custom td { color: #000000 !important; border-bottom: 1px solid #ccc !important; }
            .text-warning, .text-info, .text-success, .text-danger, .text-light { color: #000000 !important; }
        }
    </style>
</head>
<body>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-9">
            <div class="invoice-card">

                <div class="d-flex justify-content-between align-items-center border-bottom border-secondary pb-4 mb-4">
                    <div>
                        <h2 class="text-warning fw-bold mb-1" style="letter-spacing: 1px;">
                            <i class="fas fa-hotel me-2"></i>VERDELLE LUXURY
                        </h2>
                        <span class="text-muted fs-5">Hóa đơn lưu trữ lịch sử hệ thống</span>
                    </div>
                    <div class="text-end">
                        <span class="fs-4 fw-bold text-light d-block mb-1">HÓA ĐƠN ĐÃ ĐÓNG</span>
                        <span class="badge bg-success text-white px-3 py-2 fs-5">Mã đơn: ${bookingCode}</span>
                    </div>
                </div>

                <table class="table table-dark table-borderless table-custom fs-4 mb-5">
                    <tbody>
                    <tr class="border-bottom border-secondary">
                        <td><i class="fas fa-bed text-info me-3"></i> Tiền thuê phòng gốc:</td>
                        <td class="text-end fw-bold text-info fs-3">
                            <fmt:formatNumber value="${roomCost}" type="number"/> VNĐ
                        </td>
                    </tr>
                    <tr class="border-bottom border-secondary">
                        <td><i class="fas fa-utensils text-success me-3"></i> Tiền sản phẩm dịch vụ tiêu thụ:</td>
                        <td class="text-end fw-bold text-success fs-3">
                            <fmt:formatNumber value="${serviceCost}" type="number"/> VNĐ
                        </td>
                    </tr>
                    <tr class="border-bottom border-secondary">
                        <td><i class="fas fa-exclamation-triangle text-danger me-3"></i> Phí phạt hư hại phòng &amp; nội thất:</td>
                        <td class="text-end fw-bold text-danger fs-3">
                            <fmt:formatNumber value="${damageCost}" type="number"/> VNĐ
                        </td>
                    </tr>
                    <tr class="fs-2">
                        <td class="fw-bold text-warning py-4"><i class="fas fa-coins me-3"></i> TỔNG TIỀN THANH TOÁN:</td>
                        <td class="text-end fw-bold text-warning py-4" style="font-size: 2.2rem;">
                            <fmt:formatNumber value="${grandTotal}" type="number"/> VNĐ
                        </td>
                    </tr>
                    </tbody>
                </table>

                <div class="d-flex justify-content-between pt-2">
                    <a href="reception" class="btn btn-secondary btn-lg px-5 py-3 fs-5 fw-medium">
                        <i class="fas fa-arrow-left me-2"></i> Quay lại Dashboard
                    </a>
                    <button onclick="window.print();" class="btn btn-warning btn-lg px-5 py-3 fs-5 fw-bold text-dark">
                        <i class="fas fa-print me-2"></i> In lại hóa đơn này
                    </button>
                </div>

            </div>
        </div>
    </div>
</div>

</body>
</html>