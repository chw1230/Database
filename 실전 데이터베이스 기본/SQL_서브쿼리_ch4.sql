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
    
-- 상관 서브 쿼리 2
-- 지금까지 단 한번이라도 주문된 적 있는 상품 찾기
select product_id, name, price
from products;

select distinct product_id
from orders;
-- 따로 나누어 조회해보니 1,2,3,4 만 주문이 되었음을 알 수 있음!

-- 쿼리를 하나로 합치기!
select product_id, name, price
from products
where product_id in (select order_id
					from orders);
-- 이렇게 in 을 사용해서 직관적으로 나타낼 수 있음! 하지만 실무에서는 이렇게 사용하지 않는다! orders 테이블이 엄청나게 큰 경우에는 비효율적이다!!
-- 실무에서는 exist 키워드를 사용한다. exist 키워드는 값의 반환이 중요하지 않고, 값의 유무만 체크한다! 존재하면 true 아니면 false
select product_id, name, price
from products p
where exists (select 1 -- 상수를 이용해서 불필요한 데이터 피하기
			from orders o
            where p.product_id = o.product_id); -- 상관 서브 쿼리 사용하기
-- exists는 값이 하나라도 있으면 true 반환해서 바로바로 통과
-- in VS exists 
/*
실행 방식 : In - 서브쿼리의 결과를 메인 쿼리에 가져가서 사용 / Exists - 케인 쿼리의 각 행에 대해서 서브 쿼리를 실행
특징 : In - 서브 쿼리의 결과가 작을 때 직관적이고 빠름 / Exists - 상관 서브쿼리. 서브 쿼리의 테이블이 클 때 효율적
최적화 : orders 테이블 전체를 스캔해야함 / Exists - 값이 하나라도 존재하면 그 즉시 중단하고 1을 반환
*/

-- SELECT 서브쿼리
-- 비상관 서브쿼리
-- 전체 상품의 평균 가격을 모든 행에 함께 표시해서 개별 상품 가격이 평균과 얼마나 차이 나는지 비교

-- 1번 전체 상품의 평균 가격 구하기
select avg(price) from products;

-- 이 쿼리를 select 절에 그대로 넣어보기
select 
	name, 
    price,
    (select avg(price) from products ) as avg_price -- 얘는 스칼라 서브 쿼리임 -> select에 사용하는 서브쿼리는 스칼라 서브 쿼리만 가능함
from 
	products;
/* 쿼리 실행 순서 :
1. select 절의 서브쿼리를 단 하 번 먼저 실행
2. 이 값을 기억하고 메인 쿼리 실행
3. products의 각 행을 가져 올 때 마다, 계산 해둔 값을 가져옴 */
-- 지금 처럼 서브쿼리가 외부 쿼리의 컬럼을 참조하지 않아 독립적으로 실행될 수 있는 경우를 비상관 서브쿼리라고 함!!!! 위에서 배운 것 처럼!

-- 상관 서브쿼리 
-- 전체 상품 목록을 조회하면서, 각 상품별로 총 몇 번의 주문이 있었는지 '총 주문 횟수' 함계 보기
-- 이제 이렇게 된다면 전체 상춤의 평균 처럼 고정된 값이 아니라, 특정 상품의 주문 횟수 가져오고해야하는 것!
select 
	p.product_id,
    p.name,
    p.price,
    (select count(*) from orders o where o.product_id = p.product_id ) as order_count -- 이 서브 쿼리의 가장 중요한 특징, 바깥 쪽 메인 쿼리의 각 행마다 개별적으로, 반복적으로 실행될 수 있다는 점, 서브쿼리가 메인쿼리의 컬럼을 참조하는 관계를 가질 때 이를 상관 서브쿼리 라한다.
from
	products p;
-- 가장 중요한 부분 -> 서브쿼리 안의 where o.product_id = p.product_id => p.product_id 는 현재 p 가 처리하고 있는 행의 product_id를 의미한다.
/* 쿼리 실행 흐름 :
1. 메인 쿼리가 products 테이블의 행을 읽는다
2. 행의 product_count를 계산하기 위해서 스칼라 서브쿼리가 실행된다.
3. 서브쿼리의 p.product_id에 1이라는 값이 전달되고 서브쿼리를 통해서 3이라는 값을 계산한다.
4. 나머지 행들도 그대로 진행한다.
*/
-- 서브 쿼리의 성능 문제 피해갈 수 없다.
-- join으로 해결하자
select 
	p.product_id, p.name, p.price,
    count(o.order_id) as order_count
from 
	products p
left join
	orders o on p.product_id = o.product_id
group by
	p.product_id, p.name, p.price;
    
-- 테이블 서브쿼리 
-- from 절에 위치하는 서브쿼리, 실행결과가 마치 하나의 독립된 가상 테이블처럼 사용 -> 테이블 서브쿼리,
-- 쿼리 내 인라인에서 정의되는 뷰와 같다고 해서 인라인 뷰라고도 부른다.
	
-- 예제 : 각 상품 카테고리 별로, 가장 비싼 상품의 이름과 가격을 조회하기
-- 1단계 : 카테고리 별 가장 비싼 상품 가져오기
select
	category,
    max(price)
from 
	products
group by 
	category;
    
-- 2단계 : 1단계를 바탕으로 가장 비싼 상품의 이름과 가격을 조회하기
select 
	p.product_id,
    p.name,
    p.price
from 
	products p
join 
	( select
	category,
    max(price) as max_price
from 
	products
group by 
	category ) as cmp ON P.category = cmp.category and p.price = cmp.max_price;
-- P.category = cmp.category => 카테고리별로만 비교하도록 맞춰줌 / p.price = cmp.max_price => 그 카테고리 안에서 최고가인 상품 // 둘 다 만족을 해야 join하도록 하기!
-- 서브 쿼리의 결과를 가상 테이블로 여겨서 실행하기!

-- 서브쿼리 VS JOIN
-- 문제 상황 : 서울에 거주하는 모든 고객들의 주문 목록을 조회해라 

-- 서브쿼리 이용하기
-- 1번 서울에 거주하는 고객 찾기
select user_id
from users
where address like '서울%';

-- 2번 그다음, 이 user_id 목록에 포함된 order_id 를 가진 주문들을 찾기
select order_id, product_id, order_date, quantity, status
from orders
where user_id in ( select user_id
				  from users
                  where address like '서울%');
                  
-- join 이용하기
select o.order_id, o.user_id,o.product_id, order_date
from orders o
left join users u on o.user_id = u.user_id
where u.address like '서울%';

-- 성능 비교하기!!!!! => 당연히 join이 더 좋음!
-- 하지만 최근에는 간단한 서브 쿼리는 데이터베이스의 '두뇌' 역할을 하는 쿼리 옵티마이저(Query Optimizer)가 자동으로 join으로 바꿔서 실행하는 경우가 대부분!

-- 가독성 비교하기 : 서브쿼리는 쿼리의 논리적 단계와 단계적으로 이해하는 경우에 좋음!, join은 전체적인 데이터에 대한 정보를 통해 이해나는 경우에 좋음!

-- 그래서 언제 뭘 써야하는 거야?!
/*
정답 : 없음.. 하지만 우선순위 존재
1. join을 우선적으로 고려하자
2. join의 표현 방식이 너무 복잡하면 서브쿼리쓰자
3. in 서브쿼리의 대아능로, existis라는 서브쿼리 연산자 사용도 고려하자( 존재 여부만 체크해서 효율적으로 동작함 )
4. 성능이 의심되면 explain과 같은 도구로 확인해보자
 */