package tukorea.MBTIbackend.service;

import jakarta.annotation.PostConstruct;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.stereotype.Service;


import java.io.IOException;

@Service
public class ProductDataService {
    private static String PRODUCT_DATA_URL = "http://www.foodqr.kr/foodqr?PRD_NO=1986030901810";

    @PostConstruct
    public void getProductDatas() throws IOException {

        Document doc = (Document) Jsoup.connect(PRODUCT_DATA_URL).get();
        Elements myin = doc.getElementsByClass("flt alleRight");
        System.out.println(myin);

    }
}
