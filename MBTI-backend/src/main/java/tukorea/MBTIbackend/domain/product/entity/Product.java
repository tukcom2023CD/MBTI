package tukorea.MBTIbackend.domain.product.entity;

import jakarta.persistence.*;
import lombok.Getter;

@Table(name = "product")
@Getter
@Entity
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private Long productId;

    @Column
    private String allergy;
}
