package tukorea.MBTIbackend.domain.product.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import tukorea.MBTIbackend.domain.product.dto.ProductResponseDto;
import tukorea.MBTIbackend.domain.product.service.ProductService;

@RequiredArgsConstructor
@RestController
public class ProductController {
    private final ProductService productService;


    @GetMapping("/api/product/{productId}")
    public ProductResponseDto findProductById(@PathVariable Long productId) {
        return productService.findProductByPID(productId);
    }
}
