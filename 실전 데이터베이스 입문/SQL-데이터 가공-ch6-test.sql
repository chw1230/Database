use my_shop;

-- 문제1: 상품 할인 가격 계산하기
select
	name, 
    price, 
    price * 0.85 as sale_prcie
from 
	products;

-- 문제2: 고객 정보 보기 좋게 합치기
select 
	concat_ws(' - ' , name , address) as customer_info
from 
	customers;
    
-- 문제3: 상품 설명이 없는 경우 처리하기
select
	COALESCE(description, name) as product_display_info
from products;

-- 문제4: 여러 후보 값 중 유효한 값 선택하기
select 
	name,
    description,
	COALESCE(description, name, '정보 없음') as display_text
from products;

-- 문제5: 이메일 주소 분리 및 분석하기
select
	email,
	SUBSTRING_INDEX(email,'@',1) as user__id,
    char_LENGTH(SUBSTRING_INDEX(email,'@',1)) as id_length
from 
	customers;