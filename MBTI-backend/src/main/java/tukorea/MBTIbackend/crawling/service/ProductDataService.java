package tukorea.MBTIbackend.crawling.service;

import jakarta.annotation.PostConstruct;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.select.Elements;
import org.springframework.stereotype.Service;
import tukorea.MBTIbackend.crawling.domain.Url;

import java.io.IOException;

@Service
public class ProductDataService {


   // private static String PRODUCT_DATA_URL = "http://www.foodqr.kr/foodqr?PRD_NO=1986030901810";

    @PostConstruct
    public static Elements getProductDatas(Url url) throws IOException {

        String a = url.getUrl();

        Document doc = (Document) Jsoup.connect(a).get();
        Elements myin = doc.getElementsByClass("flt alleRight");
        Elements subs = myin.first().getElementsByTag("PRI_ALLERGEN");

        return myin;

    }
}
