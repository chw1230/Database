-- order DB 생성하기
create database orders;
use orders;

-- orders 테이블 생성 
CREATE TABLE orders ( 
	id INTEGER,                   
	customer_name VARCHAR(50),    
	product VARCHAR(50),         
	quantity INTEGER,            
	price DECIMAL(10, 2),        
	order_date DATE,             
	region VARCHAR(20),          
	PRIMARY KEY (id) 
); 

-- orders 데이터 삽입 
INSERT INTO orders (id, customer_name, product, quantity, price, order_date, region) 
VALUES 
	(1, '김철수', '노트북', 2, 1500000, '2023-11-01', '서울'), 
	(2, '박영희', '스마트폰', 1, 900000, '2023-11-02', '부산'), 
	(3, '이민호', '청소기', 1, 250000, '2023-11-03', '서울'), 
	(4, '최수진', '냉장고', 1, 1200000, '2023-11-04', '대구'), 
	(5, '정하늘', '노트북', 1, 1500000, '2023-11-05', '부산'), 
	(6, '홍길동', '스마트폰', 3, 900000, '2023-11-06', '서울'), 
	(7, '오준수', '에어컨', 2, 800000, '2023-11-07', '대구'), 
	(8, '서지우', '청소기', 1, 250000, '2023-11-08', '서울'), 
	(9, '이은지', '냉장고', 2, 1200000, '2023-11-09', '부산'), 
	(10, '안현준', '스마트폰', 1, 900000, '2023-11-10', '대구');

-- 모든 주문의 총 매출액을 계산
select sum(price*quantity) as '총 매출액'
from orders;

-- 단가가 1000000원 이상인 제품의 주문 건수를 계산
select count(*)
from orders
where price >= 1000000;

-- 주문 수량이 2개 이상이면서 단가가 1,000,000원 이하인 제품의 총 매출액을 계산
select sum(price * quantity)
from orders
where quantity >= 2 and price <= 1000000;

-- 고객이 사는 지역(region)의 개수를 출력
select count(distinct region)
from orders;

-- 주문 날짜가 2023-11-01과 2023-11-05 사이에 해당하는 주문의 총 수량을 계산
select count(quantity)
from orders
where order_date >= '2023-11-01' AND order_date <= '2023-11-05'; 

-- 고객 이름이 '김철수'이거나 '대구'에 사는 고객이 주문한 제품명을 조회
select product
from orders
where customer_name = '김철수' or region = '대구';

-- '스마트폰'이 총 몇 대 팔렸는지 조회
SELECT SUM(quantity) 
FROM orders 
WHERE product = '스마트폰';

