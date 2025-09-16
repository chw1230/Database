-- 서브 쿼리 문제와 풀이
use my_shop2;

-- 문제 1 : 가장 비싼 상품 조회하기
select 
	product_id as '상품 ID', 
    name as '상품명',
    price as '가격'
from 
	products
where 
	price = ( select max(price) from products ); -- where 절의 스칼라 서브쿼리 사용해서 구해보기~
    
-- 문제 2 : 동일 상품 주문 정보 조회하기
select
	o.order_id as '주문 ID',
    o.user_id as '고객 ID',
    o.order_date as '주문 일시'
from 
	orders o
where 
	o.product_id = ( select product_id
					 from orders 
					where order_id = 1 )  -- 동일한 상품
	and o.order_id != 1; -- 찾는 조건은 안나도록 하려면 이 설정 해주기!
    
-- 문제 3 : 고객별 총 주문 횟수 조회하기
select count(*)
from orders
where user_id = 4;

select 
	u.name as '고객명',
    ( select count(*)
	  from orders o
	  where o.user_id = u.user_id ) as '총주문횟수'
from 
	users u
order by
	user_id;
	