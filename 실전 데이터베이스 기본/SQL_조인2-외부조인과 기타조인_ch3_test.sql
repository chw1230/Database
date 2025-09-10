-- 문제와 풀이1
-- 문제1 : 특정 카테고리의 미판매 상품 찾기
select 
	p.name,
    p.price
from products p
left join orders o on p.product_id = o.product_id
where P.category = '전자기기' and o.product_id is null; -- 주문 목록에 상품 id가 없으면 주문 경험 없는 것!

-- 문제2 : 고객별 주문 횟수 구하기 (주문 없는 고객 포함) -> 가장 떠올리기 어려웠음!!
select
	u.name,
    count(o.order_id) as order_count  -- coiunt(*)이면 null 인 경우에도 1개로 취급하기 때문에! -> 주문 안했는데도 1개 주문 한 것으로 되어버림
from users u
left join orders o on u.user_id = o.user_id
group by u.user_id, u.name
order by u.name;

-- 문제3: RIGHT JOIN으로 주문 없는 고객 찾기
select
	u.name,
    u.email
from orders o
right join users u on o.user_id = u.user_id
where o.order_id is null;

-- 문제4: 고객별 주문 상품 목록 조회하기
select 
	u.name as user_name,
    p.name as product_name
from users u        -- users를 기준으로 생각해보기!
left join orders o on o.user_id = u.user_id
left join products p on o.product_id = p.product_id
order by user_name, product_name;

-- 문제와 풀이2 
-- 특정 상사의 부하 직원 찾기
select
	e2.employee_id,
    e2.name,
    e2.manager_id,
    e1.name as manager_name
from employees e1
join employees e2 on e1.employee_id = e2.manager_id
where e1.name = '최과장';
-- e1이 상사를 나타내고, e2가 부하를 나타냄!

-- 문제2: 모든 상품 옵션 조합에 재질 추가하기
-- 실습을 위해서 임시 테이블 생성하고 데이터 넣기
create table materials ( 	
	material varchar(20) primary key
);
insert into materials(material) values ('Cotton'), ('Silk');

select
	concat('기본티셔츠-', c.color, '-', s.size, '-', m.material) as product_full_name,
    s.size,
    c.color,
    m.material
from 
	sizes s
cross join 
	colors c
cross join
	materials m
order by
	s.size, c.color, m.material;
    
-- 문제3: 특정 고객의 주문 내역 상세 조회하기
select 
	u.name as customer_name,
    p.name as product_name,
    o.order_date,
    o.quantity
from 
	users u
join 
	orders o on u.user_id = o.user_id
join 
	products p on o.product_id = p.product_id
where
	u.name = '네이트'
order by
	o.order_date desc;
    
-- 문제4: 서울 지역 고객의 총 주문 금액 계산하기
select
	u.name as customer_name,
    sum( o.quantity * p.price) as total_spent
from 
	users u
join 
	orders o on u.user_id = o.user_id
join 
	products p on o.product_id = p.product_id
where
	u.address like '서울%'
group by 
	u.name
order by 
	total_spent desc;