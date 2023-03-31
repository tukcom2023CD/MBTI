package tukorea.MBTIbackend.domain.product.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import tukorea.MBTIbackend.domain.product.entity.Product;

import java.util.Optional;

public interface ProductRepository extends JpaRepository<Product, Long> {
    @Query("select p from Product p where p.productId = :productId")
    Optional<Product> findProductByProductId(@Param("productId") Integer productId);
}
