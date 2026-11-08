package Utils;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class JpaUtils {
    private static EntityManagerFactory emf;

    public static EntityManager getEntityManager() {
        // SỬA: Nếu Factory chưa tạo HOẶC đã bị đóng (!isOpen) thì mới tạo mới
        if (emf == null || !emf.isOpen()) {
            emf = Persistence.createEntityManagerFactory("HotelManagementNEW");
        }
        return emf.createEntityManager();
    }

    public static void closeEntityManager() {
        // SỬA: Phải kiểm tra emf khác null VÀ đồng thời đang mở (&&) thì mới đóng
        if (emf != null && emf.isOpen()) {
            emf.close();
            emf = null;
        }
    }
}