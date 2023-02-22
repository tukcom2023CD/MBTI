package tukorea.MBTIbackend.comparison.mapper;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Select;
import tukorea.MBTIbackend.comparison.dto.ProductDto;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface ProductMapper {

    List<ProductDto> getProductList();

    ProductDto getById();


}
