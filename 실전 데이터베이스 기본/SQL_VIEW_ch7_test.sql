use my_shop2;

-- view 문제와 풀이
-- 문제1: 고객의 기본 정보만 보여주는 뷰 생성하기
drop view if exists v_customer_email_list;

-- 뷰 생성
create view v_customer_email_list as
select user_id, name as 고객명, email as 이메일
from users;

select * from v_customer_email_list;

-- 문제2: 주문 상세 정보를 통합한 뷰 생성하기
drop view if exists v_order_summary;

-- 뷰 생성
create view v_order_summary as
select 
	o.order_id, 
    u.name as '고객명',
    p.name as '상품명',
    o.quantity as '주문 수량',
    o.status as '주문상태'
from users u
join orders o on u.user_id = o.user_id
join products p on o.product_id = p.product_id;

select * from v_order_summary;

-- 문제3: '전자기기' 카테고리 매출 분석 뷰 생성하기
drop view if exists v_electronics_sales_status;

create view v_electronics_sales_status as
select 
	p.category,
    count(*) as 'total_orders',
    sum(p.price * o.quantity) as 'total_sales'
from products p
join orders o on p.product_id = o.product_id
where p.category = '전자기기'
group by p.category;

select * from v_electronics_sales_status;

-- 문제4: 기존 뷰에 정보 추가하여 수정하기
select * from v_electronics_sales_status;

-- 총 매출액뿐만 아니라 평균 주문액 추가하기
ALTER VIEW  v_electronics_sales_status as
select 
	p.category,
    count(*) as 'total_orders',
    sum(p.price * o.quantity) as 'total_sales',
    avg(p.price * o.quantity) as 'average_order_value'
from products p
join orders o on p.product_id = o.product_id
where p.category = '전자기기'
group by p.category;


select * from v_electronics_sales_status;
