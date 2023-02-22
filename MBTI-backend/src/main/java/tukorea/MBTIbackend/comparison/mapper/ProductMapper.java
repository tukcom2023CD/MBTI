package tukorea.MBTIbackend.comparison.mapper;

import tukorea.MBTIbackend.comparison.dto.ProductDto;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface ProductMapper {

    List<ProductDto> getProductList();
}
