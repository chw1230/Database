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