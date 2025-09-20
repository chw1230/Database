use my_shop2;

-- CASE 문
-- 단순 CASE 문 예제 : 주문 상태를 한글로 표시하기
SELECT
	order_id,
	user_id,
	product_id,
	quantity,
	status,
	CASE status
		WHEN 'PENDING' THEN '주문 대기'
		WHEN 'COMPLETED' THEN '결제 완료'
		WHEN 'SHIPPED' THEN '배송'
		WHEN 'CANCELLED' THEN '주문 취소'
        else '알 수 없음' 
	end as status_korean
from orders; -- 이 쿼리는 orders 테이블의 각 행 마다 status 컬럼의 값을 확인하여 해당하는 한글 상태의 값을 satatus_korean 이라는 새로운 컬럼으로 반환

-- 검색 case 문 예제 : 상품 가격에 따라 등급 표시하기
select
	name,
    price,
    case
		when price >= 10000 then '고가'
        when price >= 3000 then '중가'
        else '저가'
	end as price_label
from products; -- 위에서의 단순 case 쿼리와는 다르게 여러 비교, 논리 연산이 들어감

-- case 문 기본2
-- case 문 사용시의 주의 사항 -> when 절의 순서를 잘 고려해서 사용하기 
-- 예를 들면 30000보다 큰 금액으로 조건을 검사하는데 3000이 먼저 나오면 여기에 해당됨

-- case 문과 사용 위치
select
	name, 
    price,
    case 
		when price >= 100000 then '고가'
        when price >= 30000 then '중가'
        else '저가'
	end as price_label
from products
order by 
	case 
		when price >= 100000 then 1
        when price >= 30000 then 2
        else 3
	end ASC, -- 숫자가 작은 순서대로 정렬하기
    price desc; -- 같은 등급 내에서는 가격을 내림차순하기, ex> 고가중에서 가격이 높은 순으로!
    
-- case 문 그룹핑
-- 데이터 분류 및 그룹핑
-- 문제 상황 : 고객들을 출생 연대에 따라 '1990년대생', '1980년대생', '그 이전 출생'으로 분류하고, 각 그룹에 고객이 총 몇 명씩 있는지 알고 싶다
-- 1단계 : 분류 / 고객의 출생 연대를 분류하기
select
	name, birth_date,
    case 
		when year(birth_date) >= 1990 then '1990년대생'
        when year(birth_date) >= 1980 then '1980년대생'
        else '그 이전 출생'
	end as birth_decade
from users;

-- 2단계 : 그룹핑하고 count로 집계
select
	case 
		when year(birth_date) >= 1990 then '1990년대생'
        when year(birth_date) >= 1980 then '1980년대생'
        else '그 이전 출생'
	end as birth_decade,
        count(*) as customer_count
	from users
group by 
	case 
		when year(birth_date) >= 1990 then '1990년대생'
        when year(birth_date) >= 1980 then '1980년대생'
        else '그 이전 출생'
	end;
-- 리펙토링
select
	case 
		when year(birth_date) >= 1990 then '1990년대생'
        when year(birth_date) >= 1980 then '1980년대생'
        else '그 이전 출생'
	end as birth_decade,
        count(*) as customer_count
	from users
group by birth_decade; -- 별칭을 사용해서 그룹핑하기 => 이게되네?
-- 원래는 group by 절이 먼저 실행되는데 왜 이게 가능한 거지? -> 예외적 허용!!!

-- case 문 - 조건부 집계1
-- case 문이 집계함수 안에서 작동하는 예시

-- 주문된 데이터를 확인
select order_id, status from orders;

-- 주문 상태 별로 그룹핑
select status, count(*)
from orders
group by status;

-- 주문 전체합 -> 집계 함수로 합치기
select count(*) as total_orders from orders;

-- 주문 상태 별로 나온 것과 주문 전체합을 union으로 합치기 
select 'Total' as category, count(*) as count 
from orders
union all 
select status, count(*)
from orders
group by status; -- 결과가 원하는 결과이지만, 각 상태가 컬럼으로 나오는 상태의 결과가 아니기에 돌려서 피벗 테이블로 만들어야한다!

-- 서브 쿼리 사용하기
select 
	(select count(*) from orders) as total_orders,
    (select count(*) from orders where status = 'COMPLETED') as completed_count,
    (select count(*) from orders where status = 'SHIPPED') as shipped_count,
    (select count(*) from orders where status = 'PENDING') as pending_count;
-- 이렇게 하면 각 상태들과 총합이 컬럼으로 존재하지만, 조회를 너무 많이 해야하는 단점이 존재!! -> 비효율

-- CASE 문 - 조건부 집계 2
-- CASE를 품은 집계 함수 -> 집계 한수의 인자로 CASE 문을 넣어서 조건에 맞을 때만 세게하거나 더하게 만드는 것!!
-- 패턴 1 : COUNT(CASE ... ) / COUNT(CASE WHEN status = 'COMPLETED' THEN 1 END) => status가 'COMPLETED'이면  CASE문은 숫자 1을 반환, 'COMPLETED'아닌 경우에는 NULL을 반환 그래서 결국에는 status가 'COMPLETED'인 행의 개수만 세게 된다.
-- 패턴 2 : SUM(CASE ...) / SUM(CASE WHEN status = 'COMPLETED' THEN 1 ELSE 0 END) => COMPLETED 이면 1, 아니면 0으로 바뀜! 그래서 0과 1을 다 더하고 나면 COMPLETED의 총 개수가 된다!
-- 결과는 동일

-- 실습 1: 전체 주문 상태 요약하기
select 	
	count(*) as total_orders,
    sum( case when status = 'COMPLETED' then 1 else 0 end ) as completed_count,
    sum( case when status = 'SHIPPED' then 1 else 0 end ) as shipped_count,
    sum( case when status = 'PENDING' then 1 else 0 end ) as pending_count
from 
	orders;
-- 이렇게 하면 피벗 형태의 보고서가 나오게 된다!

-- 실습 2 : group by와 함께 사용하기 (피벗 테이블) -> 상품 카테고리별로, 상태별 주문 건수를 집계하라
select 
	p.category,
    count(*) as total_count,
    sum( case when o.status = 'COMPLETED' then 1 else 0 end ) as completed_count,
    sum( case when o.status = 'SHIPPED' then 1 else 0 end ) as shipped_count,
    sum( case when o.status = 'PENDING' then 1 else 0 end ) as pending_count
from orders o
join products p on o.product_id = p.product_id
group by 
	p.category;