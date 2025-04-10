package com.daou.product.interceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.HandlerInterceptor;

public class LoggingInterceptor implements HandlerInterceptor {
    private static final Logger log = LoggerFactory.getLogger(LoggingInterceptor.class);

    // 컨트롤러 실행 전에 호출됨: 시작 시간 기록
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        long startTime = System.currentTimeMillis();
        request.setAttribute("startTime", startTime); // request에 시작 시간을 저장
        return true; // true를 반환하여 다음 인터셉터나 컨트롤러가 호출되도록 함
    }

    // 요청 완료 후 호출됨: 요청 처리 시간 로그
    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
            throws Exception {
        long startTime = (Long) request.getAttribute("startTime"); // 저장해둔 시작 시간
        long endTime = System.currentTimeMillis();
        long duration = endTime - startTime;
        // 필요한 경우 요청 URL, HTTP 메소드, 응답 상태 코드 등 추가 정보를 로깅할 수 있습니다.
        log.info("Request URL: {} | Time Taken: {} ms", request.getRequestURI(), duration);
    }
}
