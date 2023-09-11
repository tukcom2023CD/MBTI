package tukorea.MBTIbackend.domain.product.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import tukorea.MBTIbackend.domain.product.entity.Product;

import java.util.Optional;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {
    @Query("select p from Product p where p.productId = :productId")
    Optional<Product> findProductAllergyByProductId(@Param("productId") Long productId);
}