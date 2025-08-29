create database scPlus;
use scPlus;

-- 문제 1 테이블 만들기
create table employees(
	id integer,
    salary integer,
    name varchar(50),
    department varchar(50),
    position varchar(50),
    primary key(id)
);

-- 문제 2 데이터 삽입
INSERT INTO employees (id,salary,name,department,position)
VALUES 
	(1,3500000,'김철수','개발','사원'),
	(2,4200000,'박영희','개발','대리'),
	(3,5500000,'이민호','기획','팀장'),
	(4,3300000,'최수진','기획','사원'),
	(5,3100000,'정하늘','영업','사원'),
	(6,4000000,'오준수','영업','대리'),
	(7,6000000,'서지우','마케팅','팀장'),
	(8,3200000,'이은지','마케팅','사원'),
	(9,5800000,'안현준','개발','팀장'),
	(10,3000000,'홍길동','영업','사원');
    
select *
from employees;

-- 문제 3 새로운 직원 추가
insert into employees (id,salary,name,department,position)
values (11,3400000,'장미희','기획','사원');

-- 문제 4 '개발' 부서 직원의 이름과 급여 조회
select name, salary
from employees
where department = '개발';

-- 문제 5 '팀장' 직책을 가진 직원의 이름과 부서를 조회
select name, department
from employees
where position = '팀장';

-- 문제 6 '영업' 부서의 모든 직원 급여를 300,000원씩 인상
-- 안전 모드 해제 
SET SQL_SAFE_UPDATES = 0; 
update employees
set salary = salary +  300000
where department = '영업';

-- 문제 7 급여가 3,000,000원 이하인 직원을 삭제
delete from employees
where salary <= 3000000;
-- 안전 모드 다시 활성화 
SET SQL_SAFE_UPDATES = 1; 

select *
from employees;