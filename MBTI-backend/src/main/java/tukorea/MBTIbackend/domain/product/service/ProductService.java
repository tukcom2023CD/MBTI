package tukorea.MBTIbackend.domain.product.service;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import tukorea.MBTIbackend.domain.product.dto.ProductResponseDto;

import java.io.IOException;
import java.util.SimpleTimeZone;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import lombok.AllArgsConstructor;
import lombok.SneakyThrows;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import tukorea.MBTIbackend.domain.product.dto.ProductResponseDto;
import tukorea.MBTIbackend.domain.product.entity.Product;
import tukorea.MBTIbackend.domain.product.repository.ProductRepository;
import java.util.Optional;

@AllArgsConstructor
@Service
public class ProductService {
    private ProductRepository productRepository;

    @SneakyThrows
    @Transactional
    public ProductResponseDto findProductByPID(Long productId) {

        Optional<Product> optionalProduct = productRepository.findProductAllergyByProductId(productId);

        if (optionalProduct.isPresent()) {
            Product product = optionalProduct.get();
            return new ProductResponseDto(product);
        }
        else
            return new ProductResponseDto(getProductDatas(productId));
    }


    private Product getProductDatas(Long productId) throws IOException, ParseException {

        String PRODUCT_DATA_URL = "http://www.foodqr.kr/foodqr?PRD_NO=";

        String pre_allergen = null;
        Document doc = Jsoup.connect(PRODUCT_DATA_URL+productId).get();
        Elements scriptElements = doc.getElementsByTag("script");

        for (Element element : scriptElements) {
            if (element.data().contains("foodLab")) {
                Pattern pattern = Pattern.compile("\"PRI_ALLERGEN\":.*함유\"");
                Matcher matcher = pattern.matcher(element.data());

                if (matcher.find()) {
                    pre_allergen = matcher.group(0);
                    break;
                } else {
                    System.err.println("No match found!");
                }
                break;
            }
        }

        JSONParser parser = new JSONParser();
        JSONObject jsonObject = (JSONObject) parser.parse("{"+pre_allergen+"}");
        String allergy = jsonObject.toJSONString();

        Product product = Product.builder()
                .productId(productId)
                .allergy(allergy)
                .build();

        return productRepository.save(product);
    }

}