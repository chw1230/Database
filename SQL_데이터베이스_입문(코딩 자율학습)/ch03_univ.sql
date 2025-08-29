-- university DB 생성 및 진입
CREATE DATABASE university;
USE university;

-- students 테이블 생성
CREATE TABLE students (
	id INTEGER, 			-- 아이디
	nickname VARCHAR(50), 	-- 닉네임
	math INTEGER, 			-- 수학 성적
	english INTEGER, 		-- 영어 성적
	programming INTEGER, 	-- 프로그래밍 성적
	PRIMARY KEY (id) 		-- 기본키 지정: id
);

-- students 데이터 삽입
INSERT INTO students (id, nickname, math, english, programming)
VALUES
	(1, 'Sparkles', 98, 96, 93),
	(2, 'Soldier', 82, 66, 98),
	(3, 'Lapooheart', 84, 70, 82),
	(4, 'Slick', 87, 99, 98),
	(5, 'Smile', 75, 73, 70),
	(6, 'Jellyboo', 84, 82, 70),
	(7, 'Bagel', 97, 91, 87),
	(8, 'Queen', 99, 100, 88);
    
-- 모든 성적이 90점 이상인 학생 찾기
select *
from students
where math >= 90 AND english >= 90 AND programming >= 90;

-- 성적 중 75점 미만인 점수가 하나라도 있는 학생 찾기
select *
from students
where math < 75 OR english < 75 OR programming < 75;

-- 모든 학생의 총점 구하기
select nickname,math,english,programming, math + english + programming
FROM students;

-- 모든 학생의 평균 구하기
select nickname,math,english,programming, (math + english + programming)/3
FROM students;

-- 총점이 270 이상인 학생의 닉네임, 총점, 평균 출력하기
select nickname,math+english+programming, (math + english + programming)/3
FROM students
WHERE (math + english + programming) >= 270;

-- 총점이 270 이상인 학생의 닉네임, 총점, 평균 출력하기 AS 키워드 사용하기
select 
	nickname AS 닉네임,
    math+english+programming AS 총점,
    (math + english + programming)/3 AS 평균
FROM students
WHERE (math + english + programming) >= 270;