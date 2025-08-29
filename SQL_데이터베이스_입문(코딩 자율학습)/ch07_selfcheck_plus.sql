create database library;
use library;

-- 삽입 데이터 없이 실습!
-- members 테이블
CREATE TABLE members (
  id INTEGER AUTO_INCREMENT,    -- ID(자동 증가)
  name VARCHAR(50) NOT NULL,    -- 회원명(NULL 불가)
  email VARCHAR(100) UNIQUE,    -- 이메일(고유 값)
  phone_number CHAR(15),        -- 전화번호
  membership_status VARCHAR(20) DEFAULT 'active', -- 회원 상태(기본값: active)
  PRIMARY KEY (id)              -- 기본키 지정: id
);
-- member_profiles 테이블
CREATE TABLE member_profiles (
  id INTEGER AUTO_INCREMENT,    -- ID(자동 증가)
  date_of_birth DATE,           -- 생년월일
  address TEXT,                 -- 주소
  member_id INTEGER UNIQUE,     -- 회원_ID(고유 값)
  PRIMARY KEY (id),             -- 기본키 지정: id
  FOREIGN KEY (member_id) REFERENCES members(id) -- 외래키 지정: member_id
);
-- books 테이블
CREATE TABLE books (
  id INTEGER AUTO_INCREMENT,          -- ID(자동 증가)
  title VARCHAR(100) NOT NULL,        -- 도서명(NULL 불가)
  author VARCHAR(100),                -- 저자
  category VARCHAR(50),               -- 카테고리
  stock INTEGER UNSIGNED DEFAULT 0,   -- 재고(음수 불가, 기본값: 0)
  PRIMARY KEY (id)                    -- 기본키 지정: id
);
-- borrow_records 테이블
CREATE TABLE borrow_records (
  id INTEGER AUTO_INCREMENT,          -- ID(자동 증가)
  borrow_date DATE NOT NULL,          -- 대출 날짜(NULL 불가)
  return_date DATE,                   -- 반납 날짜
  member_id INTEGER NOT NULL,         -- 회원_ID
  book_id INTEGER NOT NULL,           -- 도서_ID
  PRIMARY KEY (id),                   -- 기본키 지정: id
  FOREIGN KEY (member_id) REFERENCES members(id), -- 외래키 지정: member_id
  FOREIGN KEY (book_id) REFERENCES books(id)      -- 외래키 지정: book_id
);
-- library_staff 테이블
CREATE TABLE library_staff (
  id INTEGER AUTO_INCREMENT,          -- ID(자동 증가)
  name VARCHAR(50) NOT NULL,          -- 직원명(NULL 불가)
  role VARCHAR(50) DEFAULT 'staff',   -- 역할(기본값: staff)
  employment_date DATE NOT NULL,      -- 고용 날짜(NULL 불가)
  salary INTEGER UNSIGNED CHECK (salary >= 0), -- 급여(음수 불가)
  PRIMARY KEY (id)                    -- 기본키 지정: id
);

-- 문제 1 모든 회원의 이름, 생년월일, 주소를 조회하세요(회원 프로필이 없는 회원은 제외).
select name, date_of_birth, address
from member_profiles
join members on member_profiles.member_id = members.id;

-- 문제 2 모든 회원의 이름, 생년월일, 주소를 조회하세요(회원 프로필이 없는 경우 NULL로 출력).
select name, date_of_birth, address
from member_profiles
left join members on member_profiles.member_id = members.id;

-- 문제 3 대출 기록을 보고 도서를 빌려 간 회원명과 대출한 도서명을 조회하세요.
select name, title 
from borrow_records 
join members on borrow_records.member_id = members.id
join books on borrow_records.book_id = books.id;

-- 문제 4 모든 도서명과 대출 날짜를 조회하세요(대출되지 않은 도서는 NULL로 출력).
select title, borrow_date  
from borrow_records 
left join books on borrow_records.book_id = books.id;

-- 문제 5 회원과 같은 이름을 가진 직원의 이름과 역할 조회
select library_staff.name , role
from members
JOIN library_staff ON members.name = library_staff.name;

-- 문제 6 모든 회원과 직원을 대상으로 도서관에서 주최하는 기념 행사에 초대장을 보내려고 합니다. 
-- 모든 회원과 도서관 직원의 이름을 하나의 목록으로 출력하세요(중복된 이름은 제거).
SELECT name
FROM members
UNION
SELECT name
FROM library_staff;