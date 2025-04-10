package com.daou.product.interceptor;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration // 스프링 컨텍스트에 등록 (Bean으로 등록)
public class WebMvcConfig implements WebMvcConfigurer {

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        // 등록한 인터셉터를 모든 요청에 적용하도록 설정합니다.
        registry.addInterceptor(new LoggingInterceptor())
                .addPathPatterns("/**"); // 특정 URL 패턴만 적용하려면 여기에 패턴을 지정 (예: "/api/**")
    }
}
