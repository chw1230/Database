use my_shop2;

-- INDEX 2
/* 옵티마이저는 인덱스를 사용하는게 더 비효율적이라고 판단하면, 인덱스가 존재해도 과감히 포기하고 테이블 전체를 스캔하는 방법을 택함
인덱스를 사용하면 검색 대항의 양은 줄어들지만(정렬해서) 인덱스에 저장된 주소로 여러 흩어진 위치에 랜덤하게 접근해야 함
그래서 전체 데이터의 약 20~25% 이상을 조회해야 하는 쿼리는 인덱스를 통해 테이블의 각 행에 개별적으로 접근하는 것(랜덤 I/O)보다, 테이블 전체를 순차적으로 스캔(순차 I/O)하는 것이 더 효율적
순차(책을 1페이지부터 순서대로 읽기)와 랜덤(책의 여러 페이지를 순서 없이 찾아 읽기) 비교
랜덤은 데이터의 위치를 찾는 데 걸리는 시간(탐색 시간)이 추가로 존재하기 때문에 순차 I/O에 비해 느림 */

-- 여러 번의 랜덤 I/O를 수행하는 것보다 한 번의 순차 I/O가 더 빠른 경우 -> 예시 1: 인덱스를 사용하는 효율적인 범위 검색
EXPLAIN SELECT * FROM items WHERE price BETWEEN 50000 AND 100000;
-- 결과 : rows => 5, 25건중 5건 -> 20% / type => range(인덱스 사용한 것을 알 수 있음)

-- 예시 2: 인덱스를 포기하는 비효율적인 범위 검색 -> 범위를 더 늘려보기
EXPLAIN SELECT * FROM items WHERE price BETWEEN 1000 AND 200000;
-- 결과 : possible_keys => iex_time_price(인덱스가 존재함을 알고 있음) /  rows => 25, 76% / type => ALL(풀 테이블 스캔한 것을 알 수 있음)
-- 옵티마이저는 19건의 데이터를 찾기 위해 인덱스를 읽고, 다시 테이블에 19번의 Random I/O을 하는 것보다, 그냥 테이블 전체(25건)를 한 번에 쭉 Sequential I/O하는 것이 더 저렴하다고 판단한

-- 데이터의 수가 애초에 그냥 너무 적으면 풀 테이블 스캔 할 수 있음!! ( 1000 페이지 책의 인덱스와 2 페이지 책의 인덱스 -> 2 페이지 책의 인덱스 왜 봄? )

-- 커버링 인덱스 
-- 인덱스가 있어도 무조건 사용하지는 않는 다는 것을 알 수 있었음!
-- 위에서 말한 것 처럼 인덱스 스캔 + 주소를 통해서 테이블 접근(여기에서 랜덤 I/O 발생) 그렇다면 랜덤 I/O를 없애기 는 방법은 없나?
-- 해결책 : 커버링 인덱스 : 쿼리에 필요한 모든 컬럼을 포함하고 있는 인덱스, 모든 컬럼을 가지고 있으면 원본 테이블에 전혀 접근하지 않고 오직 인덱스만을 읽어서 쿼리를 처리하도록!

-- 예시: 커버링 인덱스의 적용 전과 후
select item_id, price,item_name from items where price between 50000 and 100000;
-- extra : Using index condition -> 인덱스를 사용했지만 select절의 조회를 위해서는 다른 추가 작업이 필요한 것을 의미한다!
-- 작동 방식 : idx_items_price 인덱스를 스캔하여 price가 조건에 맞는 행의 item_id 를 5개 찾고 5개의 item_id 를 사용해, items 테이블의 원본 데이터에 5번 접근하여 각각의 item_name을 가져옴 (5번의 랜덤 I/O 발생)
-- 인덱스에 포함되지 않은 컬럼을 조회해야 해서 그런 것!!!!

-- 커버링 인덱스 적용 - 인덱스 컬럼만 조회하는 경우
select item_id, price from items where price between 50000 and 100000; 
-- 인덱스에 이미 select 절에서 요구하는 것들이 모두 포함 되어 있었으므로 원본 테이블에 접근하지 않고, 이 경우에는 커머빌 인덱스의 역할을 수행함을 알 수 있다.
-- explain -> extra : Using index => 오직 인덱스에서만 읽어서 처리 했음 , Using whrer => 쿼리의 where 문을 인덱스 내에서만 사용해서 결과를 얻었음을 알 수 있음 

-- 커버링 인덱스 적용 - item_name 추가
-- 기존 인덱스 삭제
DROP INDEX idx_items_price ON items;
CREATE INDEX idx_items_price_name ON items (price, item_name); -- price로 먼저 정렬하고, price가 같으면 item_name으로 다시 정렬하는 구조의 인덱스!

explain select item_id, price, item_name
from items
where price between 50000 and 100000; -- 커버링 인덱스를 사용했음을 알 수 있음
-- 장점 : 압도적인 조회 성능 : 랜덤 I/O를 제거하여 인덱스에서만 조회하여 성능을 향상시킴, count 쿼리 에서도 본 테이블이 아닌 인덱스 테이블만 조회해서 스캔 결과를 빠르게 반환
-- 단저 : 저장 공간의 증가, 쓰기 성능 저하 inser, update, delete 작업시에 테이블 데이터 뿐만 아니라 인덱스도 함께 수정해야해서 복잡할 수록 작업에 대한 부하가 커짐!
-- 언제 쓰나요? : 조회가 매우 빈법하고, 쓰기 작업은 상대적으로 적은 테이블에 사용!!!!, select 절에서 조회하는 컬럼의 개수가 적을 때 유리 (select * 에서 쓰면 아무 의미 없겠지!!), 성능 저하가 발생하는 특정 쿼리를 튜닝하기 위한 '비장의 무기'로 사용됨

-- 복합 인덱스 1 
-/*
다중 조건 쿼리의 성능을 최적화하기 위해 사용하는 것 -> 복합 인덱스(Composite Index) 또는 다중 컬럼 인덱스(Multi-column Index)
복합 인덱스를 제대로 사용하는 방법 : 컬럼의 순서 매우 중요 성능을 주지우지 할 수 있음 왜 그런거지?
만약에 category, price 순서로 복합 인덱스를 만들었다면 category로 정렬하고 같은 경우에 price로 정렬한다는 것임!!
category로만 정렬 -> 효율적 이미 정렬되어 있으니까, category와 price 함께 정렬 -> 이것도 효율적 카테고리 속에서 price도 이미 정렬되어 있기 때문에 
price 만으로 정렬하기 => 매우 비효율적!!! -> category 별로 다 흩어져 있으니까 풀 테이블 스캔을 선택하는 비효율 발생할 수 있음! */

/* 이렇게 복합 인덱스는 첫 번째 컬럼을 기준으로 정렬된 상태에서만 제 역할을 할 수 있음 => 이것을 인덱스 왼쪽 접두어 규칙이라고 한다!!!! a,b,c 순서로 생성 되었다면 a or a,b or a,b,c 이ㅓㄹ헥 where절에 사용해야하는 것이다!!!
복합 인덱스를 설계하고 사용할 때는 다음 세 가지 대원칙을 반드시 기억하기!!!!!!
1. 인덱스는 순서대로 사용하기!!! (왼쪽 접두어 규칙)
2. 등호(=) 조건은 앞으로, 범위 조건(<, >)은 뒤로 보내서 사용하기!!!!!
3. 정렬(ORDER BY)도 인덱스 순서를 따라서 사용하기!!!! */

show index from items; -- 내가 가진 인덱스 보기
-- 모두 지우기..
DROP INDEX idx_items_item_name ON items;
DROP INDEX idx_items_price_name ON items;
DROP INDEX idx_items_price ON items;
DROP INDEX idx_items_price_desc ON items;
DROP INDEX idx_items_price_category_temp ON items;
DROP INDEX idx_items_category_price ON  items;

-- 복합 인덱스 만들기 
create index idx_items_category_price on items (category,price);

-- 복합 인덱스 성공 : category 사용
EXPLAIN SELECT * FROM items WHERE category = '전자기기';
-- type,           key,              rows, filtered, Extra
-- 'ref', 'idx_items_category_price', '10', '100.00', NULL
-- 우리가 만든 복합 idx 사용! 첫 번째 정렬 조건인 category를 정렬순으로 쭉 가서 '전자기기'를 찾은 것!!!

-- 복합 인덱스 성공 : category, price 사용
EXPLAIN SELECT * FROM items WHERE category = '전자기기' and price = 12000;
-- type,           key,              rows, filtered, Extra
-- 'ref', 'idx_items_category_price', '1', '100.00', NULL
-- 우리가 만든 복합 idx 사용! 첫 번째 정렬 조건인 category를 정렬순으로 쭉 가서 '전자기기'를 찾고 그 안에서 price 가 120000 인 지점을 탐색한다. '전자기기' 섹션 내부는 이미 price 순으로 정렬되어 있으므로, 원하는 데이터를 매우 빠르게 찾을 수 있음
-- 쿼리에서 조회 하는 경우에 사용되는 where 절에서의 순서 price, category / category, price -> 이 순서는 상관이 없음!!

-- 복합 인덱스 성공 : 복합 인덱스와 정렬 사용 ( 정렬이 정렬작업을 진행하는 것이 아니라 그래도 인덱스를 쭉 타고 가는 경우 )
EXPLAIN SELECT * FROM items 
WHERE category = '전자기기' AND price > 100000
ORDER BY price;
-- type,           key,              rows, filtered, Extra
-- 'range', 'idx_items_category_price', '8', '100.00', Using index condition   -> 이 부분이 file sort가 아닌 것이 중요!
/* 작동 방식 보기
1. idx_items_category_price 인덱스를 사용해 category 가 '전자기기'인 섹션으로 이동
2. 해당 섹션 내에서, price 가 100000 을 초과하는 첫 번째 데이터를 찾기
3. 그 지점부터 '전자기기' 섹션이 끝날 때까지 인덱스를 순서대로 따라가며 읽기!
RDER BY 를 사용할 때 복합 인덱스의 순서대로 정렬하면 추가적인 정렬( filesort )을 피할 수 있는 장점을 이용하는 것이 중요! */ 

-- 복합 인덱스 2
-- 인덱스 순서를 무시한 조회
explain select * from items where price = 8000; -- 풀 테이블 스캔 발생
-- 인덱스 왼쪽 접두어 규칙 때문에 문제 발생, category로 먼저 정렬 되어 있기 때문에 price 8000은 여기 저에에 퍼져있을 수 있음

-- 범위 조건을 먼저 사용한 문제
-- 선행 컬럼에 범위 조건( > , < , BETWEEN , LIKE % ) 이 사용되면, 그 뒤에 오는 컬럼은 인덱스를 제대로 활용할 수 없다는 점
EXPLAIN SELECT * FROM items WHERE category >= '패션' AND price = 20000;
-- filtered를 보면 10% 라고 뜨고 Extra에 Using index condition이라고 되어 있음
-- 작동 방식 : 우선 패션부터 쭉 정렬되어 패션, 헬스/케어 이렇게 쭉 되어 있음 그러면 price는 완벽한 정렬이 되어 있다고 보기 어려움!! -> 그래서 인덱스를 통한 빠른 탐색이라고 할 수 없음!!!
-- 그래서 범위 조건은 가장 뒤에 사용해야한다!! , 덤위 조건 뒤에 오는 컬럼은 인덱스의 장점인 정렬을 잘 사용할 수 없음!!

-- 복합 인덱스 3
-- 등호 조건은 앞에 , 범위 조건을 사용하는 경우에는 뒤에 사용한다!!!
-- 만약 그렇다면 
SELECT * FROM items
WHERE category >= '패션' AND price = 20000; -- 이 쿼리가 너무 자주 쓰인다고 한다면?
-- 인덱스의 순서조건을 바꾼 인덱스를 생성해서 사용하자!!!
create index idx_price_category_tmp on items (price,category);

-- 확인해보자!
EXPLAIN SELECT * FROM items
WHERE category >= '패션' AND price = 20000;
-- 인덱스 후보 2개중에 ~~tmp 인덱스 를 사용한 것을 볼 수 있고, rows도 하나이고, filterd도 100%임을 볼 수 있음!
-- 인덱스가 일단 price로 쭉 정렬하니까 price = 20000을 빠르게 찾을 수 있음!! 그 뒤에 category 조건에 맞게 조회해오 면 효과적인 인덱스 사용이다!
-- 그래서 정리하면 인덱스 정렬 순서를 고려하는 과정에서 등호 조건을 먼저 처리해서 범위를 좁히고, 그 다음에 범위 조건을 처리하는 것이 인덱스 설계의 핵심!!!
-- 하지만 이렇게 인덱스를 무한 생성하는 것 보다, 기존의 인덱스를 잘 활용하는 것도 중요!!! 사실 기존의 인덱스를 이용해서 문제를 해결하는 방법이 있음!!

-- 그 방법을 위해서 tmp 인덱스 지우기!
drop index idx_price_category_tmp on items;

-- 실무 팁 : IN 절의 사용
-- IN 조건을 사용한 검색
explain select * from items
where category in ( '패션','헬스/뷰티') and price = 20000; 
-- rows 가 2로 줄어듬!! 그리고 filtered도 100%로 바뀜! 인덱스를 잘 활용했단 증거!!!
/*
(category = '패션' AND price = 20000) 또는 (category = '헬스/뷰티' AND price = 20000) 를 만족하는 데이터를 찾는 것으로 해석됨!
('패션', 20000) 조합을 만족하는 데이터를 찾고, ('헬스/뷰티', 20000) 조합을 만족하는 데이터를 찾음!! 
IN 은 '여러 개의 개별 지점'에 대한 동등( = ) 비교의 묶음으로 처리된다 in과 특정 빔위를 구체적으로 in( ) 괄호에 표기하여 동등 조건으로 이용하는 것!!!!
실무에서 이 특정된 범위가 있는 컬럼에 in을 많이 사용한다. in ( 품절, 판매중 ) 이런 식으로!! )
*/

-- 복합 인덱스 정리 
/* 인덱스는 순서대로 사용하기! (왼쪽 접두어 규칙)
2. 등호(=) 조건은 앞으로, 범위 조건(<, >)은 뒤로!
3. 정렬(ORDER BY)도 인덱스 순서를 따르기
*/

-- 인덱스 설계 가이드 라인
/* 
해핵심 원칙: 카디널리티 (Cardinality)
인덱스를 어디에 걸지 판단하는 가장 중요한 기준은 바로 카디널리티(Cardinality) 카디널리티란, 해당 컬럼에 저장된 값들의 고유성(uniqueness) 정도를 나타내는 지표
카디널리티가 높다 (High Cardinality): 해당 컬럼에 중복되는 값이 거의 없다 / 카디널리티가 낮다 (Low Cardinality): 해당 컬럼의 값이 몇 종류 안되어 중복되는 값이 많다
무조건  인덱스는 카디널리티가 높은, 식별력이 좋은 컬럼에 생성할 때 가장 효율적

1. where 절에서의 사용
사용자들이 검색하는 경우 이름이나 카테고리로 검색하느 경우가 많기에 이것들은 인덱스 생성의 우선 후보가 된다 할 수 있음!

2. JOIN의 연결고리가 되는 컬럼 (외래 키 이용)
join의 성능은 연결고리가 되는 컬럼에 인덱스가 있느지에 따라서 성능이 달라진다!!

SELECT s.seller_name,  i.item_name, i.price
FROM items i
JOIN sellers s ON i.seller_id = s.seller_id
WHERE s.seller_name = '행복쇼핑';

지금 이 쿼리를 보면 -> 만약에 seller_id가 외래 키로 등록 이 안되었다면 -> 인덱스 도 없음( 외래키 자동 인덱스 등록 성질 때문) 그러면 동작이 엄청 느릴 것!!
-> 왜? => 1. seller_name = '행복쇼핑' 찾기 2. seller_id = n인 상품 하나씩 찾기! 

하지만 외래키 등록 되어 있어서 자동 인덱스 형성되어 있다면 그냥 이름 찾고 정렬되어 있는 곳에서 바로 찾아내어 성능이 빠름!

3. ORDER BY 절에서 자주 사용되는 컬럼
order by 컬럼에서 자주 사용될 것이라고 예측이 된다면 해당 인덱스를 미리 만들면 order by 정렬에서 그대로 따라가기만 하면 되므로 매우 성능을 높일 수 있다!
*/

-- 인덱스의 단점과 주의 사항
/* 1. 저장 공간
원본 테이블 크기의 약 10% 내외의 공간을 추가로 차지한다

2. 쓰기 성능 (INSERT , UPDATE , DELETE )
인덱스는 SELECT 의 속도를 높이는 대가로, INSERT , UPDATE , DELETE 의 속도를 희생시킴!!
왜 그럴까? -> 데이터에 변경이 일어날 때마다, 데이터베이스는 원본 테이블뿐만 아니라 이와 관련된 모든 인덱스를 함께 수정해야 하기 때문에!!!
insert - 상품이 등록되면( INSERT ), items 테이블에 행이 추가됨, 동시에, 이 테이블에 생성된 모든 인덱스(예: PRIMARY , seller_id , idx_items_category_price )의 B-Tree에도 새로운 데이터에
대한 키 값과 주소가 추가되어야 한기 때문에!!
delete - 테이블에서 행이 사라진다. 동시에 모든 인덱스에서도 해당 상품에 대한 키 값이 삭제 되어야 함!
UPDATE - (가장 복잡)기존 price 값으로 된 인덱스 항목을 '삭제'하고, 새로운 price 값으로 인덱스 항목을 '추가'하는 것과 유사한 작업을 수행
왜냐하면 인덱스는 변경된 값에 맞추어 새로운 정렬 상태(=바뀐 값이 똑바로 정렬되었나를 확인해야하니까)를 유지해야 하기 때문에 이는 INSERT 와 DELETE 가동시에 발생하는 것과 같음!

- 읽기 중심의 서비스 : 조회가 많ㅇ느 서비스라면, 조회 성능을 높이기 위해 인덱스를 비교적 자유롭게 생성!
- 쓰지 중심 서비스 : 채팅, 주식 거래, 로깅 처럼 insert나 update가 빈번한 서비스라면, 인덱스 생성에 매우 보수적이여야함!
- 혹시나 해서 인덱스를 만들지 말기!!! -> 공간만 차지한다! => 필요할 때 만들어서 쓰기!
- 사용하지 않는 인덱스는 주기적으로 정리하기!*/