package tukorea.MBTIbackend.crawling.service;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import tukorea.MBTIbackend.crawling.domain.Url;

import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
public class ProductDataService {

    private static String PRODUCT_DATA_URL = "http://www.foodqr.kr/foodqr?PRD_NO=1986030901810";

    // @PostConstruct
    @Autowired
    public static String getProductDatas(Url url) throws IOException {

        String pre_allergen = null;
        Document doc = Jsoup.connect(PRODUCT_DATA_URL).get();
        Elements scriptElements = doc.getElementsByTag("script");
        for (Element element : scriptElements) {
            if (element.data().contains("foodLab")) {
                Pattern pattern = Pattern.compile("\"PRI_ALLERGEN\":.*함유\"");
                Matcher matcher = pattern.matcher(element.data());
                // we only expect a single match here so there's no need to loop through the matcher's groups
                if (matcher.find()) {
                    pre_allergen = matcher.group(0);
                    break;
                } else {
                    System.err.println("No match found!");
                }
                break;
            }
        }
        System.out.println(pre_allergen);
        return pre_allergen;
    }
}
