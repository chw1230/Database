-- company DB 생성 -> 진입 -> employees 테이블 생성
create database company; 
use company;
create table employees(
	id integer,
    name varchar(50),
    department varchar(50),
    salary integer
);

-- employees 데이터 삽입
insert into employees (id, name, department, salary)
values
	(101, 'John', 'Sales', 7000),
	(102, 'Aria', 'IT', 5500),
	(103, 'Mike', 'Sales', 8000),
	(104, 'Lily', 'HR', 6500),
	(105, 'David', 'IT', 7200),
	(106, 'Emma', 'Sales', 6500),
	(107, 'Oliver', 'IT', 5900),
	(108, 'Sophia', 'HR', 6300),
	(109, 'Lucas', 'Sales', 5500),
	(110, 'Charlotte', 'HR', 6800);

-- 모든 직원의 연봉 합계 계산
select sum(salary)
from employees;

-- Sales 부서의 평균 연봉 조회
select avg(salary)
from employees
where department = 'Sales';

-- 부서의 개수 조회
select count(distinct department)
from employees;

-- Sales 부서의 쵀대 연봉과 최소 연봉의 차이 구하기
select max(salary) - min(salary)
from employees
where department = 'Sales';

-- 가장 높은 연봉을 받는 직원은 평균 직원들 연봉대비 얼마 받는지 구하기
select max(salary) - avg(salary)
from employees;