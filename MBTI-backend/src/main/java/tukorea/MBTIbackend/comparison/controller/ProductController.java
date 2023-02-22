package tukorea.MBTIbackend.comparison.controller;

import tukorea.MBTIbackend.comparison.dto.ProductDto;
import tukorea.MBTIbackend.comparison.service.ProductService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
public class ProductController {

    private final ProductService productService;

    @RequestMapping(value = "/api/product", method = RequestMethod.GET)
    public List<ProductDto> getProduct() {
        return productService.getProductList();

    }
}
