package tukorea.MBTIbackend.crawling.controller;

import lombok.extern.slf4j.Slf4j;
import org.jsoup.select.Elements;
import org.springframework.web.bind.annotation.*;
import tukorea.MBTIbackend.comparison.service.ProductService;
import tukorea.MBTIbackend.crawling.domain.Url;
import tukorea.MBTIbackend.crawling.service.ProductDataService;

import java.io.IOException;

@Slf4j
@RestController
public class UrlController {
    @PostMapping("/url")
    public Url responsUrl(@RequestBody Url url) throws IOException {

        return url;
    }
}
