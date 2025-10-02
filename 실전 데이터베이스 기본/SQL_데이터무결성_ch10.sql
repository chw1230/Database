-- 데이터 무결성

use my_shop2;

/*
데이터 무결성의 중요성
1차적으로는 애플리케이션에서 검증 해야한다 하지만 그 것만으로는 충분하지 않음!
그래서 데이터베이스를 데이터를 지키는 최후의 보루로 만들기! 어떤 경로로 데이터 변경 요청이 들어오든, 
데이터베이스 스스로가 말도 안 되는 값은 거부하고 데이터의 정확성과 일관성을 지킬 수 있도록 규칙을 설정해야함!

-> 이렇게 데이터의 정확성, 일관성, 유효성을 유지하려는 성질을 데이터 무결성( Data Integrity )라고 함 / 이 데이터 무결성을 강제하기 위해 테이블의 특정 컬럼에 설정하는 규칙이 제약 조건임(Constrains)
*/

-- 기본 제약 조건

-- NOT NULL -> NULL 값 방지
-- 해당 컬럼에 NULL 값이 저장되는 것을 허용하지 X, 필요한 정보가 누락되는 것을 막음
insert into users (name, email) values ('멍멍이',null); -- 오류 발생 email 생성시 not null로 설정하였기 때문에 필수 데이터의 누락을 원천적으로 차단!

-- UNIQUE -> 중복 방지
-- 해당 컬럼에 들어가는 값이 고유해야함!
INSERT INTO users (name, email, address) VALUES ('가짜 션', 'sean@example.com', '서울시 성북구'); -- 에러 발생 이메일 생성 시 unique로 설정하였기 때문에 중복 저장 방지!

-- primary key -> 행의 대표 식별자
-- 테이블의 각 행을 고유하게 식별할 수 있는 단하나의 대표 키, NOT NULL과 UNIQUE 제약 조건의 특징 모두 포함!! / 테이블 당 오직 하나! 키를 기준으로 저장, 검색하기에 성능에도 중요한 역할( 자동 고성능 인덱스 할당 )
INSERT INTO users (user_id, name, email) VALUES (1, '누군가', 'someone@example.com' ); -- 기본키인 ID에 중복 값 1 저장 시도 

-- DEFAULT -> 기본값 설정
-- 특정 컬럼에 값을 명시적으로 입력하지 않는 경우, 자동으로 설정되는 기본 값을 지정 (무결성 강제 규칙은 x , 데이터 누락 방지 + 입력의 편리성)
-- ORDER의 status를 'pending' 기본 값으로 설정하였음! 
INSERT INTO orders (user_id, product_id, quantity) VALUES (2, 2, 1); -- 데이터 삽입에서 status 지정 없이 데이터를 추가하면?
-- '8', '2', '2', '2025-10-02 23:18:14', '1', 'PENDING' 자동으로 PENDING으로 들어감!
-- 지금까지 하나의 테이블 내부에서 데이터 유효성을 지키는 규칙이였음!

-- 외래 키 제약 조건
/* 가장 중요한 참조 무결성 : '(항상 참조해야해) 두 테이블 관계가 항상 유효하고, 일관된 상태를 유지해야한다' 는 원칙 이러한 테이블간의 관계 무결성을 강제하는 가장 강력한 제약 조건이 외래 키임!! */

-- 외래 키의 역할 : 유령 데이터 막기
-- 연관(관계) 되어 있는 양쪽을 보호하는 것!
/* 자식 테이블에 insert, update 할 때 : 부모 테이블에 존재하지 않는 id값을 자식 테이블에 넣으려는 시도 -> 에러 ( 유령 데이터 참조 방지 )
부모 테이블에 delete, update 할 때 : 자식 테이블에서 참조하고 있는 id를 지워버리려고 하는 시도 -> 에러 ( 기존 데이터를 유령으로 만드는 것을 방지 ) */
INSERT INTO orders (user_id, product_id, quantity) VALUES (999, 1, 1); -- 존재하지 않는 user
delete from users where user_id = 1; -- 부모 테이블에서 자식 테이블이 참조하고 있는 값을 지우려고 함! 

-- 삭제하고 싶으면 자식 테이블에서 데이터를 먼저 지우고(이제 부모가 참조 되는게 없으니까), 부모 테이블 지우기 
DELETE FROM orders WHERE user_id = 1; -- 자식 먼저 갑니다 ㅠㅜㅠ
DELETE FROM users WHERE user_id = 1; -- 부모도 뒤 따라 갑니다 ㅜㅠㅜ
select * from orders o join users u on o.user_id = u.user_id; -- 사라졌다..

-- ON DELETE / ON UPDATE 옵션
/*
RESTRICT (기본값): 자식 테이블에 참조하는 행이 있으면 부모 테이블의 행을 삭제/수정할 수 없음
CASCADE : 부모 테이블의 행이 삭제/수정되면, 그를 참조하는 자식 테이블의 행도 함께 자동으로 삭제/수정
SET NULL : 부모 테이블의 행이 삭제/수정되면, 자식 테이블의 해당 외래 키 컬럼의 값을 NULL 로 설정 -> 이 옵션을 쓰려면 자식 테이블의 외래 키 컬럼이 NULL 을 허용해야 함!
*/

-- 실습을 위해 기존 테이블 삭제 후 CASCADE 옵션으로 재생성
DROP TABLE orders;
CREATE TABLE orders (
 order_id BIGINT AUTO_INCREMENT,
 user_id BIGINT NOT NULL,
 product_id BIGINT NOT NULL,
 order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
 quantity INT NOT NULL,
 status VARCHAR(50) DEFAULT 'PENDING',
 PRIMARY KEY (order_id),
 
 CONSTRAINT fk_orders_users FOREIGN KEY (user_id) 
	REFERENCES users(user_id) ON DELETE CASCADE, -- CASCADE 옵션 추가
 
 CONSTRAINT fk_orders_products FOREIGN KEY (product_id)
	REFERENCES products(product_id)
);

-- 션 회원 다시 등록
INSERT INTO users(user_id, name, email, address, birth_date) VALUES
				(1, '션', 'sean@example.com', '서울시 강남구', '1990-01-15');
-- 주문 데이터 다시 입력
INSERT INTO orders(user_id, product_id, quantity, status) VALUES 
					(1, 1, 1, 'COMPLETED'),
                    (1, 4, 2, 'COMPLETED'),
                    (2, 2, 1, 'SHIPPED');
                    
-- cascade 옵션 한 테이블의 데이터 삭제해보기 
delete from users where user_id = 1; -- 오류 없이 삭제!! order에 있던 정보도 모두 삭제!
-- 실무에서는 의도하지 않은 대량의 데이터가 삭제되는 경우가 있기에 잘 사용하지 않는다! 단계적으로 자식 부터 차근차근 지우는 방식 더 선호!

-- check 제약 조건 -> 강화된 비즈니스 규칙 적용
/* 데이터의 구체적인 비즈니스 내용 자체에 대한 규칙에 대한 처리
상품의 가격( price )이나 재고 수량( stock_quantity )은 절대 음수일 수 없다.
할인율( discount_rate )은 0%에서 100% 사이의 값이어야 한다. */

-- 실습을 위해 기존 테이블들을 삭제한다.
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;

-- CHECK 제약 조건을 추가하여 products 테이블 재생성
CREATE TABLE products (
	 product_id BIGINT AUTO_INCREMENT PRIMARY KEY,
	 name VARCHAR(255) NOT NULL,
	 category VARCHAR(100),
	 price INT NOT NULL CHECK (price >= 0),                      -- 가격은 0 이상
	 stock_quantity INT NOT NULL CHECK (stock_quantity >= 0),    -- 수량도 0 이상
     
	 discount_rate DECIMAL(5, 2) DEFAULT 0.00                    -- 할인율은 0과 100 사이의 값
			CHECK (discount_rate BETWEEN 0.00 AND 100.00)
);

-- 가격에 음수 넣어 보기
-- 가격에 음수 입력
INSERT INTO products (name, category, price, stock_quantity)
VALUES ('오류상품', '전자기기', -5000, 10); -- 오류 발생 !

-- 할인율의 범위를 벗어난 값(120) 넣어보기
INSERT INTO products (name, category, price, stock_quantity, discount_rate)
VALUES ('초특가상품', '패션', 50000, 20, 120.0); -- 오류 발생 !

-- 애플리케이션 레벨에서 놓칠 수 있는 데이터의 유효성 검사를 데이터베이스가 직접 수행하여, 비즈니스 규칙에 어긋나는 데이터가 저장될 가능성을 원천적으로 차단하는 강력한 수단!! 
-- 잘 사용하지는 않음!! 정말 기본적인 핵심의 데이터에만 적용해서 최후의 방어선으로 사용하면 된다!