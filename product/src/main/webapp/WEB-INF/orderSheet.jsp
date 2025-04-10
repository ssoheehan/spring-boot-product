<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>주문서 페이지</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        table { border-collapse: collapse; width: 600px; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: center; }
        th { background: #f5f5f5; }
        .price { text-align: right; }
    </style>
</head>
<body>
<h2>주문서</h2>

<!-- 주문 상품 목록 테이블 -->
<table>
    <thead>
    <tr>
        <th>상품명</th>
        <th>수량</th>
        <th>금액</th>
    </tr>
    </thead>
    <tbody>
    <!-- 기본 상품 표시 -->
    <tr>
        <td>${baseProductName} (기본)</td>
        <td>1개</td>
        <td class="price">
            <fmt:formatNumber value="${baseProductPrice}" type="number" groupingUsed="true"/>원
        </td>
    </tr>
    <!-- 옵션/추가 상품 표시 -->
    <c:forEach var="item" items="${orderItems}">
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

<!-- 총 결제금액 -->
<h3>총 결제금액:
    <fmt:formatNumber value="${totalPrice}" type="number" groupingUsed="true"/>원
</h3>

<!-- 결제 진행 버튼 -->
<form id="orderForm" action="/order/payment" method="post">
    <!-- 기본 상품 정보를 hidden으로 넘길 수도 있음 -->
    <input type="hidden" name="baseProductName" value="${baseProductName}" />
    <input type="hidden" name="baseProductPrice" value="${baseProductPrice}" />
    <input type="hidden" name="totalPrice" value="${totalPrice}" />

    <c:forEach var="item" items="${orderItems}" varStatus="status">
        <!-- 상품명, 수량, 가격 등을 name 속성으로 묶어 보내기 -->
        <input type="hidden" name="orderItems[${status.index}].name" value="${item.name}" />
        <input type="hidden" name="orderItems[${status.index}].quantity" value="${item.quantity}" />
        <input type="hidden" name="orderItems[${status.index}].price" value="${item.price}" />
    </c:forEach>
    <!-- 구매하기 버튼 -->
    <button type="button" id="orderButton">결제하기</button>
</form>
<script>
    $(document).ready(function(){
        $('#orderButton').click(function(){
            // 폼 전송
            $('#orderForm').submit();
        });
    });
</script>
</body>
</html>
