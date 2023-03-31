package tukorea.MBTIbackend.domain.product.service;

import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import tukorea.MBTIbackend.dbconnect.entity.DbEntity;
import tukorea.MBTIbackend.domain.product.dto.ProductResponseDto;
import tukorea.MBTIbackend.domain.product.entity.Product;
import tukorea.MBTIbackend.domain.product.repository.ProductRepository;

import java.util.Optional;

@AllArgsConstructor
@Service
public class ProductService {
    private ProductRepository productRepository;


    @Transactional
    public ProductResponseDto findProductByPID(Long productId) {
        Product product = productRepository.findProductAllergyByProductId(productId).orElseThrow();

        return new ProductResponseDto(product);
    }

}
