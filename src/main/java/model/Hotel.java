package model;

public class Hotel {
    private int id;
    private String name;
    private String city;     // Tên thành phố / Khu vực
    private String address;  // Địa chỉ chi tiết khách sạn
    private int stars;       // Số sao đánh giá (StarRating)
    private double minPrice; // Giá phòng thấp nhất khả dụng

    // Constructor không tham số (Bắt buộc phải có để các Framework hoặc JSTL mapping dữ liệu)
    public Hotel() {}

    // Constructor có đầy đủ tham số
    public Hotel(int id, String name, String city, String address, int stars, double minPrice) {
        this.id = id;
        this.name = name;
        this.city = city;
        this.address = address;
        this.stars = stars;
        this.minPrice = minPrice;
    }

    // GETTER & SETTER
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }

    public String getCity() {
        return city;
    }
    public void setCity(String city) {
        this.city = city;
    }

    public String getAddress() {
        return address;
    }
    public void setAddress(String address) {
        this.address = address;
    }

    public int getStars() {
        return stars;
    }
    public void setStars(int stars) {
        this.stars = stars;
    }

    public double getMinPrice() {
        return minPrice;
    }
    public void setMinPrice(double minPrice) {
        this.minPrice = minPrice;
    }
    // 1. Thêm 3 thuộc tính này vào trong class Hotel
    private int availableSingleRooms;
    private int availableDoubleRooms;
    private int availableFamilyRooms;

    // 2. Thêm các hàm Getter và Setter dưới đây:
    public int getAvailableSingleRooms() {
        return availableSingleRooms;
    }
    public void setAvailableSingleRooms(int availableSingleRooms) {
        this.availableSingleRooms = availableSingleRooms;
    }

    public int getAvailableDoubleRooms() {
        return availableDoubleRooms;
    }
    public void setAvailableDoubleRooms(int availableDoubleRooms) {
        this.availableDoubleRooms = availableDoubleRooms;
    }

    public int getAvailableFamilyRooms() {
        return availableFamilyRooms;
    }
    public void setAvailableFamilyRooms(int availableFamilyRooms) {
        this.availableFamilyRooms = availableFamilyRooms;
    }
}