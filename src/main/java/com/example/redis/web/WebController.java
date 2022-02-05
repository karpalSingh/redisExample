package com.example.redis.web;

import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class WebController {

    @GetMapping(path={"/"}, produces = {MediaType.TEXT_HTML_VALUE})
    public String index() {
        return "SpringApplication available";
    }
}
