package tukorea.MBTIbackend.crawling.service;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import tukorea.MBTIbackend.crawling.controller.UrlController;

import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
public class ProductDataService {

    private static String PRODUCT_DATA_URL = "http://www.foodqr.kr/foodqr?PRD_NO=";

    // @PostConstruct
    @Autowired
    public static String getProductDatas(String prdno) throws IOException, ParseException {

        String pre_allergen = null;
        Document doc = Jsoup.connect(PRODUCT_DATA_URL+prdno).get();
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
        //System.out.println(jsonObject.get("PRI_ALLERGEN"));
        return jsonObject.get("PRI_ALLERGEN").toString();

    }
}
