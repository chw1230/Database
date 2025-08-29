use company;

-- 부서 테이블 
CREATE TABLE departments ( 
	id INTEGER AUTO_INCREMENT,       
	name VARCHAR(50) NOT NULL,       
	location VARCHAR(50),            
	PRIMARY KEY (id)                 
); 

-- 직원 테이블 
CREATE TABLE employees ( 
	id INTEGER AUTO_INCREMENT,       
	name VARCHAR(50) NOT NULL,       
	hire_date DATE NOT NULL,         
	salary INTEGER NOT NULL,         
	department_id INTEGER,           -- id -- 부서명 -- 위치 -- 기본키 지정:id 
	PRIMARY KEY (id),                -- id -- 직원명 -- 입사 날짜 -- 급여 -- 부서 id -- 기본키 지정: id 
	FOREIGN KEY (department_id) REFERENCES departments(id) -- 외래키 지정: department_id 
);

-- 프로젝트 테이블 
CREATE TABLE projects ( 
	id INTEGER AUTO_INCREMENT,       -- id 
	name VARCHAR(100) NOT NULL,      -- 프로젝트명 
	start_date DATE NOT NULL,        -- 시작 날짜 
	end_date DATE,                   -- 종료 날짜 
	PRIMARY KEY (id)                 -- 기본키 지정: id 
);

-- 직원-프로젝트 테이블 (다대다 관계) 
CREATE TABLE employee_projects ( 
	id INTEGER AUTO_INCREMENT,       -- id 
	employee_id INTEGER NOT NULL,    -- 직원 id 
	project_id INTEGER NOT NULL,     -- 프로젝트 id 
	PRIMARY KEY (id),                -- 기본키 지정: id 
	FOREIGN KEY (employee_id) REFERENCES employees(id), -- 외래키 지정: employee_id 
	FOREIGN KEY (project_id) REFERENCES projects(id)    -- 외래키 지정: project_id 
);

-- 급여 기록 테이블 
CREATE TABLE salary_records ( 
	id INTEGER AUTO_INCREMENT,       -- id 
	salary_date DATE NOT NULL,       -- 급여 지급 날짜 
	amount INTEGER NOT NULL,         -- 지급 금액 
	employee_id INTEGER NOT NULL,    -- 직원 id 
	PRIMARY KEY (id),                -- 기본키 지정: id 
	FOREIGN KEY (employee_id) REFERENCES employees(id) -- 외래키 지정: employee_id 
); 

-- 문제 1 SELECT 절에서의 서브쿼리 - 각 직원의 이름과 참여 중인 프로젝트 수를 조회
select name as '이름', (
	select count(*)
    from employee_projects ep
    where ep.employee_id = e.id ) as '참여 중인 프로젝트 수'
from employees e;

-- 문제 2  WHERE 절에서의 서브쿼리 - 특정 부서(예: IT 부서)의 직원 이름을 조회
select name as '이름'
from employees 
where department_id = (
	select id
    from departments
    where name = 'IT'
);

-- 문제 3 FROM 절에서의 서브쿼리 - 부서별 직원 수를 조회
select department_name as '부서이름' , count(*) as '부서별 직원 수'
from (
	select d.name as department_name, e.id as employee_id
    from employees e
    join departments d on e.department_id = d.id
) as department_employees
group by department_name; -- -> 이 과정에서 | department_name | employee_count | 이런 형식의 가상 테이터 생김! 그래서 count(*) 할 수 있는 것!

-- 문제 4 where 절에서의 서브쿼리 - 가장 높은 급여를 받은 직원의 이름과 급여를 조회
select e.name as '이름', sr.amount as '급여'
from employees e
join  salary_records sr on e.id = sr.employee_id
where sr.amount = (
	select max(amount)
    from salary_records
);

-- 문제 5 HAVING 절에서의 서브쿼리 - 부서별 평균 급여가 전체 평균 급여 이상인 부서명을 조회
select d.name as '부서명', avg(sr.amount) as '부서별 평균 급여'
from salary_records sr
join employees e on sr.employee_id = e.id
join departments d on e.department_id = d.id
group by d.name
having avg(sr.amount) >= (
	select avg(amount)
    from salary_records
);

-- 문제 6 복합 조건을 조합한 서브쿼리 - 가장 많은 직원이 참여한 프로젝트명을 조회
SELECT name 
FROM projects 
WHERE id = ( 
	SELECT project_id 
	FROM employee_projects 
	GROUP BY project_id 
	ORDER BY COUNT(*) DESC 
	LIMIT 1 
); 