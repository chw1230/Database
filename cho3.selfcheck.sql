USE mapdonalds;

-- 가격 6000이상 7000미만 버거 조회
select *
from burgers
where price >= 6000 AND price < 7000;

-- 열량 500 미만 단백질량 25이상 버거 조회
select *
from burgers
where protein >= 25 or kcal < 500;

-- 모든 버거의 100g 당 가격 조회
select 
	name as '버거 이름',
    price / gram * 100 as '100g당 가격'
from burgers;

-- 100g 당 가격이 2500원 미만인 버거 조회
select 
	name as '버거 이름',
    price as '가격',
    gram as '무게(g)',
    price / gram * 100 as '100g당 가격'
from burgers
where price / gram * 100 < 2500;

-- 1000원당 들어있는 단백질량 조회
select 
	name as '버거 이름',
    protein / price * 1000 as '1000원당 단백질량'
from burgers;

-- 1000원당 들어있는 단백질량이 5 이상인 버거 조회
select 
	name as '버거 이름',
    protein / price * 1000 as '1000원당 단백질량'
from burgers
where protein / price * 1000 >= 5;