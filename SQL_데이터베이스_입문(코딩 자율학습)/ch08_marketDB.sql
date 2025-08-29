-- market DB 생성 진입
create database market;
use market;

-- users 테이블 생성
create table users (
	id integer auto_increment,
    email varchar(255) unique,
    nickname varchar(255) unique,
    primary key (id)
);
-- users 데이터 삽입
insert into users (email, nickname)
values
	('kim@naver.com','kim'),
	('choi@naver.com','choi'),
	('park@naver.com','park');
    
-- products 테이블 생성
CREATE TABLE products (
	id INTEGER AUTO_INCREMENT, 	-- 아이디(자동으로 1씩 증가)
	name VARCHAR(100), 			-- 상품명
	price INTEGER, 				-- 가격
	product_type VARCHAR(50), 		-- 상품 유형
	PRIMARY KEY(id) 			-- 기본키 지정: id
);
-- products 데이터 삽입
INSERT INTO products (name, price, product_type)
VALUES
	('우유 900ml', 1970, '냉장 식품'),
	('참치 마요 120g', 4400, '냉장 식품'),
	('달걀 감자 샐러드 500g', 6900, '냉장 식품'),
	('달걀 듬뿍 샐러드 500g', 6900, '냉장 식품'),
	('크림 치즈', 2180, '냉장 식품'),
	('우유 식빵', 2900, '상온 식품'),
	('샐러드 키트 6봉', 8900, '냉장 식품'),
	('무항생제 특란 20구', 7200, '냉장 식품'),
	('수제 크림 치즈 200g', 9000, '냉장 식품'),
	('플레인 베이글', 1300, '냉장 식품');
    
-- orders 테이블 생성
CREATE TABLE orders (
	id INTEGER AUTO_INCREMENT, 	-- 아이디(자동으로 1씩 증가)
	status VARCHAR(50), 			-- 주문 상태
	created_at DATETIME, 			-- 주문 생성 시각
	user_id INTEGER, 				-- 사용자 아이디
	PRIMARY KEY (id), 			-- 기본키 지정: id
	FOREIGN KEY (user_id) REFERENCES users(id) -- 외래키 지정: user_id
);
-- orders 데이터 삽입
INSERT INTO orders (status, created_at, user_id)
VALUES
	('배송 완료', '2024-11-12 11:07:12', 1),
	('배송 완료', '2024-11-17 22:14:54', 1),
	('배송 완료', '2024-11-24 19:13:46', 2),
	('배송 완료', '2024-11-29 23:57:29', 3),
	('배송 완료', '2024-12-06 22:25:13', 3),
	('배송 완료', '2025-01-02 13:04:25', 2),
	('배송 완료', '2025-01-06 15:45:51', 2),
	('장바구니', '2025-03-06 14:54:23', 1);
    
-- payments 테이블 생성
CREATE TABLE payments (
	id INTEGER AUTO_INCREMENT, 	-- 아이디(자동으로 1씩 증가)
	amount INTEGER, 			-- 결제 금액
	payment_type VARCHAR(50), 	-- 결제 유형
	order_id INTEGER, 			-- 주문 아이디
	PRIMARY KEY (id), 			-- 기본키 지정: id
	FOREIGN KEY (order_id) REFERENCES orders(id) -- 외래키 지정: order_id
);
-- payments 데이터 삽입
INSERT INTO payments (amount, payment_type, order_id)
VALUES
	(9740, 'SAMSONG CARD', 1),
	(13800, 'SAMSONG CARD', 2),
	(32200, 'LOTTI CARD', 3),
	(28420, 'COCOA PAY', 4),
	(18000, 'COCOA PAY', 5),
	(5910, 'LOTTI CARD', 6),
	(17300, 'LOTTI CARD', 7);
    
-- order_details 테이블 생성
CREATE TABLE order_details (
	id INTEGER AUTO_INCREMENT, 	-- 아이디(자동으로 1씩 증가)
	order_id INTEGER, 			-- 주문 아이디
	product_id INTEGER, 			-- 상품 아이디
	count INTEGER, 				-- 주문 수량
	PRIMARY KEY (id), 			-- 기본키 지정: id
	FOREIGN KEY (order_id) REFERENCES orders(id), 	-- 외래키 지정: order_id
	FOREIGN KEY (product_id) REFERENCES products(id) -- 외래키 지정: product_id
);
-- order_details 데이터 삽입
INSERT INTO order_details (order_id, product_id, count)
VALUES
	(1, 1, 2),
	(1, 6, 2),
	(2, 3, 1),
	(2, 4, 1),
	(3, 7, 2),
	(3, 8, 2),
	(4, 2, 3),
	(4, 5, 4),
	(4, 10, 5),
	(5, 9, 2),
	(6, 1, 3),
	(7, 8, 2),
	(7, 6, 1),
	(8, 6, 3);
    
-- 상품 유형별 집계
select product_type as '상품 유형' , count(*) as '상품 개수' , max(price) as'최고 가격', min(price) as '최저 가격'
from products
group by product_type;

-- 사용자별 주문 총액 필터링
select nickname as '주문자명', sum(amount) as '주문 총액'
from orders
join users on orders.user_id = users.id
join payments on orders.id = payments.order_id
group by nickname
having sum(amount) >= 30000;		-- 주문 총액이 30000원 이상인 주문자 조회

-- 가장 많이 팔린 상품 TOP 3 찾기
select name as '상품명', sum(count) as '판매 수량'
from order_details
join orders on order_details.order_id = orders.id
join products on order_details.product_id = products.id and status = '배송 완료' -- 장바구니 상품은 제외해야함
group by name
order by sum(count) desc
limit 3;