-- 서브 쿼리
use my_shop2;

-- 서브 쿼리 소개
-- 쇼핑몰에서 판매하는 상품들의 평균 가격보다 비싼 상품 찾기
-- 평균 찾기
select avg(price) from products;
-- 평균보다 비싼거 찾기
select name, price
from products
where price > 167166.67;

-- 한번에 할 수는 없나? -> 서브 쿼리 사용
select name, price
from products
where price > (select avg(price) from products);
/* 실행 순서
1. 괄호 안의 서브쿼리 실행 / 2. 값을 얻고 서브 쿼리의 자리를 대신하기 / 3. 바뀐 값으로 쿼리 실행 */

-- 스칼라 서브쿼리
-- 특정 주문 (order_id = 1)인 고객과 같은 도시에 사는 모든 고객을 찾고 싶다.
-- 고객의 주소를 찾기
select u.address
from orders o
join users u on o.user_id = u.user_id
where o.order_id = 1;

select name, address
from users
where address = (select u.address
				from orders o
				join users u on o.user_id = u.user_id
				where o.order_id = 1);
-- 스칼라 서브쿼리의 한계점 : 스칼라 서브쿼리의 결과는 무조건 단 하나의 행만 반환해야하는 것이다! 그래서 보통 pk나 unique 같이 제약 조건이 걸린 컬럼을 대상으로 조회하는 경우가 대부분이다.
-- 그래서 여러 행을 반환하는 경우에는 다중 행 서브쿼리를 사용하면 된다.

-- 다중 행 서브쿼리
-- '전자기기' 카테고리에 속한 모든 상춤들을 주문한 주문 내역을 보고 싶다.
-- 1. 전자기기 카테고리에 속한 상품들의 product_id 찾기
-- 2. orders 테이블에서 product_id가 윌가 찾아낸 product_id 안에 속하면 주문 모두 찾기
select product_id
from products
where category = '전자기기'
order by product_id;

select * from orders
where product_id in (select product_id
					from products
					where category like '전자기기')
order by order_id;

-- ANY와 ALL의 사용
-- 문제 상황1 : '전자기기' 카테고리의 어떤 상품보다도 비싼 상품 찾기 -> 우리가 해야할 것은 뭘까? 전자기기 중 최저가 상품보다 높은 가격이면 조회하면 되는 거임!
select name, price
from products
where price > any( select price
				from products
				where category = '전자기기');
-- 1. 전자기기의 가격을 모두 조회하기 / 2. 전자기기의 가격들 중 가장 작은 값보다 크다면 전자기기 카테고리의 어떤 상품 보다도 비싼 상품을 찾게되는 것!

-- 다중 컬럼 서브쿼리 : 서브쿼리의 select 절에 두 개 이상의 컬럼이 포함되는 경우 -> 메인 쿼리으이 where 절에 여러 컬럼을 동시에 비교하는 경우에 유리
-- 문제 : "우리 쇼핑몰의 고객 '네이트'( user_id =2)가 한 주문( order_id =3)이 있다. 이 주문과 동일한 고객이면서 주문 처리 상태( status )도 같은 모든 주문을 찾아보자."
-- 1. 주문을 통해서 고객과 주문 상태 찾기
select user_id, status
from orders
where order_id = 3; -- 결과 (2, shipped)

-- 2. 모든 주문에서 얻은 정보를 통해서 같은 고객이면서 주문 처리 상태도 같은 경우 찾기
select order_id, user_id, status, order_date
from orders
where (user_id, status) = (select user_id, status
						   from orders
						   where order_id = 3);  -- (user_id, status) = (2, shipped) 비교하는 것임!
                           
-- 기준이 된 주문은 제외하기
select order_id, user_id, status, order_date
from orders
where (user_id, status) = (select user_id, status
						   from orders
						   where order_id = 3) 
      and order_id != 3;

-- 다중 컬럼 서브쿼리와 IN 연산자
-- "각 고객별로 가장 먼저 한 주문의 주문ID, 사용자ID, 사용자이름, 제품이름, 주문 날짜를 조회해라"

-- 먼저 각 고객별로 가장 빠른 주문 날짜를 구하는 서브쿼리를 작성하기
select user_id, min(order_date)
from orders 
group by user_id;
-- 위의 쿼리에 포함되는 데이터를 조회하는 것! 여러개 이니까 그래서 in 을 사용해야 한다! 여기서 반환하는 여러개의 쌍 중 일치하는 쌍이 있어야 조회하는 것 -> in 사용!

-- 위의 데이터를 바탕으로 쿼리 작성하기
select o.order_id, o.user_id, u.name, p.name, o.order_date
from orders o
join users u on o.user_id = u.user_id
join products p on o.product_id = p.product_id
where (o.user_id,o.order_date) in (select user_id, min(order_date)
								  from orders
								  group by user_id);

-- 상관 서브 쿼리 1
/* 지금까지는 서브 쿼리가 결과를 만들면 그것을 메인 쿼리가 이어 받아 사용하는 방식으로 진행이 되었었음!
하지만 만약 '각 상품별로, 자신이 속한 카테고리의 평균 가격 이상의 상품을 찾아라 라고 한다면?'
여기서 문제는 자신이 속한 카테고리의 평균 가격을 구하는데 있다.
이처럼 서브 쿼리가 메인쿼리에서 연재 처리중인 특정 행의 값을 알아야만 계산을 수행할 수 있을 때, 상관 서브쿼리라고 한다. 
이 문제를 해결하려면 products의 테이블의 각 행을 하나씩 확인하면서 비교 대상을 동적으로 바꿔야한다. 
그러면 그때 그때 계산해서 연재 상품의 가격과 비교하는 방법은 무엇일까? 
메인 쿼리가 먼저 한 행을 읽어서 이 값을 서브 쿼리에 전달하고 서브 쿼리가 실행되고, 
서브쿼리의 결과를 이용해서 메인쿼리의 where를 판단하는 방식이다!! */

-- '각 상품별로, 자신이 속한 카테고리의 평균 가격 이상의 상품을 찾아라 '
select
	product_id,
    name,
	category,
    price
from products p1
where price >= (
	select avg(price)
	from products p2
    where p2.category = p1.category); -- 서브 쿼리의 의미 서브 쿼리에서 평균을 계산할 때, 메인 쿼리가 보고 있는 상품(p1)과 동일한 카테고리를 가진 상품들(p2)만을 대상으로 하라는 의미!