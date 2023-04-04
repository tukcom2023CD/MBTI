package tukorea.MBTIbackend.domain.product.service;

import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import tukorea.MBTIbackend.domain.product.dto.ProductResponseDto;
import tukorea.MBTIbackend.domain.product.entity.Product;
import tukorea.MBTIbackend.domain.product.repository.ProductRepository;
import tukorea.MBTIbackend.crawling.service.ProductDataService;

import java.util.NoSuchElementException;
import java.util.Optional;

import static tukorea.MBTIbackend.crawling.service.ProductDataService.getProductDatas;

@AllArgsConstructor
@Service
public class ProductService {
    private ProductRepository productRepository;

    @Transactional
    public ProductResponseDto findProductByPID(Long productId) {
       // Product product = productRepository.findProductAllergyByProductId(productId).orElseThrow();
       // return new ProductResponseDto(product);

        Optional<Product> optionalProduct = productRepository.findProductAllergyByProductId(productId);
        try {
            if (optionalProduct.isPresent()) {
                Product product = optionalProduct.get();
                return new ProductResponseDto(product);
                // do something with the product
            } else {
               // throw new NoSuchElementException("Product not found with ID: " + productId);
                ProductDataService productDataService = new ProductDataService();
               // Product product = getProductDatas(productId.toString());

            }
        } catch (NoSuchElementException e) {
            // handle the case where the product is not found
            System.out.println(e.getMessage());
        }
        return null;
    }
}
