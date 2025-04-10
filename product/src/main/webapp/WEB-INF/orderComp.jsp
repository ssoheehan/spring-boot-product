<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>주문 확인</title>
    <style>
        table { border-collapse: collapse; width: 600px; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: center; }
        th { background: #f5f5f5; }
        .price { text-align: right; }
    </style>
</head>
<body>
<h2>주문 확인</h2>
<table>
    <thead>
    <tr>
        <th>상품명</th>
        <th>수량</th>
        <th>금액</th>
    </tr>
    </thead>
    <tbody>
    <!-- 기본 상품 -->
    <tr>
        <td>${order.baseProductName} (기본)</td>
        <td>1개</td>
        <td class="price">
            <fmt:formatNumber value="${order.baseProductPrice}" type="number" groupingUsed="true"/>원
        </td>
    </tr>
    <!-- 옵션/추가 상품 -->
    <c:forEach var="item" items="${order.orderItems}">
        <tr>
            <td>${item.name}</td>
            <td>${item.quantity}개</td>
            <td class="price">
                <fmt:formatNumber value="${item.price * item.quantity}" type="number" groupingUsed="true"/>원
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>
<h3>총 결제금액: <fmt:formatNumber value="${order.totalPrice}" type="number" groupingUsed="true"/>원</h3>
</body>
</html>
