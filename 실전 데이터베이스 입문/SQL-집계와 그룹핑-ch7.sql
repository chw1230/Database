use my_shop;

CREATE TABLE order_stat (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(50),
    category VARCHAR(50),
    product_name VARCHAR(100),
    price INT,
    quantity INT,
    order_date DATE
);
 
 INSERT INTO order_stat (customer_name, category, product_name, price, 
quantity, order_date) VALUES
 ('이순신', '전자기기', '프리미엄 기계식 키보드', 150000, 1, '2025-05-10'),
 ('세종대왕', '도서', 'SQL 마스터링', 35000, 2, '2025-05-10'),
 ('신사임당', '가구', '인체공학 사무용 의자', 250000, 1, '2025-05-11'),
 ('이순신', '전자기기', '고성능 게이밍 마우스', 80000, 1, '2025-05-12'),
 ('세종대왕', '전자기기', '4K 모니터', 450000, 1, '2025-05-12'),
 ('장영실', '도서', '파이썬 데이터 분석', 40000, 3, '2025-05-13'),
 ('이순신', '문구', '고급 만년필 세트', 200000, 1, '2025-05-14'),
 ('세종대왕', '가구', '높이조절 스탠딩 데스크', 320000, 1, '2025-05-15'),
 ('신사임당', '전자기기', '노이즈캔슬링 블루투스 이어폰', 180000, 1, '2025-05-15'),
 ('장영실', '전자기기', '보조배터리 20000mAh', 50000, 2, '2025-05-16'),
 ('홍길동', NULL, 'USB-C 허브', 65000, 1, '2025-05-17'); 
 
 SELECT * FROM order_stat;

-- NULL과 특정 컬럼의 개수: COUNT(컬럼) vs COUNT(*)
-- COUNT(*)와 COUNT(category)의 차이 확인하기
SELECT
 COUNT(*) AS `전체 주문 건수`,
 COUNT(category) AS `카테고리 등록 건수`
 FROM
    order_stat;
    
-- 합계와 평균 계산으로 매출 분석하기: SUM(), AVG()
--  총 매출액과 평균 주문 금액 분석하기
SELECT 
SUM(price * quantity) AS `총 매출액`,
 AVG(price * quantity) AS `평균 주문 금액`
 FROM 
    order_stat;
    
--  총 판매 상품 수량과 주문당 평균 수량 분석하기
SELECT 
SUM(quantity) AS `총 판매 수량`, 
AVG(quantity) AS `주문당 평균 수량`
 FROM 
    order_stat;
    
-- 최대, 최소값으로 상품 전략 세우기: MAX(), MIN()
-- 최고가, 최저가 상품 가격 찾기    
SELECT 
MAX(price) AS 최고가, 
MIN(price) AS 최저가
FROM 
    order_stat;
    
-- 최초 주문일과 최근 주문일 찾기
SELECT 
MIN(order_date) AS `최초 주문일`, 
MAX(order_date) AS `최근 주문일` 
FROM 
    order_stat;
   
-- 고유 고객 수 파악하기: DISTINCT
SELECT 
COUNT(customer_name) AS `총 주문 건수`, 
COUNT(DISTINCT customer_name) AS `순수 고객 수`
 FROM 
    order_stat;
    
--  GROUP BY - 그룹으로 묶기
SELECT
    category,
 COUNT(*) AS `카테고리별 주문 건수`
 FROM
    order_stat
 GROUP BY
    category;

-- 고객별로 총 몇 번이나 주문했을까?
SELECT 
    customer_name, 
COUNT(*) AS `주문 횟수`
 FROM 
    order_stat
 GROUP BY 
    customer_name;
    
-- 그룹별로 심층 분석하기: GROUP BY와 집계 함수
-- 고객별 구매 활동 분석 (VIP 고객 찾기)
 SELECT
    customer_name,
 COUNT(*) AS `총 주문 횟수`,
 SUM(quantity) AS `총 구매 수량`,
 SUM(price * quantity) AS `총 구매 금액`
 FROM
    order_stat
 GROUP BY
    customer_name
 ORDER BY
    `총 구매 금액` DESC; -- 여기서 이렇게 사용할 때는 '`(백틱)'을 사용해야함
    
-- 더 세분화된 그룹으로 분석하기: 여러 컬럼 기준 그룹화
-- 고객이 어떤 카테고리에서 얼마를 사용했는가?
SELECT
    customer_name,
    category,
 SUM(price * quantity) AS `카테고리별 구매 금액`
 FROM
    order_stat
 GROUP BY
    customer_name, category
 ORDER BY
    customer_name, `카테고리별 구매 금액` DESC;
    
-- GROUP BY - 주의사항
-- GROUP BY를 사용할 때 SELECT 절에는 GROUP BY에 사용된 컬럼과 집계 함수만 사용할 수 있다
-- 만약 "각 카테고리에 속한 상품명도 하나 보고 싶다"는 요구를 받았다고 한다면 
/*
- 잘못된 쿼리의 예시 , 이렇게 잘못된 쿼리를 작성하게 된다.
SELECT
    category,
    product_name, -- 바로 이 컬럼이 문제다! / product_name 얘는 상품의 이름이 정말 다양하게 존재한다! 그래서 뭘 보야 줘야 하는 지도 모르는 상태이다 
 COUNT(*)
 FROM
    order_stat
 GROUP BY
    category;
*/

-- 해결책
SELECT
    category,
    min(product_name), -- 이렇게
    max(quantity), -- 집계 함수를 적용하자 그러면 관련 정보를 얻을 수 있다!
    COUNT(*),
    sum(quantity)
 FROM
    order_stat
 GROUP BY
    category;
    
--  HAVING - 그룹 필터링1 - 그룹 안에서의 필터링
SELECT
    category,
 SUM(price * quantity) AS total_sales
 FROM
    order_stat
 GROUP BY
    category;
-- 위의 쿼리에서 매출이 50만원 이상인 것만 얻으려면 어쩌지??
-- where 쓰면 되는 건가? -> 오류 납니다. 
/* 
 WHERE 절은 그룹화가 이루어지기 전, 즉 테이블의 개별 행 하나하나에 대해 조건을 검사!!
 SUM()과 같은 집계 함수는  GROUP BY를 통해 여러 행이 하나의 그룹으로 묶인 후에야 계산될 수 있는 값!!
 따라서 WHERE 절의 입장에서는 아직 존재하지도 않는 값을 조건으로 사용하려는 셈이니, 오류를 내뱉는 것이 당연 
*/
-- 그래서 그룹으로 묶인 뒤에  다시 필터링을 하고 싶을 때 having을 사용한다!
-- WHERE는 그룹화 이전에 개개인을 걸러내는 조건이고, HAVING은 그룹화 이후에 그룹 자체를 걸러내는 조건

-- 그룹을 위한 필터: HAVING 절의 사용법
--  '핵심 카테고리' 필터링하기
select 
	category,
    sum(price * quantity) as total_sales
from 
	order_stat
group by 
	category
having 
	sum(price * quantity) >= 500000;
    
-- HAVING에서 별칭 사용
select 
	category,
    sum(price * quantity) as total_sales
from 
	order_stat
group by 
	category
having 
	 total_sales >= 500000;
     
-- 충성 고객 필터링하기
select
	customer_name,
    count(*) as order_count
from
	order_stat
group by
	customer_name
having 				-- HAVING 절을 추가하여 주문 횟수 3회 이상인 그룹 필터링하기
	count(*) >= 3;
    
-- HAVING - 그룹 필터링2
-- where VS having
/*
where           |          having
group by 이전 작동 | group by 이후 작동
개별 행에 대해 필터링 | 그룹에 대해 필터링
집게함수 사용 x     | 집계함수 사용 o
개별행 선택        | 그룹화된 결과 중 조건에 맞는 그룹을 선택

where는 그룹화 전에 개인을 걸러내는 조건, having은 그룹화 이후에 그룹 자체를 걸러내는 조건
*/

-- WHERE 와 HAVING 함께 사용
-- 가격이 10만 원 이상인 고가 상품들 중에서만 카테고리별로 묶었을 때, 그 고가 상품이 2건 이상 팔린 카테고리는 어디인가요?
select
	category,
    count(*) as premium_order_count
from 
	order_stat
where 
	price >= 100000 -- 이거로 먼저 개인 데이터들 중 가격이 10만원 이상인 애들만 남긴다.
group by 
	category -- 그러고 남긴 애들 중 카테고리로 묶는다.
having 
	count(*) >= 2; -- 묶은 것 중 조건에 만족하느 것만 보여준다.
    
-- sql 실행 순서
/*
1. from : 가장 먼저 실행, 어떠 테이블에거 데이터를 가져올지 결정
2. where : from에서 가져온 테이블의 개별 행 필터링
3. group by : 필터링된 개별 행들을 그룹으로 형성
4. having : 만들어진 그룹에서 필터링을 진행
5. select : 그룹에서도 필터링이 진행된 이후에 우리가 볼 데이터를 여기에서 선택
6. order by : 우리가 보려고 하는 데이터를 정렬 하는 단계
7. limit : 정렬된 데이터에서 특정 개수로 제한하는 단계
*/
/* 문제
2025년 5월 14일 이전에 들어온 주문들 중에서(WHERE), 고객별로 그룹화하여(GROUP BY), 주문 건수가 2회 이
상인 고객을 찾아서(HAVING), 해당 고객의 이름과 총 구매 금액을 조회하고(SELECT), 총 구매 금액을 기준으로 내
림차순 정렬해라(ORDER BY) 그리고 하나의 데이터만 출력해라. */
select
	customer_name,
    sum(price * quantity) as total_purchase
from 
	order_stat
where 
	order_date < '2025-05-14'
group by
	customer_name
having 
	count(*) >= 2
order by 
	total_purchase desc
limit 1;