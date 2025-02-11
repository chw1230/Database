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

-- 다중 데이터 삽입
insert into burgers(id,name,price,gram,kcal,protein)
values
	(1,'빅맨',5300,223,583,27),
	(2,'베이컨 디럭스',6200,242,545,27),
    (3,'상하이 버거',5300,235,494,20),
    (4,'뚜비두밥 버거',6200,269,563,21),
    (5,'더블 쿼터 파운드 치즈버거',7700,275,770,50);
    
-- 모든 버거 조회
select *
FROM burgers;

-- price가 5500원 보다 저렴한 버거
select *
FROM burgers
WHERE price < 5500;

-- price가 5500원 보다 비싼 버거
select *
FROM burgers
WHERE price > 5500;

-- protein이 25보다 적은 버거
select *
FROM burgers
WHERE protein < 25;

-- price가 5500원 보다 싸고 protein이 25보다 많은 버거
select *
FROM burgers
WHERE price < 5500 AND protein > 25;

-- price가 5500원 보다 싸거나 protein이 25보다 많은 버거
select *
FROM burgers
WHERE price < 5500 or protein > 25;

-- protein이 25보다 많지 않은 버거
select *
FROM burgers
WHERE NOT protein > 25;

-- 산술 연산자
select 100 - 20;
select 100 * 20;
select 100 / 20;
select 100 % 20;
select 100 - 20;