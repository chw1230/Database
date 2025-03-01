-- group_analysis DB 생성 및 진입
create database group_analysis;
use group_analysis;

-- students 테이블 생성
CREATE TABLE students (
	id INTEGER AUTO_INCREMENT, 	-- 아이디(자동으로 1씩 증가)
	gender VARCHAR(10), 			-- 성별
	height DECIMAL(4, 1), 			-- 키
	PRIMARY KEY (id) 			-- 기본키 지정: id
);

-- students 데이터 삽입
INSERT INTO students (gender, height)
VALUES
	('male', 176.6),
	('female', 165.5),
	('female', 159.3),
	('male', 172.8),
	('female', 160.7),
	('female', 170.2),
	('male', 182.1);
    
-- 전체 학생의 평균 키
select avg(height)
from students;

-- 성별에 따른 평균 키
select gender, avg(height)
from students
group by gender; -- group by 절을 통해서 그룹화 하기!

-- sales 테이블 생성
CREATE TABLE sales (
  id INTEGER AUTO_INCREMENT,  	-- 아이디(자동으로 1씩 증가)
  city VARCHAR(50) NOT NULL,     -- 도시명
  sale_date DATE NOT NULL,         -- 판매 날짜
  amount INTEGER NOT NULL,      	-- 판매 금액
  PRIMARY KEY (id)			-- 기본키 지정: id
);

-- sales 데이터 삽입
INSERT INTO sales (city, sale_date, amount) 
VALUES
  ('Seoul', '2023-01-15', 1000),
  ('Seoul', '2023-05-10', 2000),
  ('Seoul', '2023-08-29', 2500),
  ('Seoul', '2024-02-14', 4000),
  ('Busan', '2023-03-05', 1500),
  ('Busan', '2024-05-10', 1800),
  ('Busan', '2024-07-20', 3000),
  ('Incheon', '2023-11-25', 1200),
  ('Incheon', '2024-03-19', 2200),
  ('Incheon', '2024-09-12', 3300);
  
-- 특정 도시의 연도별 총 매출 -> 도시로 그룹 짓고 도시 속에 연도로 그룹 짓기
select city, year(sale_date), sum(amount)
from sales
group by city, year(sale_date);

-- 잘못된 컬럼 예시
select id, gender,avg(height)
from students
group by gender;

-- payments 테이블 생성
CREATE TABLE payments (
	id INTEGER AUTO_INCREMENT, 	-- 아이디(자동으로 1씩 증가)
	amount INTEGER, 			-- 결제 금액
	ptype VARCHAR(50), 			-- 결제 유형
	PRIMARY KEY (id) 			-- 기본키 지정: id
);

-- payments 데이터 삽입
INSERT INTO payments (amount, ptype)
VALUES
	(33640, 'SAMSONG CARD'),
	(33110, 'SAMSONG CARD'),
	(31200, 'LOTTI CARD'),
	(69870, 'COCOA PAY'),
	(32800, 'COCOA PAY'),
	(42210, 'LOTTI CARD'),
	(46060, 'LOTTI CARD'),
	(42520, 'SAMSONG CARD'),
	(23070, 'COCOA PAY');
    
-- 그룹화 필터링 실습
select ptype AS '결제 유형', avg(amount) as '평균 결제 금액'
from payments
group by ptype						-- 그룹화
having avg(amount) >= 40000;        -- 그룹화 필터링 진행 -> having 사용 , where 절과 다르게 그룹 단위에 대해서 필터링을 진행! , where는 개별 튜플에 대해서 필터링 진행

-- 단일 컬럼으로 정렬
select ptype as '결제 유형', amount as '결제 금액'
from payments
order by amount desc; -- amount 를 기준으로 내림차순 정렬

-- 다중 컬럼으로 정렬
select ptype as '결제 유형', amount as '결제 금액'
from payments
order by ptype asc, amount desc;    -- ptype의 오름차순 정렬 후 amount를 기준으로 내림차순 정렬

-- 조회 개수 제한
select ptype as '결제 유형', amount as '결제 금액'
from payments
order by amount desc
limit 3;  				-- amount를 기준으로 내림차순 한 뒤에 상위 3개의 튜플만 조회

-- 조회 개수 제한 ( offset 이용 )
select ptype as '결제 유형', amount as '결제 금액'
from payments
order by amount desc
limit 3 offset 3;		-- amount를 기준으로 내림차순 한 뒤에 3개를 건너 뛰고, 3개를 가져오기! -> limit N offset M -> N개 건너 뛰고, M개 가져오기