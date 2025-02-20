-- 제약 조건 사용 예시
create table users (
	id integer auto_increment,				-- id(자동으로 1씩 증가)
    email varchar(100) unique,				-- email(고유한 값만 허용)
    name varchar(50) not null,				-- name(null을 허용하지 않음)
    status varchar(10) default 'active',	-- status('active'가 기본값)
    balance integer unsigned,				-- balance(음수 허용 X)
    age integer check (age>= 18),			-- check 이하의 조건만 만족하는 age
    primary key (id)
);

-- relation DB 생성 및 진입
create database relation;
use relation;

-- contries 테이블 생성
create table countries (
	id integer,			-- 아이디
    name varchar(255),	-- 국가명
    primary key (id)	-- 기본키 지정 : id
);	

-- capitals 테이블 생성
create table capitals (
	id integer,											-- 아이디
    name varchar(255),									-- 수도명
    country_id integer unique,							-- 국가 아이디 (고유한 값만 허용)
    primary key (id),									-- 기본키 지정
    foreign key (country_id) references countries(id)	-- 외래키 지정 : country_id
);

-- countries 데이터와 capitals 데이터 삽입
insert into countries (id, name)
values
	(1,'South Korea'),
	(2,'United states'),
	(3,'Japan');
insert into capitals (id, name,country_id)
values
	(101,'Seoul',1),
	(102,'Washington D.C',2),
	(103,'Tokyo',3); 

-- teams 테이블 생성
create table teams (
	id integer,			-- 아이디
    name varchar(255),	-- 팀명
    primary key (id)	-- 기본키 지정 : id
);

-- players 테이블 생성
create table players (
	id integer,				-- 아이디
    name varchar(255),		-- 선수명
    team_id integer,		-- 소속팀 아이디
    primary key (id),
    foreign key (team_id) references teams(id)   -- 외래키 지정 : team_id
);

-- teams 데이터 등록
insert into teams (id,name)
values 
	(1,'FC hello'),
    (2,'FC bye');
    
-- player 데이터 등록
insert into players (id,name,team_id)
values
	(1,'choi',1),
	(2,'kim',1),
	(3,'park',2),
	(4,'lee',2),
	(5,'gu',2);
    
-- doctors 테이블 생성
create table doctors (
	id integer,
    name varchar(255),
    primary key (id)
);

-- patients 테이블 생성
create table patients (
	id integer,
    name varchar(255),
    primary key (id)
);

-- appointments 테이블 생성
create table appointments (
	id integer,
    doctor_id integer,
    patient_id integer,
    date date,
    primary key (id),
    foreign key (doctor_id) references doctors (id),
    foreign key (patient_id) references patients (id)
);
    
-- doctors 데이터 삽입
insert into doctors (id, name)
values 
	(1,'김'),
	(2,'이'),
	(3,'박');
    
-- patients 데이터 삽입
insert into patients (id, name)
values 
	(1,'환자 A'),
	(2,'환자 B'),
	(3,'환자 C');
    
-- appointments 데이터 삽입
insert into appointments (id,doctor_id,patient_id,date)
values
	(1,1,1,'2025-01-01'),
	(2,1,2,'2025-01-02'),
	(3,2,2,'2025-01-03'),
	(4,2,3,'2025-01-04'),
	(5,3,3,'2025-01-05'),
	(6,3,1,'2025-01-06');