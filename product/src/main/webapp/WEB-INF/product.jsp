<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>옵션 선택 + 추가 상품 선택 + 구매하기</title>
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        .product-item {
            border: 1px solid #ccc;
            padding: 10px;
            margin: 5px 0;
            position: relative;
        }
        .quantity-control { margin-top: 10px; }
        .qty-input { text-align: center; width: 40px; }
        #orderSummary { margin-top: 20px; font-weight: bold; }
        .remove-item {
            cursor: pointer;
            color: red;
            position: absolute;
            bottom: 5px;
            right: 5px;
            font-weight: bold;
        }
        /* 구매하기 버튼 */
        #orderButton {
            margin-top: 20px;
            width: 100%;
            height: 50px;
            background-color: #007bff;
            color: #fff;
            font-size: 16px;
            font-weight: bold;
            border: none;
            cursor: pointer;
        }
    </style>
</head>
<body>
<!-- 기본 상품 정보 -->
<h2>기본 상품 정보</h2>
<div id="baseProduct">
    <p>상품명: NOW Foods, 아연 50mg, 250정</p>
    <p>가격: 10,544원</p>
</div>
<hr>

<!-- 옵션 선택 -->
<h2>옵션 선택</h2>
<select id="optionSelect">
    <option value="">-- 옵션을 선택하세요 --</option>
    <option value="onePlusOne">1+1 묶음상품 (추가 2,025원)</option>
    <option value="giftBox">선물 포장 (추가 1,000원)</option>
</select>
<hr>

<!-- 추가 상품 선택 -->
<h2>추가 상품 선택</h2>
<select id="additionalProduct">
    <option value="">-- 추가 상품을 선택하세요 --</option>
    <option value="multivitamin">멀티비타민 제품</option>
    <option value="vitaminD">비타민D 5000IU</option>
</select>
<hr>

<!-- 선택된 옵션/추가 상품 목록 -->
<h2>선택한 옵션/추가 상품 목록</h2>
<div id="selectedProducts"></div>

<!-- 총 수량 및 총 결제금액 -->
<div id="orderSummary">
    총 수량: <span id="totalQuantity">1</span>개, 총 결제금액: <span id="totalPrice">10,544</span>원
</div>

<!-- 구매하기 버튼을 포함한 form -->
<form id="orderForm" action="/order/orderSheet" method="post">
    <!-- 기본 상품 정보를 hidden으로 넘길 수도 있음 -->
    <input type="hidden" name="baseProductName" value="NOW Foods, 아연 50mg, 250정" />
    <input type="hidden" name="baseProductPrice" value="10544" />

    <!-- 선택된 옵션/추가상품 정보를 JSON 문자열로 담을 hidden 필드 -->
    <input type="hidden" id="hiddenSelectedItems" name="selectedItemsJson" value="" />

    <!-- 구매하기 버튼 -->
    <button type="button" id="orderButton">구매하기</button>
</form>

<script>
    $(document).ready(function(){
        // 기본 상품
        var baseProductName = "NOW Foods, 아연 50mg, 250정";
        var baseProductPrice = 10544;  // 숫자

        // 옵션 상품 데이터
        var optionData = {
            "onePlusOne": {
                "name": "1+1 묶음상품",
                "numericPrice": 2025,
                "price": "2,025원",
                "description": "동일 상품을 하나 더 추가로 받을 수 있는 옵션",
                "gubun": "옵션"
            },
            "giftBox": {
                "name": "선물 포장",
                "numericPrice": 1000,
                "price": "1,000원",
                "description": "선물 포장 옵션",
                "gubun": "옵션"
            }
        };

        // 추가 상품 데이터
        var productData = {
            "multivitamin": {
                "name": "멀티비타민 제품",
                "numericPrice": 10621,
                "price": "10,621원",
                "description": "종합 영양을 위한 멀티비타민",
                "gubun": "메인"
            },
            "vitaminD": {
                "name": "비타민D 5000IU",
                "numericPrice": 25036,
                "price": "25,036원",
                "description": "고함량 비타민D 제품",
                "gubun": "메인"
            }
        };

        // 선택된 상품을 리스트에 추가
        function addProductItem(name, numericPrice, displayPrice, description, gubun) {
            var productHtml =
                '<div class="product-item" data-price="' + numericPrice + '" data-name="' + name + '"data-gubun="' + gubun +'">'
                + '<p class="product-name">상품명: ' + name + '</p>'
                + '<p>가격: ' + displayPrice + '</p>'
                + '<p>설명: ' + description + '</p>'
                + '<div class="quantity-control">'
                + '수량: <button type="button" class="minus-btn">-</button> '
                + '<input type="text" class="qty-input" value="1" /> '
                + '<button type="button" class="plus-btn">+</button>'
                + '</div>'
                + '<span class="remove-item">X</span>'
                + '</div>';
            $('#selectedProducts').append(productHtml);
        }

        // 총 수량 및 총 결제금액 갱신
        function updateOrderSummary(){
            var totalQuantity = 1; // 기본 상품 1개
            var totalPrice = baseProductPrice;

            $('#selectedProducts .product-item').each(function(){
                var price = parseInt($(this).data('price')) || 0;
                var quantity = parseInt($(this).find('.qty-input').val()) || 1;
                totalQuantity += quantity;
                totalPrice += (price * quantity);
            });

            function numberWithCommas(x) {
                return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
            }
            $('#totalQuantity').text(totalQuantity);
            $('#totalPrice').text(numberWithCommas(totalPrice));
        }

        // 옵션 select
        $('#optionSelect').change(function(){
            var selectedKey = $(this).val();
            if(!selectedKey) return;

            var opt = optionData[selectedKey];
            if(opt) {
                // 옵션은 기본 상품명 뒤에 /옵션 형식으로 해도 되지만, 여기서는 그냥 옵션명만
                var combinedName = baseProductName + " / " + opt.name;
                addProductItem(combinedName, opt.numericPrice, opt.price, opt.description, opt.gubun);
                updateOrderSummary();
            }
        });

        // 추가 상품 select
        $('#additionalProduct').change(function(){
            var selectedKey = $(this).val();
            if(!selectedKey) return;

            var p = productData[selectedKey];
            if(p) {
                addProductItem(p.name, p.numericPrice, p.price, p.description, p.gubun);
                updateOrderSummary();
            }
        });

        // 플러스/마이너스/수량 입력 이벤트
        $(document).on('click', '.plus-btn', function(){
            var input = $(this).siblings('.qty-input');
            var currentVal = parseInt(input.val());
            if(currentVal >= 10) {
                alert("최대 구매 가능 수량은 10개 입니다.");
                input.val(10);
            } else {
                input.val(currentVal + 1);
            }
            updateOrderSummary();
        });

        $(document).on('click', '.minus-btn', function(){
            var input = $(this).siblings('.qty-input');
            var currentVal = parseInt(input.val());
            if(currentVal <= 1) {
                alert("최소 구매 수량은 1개 입니다.");
                input.val(1);
            } else {
                input.val(currentVal - 1);
            }
            updateOrderSummary();
        });

        $(document).on('change', '.qty-input', function(){
            var val = parseInt($(this).val());
            if(isNaN(val) || val < 1) {
                alert("최소 구매 수량은 1개 입니다.");
                $(this).val(1);
            } else if(val > 10) {
                alert("최대 구매 가능 수량은 10개 입니다.");
                $(this).val(10);
            }
            updateOrderSummary();
        });

        // 삭제 버튼
        $(document).on('click', '.remove-item', function(){
            $(this).closest('.product-item').remove();
            updateOrderSummary();
        });

        // 구매하기 버튼 클릭
        $('#orderButton').click(function(){
            // 선택된 항목 JSON 구성
            var selectedItems = [];
            $('#selectedProducts .product-item').each(function(){
                var name = $(this).data('name');
                var gubun = $(this).data('gubun');
                var price = parseInt($(this).data('price')) || 0;
                var quantity = parseInt($(this).find('.qty-input').val()) || 1;

                selectedItems.push({
                    name: name,
                    price: price,
                    quantity: quantity,
                    gubun: gubun
                });
            });

            // JSON 문자열로 변환
            var itemsJson = JSON.stringify(selectedItems);
            // hidden 필드에 저장
            $('#hiddenSelectedItems').val(itemsJson);

            // 폼 전송
            $('#orderForm').submit();
        });
    });
</script>
</body>
</html>
