package tukorea.MBTIbackend.comparison.service;

import tukorea.MBTIbackend.comparison.dto.ProductDto;
import tukorea.MBTIbackend.comparison.mapper.ProductMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ProductServiceImpl implements ProductService {

    private final ProductMapper productMapper;

    @Override
    public List<ProductDto> getProductList() {

        return productMapper.getProductList();
    }

}
