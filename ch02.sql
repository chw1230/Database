/*****************************
* 2.2 데이터배이스 만들기 *
*****************************/
show databases; 				-- 모든 DB 목록 조회
CREATE DATABASE mapdonalds;		-- mapdonalds DB 생성
USE mapdonalds;					-- mapdonalds DB 진입
select database();				-- 현재 사용 중인 DB 조회
drop database mapdonalds;		-- mapdonalds DB 삭제

CREATE DATABASE mapdonalds;		-- mapdonalds DB 생성
USE mapdonalds;					-- mapdonalds DB 진입

-- burger 테이블 생성
create table burgers(
	id integer,					-- 아이디(정수형 숫자)
    -- id integer primary key -> 이처럼 칼럼을 정의할 때 키본키를 지정할 수도 있음!
    name varchar(50),			-- 이름(문자형: 최대 50자)
    price integer,				-- 가격(정수형 숫자)	
    gram integer,				-- 그램(정수형 숫자)
    kcal integer,				-- 칼로리(정수형 숫자)
    protein integer,			-- 단백질량(정수형 숫자)
    primary key(id)				-- 기본키 지정: id
);

-- burgers 테이블의 구조 조회 -> 표 형식으로 보여줌
DESC burgers;

-- 단일 데이터 삽입
insert into burgers(id,name,price,gram,kcal,protein)
values(1,'빅맨',5300,223,583,27);

-- 다중 데이터 삽입
insert into burgers(id,name,price,gram,kcal,protein)
values
	(2,'베이컨 디럭스',6200,242,545,27),
    (3,'상하이 버거',5300,235,494,20),
    (4,'뚜비두밥 버거',6200,269,563,21),
    (5,'더블 쿼터 파운드 치즈버거',7700,275,770,50);

-- burger 테이블의 모든 칼럼 조회
select *
from burgers;

-- burger 테이블의 name, price 칼럼 조회
select name, price
from burgers;

-- 안전모드 해제하기
SET SQL_SAFE_UPDATES = 0;

-- 모든 버거의 가격을 1000원으로 수정
update burgers
set price = 1000;

-- 안전모드 재설정
SET SQL_SAFE_UPDATES = 1;

-- burgers 모든 테이블 조회
select *
from burgers;

-- 특정 데이터 수정 -> 빅맨 가격을 500으로 수정
-- update는 id 조건으로 대상을 찾아서 수정해야함!!
update burgers
set price = 500
where id = 1;

-- burgers 모든 테이블 조회
select *
from burgers;

-- 뚜비두밥 버거 삭제
delete from burgers
where id = 4;

-- burgers 모든 테이블 조회
select *
from burgers;

-- burgers 테이블 삭제
drop table burgers;

-- burgers 테이블의 구조 조회를 통한 burgers 테이블 삭제 여부 확인
desc burgers; -- 오류 발생 -> 삭제된 것