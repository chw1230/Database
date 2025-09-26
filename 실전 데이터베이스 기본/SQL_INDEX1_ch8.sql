use my_shop2;

-- 인덱스1
-- 실습을 위한 데이터 넣기
-- 판매자 테이블 생성
CREATE TABLE sellers (
 seller_id INT PRIMARY KEY AUTO_INCREMENT, seller_name VARCHAR(100) UNIQUE NOT NULL,
 registered_date DATE NOT NULL
);

-- 상품 테이블 생성
CREATE TABLE items (
 item_id INT PRIMARY KEY AUTO_INCREMENT,
 seller_id INT NOT NULL,
 item_name VARCHAR(255) NOT NULL,
 category VARCHAR(100) NOT NULL,
 price INT NOT NULL,
 stock_quantity INT NOT NULL,
 registered_date DATE NOT NULL,
 is_active BOOLEAN NOT NULL,
  CONSTRAINT fk_items_sellers FOREIGN KEY (seller_id)
REFERENCES sellers(seller_id)
);
-- 판매자 데이터 입력
INSERT INTO sellers (seller_id, seller_name, registered_date) VALUES
(1, '행복쇼핑', '2020-01-15'),
(2, '스마트상점', '2021-03-22'),
(3, '글로벌셀러', '2019-11-01'),
(4, '에코마켓', '2022-07-10'),
(5, '베스트딜', '2020-05-30'),
(6, '패션리더', '2023-01-05'),
(7, '리빙스타', '2021-09-12'),
(8, '테크월드', '2022-04-18'),
(9, '북스토리', '2020-08-25'),
(10, '헬스앤뷰티', '2023-03-01');


-- 상품 데이터 입력
INSERT INTO items (item_id, seller_id, item_name, category, price, stock_quantity, registered_date, is_active) 
	VALUES
	(1, 1, '무선 기계식 키보드', '전자기기', 120000, 100, '2022-01-20', TRUE),
	(2, 1, '4K UHD 모니터', '전자기기', 450000, 50, '2022-02-15', TRUE),
	(3, 2, '프리미엄 게이밍 마우스', '전자기기', 80000, 200, '2021-11-10', TRUE),
	(4, 3, '관계형 데이터베이스 입문', '도서', 30000, 500, '2020-05-01', TRUE),
	(5, 4, '친환경 세제', '생활용품', 15000, 300, '2023-08-01', FALSE),
	(6, 5, '고급 가죽 지갑', '패션', 70000, 120, '2022-06-25', TRUE),
	(7, 1, '스마트 워치', '전자기기', 250000, 80, '2023-03-10', TRUE),
	(8, 6, '캐시미어 스웨터', '패션', 95000, 70, '2023-10-05', FALSE),
	(9, 7, '아로마 디퓨저', '생활용품', 40000, 150, '2022-09-01', TRUE),
	(10, 8, '게이밍 노트북', '전자기기', 1500000, 30, '2023-01-30', TRUE),
	(11, 9, 'SQL 마스터 가이드', '도서', 35000, 400,'2021-04-12' , TRUE),
	(12, 10, '유기농 비누 세트', '헬스/뷰티', 20000, 250, '2023-02-20', FALSE),
	(13, 1, '노이즈 캔슬링 헤드폰', '전자기기', 300000,90, '2023-07-01', TRUE),
	(14, 2,'인체공학 키보드','전자기기',90000,110,'2022-05-05', TRUE),
	(15, 3, '파이썬 프로그래밍 가이드', '도서', 28000, 600, '2021-01-01', FALSE),
	(16, 4, '재활용 쇼핑백', '생활용품', 5000, 1000, '2023-09-15', TRUE),
	(17, 5, '빈티지 가죽 백팩', '패션', 180000, 60, '2022-08-01', TRUE),
	(18, 6, '여름용 린넨 셔츠', '패션', 45000, 180, '2023-04-20', TRUE),
	(19, 7, '친환경 주방 세트', '생활용품', 60000, 130, '2022-10-10', FALSE),
	(20, 8, '고성능 그래픽 카드', '전자기기', 800000, 40, '2023-06-01', TRUE),
	(21, 9, '어린이를 위한 그림책', '도서', 18000, 700, '2022-03-01', TRUE),
	(22, 10, '천연 에센셜 오일', '헬스/뷰티', 25000, 200, '2023-05-10', TRUE),
	(23, 1, '휴대용 빔 프로젝터', '전자기기', 350000, 70, '2023-02-01', TRUE),
	(24, 2, '게이밍 의자', '전자기기', 200000, 90,'2022-07-20' , TRUE),
	(25, 3, '세계사 탐험', '도서', 22000, 350, '2021-02-28', false);
    
select * from sellers;
select * from items;

-- 인덱스가 필요한 이유
/* 만약에 데이터가 엄청 많아졌는데 기존과 같이 조회한다면 찾는데 오래걸림 왜? 직접 하나하나 DB가 다 조회하는 행위이기 떄문에 이러한 방식을 풀 페이지 스캔이라 한다. 
데이터가 많아 질 수록 점점 느려지게 됨! */

-- 인덱스 생성, 조회, 삭제
-- 인덱스 생성하기
create index idx_item_item_name on items(item_name);

-- 만들어 진 것 확인하기 
show index from items;
-- 인덱스는 unique, primary key, foreigen key, unique 제약 조건에 대해서 기본적으로 index를 생성해둔다!!!
-- 확인 했을 때 Key_name은 인덱스의 번호를 Column_name은 어떤 컬럼을 기반으로 생성한 것 인지

-- 인덱스 삭제
drop index idx_item_item_name on items;

-- 인덱스가 정말 사용되는지 확인하는 법 ( EXPLAIN 사용하기 )
-- 인덱스 삭제하고 확인하는 경우
EXPLAIN SELECT * FROM items WHERE item_name = '게이밍 노트북';
-- 결과 값 분석 해보자!
/*
tyep: ALL 이라고 나옴!!! 의미 : 이 값을 조회하기 위해서 출 테이블 스캔을 진행하였음을 의미!!! -> 모든 데이터를 하나씩 다 읽어서 조건에 맞는 데이터를 찾는다. / ref 는 = 조건이나 join에서 사용한 것임을 알 수 있음, range는 범위 검색에서 사용한 것임을 알 수 있음!
key: NULL 이라고 나옴 / 의미 : 어떤 인덱스도 사용하지 못했다는 것을 의미
rows: 25 의미 : 옵티마이저가 쿼리를 처리하기 위해서 탐색할 것으로 예상되는 행의 수를 의미
filtered: 10.00 %를 의미하며 테이블에서 읽어온 전체 행에서 where 절로 필터링되어 최종적으로 보여지는 행의 수를 %로 나타 낸 것!
Extra: using where 의미 : where를 사용해서 필터링을 진행 했음을 알 수 있음! */

-- 인덱스와 동등 비교
-- 인덱스의 사용처 3개 - 1. 동등 비교, 2. 범위 검색, 3. order by의 정렬 작업

-- 인덱스 만들기
create index idx_items_item_name on items(item_name);
explain select * from items where item_name = '게이밍 노트북';
/* 결과 분석 :
type : ref -> 인덱스를 써서 동등비교(=)를 했다, 
key = idx_items_item_name -> 사용된 인덱스 이름
rows : 1 -> 단 1개의 행만 읽으면 된다!
*/

-- 인덱스와 범위 검색
-- 인덱스 없이 사용했을 때 
explain select * from items where price between 50000 and 100000;
/* 결과 분석 :
type : ALL -> 풀 테이블 스캔
row2 : 25 -> 25줄을 모두 확인 등등 */

-- 인덱스 생성하기
create index idx_items_price on items(price);
-- 생성 한 뒤에 사용했을 때
explain select * from items where price between 50000 and 100000;
/* 결과 분석 : 
type : range -> 범위 분석에 idx를 사용했구나!
key: idx_items_price -> idx_items_price가 사용되었구나!
rows: 5 -> 스캔할 것으로 예측되는 행의 수가 5개로 확 줄었다!
filtered: 100.00 -> inx를 이용해서 스캔한 행을 전부 다 사용한다!

indx의 range 검색 작동 방식 분석하기 -> 먼저 price가 50000원 이상인 조건을 찾는다! 이후에 100000까지 쭉 확인하고 그냥 나가버림! -> 왜 나가? => 이미 정렬 되어 있으니 그뒤에 100000 이하의 값이 올 수 없음!
*/
select * from items where price between 50000 and 100000; -- 결과에서 주목할 점!!!
-- 주목할 점은 바로 price가 정렬되어 나타난다는 거!! -> 왜 그런거지? => 인덱스 없을 땐 item_id(pk) 순서로 결과가 나옴 하지만 인덱스가 있으니까 이것을 활용해서 인덱스 키인 price를 이용했음을 알 수 있다!!!, 근데 항상 이런 것은 아니고! price를 이용해서 정렬하려면 order by를 추가해야함!

-- 인덱스와 LIKE 범위 검색
-- like 절에서 %를 사용하는 경우에는 '검색어%' 이러식으로 검색어 뒤에 %가 위치 해야한다!
EXPLAIN SELECT * FROM items WHERE item_name LIKE '게이밍%';
-- 결과 분석 : 이것도 범위 분석이랑 같은 것임 정렬되어 있기 때문에!!!! 게이밍으로 시작하는 단어들을 쭉 찾을 것이기 때문에 게이밍 뒤에 이어지는 말들은 게이밍 ~~~ 쭉 이렇게 정렬되어 있을 것임!

-- like 범위 검색에서 idx 사용이 실패하는 예제
-- 와일드 카드가 검색어 앞에 오는 경우 실패하게 됨! '%검색어' 일단 분석부터 해보자!
EXPLAIN SELECT * FROM items WHERE item_name LIKE '%게이밍'; -- 결과 분석 : type : ALL -> 풀 테이블 스캔이 일어남! 
-- 왜 그런 걸까? -> 정렬 방식을 보자 ㄱ부터 쭉 정렬되어 있음 근데 중간에 게이밍이 들어간 글자를 찾으려면 ㄱ부터 ㅎ까지 싹다 돌아야함 -> 풀 테이블 스캔 발생!
-- 결론 : 그래서 인덱스를 사용한 like 검색은 와일드카드를 검색어의 마지막에 붙여서 사용해야한다!

/* 실무 팁!! : 전문 검색, 전체 문자 검색 (Full-Text Search)
이처럼 LIKE '%검색어%' 방식은 데이터가 많아질수록 성능이 심각하게 저하되어 실제 서비스에서는 사용 어려움! 
이런 '내용 검색' 또는 '포함 검색' 문제를 해결하기 위해 데이터베이스는 전문 검색(Full-Text Search) 특수한 기능을 제공
전문 검색 인덱스는 B-Tree 인덱스와는 달리, 텍스트를 단어(토큰) 단위로 쪼개서 인덱싱하는 방식으로 텍스트 중간에 있는 단어도 매우 빠르게 검색할 수 있음!!
만약 쇼핑몰에서 상품명 검색 기능을 구현해야 한다면, LIKE 대신 MATCH ... AGAINST 구문을 사용하여 전문 검색 기능을 이용하자! */

-- 인덱스와 정렬 
-- 인덱스를 이용해서 정렬하기 , 인덱스는 이미 데이터가 특정 순서로 정렬된 자료구조이다. 그렇다면 이 정렬된 인덱스를 통해서 order by의 성능을 늘려보자!
explain select * from items where price between 50000 and 100000
order by price; -- 우리가 아까 위해서 price로 인덱스를 만들었었음!! 그러면 price는 당연히 정렬되어 있는 상태임!

select * from items where price between 50000 and 100000
order by price;

select * from items where price between 50000 and 100000;
-- 둘의 결과가 같아요!

-- 그러면 오름차순 정렬 말고 내림 차순 정렬하면 filesort(인덱스를 활용하지 않는 쿼리에서 사용됨)가 사용될까?
explain select * from items where price between 50000 and 100000
order by price desc; -- 아니다!! Backward index scan 이라느 새로운 것이 생겼음 이것 뭐임? -> 옵티마이저가 역방향 스캔을 알아서 해줌!! 큰수에서 작은수로 알아서 찾아준다고 생각하면 됨!
-- 이런 방식으로 정렬해서 오름 차순 , 내림 차순 모두 filesort 방식을 사용하지 않도록 하는 것이 중요하다.

-- 내림차순 인덱스 -> 데이터 자체를 처음부터 내림차순으로 정렬해서 저장하는 것!
-- 기존의 오름차순 인덱스를 삭제하고 확인해보기
DROP INDEX idx_items_price ON items;
-- price 컬럼에 내림차순 인덱스 생성
CREATE INDEX idx_items_price_desc ON items (price DESC);

-- 결과 확인
explain select * from items where price between 50000 and 100000; -- bcakindex scan 사라짐!

-- 다시 지우고 복구하기
-- 기존의 오름차순 인덱스를 삭제하고 확인해보기
DROP INDEX idx_items_price_desc ON items;
-- price 컬럼에 내림차순 인덱스 생성
CREATE INDEX idx_items_price ON items(price); 

-- 굳이 필요 없는 것 같겠지만 여러 컬럼에 대해 서로 다른 정렬 순서 (오름차순과 내림차순의 혼합)가 필요한 복잡한 쿼리에서는 내림차순 인덱스의 장점을 느낄 수 있다!ex> ORDER BY category ASC, registered_date DESC