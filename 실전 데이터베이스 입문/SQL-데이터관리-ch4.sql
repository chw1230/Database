-- 1. 데이터베이스 시작하기 1

-- DATABASE 생성하기
CREATE DATABASE my_shop; 

-- DATABASE 사용하기, 작업 공간의 선택
USE my_shop;

-- 테이블 설계(=정의)하기
CREATE TABLE sample (
	product_id INT PRIMARY KEY, -- 기본 키란, 테이블에 있는 모든 행(Row)들 중에서 특정 행 하나를 유일하게 식별할 수 있는 열(Column) 또는 열들의 조합
    name VARCHAR(100),
    price INT,
    stock_quantity INT,
    release_date date
);

-- 테이블의 구조와 자료형과 같은 정보 확인하기 -> DESC
DESC sample; -- 또는 DESCRIBE sample;

-- 테이블 삭제하기
DROP TABLE sample;

-- 데이터 베이스 삭제하기    
DROP DATABASE my_shop;

-- 2. 데이터베이스 시작하기 2

-- 데이터베이스의 기본, CRUD 맛보기
INSERT INTO sample (product_id, name, price , stock_quantity, release_date)
VALUES (1, '프리미엄 청바지', 59900, 100, '2025-04-11'); 

SELECT * FROM sample;

UPDATE sample
SET price = 40000
WHERE product_id = 1;

DELETE FROM sample
WHERE product_id = 1;


-- 4. SQL - 데이터 관리

-- DDL - 테이블 생성1
-- 쇼핑몰 테이블 실전 설계

-- 고객 테이블 만들기
CREATE TABLE customers (
	customer_id INT AUTO_INCREMENT PRIMARY KEY, -- 값이 1씩 자동증가, 기본 키 설정
    name VARCHAR(50) NOT NULL, 					-- 필수 값들은 NOT NULL 처리하기
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    join_date DATETIME DEFAULT CURRENT_TIMESTAMP -- 값을 넣지 않으면 DEFAULT 설정에 따라서 현재 시간이 자동으로 기록됨!
);

-- 상품 테이블 만들기
CREATE TABLE products (
	product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    pricr INT NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0
);

-- 주문 테이블 만들기
CREATE TABLE orders (
	order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT '주문접수',
    
    CONSTRAINT fk_orders_customers FOREIGN KEY (customer_id)  -- 주문 테이블의 customer_id는 customers 테이블의 customer_id를 참조함 => 두 테이블 사이에 '관계'가 형성됨
    REFERENCES customers(customer_id),
    
    CONSTRAINT fk_orders_products FOREIGN KEY (product_id)    -- 주문 테이블의 product_id는 products 테이블의 product_id를 참조함 => 두 테이블 사이에 '관계'가 형성됨
    REFERENCES products(product_id)
);

--  DDL - 테이블 변경, 제거
ALTER TABLE customers
ADD COLUMN point INT NOT NULL DEFAULT 0;

DESC customers;

SELECT * FROM customers;

ALTER TABLE customers
MODIFY COLUMN address VARCHAR(500) NOT NULL; -- 제약 조건 수정하기

ALTER TABLE customers
DROP COLUMN point; -- 컬럼 삭제

-- DML - 등록
INSERT INTO customers VALUES ( NULL, '강감찬', 'kang@example.com', 'pwpwpw', '서울시 성북구', '2025-08-21 14:00:00');
INSERT INTO customers VALUES ( NULL, '이순신', 'lee@example.com', 'pwpwpw2', '서울시 종로구', '2025-08-22 14:00:00');

INSERT INTO customers ( name, email, password, address )
VALUES ('세종대왕','sejoing@example.com', 'hased__pw_456', '서울시 종로구'); 
-- customer_id 와 join_date 는 우리가 입력하지 않아도 auto_increment와 default로 인해서 자동으로 값이 들어감!


SELECT * FROM products;

-- 이렇게 column 목록을 명시적으로 작성하는 것이 안전하고 좋은 습관임
INSERT INTO products ( name, price, stock_quantity )
VALUES ('베이직 반팔 티셔츠', 19900, 200 ); 

INSERT INTO products ( name, price, stock_quantity )
VALUES ('초록색 긴팔 티셔츠', 30000, 50 ); 

-- 한번에 등록하기
INSERT INTO products ( name, price, stock_quantity )VALUES 
('검정 양말', 5000, 100 ),
('흰 양말', 5000, 50 ),
('파랑 양말', 5000, 50 ), 
('보라 양말', 5000, 50 ); 


-- DML 수정

SELECT * FROM products
WHERE product_id = 1;

-- update
UPDATE products
SET price = 9800, stock_quantity = 580 , description = '왕창 사가쇼!'
WHERE product_id;

-- 안전 update 모드란 무엇일까?
UPDATE products
SET price = 9800; 
-- 이런 쿼리를 이용하면 오류가 발생하게 된다. 위의 쿼리의 의미는 상품 전체의 가격을 9800으로 바꾸겠다는 의미인 것이다! 
-- 이런 실수를 방지하기 위해 MySQL은 "안전 업데이트 모드"를 제공함!
/* Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column. 
 To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect 
 You are using safe update mode and you tried to update a table without a WHERE => 안전 모드이고, where 없이 사용할 수 없다고 뜬다!
 안전 업데이트 모드 활성화 상태에서는 데이터를 변경하거나 삭제할 때 WHERE 절에 '!기본 키 컬럼!'을 반드시 지정해야함! */
 
 -- 안전 업데이트 모드 확인 법 / 1 - 활성, 0 - 비활성
 SELECT @@SQL_SAFE_UPDATES; 
 
 -- WHERE를 쓰지 않는 일이 많다고 한다. 그래서 대상을 먼저 확인하는 습관을 들이자!
 -- UPDATE, DELETE 문을 실생하기 전에는, 반드시 동일한 WHERE 절을 사용한 SELECT문을 실행해서 병경할 값을 눈으로 직접 확인하는 습관을 들이자!
 
 -- 예시 
 SELECT * FROM products
 WHERE name = '베이직 반팔 티셔츠';
 
 SET SQL_SAFE_UPDATES = 0; -- 안전 모드 비활성화
 
 UPDATE products
 SET price = 2000000
 WHERE name = '베이직 반팔 티셔츠';
 
 SET SQL_SAFE_UPDATES = 1;

-- DML - 삭제
 SELECT * FROM products
 WHERE product_id = 1;
 
 DELETE FROM products
 WHERE product_id = 1;
 
-- DELETE 역시 실행 전에 SELECT 문으로 삭제 대상을 확인하는 것이 철칙이다!
/* 실수 했다면 즉시 보고하기... 주변 사람들에게 알리기... DBA에게 알리기...

/*
DELETE vs TRUNCATE 비교
둘 다 데이터를 삭제하는데, 무슨 차이가 있을까?

+ DELETE FROM table;
종류 : DML(데이터 조작어)
처리 방식 : 한 줄씩, 조건에 따라 삭제 가능 (WHERE 사용 가능)
속도 : 느림 ( 각 행 한줄씩 )
AUTO_INCREMENT : 초기화 도지 않음
ROLLBACK : 가능

+ TRUNCATE TABLE table;
종류 : DDL(데이터 정의어)
처리 방식 : 테이블 전체를 한 번에 삭제 (WHERE 사용 불가)
속도 : 매우 빠름 (테이블을 잘라내고 새로 만드는 개념)
AUTO_INCREMENT : 1부터 다시 시작하도록 초기화됨
되돌리기(Rollback) : 불가능(즉시 적용되기 때문에)

언제 무엇을 써야 할까?
1. "탈퇴한 회원 한 명의 정보만 지우고 싶다" 또는 "특정 조건에 맞는 주문 기록만 삭제하고 싶다"
같이 특정 조건의 선별적인 삭제가 필요할 때는 DELETE를 사용한다.
일반적인 비즈니스 로직은 항상 DELETE를 사용한다고 생각하면 된다.

2. "테스트용으로 넣었던 수백만 건의 데이터를 모두 지우고 처음부터 다시 시작하고 싶다" 
같이 테이블의 모든 데이터를 깨끗하게 비울 목적이라면 TRUNCATE가 빠르고 효율적이다.
*/

-- 제약 조건 활용

-- NOT NULL 제약 조건 위반: "필수 항목을 입력해주세요."
-- customers의 name은 NOT NULL로 설정 했었음! 한번 이름을 입력하지 않고 쿼리를 작성해보자
INSERT INTO customers (email, password, address)
VALUES ('CHW@email.com','hashed__pw',' 서울시 성북구');
-- Error Code: 1364. Field 'name' doesn't have a default value / name은 NOT NULL인데 값을 주지 않음 그리고, DEFAULT로 지정된 값도 없어서 오류가 난 것

--  UNIQUE 제약 조건 위반: "이미 사용 중인 이메일입니다."
INSERT INTO customers (name,email, password, address)
VALUES ('최현우','lee@email.com','hashed__pw',' 서울시 성북구');

INSERT INTO customers (name,email, password, address)
VALUES ('이순신','lee@email.com','hashed__pw',' 서울시 성북구');
-- Error Code: 1062. Duplicate entry 'lee@email.com' for key 'customers.email' / 이미 중복이야!

-- 외래 키(FK) 제약 조건: 관계의 무결성 지키기
-- orders 테이블에 데이터를 추가하려면, 그 주문을 한 고객(customer_id)과 주문한 상품(product_id)가 각각의 테이블에 존재하고 있어야 한다.

 INSERT INTO products (name, price, stock_quantity)
 VALUES ('베이직 반팔 티셔츠', 19900, 200);
 SELECT * FROM products;
 
 -- 1번 고객이 1번 상품을 1개 주문한다.
 INSERT INTO orders (customer_id, product_id, quantity)
 VALUES (1, 1, 1);
 SELECT * FROM orders;
 
 -- 존재하지 않는 주문 요청해보기
 -- 존재하지 않는 999번 고객이 1번 상품을 1개 주문하려고 시도한다.
 INSERT INTO orders (customer_id, product_id, quantity)
 VALUES (999, 1, 1);
 -- Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`my_shop`.`orders`, CONSTRAINT `fk_orders_customers` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`))