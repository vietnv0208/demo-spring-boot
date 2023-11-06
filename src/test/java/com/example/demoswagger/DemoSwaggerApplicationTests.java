package com.example.demoswagger;

import java.util.Locale;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.i18n.LocaleContextHolder;
import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
class DemoSwaggerApplicationTests {

    @Test
    void contextLoads() {
        LocaleContextHolder.setLocale(Locale.ENGLISH);

        assertThat("a").isEqualTo("b");
    }

}
