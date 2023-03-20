package tukorea.MBTIbackend.crawling.controller;

import lombok.extern.slf4j.Slf4j;
import org.json.simple.parser.ParseException;
import org.jsoup.select.Elements;
import org.springframework.web.bind.annotation.*;
import tukorea.MBTIbackend.crawling.domain.Url;
import tukorea.MBTIbackend.crawling.service.ProductDataService;

import java.io.IOException;

import static tukorea.MBTIbackend.crawling.service.ProductDataService.getProductDatas;

@Slf4j
@RestController
public class UrlController {
    @PostMapping("/url")
    public String requestUrl(@RequestBody Url url) throws IOException, ParseException {
        return getProductDatas(url.getPrdno());

    }
}
