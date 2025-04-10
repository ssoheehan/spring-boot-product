package com.daou.product.controller;

import com.daou.product.dto.Order;
import com.daou.product.dto.OrderItem;
import com.daou.product.service.OrderService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Controller
public class OrderController {

    private final OrderService orderService;
    private final ObjectMapper objectMapper;

    @Autowired
    public OrderController(OrderService orderService, ObjectMapper objectMapper) {
        this.orderService = orderService;
        this.objectMapper = objectMapper;
    }

    @RequestMapping("/order/orderSheet")
    public String processOrder(
            @RequestParam("baseProductName") String baseProductName,
            @RequestParam("baseProductPrice") int baseProductPrice,
            @RequestParam("selectedItemsJson") String selectedItemsJson,
            Model model
    ) {
        // JSON -> 자바 객체 변환 (Jackson)
        List<OrderItem> orderItems = new ArrayList<>();
        if (selectedItemsJson != null && !selectedItemsJson.isEmpty()) {
            try {
                OrderItem[] items = objectMapper.readValue(selectedItemsJson, OrderItem[].class);
                orderItems = Arrays.asList(items);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        // 총금액 계산
        int totalPrice = baseProductPrice;
        for (OrderItem item : orderItems) {
            totalPrice += (item.getPrice() * item.getQuantity());
        }

        // 주문서 페이지로 넘길 데이터 세팅
        model.addAttribute("baseProductName", baseProductName);
        model.addAttribute("baseProductPrice", baseProductPrice);
        model.addAttribute("orderItems", orderItems);
        model.addAttribute("totalPrice", totalPrice);

        return "/orderSheet";
    }

    @PostMapping("/order/payment")
    public String processPayment(
            @RequestParam("baseProductName") String baseProductName,
            @RequestParam("baseProductPrice") int baseProductPrice,
            @ModelAttribute Order order,
            Model model) {

        List<OrderItem> orderItems = order.getOrderItems();

        // 총 결제금액 계산 (기본 상품 포함)
        int totalPrice = baseProductPrice;
        if (orderItems != null) {
            for (OrderItem item : orderItems) {
                totalPrice += item.getPrice() * item.getQuantity();
            }
        }

        // 주문(Order) 객체 구성
        order.setBaseProductName(baseProductName);
        order.setBaseProductPrice(baseProductPrice);
        order.setTotalPrice(totalPrice);

//        if (orderItems != null) {
//            for (OrderItem item : orderItems) {
//                order.addOrderItem(item);
//            }
//        }

        // DB에 주문 저장
//        Long orderId = orderService.saveOrder(order);
        // 저장 후 주문 ID를 주문 객체에 세팅 (필요 시)
//        order.setId(orderId);

        // 주문 확인 페이지에 주문 정보를 전달
        model.addAttribute("order", order);
        return "orderComp"; // 주문 확인 페이지
    }
    
}
