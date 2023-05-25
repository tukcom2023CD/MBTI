package tukorea.MBTIbackend.domain.product.entity;

import jakarta.persistence.*;
import lombok.*;

@Table(name = "product")
@Getter
@Setter
@Builder
@Entity
@NoArgsConstructor
@AllArgsConstructor
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private Long productId;

    @Column
    private String allergy;

    @Column
    private String productname;

    @Column
    private String manufacturer;

    @Column
    private String nutrient;
}
