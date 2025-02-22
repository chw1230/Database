-- events DB 만들기
create database events;
use events;

-- events 테이블 생성 
CREATE TABLE events ( 
	id INTEGER,           -- ID 
	title VARCHAR(100),   -- 이벤트 제목 
	event_date DATE,      -- 이벤트 날짜 
	start_time TIME,      -- 시작 시간 
	location VARCHAR(50), -- 장소 
	attendees INT,        -- 참석자 수 
	PRIMARY KEY (id) 
); 

-- events 데이터 삽입 
INSERT INTO events (id, title, event_date, start_time, location, attendees) 
VALUES 
	(1, '코딩 부트캠프', '2023-10-01', '09:00:00', '서울', 50), 
	(2, 'AI 세미나', '2023-10-15', '14:00:00', '부산', 100), 
	(3, '데이터 분석 워크숍', '2023-11-05', '10:30:00', '서울', 30), 
	(4, '스타트업 데모데이', '2023-12-10', '13:00:00', '대전', 200), 
	(5, '클라우드 컨퍼런스', '2024-01-20', '11:15:00', '인천', 150), 
	(6, '해커톤', '2024-02-05', '08:00:00', '서울', 300), 
	(7, 'UX/UI 디자인 워크숍', '2023-09-25', '09:30:00', '광주', 25), 
	(8, '기술 트렌드 토크', '2023-11-20', '15:00:00', '서울', 80), 
	(9, '프로그래밍 대회', '2023-12-01', '10:00:00', '부산', 120), 
	(10, '오픈소스 컨트리뷰션 데이', '2023-10-25', '16:00:00', '서울', 60);

-- LIKE: 칼럼 값이 특정 패턴과 완전히 일치하거나 특정 패턴을 포함하는지 확인할 때 사용하는 연산자 / _, %와 함께 사용
-- BETWEEN: 두 값 사이에 속하는지 확인할 때 사용하는 연산자
-- 이벤트 제목에 '워크숍'이 포함된 이벤트의 제목과 장소를 조회
select title, location
from events
where title like '%워크숍%';

-- 이벤트 제목이 '데이터'로 시작하는 이벤트의 제목과 참석자 수를 조회
select title, attendees
from events
where title like '데이터%';

-- 이벤트 날짜가 2023년인 이벤트의 제목과 날짜 조회
select title, event_date
from events
where year(event_date) = 2023;

-- 이벤트 시작 시간이 오전 9시 이전인 이벤트의 제목과 시작 시간을 조회
select title, start_time
from events
where hour(start_time) < 9;

-- 참석자가 50명 이상 150명 이하인 이벤트의 제목과 참석자 수를 조회
select title, attendees
from events
where attendees between 50 and 150;

-- 이벤트 날짜가 2023-10-01부터 2023-12-31 사이인 이벤트의 제목과 날짜를 조회
select title, event_date
from events
where event_date between '2023-10-01' and '2023-12-31';

-- 이벤트 제목에 '컨퍼런스' 또는 '컨트리뷰션'이 포함되고, 시작 시간이 오전 11시 이후인 이벤트의 제목과 시작 시간을 조회
select title, start_time
from events
where  (title like '%컨퍼런스%' or title like '%컨트리뷰션%') and hour(start_time) >= 11;

-- 이벤트 날짜가 2023-11-1부터 2023-12-31 사이고, 시작 시간이 오후 2시 이후인 이벤트의 제목과 날짜, 시작 시간을 조회
select title, event_date, start_time
from events
where (event_date between '2023-11-1' and '2023-12-31') and hour(start_time) >= 14;

-- 