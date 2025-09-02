use my_shop;

-- 산술 연산
-- 각 상품의 재고 자산 총액이 얼마인지 알고 싶다면?
-- SELECT절 안에서 사칙연산 활용하기
select 
	name, price, stock_quantity,
    price * stock_quantity  as total_stock_value -- 계산된 컬럼은 별칭 붙여주기
FROM products;

-- 다양한 산술 연산
select 
	name, price, stock_quantity,
    price + 3000  as expected_price -- 계산된 컬럼은 별칭 붙여주기
FROM products;

select 
	name, price, stock_quantity,
    price - 1000  as discounted_price -- 계산된 컬럼은 별칭 붙여주기
FROM products;

select 
	name, price,
    price / 10  as monthly_payment -- 계산된 컬럼은 별칭 붙여주기
FROM products;

-- 문자열 함수
-- CONCAT() 함수로 문자열 합치기
select concat(name,  '(' , email, ')' ) as name_and_email
from customers;

--  CONCAT_WS(separator, string1, string2, ...) / 첫 번째 인자로 구분자를 받아 각 문자열 사이에 자동으로 넣어준다.alter
select concat_ws('-',name, email, address) as customer_details from customers;

-- upper() / lower()
SELECT email, UPPER(email) AS upper_email 
FROM customers;

-- LENGTH() - 문자열 길이를 바이트 단위로 반환, CHAR_LENGTH() - 글자 수 반환
select name, char_length(name) as char_length, length(name) as byte_length
from customers;

-- NULL 함수
-- NULL 값을 그대로 노출하는 대신, 우리가 원하는 특정 값으로 대체해서 보여줘야 하는 상황이 바로 우리가 해결해야 할 문제
-- ifnull(표현식 1, 표현식 2); -> 표현식 1이 null이 아니면 그대로 표현식 1반환, null이면 표현식 2의 값을 반환
SELECT
	name,
	IFNULL(description, '상품 설명 없음') AS description 
FROM
	products;
    
-- COALESCE(표현식1, 표현식2, ...) / 괄호 안에 여러 개의 인자를 전달할 수 있으며, 좌측 부터 차례대로 확인해서 처음으로 null이 아닌 값을 반환하거나 모두가 null이면 null을 반환한다.
select
	name, 
    coalesce(description, '상품 설명 없음') as description
from 
	products;