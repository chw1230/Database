use my_shop2;

-- UNION

-- 실습 데이터 준비하기 -> retired_users 테이블 생성
create table retired_users (
	id bigint,
    name varchar(255) not null,
    email varchar(255) not null,
    retired_date date not null
);

-- 탈퇴 고객 데이터 입력
INSERT INTO retired_users (id, name, email, retired_date) VALUES
	(1, '션', 'sean@example.com', '2024-12-31'), -- 션을 왜 여기에도 넣음? 개발자의 실수를 가정한 상황!
	(7, '아이작 뉴턴', 'newton@example.com', '2025-01-10');
    
-- UNION의 개념과 사용법
-- 탈퇴 회원 테이블과 활동 회원 테이블을 union으로 합치기
select name, email from users
union
select name, email from retired_users;
/* 규칙 :
1. 컬럼의 개수가 동일해야한다.
2. 컬럼들은 서로 호환 가능한 데이터 타입이여야 한다. 
3. 최종 컬럼의 이름은 첫 select 문의 컬럼 이름을 따라간다. 
4. UNION은 기본적으로 두 결과 집합을 합치고, 완전히 중복되는 행은 자동으로 제거하여 고유값만 남긴다! -> 그래서 양쪽 테이블에 있던 션이 한번만 나온것! */

-- UNION ALL

-- UNINON과 UNION ALL의 사용 차이
-- UNION : 두 결과를 합치고, 중복 제거
-- UNION ALL : 중복 제거 없이, 그대로 합하기

-- 예제 전자기기 구매 고객과 서울 거주 조객 합치기 - union
select u.name, u.email
from users u
join orders o on u.user_id = o.user_id
join products p on o.product_id = p.product_id
where p.category = '전자기기'

union

select name, email
from users 
where address like '서울%';


-- 예제 전자기기 구매 고객과 서울 거주 조객 합치기 - union all
select u.name, u.email
from users u
join orders o on u.user_id = o.user_id
join products p on o.product_id = p.product_id
where p.category = '전자기기'

union all

select name, email
from users 
where address like '서울%'; -- 네이트와 마리 퀴리가 겹친다.

-- 실무 가이드 : 성능 우선!!!
-- union all 이 union 보다 빠르다!!!!
/* 
union은 합치고, 중복제거 위해 정렬해서 인접한 행들을 비교해서 중복을 제거하는 로직을 가진다.
union all은 이럴 것 없이 그냥 냅다 같다 붙임 => 겁내 빠름 => 우선적으로 사용하기 */

-- UNION 정렬
-- union으로 합친 결과에 정렬을 하려면 order by를 사용하면 된다! 단, 위치가 중요하다!!
/*
select1 ~
union
select2 ~
order by -> 여기에 !!!!!! */
select name, email from users
union
select name, email from retired_users
order by name;

-- union에 나오지 않는 필드를 사용한다면?
-- 위에서 만한 것 처럼 첫번째 select 문의 컬럼 이름이나 해당 컬럼의 별칭만 사용가능 (union , union all , order by 모두 해당)
select name, email, created_at from users
union all
select name, email , retired_date from retired_users; -- 이렇게 하면 최종 결과에는 created_at으로 뜨게 됨!

-- 그래서 이런 경우에는 별칭을 사용해서 처리하도록 하자!
select name, email, created_at as event_date from users
union all
select name, email , retired_date as event_date from retired_users
order by event_date desc;