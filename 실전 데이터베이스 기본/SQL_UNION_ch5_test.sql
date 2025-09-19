use my_shop2;

-- 문제와 풀이

-- 문제 1 : 전체 고객 목록 조회하기
select name as 이름, email as 이메일 from users
union
select name as 이름, email as 이메일 from retired_users;


-- 문제 2 : 특별 이벤트 대상자 목록 만들기 (중복 포함)
select distinct u.name as '고객명', u.email as '이메일'
from users u
join orders o on u.user_id = o.user_id
join products p on o.product_id = p.product_id
where p.category = '전자기기'

union all

select distinct u.name , u.email
from users u 
join orders o on u.user_id = o.user_id
where o.quantity > 1;


-- 문제 3 : 회사 주요 이벤트 타임라인 만들기
select created_at as '이벤트 날짜','고객 가입' as '이벤트 종류', name as '상세 내용' 
from users

union all

select o.order_date,'상품 주문', p.name 
from orders o
join products p on o.product_id = p.product_id

order by '이벤트 날짜' desc;


-- 문제 4 : 회사 전체 인명록 만들기
select name as 이름,'고객' as 역할, email as 이메일
from users

union all

select name , '직원', concat(name, '@my-shop.com')
from employees

order by 이름;