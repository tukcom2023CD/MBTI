package tukorea.MBTIbackend.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;
import tukorea.MBTIbackend.domain.Url;

@Slf4j
@RestController
public class UrlController {

    @PostMapping("/url")
    public String Url(@RequestBody Url url) {
        log.info("url = {}", url.getUrl());
        return "ddd";
    }
}
