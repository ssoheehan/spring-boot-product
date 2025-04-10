package com.daou.product.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class OrderItem {
    private Long id;
    private Long orderId; // 주문 테이블의 id와 연결됨
    private String name;
    private int price;
    private int quantity;

}
