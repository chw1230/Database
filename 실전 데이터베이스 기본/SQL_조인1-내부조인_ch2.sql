use my_shop2;

 -- 내부조인
 -- 조인이 필요한 이유
 -- 최근 주문 현황을 고객 이름과 상품명 포함 해서 보여줘 라고 한다면 뭘 보여줘야 하는 걸까?
 select * from orders; -- 이거로는 부족하다...
 -- order 테이블만으로는 고객의 이름과 상품명을 전달 할 수 없다.
 -- 그렇다면 모든 테이블이 하나의 테이블에 저장한다면?
/* 
1. 데이터 중복 문제 : 한 고객이 상품을 2번 주문했다 -> 고객의 불피요한 정보들이 2번 저장이 되어야함!
2. 갱신 이상 : 만약 한 고객이 수정했다면 이것에 맞춰서 100개의 주문 데이터 속 이메일을 수정해야할 것!
3. 삽입 이상 : 만약 새로운 상품이 등록하고 싶다면? -> 주문이 발생하지 않은 상품에 대해서서 주문이 발생했다고 할 수 있습니다.
4. 삭제 이상 : 회사의 사정상 한 고객의 데이터를 삭제해야 한다면 주문 기록 뿐아니라 전체 사람에 대한 모든 정보가 사라질 것 !!

-> 이렇게 중복을 제거하여 잘 나워서 보관하는 것을 정규화라고한다.*/

-- 그래서 위 처럼 흩어져서 보이는 것을 한눈에 보도록 하기 위해서 정규화가 필요하다.

-- 내부 조인
-- 내부 조인은 두 테이블을 연결할 때, 양쪽 테이블 모두 공통으로 존재하는 데이터 만을 보여 줘야한다.
SELECT *
FROM orders
INNER JOIN users ON orders.user_id = users.user_id;

-- 필요한 컬럼만 선택하고, where로 필터링 할 수 있다.
SELECT 
	users.user_id,
    users.name,
    orders.order_date
FROM orders
INNER JOIN users ON orders.user_id = users.user_id
where orders.status = 'COMPLETED';
-- 위의 쿼리를 보면 from-where 절이 1번, where 절이 2번, select 절이 3번을 이와 같은 '논리 적인 순서'를 가진다!

-- inner join은 양방향
-- 내부 조인의 방향성 확인
-- users의 user_id 사용해서 orders의 user_id와 함치기! 
select
	orders.user_id,
    orders.order_date,
    orders.user_id as order_user_id,
    users.user_id as users_user_id,
    users.name
from users
inner join orders on users.user_id = orders.user_id;

-- 실무에서 사용하는 테이블 별칭 기법
select 
	u.user_id,
    u.name,
    o.order_date
from orders as o
inner join users as u on o.user_id = u.user_id
where o.status = 'COMPLETED';
-- 실무에서는 as 키워드를 생략해서 사용한다. 다만 select에 들어가는 as는 붙여서 사용한다, 그리고 inner도 생략해서 사용한다.
-- 그렇다면 select에 들어가는 컬럼에는 왜 as를 사용해야하는 걸까?
-- 가독성 때문에!!

-- 정리 : 컬럼에 들어가는 as는 사용(생략 X), 테이블에 들어가는 as는 생략한다!
