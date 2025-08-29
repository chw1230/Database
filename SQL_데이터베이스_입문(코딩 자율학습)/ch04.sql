-- mapdonalds DB 진입
use mapdonalds;

-- 가장 싼 버거와 가장 비싼 버거의 가격 조회
SELECT max(price), min(price)
FROM burgers;

-- 무게가 240을 초과하는 버거의 개수 세기
select count(*)
FROM burgers
where gram > 240;

-- 합계 구하기
select SUM(price)
from burgers;

-- 평균 구하기
select avg(price)
from burgers;

-- 집계함수 실습 : 은행 DB
-- bank DB 생성 및 진입
create DATABASE bank;
use bank;

create table transactions (
	id INTEGER,              -- 아이디
	amount DECIMAL(12,2),    -- 거래 금액
    msg varchar(15),         -- 거래처
    created_at datetime,     -- 거래 일시
    primary key(id)          -- 기본키 지정 : id
);

-- transactions 데이터 삽입
INSERT INTO transactions (id, amount, msg, created_at)
VALUES
	(1, -24.20, 'Google', '2024-11-01 10:02:48'),
	(2, -36.30, 'Amazon', '2024-11-02 10:01:05'),
	(3, 557.13, 'Udemy', '2024-11-10 11:00:09'),
	(4, -684.04, 'Bank of America', '2024-11-15 17:30:16'),
	(5, 495.71, 'PayPal', '2024-11-26 10:30:20'),
	(6, 726.87, 'Google', '2024-11-26 10:31:04'),
	(7, 124.71, 'Amazon', '2024-11-26 10:32:02'),
	(8, -24.20, 'Google', '2024-12-01 10:00:21'),
	(9, -36.30, 'Amazon', '2024-12-02 10:03:43'),
	(10, 821.63, 'Udemy', '2024-12-10 11:01:19'),
	(11, -837.25, 'Bank of America', '2024-12-14 17:32:54'),
	(12, 695.96, 'PayPal', '2024-12-27 10:32:02'),
	(13, 947.20, 'Google', '2024-12-28 10:33:40'),
	(14, 231.97, 'Amazon', '2024-12-28 10:35:12'),
	(15, -24.20, 'Google', '2025-01-03 10:01:20'),
	(16, -36.30, 'Amazon', '2025-01-03 10:02:35'),
	(17, 1270.87, 'Udemy', '2025-01-10 11:03:55'),
	(18, -540.64, 'Bank of America', '2025-01-14 17:33:01'),
	(19, 732.33, 'PayPal', '2025-01-25 10:31:21'),
	(20, 1328.72, 'Google', '2025-01-26 10:32:45'),
	(21, 824.71, 'Amazon', '2025-01-27 10:33:01'),
	(22, 182.55, 'Coupang', '2025-01-27 10:33:25'),
	(23, -24.20, 'Google', '2025-02-03 10:02:23'),
	(24, -36.30, 'Amazon', '2025-02-03 10:02:34'),
	(25, -36.30, 'Notion', '2025-02-03 10:04:51'),
	(26, 1549.27, 'Udemy', '2025-02-14 11:00:01'),
	(27, -480.78, 'Bank of America', '2025-02-14 17:30:12');
    

-- Google과 거래한 금액의 합계 구하기
select sum(amount)
from transactions
where msg = 'Google';

-- Paypal과 거래한 금액의 최대 최소 구하기
select max(amount), min(amount)
from transactions
where msg = 'Paypal';

-- 쿠팡과 아마존과 거래한 횟수 구하기
select count(*)
from transactions
where msg = 'Coupang' or msg = 'Amazon';

-- 쿠팡과 아마존과 거래한 횟수 구하기 (in 연산자 활용하기)
select count(*)
from transactions
where msg in ('Coupang' , 'Amazon');

-- 구글과 아마존에서 입금받은 금액의 평균 구하기
select avg(amount)
from transactions
where msg in ('Google' , 'Amazon') and amount > 0;

-- 중복을 제거한 msg 목록 조회 (DISTINCT 키워드 사용)
select distinct msg
from transactions;

-- 중복을 제거한 msg 수 세기
select count(distinct msg)
from transactions;