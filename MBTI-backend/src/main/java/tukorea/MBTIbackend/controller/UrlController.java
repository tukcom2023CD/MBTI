package tukorea.MBTIbackend.controller;

import lombok.extern.slf4j.Slf4j;
import org.jsoup.select.Elements;
import org.springframework.web.bind.annotation.*;
import tukorea.MBTIbackend.domain.Url;
import tukorea.MBTIbackend.service.ProductDataService;

import java.io.IOException;

@Slf4j
@RestController
public class UrlController {

    @PostMapping("/url")
    public Elements Url(@ModelAttribute Url url) throws IOException {
     //   log.info("url = {}", url.getUrl());
        return ProductDataService.getProductDatas(url);
    }
}
