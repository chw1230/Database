use my_shop2;

-- 문제 1 : 주문별 상품 정보 조회
select
	o.order_id,
    p.name,
    o.quantity
from orders o
join products p on o.product_id = p.product_id
order by order_id;

-- 문제 2 : 3개 테이블 조인하기
select 
	o.order_id,
    u.name as user_name,
    p.name as product_name,
    o.order_date
from orders o
join users u on o.user_id = u.user_id
join products p on o.product_id = p.product_id
where o.status = 'SHIPPED';

-- 문제 3 : 고객병 총 구매액 계산
select
	u.name as user_name,
    sum(o.quantity * p.price) as total_purchase_amout
from orders o 
join products p on o.product_id = p.product_id
join users u on o.user_id = u.user_id
group by user_name
order by total_purchase_amout desc;