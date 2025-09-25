use my_shop2;

-- view 

-- 지난번에 만든 쿼리 
select
	p.category,
    count(*) as total_orders,
    sum( case when o.status = 'COMPLETED' then 1 else 0 end) as completed_count,
    sum( case when o.status = 'SHIPPED' then 1 else 0 end) as shipped_count,
    sum( case when o.status = 'PENDING' then 1 else 0 end) as pending_count
from 
	orders o
join 
	products p on o.product_id = p.product_id
group by 
	p.category;
    
-- view 사용이유 
/*
편리성 : 복잡한 쿼리를 간단하게 재사용
보안성 : 원본 테이블에 대한 접근 권한을 직접 주는 것이 아니라, view를 통해서만 접근하여 뷰를 통해서만 제한된 데이터에만 접근하도록 허용
논리적 독립성 : 뷰가 중간에서 변화를 흡수하는 추상화 계층 역할을 하기 때문!
*/
-- view의 생성, 조회, 수정, 삭제
-- 생성
drop view if exists v_category_order_statud;
create view v_category_order_status as
select
	p.category,
	count(*) as total_orders,
    sum( case when o.status = 'COMPLETED' then 1 else 0 end) as completed_count,
    sum( case when o.status = 'SHIPPED' then 1 else 0 end) as shipped_count,
    sum( case when o.status = 'PENDING' then 1 else 0 end) as pending_count
from 
	orders o
join 
	products p on o.product_id = p.product_id
group by 
	p.category;
-- select 쿼리 자체를 담고 있는 view를 생성
    
-- 조회
select * from v_category_order_status;

-- 수정
alter view v_category_order_status as 
select
	p.category,
    sum( p.price * o.quantity ) as total_sales,
    count(*) as total_orders,
    sum( case when o.status = 'COMPLETED' then 1 else 0 end) as completed_count,
    sum( case when o.status = 'SHIPPED' then 1 else 0 end) as shipped_count,
    sum( case when o.status = 'PENDING' then 1 else 0 end) as pending_count
from 
	orders o
join 
	products p on o.product_id = p.product_id
group by 
	p.category;
    
select * from v_category_order_status;

-- 삭제 
drop view v_category_order_status;

-- 뷰의 장점과 단점 
/* 
장점 : 
편리성과 재사용성 : 복잡한 쿼리를 뷰 뒤에 숨겨 이용하며 편이성과 재사용성을 느낄 수 있음
보안성 : 뷰를 통해서 섬세한 '권한 제어'가 가능 사용자에게 원본 테이블에 직접 권한을 주지 않고도, 그들이 꼭 봐야할 데이터만 안전하게 노출이 가능!
논리적 데이터 독립성 : 추상화 계층 역할을 중간에서 하며 물리적 테이블의 변화를 숨겨주는 방패 역할을 한다. 

단점과 주의 사항 :
성능 문제 : 간단한 뷰 뒤에 엄청나게 무거운 쿼리가 있을 수 있음, 최적화 하는데 어려움
업데이트 제약 : 수정 불가(join, 집계함수)등을 사용한 복잡한 뷰는 insert, update, delete가 불가능!, 수정 가능 - 뷰가 오직 하나의 기본 테이블만을 참조하고, 뷰의 모든 컬럼이 기본 테이블의 실제 컴럼을 직접 참조하는 경우에는 뷰에 데이터를 추가 수정할 수 있음, 실무 규칙 - 뷰는 기본적으로 조회용으로 사용!!!!