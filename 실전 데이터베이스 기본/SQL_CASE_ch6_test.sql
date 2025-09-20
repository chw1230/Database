use my_shop2;

-- 문제와 풀이
-- 문제1 : 상품 카테고리 영문으로 표기하기
select
	name,
    category,
    case category
		when '전자기기' then 'Electronics'
        when '도서' then 'Books'
        when '패션' then 'Fashion'
        else 'etc'
	end as category_english
from products;
-- simple case 적용해서 문제 해결하기

-- 문제2: 주문 수량에 따른 분류 및 정렬
select 
	order_id,
    quantity,
    case 
		when quantity >= 2 then '다량 주문'
		else '단일 주문' 
	end as order_type
from orders
order by 
	case 
		when quantity >= 2 then 1
		else 2
	end asc;
-- 

-- 문제3: 재고 수준별 상품 수 집계하기
select
    case 
		when stock_quantity >= 50 then '재고 충분'
        when stock_quantity >= 20 then '재고 보통'
        else '재고 부족'
	end as stock_level,
    count(*) as product_count
from products
group by 
	case 
		when stock_quantity >= 50 then '재고 충분'
        when stock_quantity >= 20 then '재고 보통'
        else '재고 부족'
	end;
    
/* 별명으로 group by 하기
select
    case 
		when stock_quantity >= 50 then '재고 충분'
        when stock_quantity >= 20 then '재고 보통'
        else '재고 부족'
	end as stock_level,
    count(*) as product_count
from products
group by 
	stock_level; */
    
-- 문제4 : 사용자별 카테고리 주문 건수 피벗 테이블 만들기
select 
	u.name AS user_name, 
    count(o.order_id) as total_orders,
    sum( CASE WHEN p.category = '전자기기' then 1 else 0 end ) as electronics_orders,
    sum( CASE WHEN p.category = '도서' then 1 else 0 end ) as book_orders,
    sum( CASE WHEN p.category = '패션' then 1 else 0 end ) as fashion_orders
from users u
left join orders o on u.user_id = o.user_id
left join products p on o.product_id = p.product_id
group by u.name; 
/*
생각 : 일단 뭐가 필요한지 생각하자! 
1. 전체 사용자가 카테고리별로 몇 건의 주문을 했는지 알아야함! -> 그러면 users, orders, products 모두를 조인 해야함!
2. 그러면 어떤 join을 쓸래? -> 주문 하지 않은 고객도 결과에 넣을래 => left join 쓰쟈~
3. 누굴 기준으로 그룹핑을 할까? -> 사용자가 어떤 주문을 하고 어떤 카테고리의 주문을 했는지 알아야하니 사용자의 이름으로 그룹핑하자!
4. 사용자가 구매한 주문은 어떻게 확인하지? -> count(order_id) 해서 사용자가 주문한 주문 횟수를 가져오자
5. 그러면 여기서 주문한 카테고리 별로 몇번을 구매했는지 찾아보자!
6. 어떻게 찾지? -> sum 속의 case 문으로 해당 카테고리일때 합하는 과정을 통해서 회수를 조회하자 */ 