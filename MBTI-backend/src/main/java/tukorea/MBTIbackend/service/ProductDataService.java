package tukorea.MBTIbackend.service;

import jakarta.annotation.PostConstruct;
import org.jsoup.Jsoup;
import org.springframework.stereotype.Service;

import javax.swing.text.Document;
import java.io.IOException;

@Service
public class ProductDataService {
    private static String PRODUCT_DATA_URL = "http://www.foodqr.kr/foodqr?PRD_NO=1986030901810";

    @PostConstruct
    public void getProductDatas() throws IOException {

        Document doc = (Document) Jsoup.connect(PRODUCT_DATA_URL).get();
        System.out.println(doc);

    }
}
