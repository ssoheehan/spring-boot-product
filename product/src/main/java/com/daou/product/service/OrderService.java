package com.daou.product.service;

import com.daou.product.dao.OrderDao;
import com.daou.product.dto.Order;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class OrderService {

    private final OrderDao orderDao;

    @Autowired
    public OrderService(OrderDao orderDao) {
        this.orderDao = orderDao;
    }

    public Long saveOrder(Order order) {
        return orderDao.saveOrder(order);
    }
}
