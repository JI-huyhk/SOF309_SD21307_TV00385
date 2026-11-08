package model;

public class Room {
    private int id;
    private int roomId;
    private int hotelId;
    private String roomName;
    private String roomNumber;
    private String roomTypeName;
    private String description;
    private double price;
    private int maxAdults;
    private int maxChildren;
    private int area;
    private String image;
    private boolean hasBathtub;
    private boolean hasBreakfast;
    private boolean isRecommended;
    private String status;
    private int maxPeople;
    private int availableCount;
    private String condition;

    // Constructor mặc định không tham số

    public Room() {
    }

    public Room(int id, int roomId, int hotelId, String roomName, String roomNumber, String roomTypeName, String description, double price, int maxAdults, int maxChildren, int area, String image, boolean hasBathtub, boolean hasBreakfast, boolean isRecommended, String status, int maxPeople, int availableCount, String condition) {
        this.id = id;
        this.roomId = roomId;
        this.hotelId = hotelId;
        this.roomName = roomName;
        this.roomNumber = roomNumber;
        this.roomTypeName = roomTypeName;
        this.description = description;
        this.price = price;
        this.maxAdults = maxAdults;
        this.maxChildren = maxChildren;
        this.area = area;
        this.image = image;
        this.hasBathtub = hasBathtub;
        this.hasBreakfast = hasBreakfast;
        this.isRecommended = isRecommended;
        this.status = status;
        this.maxPeople = maxPeople;
        this.availableCount = availableCount;
        this.condition = condition;
    }

    // Hệ thống Getter và Setter
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getRoomId() { return roomId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }

    public int getHotelId() { return hotelId; }
    public void setHotelId(int hotelId) { this.hotelId = hotelId; }

    public String getRoomName() { return roomName; }
    public void setRoomName(String roomName) { this.roomName = roomName; }

    public String getRoomTypeName() { return roomTypeName; }
    public void setRoomTypeName(String roomTypeName) { this.roomTypeName = roomTypeName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public int getMaxAdults() { return maxAdults; }
    public void setMaxAdults(int maxAdults) { this.maxAdults = maxAdults; }

    public int getMaxChildren() { return maxChildren; }
    public void setMaxChildren(int maxChildren) { this.maxChildren = maxChildren; }

    public int getArea() { return area; }
    public void setArea(int area) { this.area = area; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public boolean isHasBathtub() { return hasBathtub; }
    public void setHasBathtub(boolean hasBathtub) { this.hasBathtub = hasBathtub; }

    public boolean isHasBreakfast() { return hasBreakfast; }
    public void setHasBreakfast(boolean hasBreakfast) { this.hasBreakfast = hasBreakfast; }

    public boolean isRecommended() { return isRecommended; }
    public void setRecommended(boolean recommended) { this.isRecommended = recommended; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getMaxPeople() { return maxPeople; }
    public void setMaxPeople(int maxPeople) { this.maxPeople = maxPeople; }

    public int getAvailableCount() { return availableCount; }
    public void setAvailableCount(int availableCount) { this.availableCount = availableCount; }

    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber;}

    public String getCondition() { return condition; }
    public void setCondition(String condition) { this.condition = condition; }
}