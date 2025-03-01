-- sub_query DB 생성 및 진입
create database sub_query;
use sub_query;

-- students 테이블 생성
CREATE TABLE students (
	id INTEGER AUTO_INCREMENT, 	-- 아이디(자동으로 1씩 증가)
	name VARCHAR(30), 			-- 이름
	score INTEGER, 				-- 성적
	PRIMARY KEY (id) 			-- 기본키 지정: id
);

-- students 데이터 삽입
INSERT INTO students (name, score)
VALUES
	('엘리스', 85),
	('밥', 78),
	('찰리', 92),
	('데이브', 65),
	('이브', 88);
    
-- 평균 보다 더 높은 점수를 받은 학생 조회
select *
from students
where score > (
	-- 서브 쿼리
    -- 평균 점수 계산
    select avg(score)
    from students
);

use market;

-- select 절 에서의 서브쿼리 실습
select avg(amount)
from payments;

-- select 절 에서의 서브쿼리 실습
select payment_type as '결제 유형',
	amount as '결제 금액',
    amount - (select avg(amount) from payments) as '평균 결제 금액과의 차이'
from payments;
-- 이때 select 절에서 서브쿼리는 단일 값, 즉 하나의 행과 하나의 컬럼을 반환해야 정확히 동작함!

-- from 절에서의 서브쿼리 실습
select order_id, sum(count) as total_count
from order_details
group by order_id;

-- from 절에서의 서브쿼리 실습
-- 메인 쿼리
select avg(sub.total_count) as '1회 주문 시 평균 상품 개수'
from (
	select sum(count) as 'total_count'
    from order_details
    group by order_id
) as sub; -- From 절에 서브 쿼리 넣을 때에는 별칭 지정하기!

-- join 절에서의 서브쿼리 실습
-- 메인 쿼리 : 상품별 주문 개수 집계
select name as '상품명' , sub.total_count as '주문 개수'
from products
join (
	-- 서브 쿼리  : 상품 아이디별 주문 개수 집계
	select product_id , sum(count) as 'total_count'
    from order_details
    group by product_id
) as sub on products.id = sub.product_id; -- 별칭을 통한 JOIN 작성

-- where 절에서의 서브 쿼리 실습
-- 메인 쿼리 : 평균 가격보다 비싼 상품 조회
select name as '상품명' , price as '가격'
from products
where price > (
	-- 서브쿼리 : 상품의 평균 가격 집계
	select avg(price)
    from products
);

-- HAVING 절에서의 서브쿼리 실습
-- 메인쿼리 : 크림 치즈보다 매출이 높은 상품 조회
select name as '상품명', sum(price*count) as '매출'
from products
join order_details on products.id = order_details.product_id
group by name 
having sum(price*count) > (
	-- 서브쿼리 : 크림 치즈 매출 합계 집계
	select sum(price*count) as cream_cheese_sales
    from products
    join order_details on products.id = order_details.product_id and name = '크림 치즈'
);

-- IN 연산자 사용 예시 1
select id
from products
where name in ('우유 식빵','크림 치즈');

-- IN 연산자 사용 예시 2
-- 메인 쿼리 : 우유 식빵과 크림 치즈를 포함하는 모든 주문의 상세 내역 조회
select *
from order_details
where product_id in (
	select id
    from products
    where name in ('우유 식빵','크림 치즈')
);

-- 조인과 In 연산자 실습 <우유 식빵과 크림 치즈를 주문하거나 장바구니에 담은 사용자의 id와 nickname>
select distinct u.id , nickname
from users u
join orders o on u.id = o.user_id
join order_details od on o.id = od.order_id
join products p on od.product_id = p.id ;

-- any 연산자 실습
-- 메인쿼리 : 우유 식빵이나 플레인 베이글보다 저렴한 상품이 있는지 조회
select name 이름, price 가격
from products
where price < any (
	-- 서브쿼리 : 우유 식빵과 플레인 베이글의 가격 조회
	select price
    from products
    where name in ('우유 식빵', '플레인 베이글')
);

-- all 연산자 실습
-- 메인쿼리 : 우유 식빵, 플레인 베이글 2가지 보다 가격이 더 높은 상품이 있는지 조회
select name 이름, price 가격
from products
where price > all (
	-- 서브쿼리 : 우유 식빵과 플레인 베이글의 가격 조회
	select price
    from products
    where name in ('우유 식빵', '플레인 베이글')
);

-- exists 연산자 실습
-- 메인쿼리 : 적어도 한 번은 주문한 사용자 조회
select *
from users u
where exists ( -- 서브 쿼리의 결과 테이블에 하나라도 행이 존재한다면 이를 받은 exists 연산자가 true가 되고, 그 결과 적어도 하나의 주문 기록이 있는 사용자 조회
	-- 서브쿼리 : 주문자 아이디가 사용자 테이블에 있다면 1 반환
    select 1
    from orders o
    where o.user_id = u.id
    -- 주문자id(o.user_id)와 사용자id(u.id) 가 같은 경우 서브쿼리의 결과 테이블에 추가
);
-- 위의 쿼리의 특이점 -> 서브쿼리가 메인쿼리의 값을 참조한다는 것! 서브 쿼리에서 온 값과 메인 쿼리에서 온 값을 같은지 비교하는 과정를 거침!!
-- 이렇게 서브쿼리가 메인쿼리의 특정 값을 참조하는 쿼리를 '상관 쿼리'라고 한다!
-- 상관 쿼리 -> 메인 쿼리의 각 행에 대해 만복 실행되는 서브쿼리로, 서브쿼리가 메인쿼리의 칼럼 값을 참조함 
-- 상관 쿼리는 상호 의존 관례를 가진 메인쿼리와 서브쿼리 간 특정 조건을 만족하는 튜플을 찾는데 사용!!

-- NOT EXISTS 연산자 실습
-- 메인쿼리 : COCOA PAY로 결제하지 않은 사용자 조회
select *
from users u
where NOT exists ( -- 1이 반환 -> 사용했다는 뜻 그래서 사용하지 않은 사람의 정보를 알기 위해 not exists 사용!
	-- 서브쿼리 : COCOA PAY를 사용한 사용자가 있다면  1 반환
    select 1
    from orders o
	join payments on o.id = payments.order_id
    where o.user_id = u.id and payment_type = 'COCOA PAY' -- 주문자 사용자 동일한지 확인 -> 코코아 페이 쓴지 확인
);
