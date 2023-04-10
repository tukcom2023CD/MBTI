package tukorea.MBTIbackend.domain.product.service;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.AllArgsConstructor;
import lombok.SneakyThrows;
import tukorea.MBTIbackend.domain.product.entity.Product;
import tukorea.MBTIbackend.domain.product.repository.ProductRepository;
import tukorea.MBTIbackend.domain.product.dto.ProductResponseDto;

import java.io.IOException;
import java.util.NoSuchElementException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
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
            } else
                return new ProductResponseDto(getProductDatas(productId));

    }

    private Product getProductDatas(Long productId) throws IOException, ParseException {

        String PRODUCT_DATA_URL = "http://www.foodqr.kr/foodqr?PRD_NO=";
        String pre_allergen = null;
        String prdlst_nm = null;
        String bssh_nm = null;

        Document doc = Jsoup.connect(PRODUCT_DATA_URL+productId).get();
        Elements scriptElements = doc.getElementsByTag("script");

        for (Element element : scriptElements) {
            if (element.data().contains("foodLab")) {

                Pattern pattern_allergen = Pattern.compile("\"PRI_ALLERGEN\":.*함유\"");
                Matcher matcher_allergen = pattern_allergen.matcher(element.data());

                if (matcher_allergen.find()) {
                    pre_allergen = matcher_allergen.group(0);
                } else {
                    System.err.println("No match found!");
                }

                Pattern pattern_prdlst = Pattern.compile("\"PRDLST_NM\":\"위러브플러스\",\\s*\"P[^\"]*\"");
                Matcher matcher_prdlst = pattern_prdlst.matcher(element.data());

                if (matcher_prdlst.find()) {
                    prdlst_nm = matcher_prdlst.group(0);
                } else {
                    System.err.println("No math found!");
                }

                Pattern pattern_bssh = Pattern.compile("\"BSSH_NM\":\"\\(주\\)풀무원녹즙\",\\s*\"S[^\"]*\"");
                Matcher matcher_bssh = pattern_bssh.matcher(element.data());

                if (matcher_bssh.find()) {
                    bssh_nm = matcher_bssh.group(0);
                } else {
                    System.err.println("No math found!");
                }

                break;
            }
        }

        JSONParser parser = new JSONParser();
        JSONObject jsonObject = (JSONObject) parser.parse("{"+pre_allergen+"}");

        String allergy = (String)jsonObject.get("PRI_ALLERGEN");
        int palength = allergy.length();
        StringBuilder pasb = new StringBuilder(allergy);
        pasb.delete(palength - 3, palength);
        String allergen = pasb.toString();

        int pnlength = prdlst_nm.length();
        StringBuilder pnsb = new StringBuilder(prdlst_nm);
        pnsb.delete(pnlength - 13, pnlength);
        String jsonproductname = pnsb.toString();
        JSONObject pnjsonObject = (JSONObject) parser.parse("{"+jsonproductname+"}");
        String productname = (String)pnjsonObject.get("PRDLST_NM");

        int bnlength = bssh_nm.length();
        StringBuilder bnsb = new StringBuilder(bssh_nm);
        bnsb.delete(bnlength - 12, bnlength);
        String jsonmanufacturer = bnsb.toString();
        JSONObject bnjsonObject = (JSONObject) parser.parse("{"+jsonmanufacturer+"}");
        String manufacturer = (String)bnjsonObject.get("BSSH_NM");

        Product product = Product.builder()
                .productId(productId)
                .allergy(allergen)
                .productname(productname)
                .manufacturer(manufacturer)
                .build();

        return productRepository.save(product);
    }

}