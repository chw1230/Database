use my_shop2;

-- 조인2 - 외부 조인과 기타 조인
-- 한 번도 주문하지 않은 고객 찾기
-- 1단계 : 단순 조회로 고객 찾기
select user_id, name, email
from users;

select user_id, order_id
from orders;
-- 이렇게 단순 조회하면, 누가 가입만 하고 주문을 안했는지 알수 있지만 비교를 하기가 힘들어! -> 조인을 쓰자!

-- 2단계 : inner join 사용하기
select
	u.user_id,
    u.name,
    o.order_id,
    o.user_id
from users u
join orders o on u.user_id = o.user_id
order by order_id;
-- 이너 조인을 사용하면 누가 등록만하고 구매를 안했는지 알 수가 없음! -> user_id -> 6의 값이 없기 때문에 조인 대상에서 제외가 된다!
-- 이렇게 주문 기록이 없는 고객은 orders 테이블에 짝이 없어서 결과에서 제외가 된다. => 이를 통해서 외부 조인의 필요성에 대해서 느낄 수 있음!

-- 외부 조인 1
-- LEFT JOIN으로 '한 번도 주문하지 않은 고객 찾기'
select
	u.user_id,
    u.name,
    o.order_id,
    o.user_id
from users u
left join orders o on u.user_id = o.user_id
order by u.user_id;

-- null 인 고객 필터링하기
select
	u.user_id,
    u.name,
    u.email
from users u
left join orders o on u.user_id = o.user_id
where o.order_id is null;

-- 외부 조인2
-- left join으로 '단 한 번도 팔리지 않은 상품' 찾기
-- 1단계 : orders와 products 테이블을 product_id를 기준으로 left join 하기
select
	p.product_id,
    p.name,
    p.price,
    o.product_id,
    o.order_id
from products p
left join orders o on p.product_id = o.product_id;
-- 5번 6번 상품이 안팔린 것을 알 수 있음

-- 2단계 : null인 상품만 필터링 해서 보기
select
	p.product_id,
    p.name,
    p.price,
    o.product_id,
    o.order_id
from products p
left join orders o on p.product_id = o.product_id
where o.order_id is null;

-- 3단계 : right join으로 단 한번도 팔리지 않은 상품 찾기
select
	p.product_id,
    p.name,
    p.price,
    o.product_id,
    o.order_id
from orders o
right join products p on o.product_id = p.product_id; -- 오른쪽(join 절)이 기준이 되는 것!!!

-- 4단계 : null인 것만 필터링 하기
select
	p.product_id,
    p.name,
    p.price,
    o.product_id,
    o.order_id
from orders o
right join products p on o.product_id = p.product_id
where o.order_id is null;

-- 정리 : 실무에서는 LEFT JOIN을 더 많이 사용한다!! 보통 분석의 기준이 되는 것을 더 많이 사용하기 때문에 FROM에 기준을 입력하는 
-- LEFT JOIN을 더 많이 사용한다! => FROM 절에 기준을 넣고 LEFT JOIN 사용하기!!

-- 조인의 특징
-- 조인에서 데이터가 늘어나는 경우
/* 기준으로 삼는 테이블의 한 행이 다른 쪽 테이블의 여러 행과 연결될 수 있다면, 결과의 전체 행 수는 늘어남, 반대로 한 행이 다른 쪽 테이블의 단 하나의 행과 연결되거나, 아무 행과 연결되지 않는 다면 행의 수는 늘어나지 않음 
부모 테이블 : PK 소유한 테이블
자식 테이블 : FK를 통해서 부모 데이블을 참조하는 테이블

자식 -> 부모 조인(FK -> PK 참조) : 행 개수가 늘어나지 않음
ex> order를 기준으로 users 테이블을 조인하는 경우, 주문 하나가 하나의 부모(사용자)와 연결되기 때문에! -> 테이블의 행 수가 그대로 유지가 됨

부모 -> 자식 조인(PK -> FK 참조) : 행 개수가 늘어날 수 있음
부모 테이블의 한 고객은 여러 명의 자식을 가질 수 있음, 이 경우 한 고객의 정보를 여러 주문 정보에 각각 매칭 시키면서, 전체 행의 수가 증가할 수 있음*/

-- 실제 데이터로 살펴보기
select user_id, name, email
from users
where user_id = 1; -- 하나의 데이터만 나옴

select order_id, product_id, user_id
from orders
where user_id = 1; -- 2개의 행이 나옴 그렇다면 이 두개를 조인해보자

-- 경우1 : 자식 -> 부모 조인 (자식 테이블에서 부모 테이블로 Fk에서 pk로 조인)
select
	o.order_id,
    o.product_id,
    o.user_id as orders_user_id,
    u.user_id as users_user_id,
    u.name,
    u.email
from 
	orders o
join 
	users u on o.user_id = u.user_id
where
	o.user_id = 1;
-- join 했을 때의 결과가 기존의 기준 테이블인 order 결과 2개가 그대로 유지 된 것을 볼 수 있음

-- 경우2 : 부모 -> 자식 조인(users -> orders  행 개수 증가)
-- 부모 테이블에서 자식 테이블로 조인 ( pk -> fk 조인 )
select
	 u.user_id as users_user_id,
    u.name,
    u.email,
    o.order_id,
    o.product_id,
    o.user_id as orders_user_id
from 
	users u
join 
	orders o on o.user_id = u.user_id
where
	o.user_id = 1;
-- 기존의 기준 테이블 이였던 users 테이블의 결과 1개와 비교 했을때 join의 결과가 하나 더 많음을 알 수 있음

-- 전체 데이터로 확장하기
-- 자식 -> 부모 조인 (orders 테이블 기준)
select
	o.order_id,
    o.product_id,
    o.user_id as orders_user_id,
    u.user_id as users_user_id,
    u.name,
    u.email
from 
	orders o
join users u on o.user_id = u.user_id;
-- 이렇게 하면 원래 order 테이블의 수 만큼 join의 결과가 생성이 됨!
-- fk를 이용해서 pk에 join하는 것이기 때문에 기존의 orders의 테이블의 행 수 만큼 나옴!

-- 부모 -> 자식 조인 (users 테이블 기준)
select
	 u.user_id as users_user_id,
    u.name,
    u.email,
    o.order_id,
    o.product_id,
    o.user_id as orders_user_id
from 
	users u
join 
	orders o on o.user_id = u.user_id;
-- users 테이블은 6행이였지만, 조인의 결과는 7행이 되었음

-- 정리 : 언제 행이 늘어나고 언제 그대로 인 것인가?
/* 
행 개수 유지 : 자식에서 부모로 조인하는 경우 (to - one(PK))
FK -> PK
자식 테이블의 FK들은 하나인 PK로 연결! 그렇기에 자식 테이블의 행 수가 그대로 유지가 됨!

행 개수 증가 가능한 경우 : 부모에서 자식으로 조인하는 경우 (to - many)
PK -> FK
부모 테이블의 한 행은 자식 테이블의 여러 행과 매칭가능! 한 명의 고객이 여러 번 주문 가능 -> 자식 테이블의 행 수 만큼 복제되며 늘어날 수도 있음	
*/

-- 행의 개수가 늘어나는 것이 왜 중요한가?
/* 이 원리를 모르고 count와 같은 집계 함수를 사용하면 오류 발생할 가능성 있음! 
쿼리를 작성하기 전에 항상 어떤 테이블을 기준으로 삼을지, 그리고 조인으로 인해 행 수가 증가하는 상황인지 아닌지 먼저 생각하는 습관 중요! */

-- 조인의 유연성
/* 지금 까지 조인하는 과정에서 pk와 fk를 연결 시켰지만 사실은 pk-fk 관계가 아니더라도 조인이 가능하다. ㅇㅣ름이라던지, 날짜 등!

-- 셀프 조인
-- 연결해서 보여줘야 하는 대상이 자기 자신인 경우에 사용
-- 문제 상황 : 각 직원의 이름과 바로 위 직속 상사의 이름을 나란히 함께 출력하려면 어떻게 해야 할까?
-- 한 테이블 안에서 자신의 컬럼이     같은 테이블의 다른 컬럼을 참조하는 구조 => ' 자기 참조 관계 '
-- 별칭 기법을 이용하여 문제 해결하기
/* 하나는 직원을 나타내는 e, 다른 하나는 상사를 나타내는 m으로 사용하기 그리고 이것을 통해서 manager_id와 employee_id를 연결하기 */
select
	e.name as emplyee_name,
    m.name as manager_name
from employees e
join employees m on e.manager_id = m.employee_id;
-- 직원 | 상사 이렇게 결과가 나옴 -> 진짜 신기하다!!!

-- left join을 사용해서 리더인 김회장까지 포함한 전체 직원 목록을 보고 싶다면 어떻게 해야할까?
select
	e.name as emplyee_name,
    m.name as manager_name
from employees e
left join employees m on e.manager_id = m.employee_id; -- left join 사용한다!

-- CORSS 조인
-- CROSS 조인의 개념과 카테시안 곱
-- 상품 옵션 조합 만들기
select
	s.size,
    c.color
from 
	sizes s
cross join
	colors c;
-- 3 * 4 = 12개의 조합이 나온다.

-- 상품명 자동생성
select
	concat('기본티셔츠-',c.color,'-',s.size) as product_name,
	s.size,
    c.color
from 
	sizes s
cross join
	colors c;
    
-- insert into ... select 로 상품 옵션 마스터 테이블 만들기
create table product_options (
	option_id bigint auto_increment,
    product_name varchar(255) not null,
    size varchar(10) not null,
    color varchar(20) not null,
    primary key (option_id)
);

insert into product_options (product_name, size, color)
select
	concat('기본티셔츠-',c.color,'-',s.size) as product_name,
	s.size,
    c.color
from 
	sizes s
cross join
	colors c;
-- insert into ... select를 통해서 조회된 결과를 즉시 다른 테이블로 삽입하기

select * from product_options;

-- 조인 종합 실습 
-- 2025년 6월에 '서울'에 거주하는 고객이 주문한 모든 내역에 대해서, 고객 이름, 고객 이메일, 주문 날짜, 주문한 상품명, 상품 가격, 주문 수량을 포함하는 상세 보고서를 최신 주문 순으로 작성
select
	u.name as customer_name,  u.email,
    o.order_date,
    p.name as product_name , p.price,
    o.quantity
from orders o
join users u on o.user_id = u.user_id
join products p on o.product_id = p.product_id
where u.address like "%서울%" and '2025-06-01' <= o.order_date and o.order_date < '2025-07-01';