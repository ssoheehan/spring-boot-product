package com.daou.product.dao;

import com.daou.product.dto.Order;
import com.daou.product.dto.OrderItem;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.sql.Statement;

@Repository
public class OrderDao {

//    private final JdbcTemplate jdbcTemplate;

//    @Autowired
//    public OrderDao(JdbcTemplate jdbcTemplate) {
//        this.jdbcTemplate = jdbcTemplate;
//    }

    public Long saveOrder(Order order) {
        // 주문 정보 저장
        String orderSql = "INSERT INTO orders (base_product_name, base_product_price, total_price) VALUES (?, ?, ?)";
//        KeyHolder keyHolder = new GeneratedKeyHolder();
//        jdbcTemplate.update(connection -> {
//            PreparedStatement ps = connection.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS);
//            ps.setString(1, order.getBaseProductName());
//            ps.setInt(2, order.getBaseProductPrice());
//            ps.setInt(3, order.getTotalPrice());
//            return ps;
//        }, keyHolder);

        Long orderId = 0L;
//        orderId = keyHolder.getKey().longValue();

        // 주문 항목 저장
        String itemSql = "INSERT INTO order_items (order_id, name, price, quantity) VALUES (?, ?, ?, ?)";
//        for (OrderItem item : order.getOrderItems()) {
//            jdbcTemplate.update(itemSql,
//                    orderId,
//                    item.getName(),
//                    item.getPrice(),
//                    item.getQuantity());
//        }
        return orderId;
    }
}
