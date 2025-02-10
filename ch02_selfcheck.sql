-- 데이터베이스 만들기
create database starbucks;

-- 데이터베이스 사용 처리
use starbucks;

-- 테이블 만들기
create table coffees(
	id integer,
    name varchar(21),
    price integer,
    primary key (id)
);

-- 데이터 삽입 하기
insert into coffees (id, name, price)
values
	(1,'아메리카노',3800),
	(2,'카페라떼',4000),
	(3,'콜드브루',3500),
	(4,'카페모카',4500),
	(5,'카푸치노',5000);

-- 테이블의 모든 커피 이름을 조회
select name
from coffees;

-- 카푸치노 가격 200원 인상하기
update coffees
set price = price+  200
where id = 5;

-- 콜드브루 삭제
delete from coffees
where id = 3;

-- 모든 커피 데이터 조회
select *
from coffees;