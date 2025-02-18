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