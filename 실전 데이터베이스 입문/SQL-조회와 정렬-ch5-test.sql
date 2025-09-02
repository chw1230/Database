use my_shop;

-- 문제 1 : 특정 열 조회 및 별칭 사용
select name as '상품명', price as '판매가'
from products; 

-- 문제 2 : 간단한 조건으로 필터링하기
select *
from customers
where name = '장영실';

-- 문제 3 : 복합 조건으로 필터링하기 (AND, OR)
select *
from products
where price >= 10000 and stock_quantity < 50;

-- 문제 4 : 특정 범위 및 목록으로 필터링하기 (BETWEEN, IN)
select name, price
from products
where product_id between 2 and 4;
-- SELECT name, price FROM products WHERE product_id IN (2, 3, 4); 이거도 가능

-- 문제 5 : 문자열 패턴으로 검색하기 (like)
select name, address
from customers
where address like '서울특별시%';

-- 문제 6 : null 값 데이터 조회하기 (is null)
select *
from products
where description is null;

-- 문제 7 : 결과 정렬하기 (order by)
select *
from products
order by price desc;

-- 문제 8 : 다중 기준으로 정렬하기
select *
from products
order by price asc, stock_quantity desc;

-- 문제 9 : 조회 결과 개수 제한하기 (LIMIT)
select *
from customers
order by join_date desc limit 2;

-- 문제 10 : 중복 값 제거하여 조회하기 (DISTINCT)
select distinct customer_id, product_id
from orders;

-- 문제 11 : 종합 실전 문제
-- products 테이블에서 가격이 3000원을 초과하고 재고가 100개 이하인 상품들을 대상으로, 재고가 많은 순서대로 
-- 정렬하여 상위 3개의 상품명과 재고 수량을 조회해라 이때 상품명은 '상품 이름'으로, 재고 수량은 '남은 수량'으로 출력해라
select name as `상품 이름`, stock_quantity as `남은 수량`
from products
where price > 3000 and stock_quantity <= 100
order by stock_quantity 
desc limit 3;