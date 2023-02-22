package tukorea.MBTIbackend.comparison.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import tukorea.MBTIbackend.comparison.dto.ProductDto;
import tukorea.MBTIbackend.comparison.mapper.ProductMapper;
import tukorea.MBTIbackend.comparison.service.ProductService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
public class ProductController {

    @Autowired
    ProductMapper productMapper;

    private final ProductService productService;

    @RequestMapping(value = "/api/product", method = RequestMethod.GET)
    public List<ProductDto> getProduct() {
        return productService.getProductList();
    }

    @RequestMapping(value = "/api/product/{id}", method = RequestMethod.GET)
    public ProductDto getById(@PathVariable("id") int id) {
        return productMapper.getById();
    }
}
