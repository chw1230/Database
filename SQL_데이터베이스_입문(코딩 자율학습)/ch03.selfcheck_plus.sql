-- products DB 생성
create database products;
use products;

-- products 테이블 생성
create table products (
	id integer,
	name varchar(50),
    CATEGORY VARCHAR(30),
    price integer,
    stock integer,
    primary key (id)
);

-- products 데이터 삽입
insert into products (id,name,category,price,stock)
values
	(1, '노트북', '전자기기', 1200000, 10), 
	(2, '스마트폰', '전자기기', 800000, 15), 
	(3, '청소기', '생활용품', 150000, 8), 
	(4, '텀블러', '생활용품', 12000, 50), 
	(5, '초코바', '식품', 1500, 100), 
	(6, '커피', '식품', 4500, 200), 
	(7, '에어컨', '전자기기', 1200000, 5), 
	(8, '책상', '가구', 50000, 20), 
    (9, '의자', '가구', 40000, 25), 
	(10, '모니터', '전자기기', 300000, 12);
    
-- 가격이 300000원 이상인 제품명과 가격을 조회
select name, price
from products
where price >= 300000;

-- 카테고리가 '전자기기'이고 재고가 10개 이상인 제품명과 재고를 조회
select name, stock
from products
where category = '전자기기' and stock >= 10;

-- 가격에 10% 세금을 적용한 최종 가격을 계산해 제품명과 함께 조회
select name, price*1.1 as '최종가격'
from products;

-- 카테고리가 '전자기기'가 아닌 제품을 찾아 제품명과 카테고리를 조회
select name, category
from products
where not category = '전자기기';

-- 재고가 10개 이하인 제품 중 가격을 20% 할인해 제품명과 가격을 조회
select name, price *0.8 as '20% 할인된 가격'
from products
where stock <= 10;

-- 카테고리가 '생활용품'이고 가격이 100,000원 이상이거나, 재고가 50개 이상인 제품의 제품명, 카테고리, 재고를 조회
select name, category, stock
from products
where category = '생활용품' and price >= 100000 or stock >= 50;

-- 카테고리가 ‘전자기기’인 제품 중 재고가 10개 이하 남은 제품을 30% 할인된 가격으로 판매하려고 합니다. 해당 제품의 제품명, 재고, 할인된 가격을 조회
select name, stock, price * 0.7 as '30% 할인된 가격'
from products
where category = '전자기기' and stock <= 10;

-- 각 제품의 재고를 모두 소진했을 때 매출을 구해 제품명과 총판매액을 출력
select name, price * stock as '총판매액'
from products;