package tukorea.MBTIbackend.domain.product.dto;

import lombok.Getter;
import org.hibernate.boot.archive.scan.internal.ScanResultImpl;
import tukorea.MBTIbackend.domain.product.entity.Product;

@Getter
public class ProductResponseDto {
    private Long productId;
    private String allergy;
    private String productname;
    private String manufacturer;
    private String nutrient;

    public ProductResponseDto(Product product) {
        productId = product.getProductId();
        allergy = product.getAllergy();
        productname = product.getProductname();
        manufacturer = product.getManufacturer();
        nutrient = product.getNutrient();
    }

}
