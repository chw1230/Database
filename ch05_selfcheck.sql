use store;

select *
from orders;

-- 1. 상품명이 '국내산'으로 시작하는 주문의 개수
select count(*)
from orders
where name like '국내산%';

-- 2. 주문 수량이 2~4개인 상품의 평균 가격
select avg(price)
from orders
where quantity between 2 and 4;

-- 3. 11월 주문 중 11월 20일 이후에 들어온 주문의 개수
select count(*)
from orders
where month(created_at) = 11 and day(created_at) > 20; 

-- 4. 상품명에 부피 단위인 'ml'과 'l'가 포함된 주문을 모두 조회
select *
from orders
where name like '%ml%' or name like '%l%';

-- 5. 10월과 12월에 들어온 주문의 개수 구하기 (11월은 미포함)
select count(*)
from orders
where month(created_at) in (10,12);