package tukorea.MBTIbackend.comparison.service;

import tukorea.MBTIbackend.comparison.dto.ProductDto;

import java.util.List;

public interface ProductService {

    public List<ProductDto> getProductList();

    public ProductDto getById();

}
