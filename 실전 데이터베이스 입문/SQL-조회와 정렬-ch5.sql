use my_shop;

SET FOREIGN_KEY_CHECKS = 0; -- 비활성화
truncate table products;
 truncate table customers;
 truncate table orders;
 SET FOREIGN_KEY_CHECKS = 1; -- 활성화
 
-- 더미 데이터 넣기
 INSERT INTO customers (name, email, password, address, join_date) VALUES
 ('이순신', 'yisunsin@example.com', 'password123', '서울특별시 중구 세종대로', 
'2023-05-01'),
 ('세종대왕', 'sejong@example.com', 'password456', '서울특별시 종로구 사직로', 
'2024-05-01'),
 ('장영실', 'youngsil@example.com', 'password789', '부산광역시 동래구 복천동', 
'2025-05-01');

INSERT INTO products (name, description, price, stock_quantity) VALUES
 ('갤럭시', '최신 AI 기능이 탑재된 고성능 스마트폰', 10000, 55),
 ('LG 그램', '초경량 디자인과 강력한 성능을 자랑하는 노트북', 20000, 35),
 ('아이폰', '직관적인 사용자 경험을 제공하는 스마트폰', 5000, 55),
 ('에어팟', '편리한 사용성의 무선 이어폰', 3000, 110),
 ('보급형 스마트폰', NULL, 5000, 100);
 
INSERT INTO orders (customer_id, product_id, quantity) VALUES
 (1, 1, 1), -- 이순신 고객이 갤럭시 1개 주문
(2, 2, 1), -- 세종대왕 고객이 LG 그램 1개 주문
(3, 3, 1), -- 장영실 고객이 아이폰 1개 주문
(1, 4, 2), -- 이순신 고객이 에어팟 2개 추가 주문
(2, 2, 1); -- 세종대왕 고객이 LG 그램 1개 주문(추가 주문)

TRUNCATE TABLE orders;

select * from orders;
select * from products;
select * from customers;

select name, email from customers;

-- WHERE - 기본 검색
-- 특정 열만 선택해서 보기
select 
	name as 고객명,
	email as 이메일
from customers;

-- 조건문의 시작: WHERE 절과 비교 연산자
select *
from customers
where email = 'yisunsin@example.com';

--  products 테이블에서 가격(price)이 10000원 이상인 상품만 조회해보자
select *
from products
where price >= 10000;

-- 가격이 5000원 이상이면서, 재고가 50개 이상인 상품 조회하기 (AND)
select * 
from products
where price >= 5000 AND stock_quantity >= 50;

-- 가격이 20000원이거나, 재고가 100개 이상인 상품 조회하기 (OR)
select *
from products
where price = 20000 OR stock_quantity >= 100;

-- 가격이 20000원이 아닌 상품 조회하기 (!=)
select *
from products
where price != 2000;

--  WHERE - 편리한 조건 검색
--  BETWEEN: 특정 범위에 있는 값 찾기
select * 
from products
where price between 5000 and 15000;

--   products 테이블에서 가격이 5000원 이상 15000원 이하가 아닌 상품 조회하기
select * 
from products
where price not between 5000 and 15000;

-- IN: 목록에 포함된 값 찾기 / "갤럭시, 아이폰과 에어팟만 모아서 할인 행사를 하고 싶어요. 해당 상품들 목록만"
select *
from products 
where name in ('갤럭시','아이폰','어어팟');

-- products 테이블에서 이름이 '갤럭시', '아이폰', '에어팟'이 아닌 상품 조회하기
select *
from products
where name not in ( '갤럭시','아이폰','에어팟');

-- LIKE: 문자열의 일부로 검색하기 (패턴 매칭) / 와일드카드 : %, _
-- customers 테이블에서 이메일이 'sejong'으로 시작하는 고객 검색하기
select *
from customers
where email like 'sejong%'; -- % -> 0개 이상의 모든 문자

--  서울특별시에 살지 않는 고객 검색하기
select *
from customers
where address not like '%서울특별시%';

-- ORDER BY 정렬 / 결과의 순서를 지정하는 역할
-- customers 테이블을 가입일(join_date) 최신순으로 정렬하기
select *
from customers
order by join_date desc;

-- products 테이블을 가격(price) 낮은순으로 정렬하기
select *
from products
order by price asc;

-- 다중 열 정렬 (Multi-column Sort)
-- products 테이블을 재고수량 내림차순, 가격 오름차순으로 정렬하기
select *
from products
order by stock_quantity desc, price asc;

--  LIMIT - 개수 제한
--  products 테이블에서 가장 비싼 상품 2개만 조회하기
select *
from products
order by price desc limit 2; -- 정렬하고, 2개 가져오기!

-- 특정 범위의 결과만 조회하기: LIMIT, 오프셋
-- LIMIT 건너뛸개수(offset), 가져올개수(row_count); ex. LIMIT 10, 5 / 10개 건너뛰고 5개 가져와
-- products 목록을 한 페이지당 2개씩 보여줄 때, 1페이지 조회하기
select *
from products
order by product_id asc limit 0, 2; 
-- order by product_id asc limit 2 offset 0; 이렇게 명시적으로 사용이 가능하다.

--  products 목록의 2페이지 (3~4번째 상품) 조회하기
select *
from products
order by product_id asc limit 2, 2;

--  products 목록의 3페이지 (5번째 상품) 조회하기
select *
from products
order by product_id asc limit 4, 2;

-- DISTINCT - 중복 제거
-- 우리 쇼핑몰에서 한 번이라도 주문을 한 고객의 ID 목록
select distinct customer_id
from orders;
-- distinct를 사용해서 조회된 결과에서 중복된 행을 모두 제거하고 유일한 값만 남기기!

-- 여러 컬럼에 distinct 적용하기
 SELECT DISTINCT customer_id, product_id 
 FROM orders;
-- 어떤 고객이 어떤 상품을 구매했는지 그 조합을 중복 없이 보고 싶다 -> 같은 고객이 2번 주문 한거 없이 조회

--   NULL - 알 수 없는 값
-- 설명이 등록되지 않은 상품들만 골라서 보여주기
select *
from products
where description = null; -- 이렇게 하면 설명이 없는 보급형 스마트폰이 조회될 줄 알았는데 조회 안됨!!
-- 왜 그런거지?
-- null은 값이 없음 이라는 상태를 의미하는 특별한 존재이기에 0도 아니고  공백 문자열('')도 아닌, 알수 없는 값이라는 개념이 더 가깝다. 
-- 그래서 값을 비교하는 '='로는 null인지 아닌지 알수가 없는 것!

select *
from products
where description is null; -- 이와 같이 조회해야한다.

--  NULL 정렬
-- order by 정렬의 과정에서 null은 어떻게 취급이 될까?
-- MySQL은 null 값을 가장 작은 값으로 취급한다!!!!
select *
from products
order by description asc; -- 그래서 오름차순 하면 가장 먼저 정렬되게 된다.

-- description 열을 내림차순으로 정렬하기
select * 
from products 
order by description desc;

-- [실무 팁] NULL 위치를 강제로 바꾸고 싶을 때
-- 상품 설명을 내림차순으로 정렬하되, 설명이 없는 상품은 빨리 확인할 수 있게 맨 앞으로 보내주세요 같은 요구사항을 처리하는 방법
select product_id, name,description,  description IS NULL
from products
order by (description IS NULL) desc , description desc;
-- description IS NULL을 통해서 descriprion 값이 null이면 1값을 description IS NULL에 저장하도록 설정한뒤에 정렬 조건에 사용하기!
-- 1차로 description이 null 인것으로 먼저 정렬하고, 그 다음 설명 ㄱㄴㄷ 순으로 정렬