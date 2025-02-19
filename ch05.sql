-- data_type DB 생성 및 진입
create database data_type;
use data_type;

-- 유효성 보장 : 나이 -> 0 ~ 255 의 유효값만 저장
create table user (
	age tinyint unsigned
);

-- 안전성 보장 : 재고는 음수가 될 수 없음
create table products (
	stock integer unsigned
);

-- students_records 테이블 생성
create table students_records (
	id integer,
    grade tinyint unsigned,
    average_score float,
    tuition_fee decimal(10,2),
    primary key(id)
);

-- 데이터 삽입
insert into students_records (id,grade, average_score,tuition_fee)
values
	(1,3,88.75,50000.00),
	(2,6,92.5,100000.00);
    
-- 데이터 조회
select *
from students_records;

-- char와 varchar 자료형의 사용 예
create table addresses (
	postal_code char(5), 			-- 우편번호 (고정 길이 문자 : 5자)
    street_address varchar(100)     -- 거리 주소 (가변(길이 일정하지 않은) 길이 문자 : 최대 100자)
);

-- text 자료형의 사용 예
create table articles (
	title varchar(200),           -- 제목 (가변 길이 문자 : 최대 200자)
    short_description tinyint,    -- 짧은 설명 (최대 255byte)
    comment text,				  -- 댓글 (최대 64kb)
    content mediumtext,			  -- 본문 (최대 16mb)
    additional_info longtext	  -- 추가 정보 (최대 6GB)
);

-- BLOB 자료형의 사용 예
create table files (
	file_name varchar(200),
    small_thumbnail tinyblob,
    document blob,
    video mediumblob,
    large_data longblob
);

-- ENUM 자료형의 사용 예
create table memberships (
	name varchar(100),
    level ENUM('bronze','silver','gold')
);

-- user_profiles 테이블 생성
CREATE TABLE user_profiles (
	id INTEGER, 				-- 아이디(표준 정수)
	email VARCHAR(255), 		-- 이메일(가변 길이 문자: 최대 255자)
	phone_number CHAR(13), 		-- 전화번호(고정 길이 문자: 13자)
	self_introduction TEXT, 	-- 자기소개(긴 문자열: 최대 64KB)
	profile_picture MEDIUMBLOB, -- 프로필 사진(파일: 최대 16MB)
	gender ENUM('남', '여'), 	-- 성별(선택 목록 중 택 1)
	PRIMARY KEY (id) 			-- 기본키 지정: id
);

-- user_profiles 데이터 삽입
INSERT INTO user_profiles (id, email, phone_number, self_introduction, profile_picture, gender)
VALUES
	(1, 'hongpark@example.com', '012-3456-7890', '안녕하십니까!', NULL, '남'),
	(2, 'hongsoon@example.com', '987-6543-2109', '반갑습니다!', NULL, '여');
    
-- 데이터 조회
SELECT *
FROM user_profiles;

-- 날짜 및 시간 자료형 사용 예
create table movie_showtimes (
	movie_title varchar(100),		-- 영화 제목 (가변 길이 문자: 최대 문자 100자)
    release_date date,				-- 개봉일(yyyy-mm--dd)
    showtime time,					-- 상영시간(hh:mm:ss)
    show_datetime datetime,			-- 상영 날짜와 시간(yyyy-mm-dd hh:mm:ss)
    production_year year			-- 제작 연도(yyyy)
);

-- events 테이블 생성
create table events (
	id integer,
    event_name varchar(100),
    event_date date,
    start_time time,
    created_at datetime,
    event_year year,
    primary key (id)
);

-- events 데이터 삽입
INSERT INTO events (id, event_name, event_date, start_time, created_at, event_year)
VALUES
	(111, 'Music Festival', '2024-10-04', '17:55:00', '2024-09-04 10:25:30', '2024'),
	(222, 'Art Exhibition', '2024-11-15', '12:00:00', '2024-09-05 11:30:00', '2024');
    
-- 데이터 조회
SELECT *
FROM events;

-- store DB 생성 및 진입
create database store;
use store;

-- orders 테이블 만들기
create table orders (
	id integer,
    name varchar(255),
    price decimal(10,2),
    quantity integer,
    created_at datetime,
    primary key(id)
);

-- orders 데이터 삽입
INSERT INTO orders (id, name, price, quantity, created_at)
VALUES
	(1, '생돌김 50매', 5387.75, 1, '2024-10-24 01:19:44'),
	(2, '그릭 요거트 400g, 2개', 7182.25, 2, '2024-10-24 01:19:44'),
	(3, '냉장 닭다리살 500g', 6174.50, 1, '2024-10-24 01:19:44'),
	(4, '냉장 고추장 제육 1kg', 9765.00, 1, '2024-10-24 01:19:44'),
	(5, '결명자차 8g * 18티백', 4092.25, 1, '2024-10-24 01:19:44'),
	(6, '올리브 오일 1l', 17990.00, 1, '2024-11-06 22:52:33'),
	(7, '두유 950ml, 20개', 35900.12, 1, '2024-11-06 22:52:33'),
	(8, '카카오 닙스 1kg', 12674.50, 1, '2024-11-06 22:52:33'),
	(9, '손질 삼치살 600g', 9324.75, 1, '2024-11-16 14:55:23'),
	(10, '자숙 바지락 260g', 6282.00, 1, '2024-11-16 14:55:23'),
	(11, '크리스피 핫도그 400g', 7787.50, 2, '2024-11-16 14:55:23'),
	(12, '우유 900ml', 4360.00, 2, '2024-11-16 14:55:23'),
	(13, '모둠 해물 800g', 4770.15, 1, '2024-11-28 11:12:09'),
	(14, '토마토 케첩 800g', 3120.33, 3, '2024-11-28 11:12:09'),
	(15, '계란 30구', 8490.00, 2, '2024-12-11 12:34:56'),
	(16, '해물 모듬 5팩 묶음 400g', 9800.50, 4, '2024-12-11 12:34:56'),
	(17, '칵테일 새우 900g', 22240.20, 1, '2024-12-11 12:34:56'),
	(18, '토마토 케첩 1.43kg', 7680.25, 1, '2024-12-11 12:34:56'),
	(19, '국내산 양파 3kg', 5192.00, 1, '2024-12-11 12:34:56'),
	(20, '국내산 깐마늘 1kg', 9520.25, 1, '2024-12-11 12:34:56');

-- name이 '캐첩'인 상품 조회 -> LIKE 키워드 사용
select *
from orders
where name like '케첩';
-- 결과 값 빈 테이블 나옴 -> 캐첩이라는 상품명이 없음 다 ~캐첩 이런 상품들! '캐첩'이라는 키워드가 포함되어 있는 경우 어떻게 해결할까?

-- name에 '캐첩'이 포함된 상품 조회 -> 와일드카드 사용
select *
from orders
where name like '%케첩%';

-- 11월에 주문받은 상품 조회
select *
from orders
where month(created_at) = 11;

-- 11월에 주문받은 상품 개수의 합계
select sum(quantity)
from orders
where month(created_at) = 11;

-- 오전에 주문받은 상품 조회
select *
from orders
where hour(created_at) < 12;


-- 오전에 주문받은 매출의 합꼐
select sum(price * quantity)
from orders
where hour(created_at) < 12;

-- 오전에 주문받은 상품 조회
select *
from orders
where hour(created_at) < 12;

-- price 가 10000~20000 사이에 있는 주문 조회
select *
from orders
where price between 10000 and 20000;

-- 2024-11-15 ~ 2024-12-15 사이의 주문 개수 합계
select count(*)
from orders
where created_at between '2024-11-15' and '2024-12-15';

-- 상품명의 첫 글자 'ㄱ'으로 시작하는 주문 조회
select *
from orders
where name between 'ㄱ' and '깋';
