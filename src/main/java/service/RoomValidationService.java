package service;

import model.Room;

/**
 * =========================================================================
 * RoomValidationService - Lớp nghiệp vụ xác thực dữ liệu phòng khách sạn
 *
 * Mục đích: Tách riêng logic kiểm tra dữ liệu phòng ra khỏi Servlet
 * để có thể viết Unit Test thuần mà không cần kết nối DB / Servlet Container.
 *
 * Ánh xạ với: RoomController.java, PartnerRoomController.java
 * =========================================================================
 */
public class RoomValidationService {

    // =========== HẰNG SỐ QUI TẮC NGHIỆP VỤ PHÒNG ===========
    public static final double PRICE_MIN = 100_000;        // 100.000 VNĐ
    public static final double PRICE_MAX = 100_000_000;    // 100 triệu VNĐ
    public static final int AREA_MIN = 10;                 // 10 m²
    public static final int AREA_MAX = 1000;               // 1.000 m²
    public static final int MAX_PEOPLE_MIN = 1;
    public static final int MAX_PEOPLE_MAX = 20;
    public static final int ROOM_NUMBER_MAX_LENGTH = 10;

    /**
     * Kiểm tra giá phòng hợp lệ:
     * - Phải > 0
     * - Trong khoảng [100.000 - 100.000.000] VNĐ
     */
    public boolean isValidPrice(double price) {
        return price >= PRICE_MIN && price <= PRICE_MAX;
    }

    /**
     * Kiểm tra diện tích phòng hợp lệ (10 - 1000 m²)
     */
    public boolean isValidArea(int area) {
        return area >= AREA_MIN && area <= AREA_MAX;
    }

    /**
     * Kiểm tra số người tối đa hợp lệ (1 - 20 người)
     */
    public boolean isValidMaxPeople(int maxPeople) {
        return maxPeople >= MAX_PEOPLE_MIN && maxPeople <= MAX_PEOPLE_MAX;
    }

    /**
     * Kiểm tra số phòng không được rỗng và không quá dài
     */
    public boolean isValidRoomNumber(String roomNumber) {
        if (roomNumber == null || roomNumber.trim().isEmpty()) return false;
        return roomNumber.trim().length() <= ROOM_NUMBER_MAX_LENGTH;
    }

    /**
     * Kiểm tra loại phòng không được rỗng
     */
    public boolean isValidRoomType(String roomType) {
        return roomType != null && !roomType.trim().isEmpty();
    }

    /**
     * Kiểm tra trạng thái phòng hợp lệ
     */
    public boolean isValidStatus(String status) {
        if (status == null) return false;
        String s = status.trim().toLowerCase();
        return s.equals("available") || s.equals("occupied") || s.equals("maintenance");
    }

    /**
     * Kiểm tra toàn bộ đối tượng Room:
     * @return "" nếu hợp lệ, mã lỗi nếu sai
     */
    public String validateRoom(Room room) {
        if (room == null) return "ROOM_NULL";
        if (!isValidRoomNumber(room.getRoomNumber())) return "ROOM_NUMBER_INVALID";
        if (!isValidRoomType(room.getRoomTypeName())) return "ROOM_TYPE_INVALID";
        if (!isValidPrice(room.getPrice())) return "PRICE_OUT_OF_RANGE";
        if (!isValidArea(room.getArea())) return "AREA_OUT_OF_RANGE";
        if (!isValidMaxPeople(room.getMaxPeople())) return "MAX_PEOPLE_OUT_OF_RANGE";
        if (!isValidStatus(room.getStatus())) return "STATUS_INVALID";
        return "";
    }

    /**
     * Tính giá sau khi áp dụng giảm giá phần trăm
     */
    public double applyDiscount(double originalPrice, double discountPercent) {
        if (discountPercent < 0 || discountPercent > 100) {
            throw new IllegalArgumentException("Phần trăm giảm giá phải trong khoảng 0 - 100");
        }
        return originalPrice * (1 - discountPercent / 100.0);
    }

    /**
     * Tính tổng tiền dựa trên số đêm
     */
    public long calculateTotalPrice(double pricePerNight, int numberOfNights) {
        if (pricePerNight <= 0) {
            throw new IllegalArgumentException("Giá phòng phải lớn hơn 0");
        }
        if (numberOfNights <= 0) {
            throw new IllegalArgumentException("Số đêm phải lớn hơn 0");
        }
        return Math.round(pricePerNight * numberOfNights);
    }
}
