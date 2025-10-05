use my_shop2;

-- 저장 프로시저, 함수, 트리거
-- 실무에서 거의 사용하지 않는다 이렇게 쓰고 이런 방식이구나 하고 넘어가기

-- 저장 프로시저 실습
DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
 id INT AUTO_INCREMENT PRIMARY KEY,
 description VARCHAR(255),
 created_at DATETIME DEFAULT CURRENT_TIMESTAMP
); -- 테이블 만들기

-- 구분자를 // 로 변경
DELIMITER //
CREATE PROCEDURE sp_change_user_address(
 IN user_id_param INT,
 IN new_address_param VARCHAR(255)
) -- 2개의 입력 파라미터 user_id_param와 new_address_param
BEGIN
 -- 1. users 테이블의 주소 업데이트
 UPDATE users SET address = new_address_param WHERE user_id = user_id_param;
 -- 2. logs 테이블에 변경 이력 기록
 INSERT INTO logs (description) 
 VALUES (CONCAT('User ID ', user_id_param, ' 주소 변경 ', new_address_param));
END //

-- 구분자를 다시 ; 로 원상 복구
DELIMITER ;

-- 프로시저 호출 -> 값의 변경 -> 로그 추가
call sp_change_user_address(2, '경기도 파주시');

-- 변경 결과 확인 
select address from users where user_id = 2;

-- 로그 확인
select * from logs; -- 1 | User ID 2 주소 변경 경기도 파주시 | 2025-10-05 21:29:30

-- 프로시저 삭제
DROP PROCEDURE IF EXISTS sp_change_user_address;


-- 저장 함수 실습 
DROP TABLE IF EXISTS stored_items;
CREATE TABLE stored_items (
 item_id BIGINT AUTO_INCREMENT PRIMARY KEY,
 name VARCHAR(255) NOT NULL,
 price INT NOT NULL,
 discount_rate DECIMAL(5, 2) -- 할인율
);
INSERT INTO stored_items (name, price, discount_rate) VALUES
('고성능 노트북', 1500000, 10.00),
('무선 마우스', 25000, 20.00),
('기계식 키보드', 120000, 30.00),
('4K 모니터', 450000, 40.00),
('전동 높이조절 책상', 800000, 50.00); -- 데이터 만들고 넣기

-- 저장 함수 정의
DELIMITER //

CREATE FUNCTION fn_get_final_price(
 price_param INT,
 discount_rate_param DECIMAL(5, 2)
)
RETURNS DECIMAL(10, 2) /*반환타입 정의*/
DETERMINISTIC
BEGIN -- 최종 가격을 계산 (가격 * (1 - 할인율/100))
	RETURN price_param * (1 - discount_rate_param / 100); -- 계산
END //

DELIMITER ;

SELECT
	name, price, discount_rate,
    fn_get_final_price(price, discount_rate) AS final_price
from stored_items;
-- 특정 계산을 수행하고 하나의 결과 값을 반환하는 데 특화되어 있으며, SELECT 문 등 SQL 쿼리 내에서 내장 함수처럼 활용될 수 있음!

-- 삭제
DROP FUNCTION IF EXISTS fn_get_final_price;

-- 트리거 
-- 탈퇴 고객 테리블 만들기
DROP TABLE IF EXISTS retired_users;
CREATE TABLE retired_users (
 id BIGINT PRIMARY KEY,
 name VARCHAR(255) NOT NULL,
 email VARCHAR(255) NOT NULL,
 retired_date DATE NOT NULL
);
-- 탈퇴 고객 데이터 입력
INSERT INTO retired_users (id, name, email, retired_date) VALUES
(1, '션', 'sean@example.com', '2024-12-31'),
(7, '아이작 뉴턴', 'newton@example.com', '2025-01-10');

-- 트리거 생성
DELIMITER //

CREATE TRIGGER trg_backup_user
BEFORE DELETE ON users -- user 테이블에서 delete되기 before BEGIN 로직 실행하기!
FOR EACH ROW
BEGIN
	INSERT INTO retired_users (id, name, email, retired_date)
    VALUES (OLD.user_id, OLD.name, OLD.email, CURDATE()); -- old의 의미 -> 이벤트 발생 전의 컬럼에 접근하기!
END //

DELIMITER ;

-- 트리거 작동을 위해서 고객을 삭제 해보기!
DELETE FROM users WHERE user_id = 5;

-- 삭제한 고객의 정보가 retired_users에 담겼는지 확인하기
select * from retired_users;

--  트리거 삭제
DROP trigger IF exists trg_backup_user;

-- 왜 현대의 프로젝트에서는 이 기능들을 왜 잘 사용하지 않는 걸까?
/* 일단 프로시저, 함수, 트리거의 장점 
성능 : 여러개의 SQL을 네트워크를 통해서 주고 받지 않아도, 데이터베이스 안에 로직을 넣어두고 한 번만 호출하는 것이 훨씬 더 효율적
코드 재사용과 중앙화 : 여러 종류의 애플리케이션이 동일한 데이터 베이스 로직을 사용하는 경우에 로직을 데이터 베이스의 프로시저에 중앙화 시켜서 모두가 일관된로직을 재 사용할 수 있도록 함!
보안 : 사용자에게 테이블에 대한 직접적인 수정 권한을 주기 않고, 특정 프로시저를 실행할 수 있는 권한만 부여 할 수 있음! */

-- 기술의 '좋고 나쁨'의 문제가 아니라, 시대의 흐름과 소프트웨어 아키텍처의 패러다임 변화에 때문임!

/* 
1. 유지보수의 어려움 (어디에 로직이 있지?)
- 혼란의 시작 : DB에서 비즈니스 로직을 다루게 되면 애플리케이션에서 수정읋 해야할지 DB에서 해야할지 모두 다 기억하고 있을 수는 없음!
- 비전 관리의 어려움 : git을 통한 버전 관리의 어려움이 증가!

2. 성능 및 확장성
- DB의 병목 현상 : DB에서 비즈니스 로직을 다루게 되면 데이터 입출력 뿐만아니라 애플리케이션의 로직까지 수행하느라 과부하에 걸림 
- 확장성 차이 : 현대적인 웹 서비스는 수평적 확장에 유리한 설계 -> 사용자의 증가 -> 값이 저렴한 애플리게이션 서버 was를 늘려서 부하를 분산시킴! 하지만 DB 서버는 수평적으로 확장하기 어려움! -> 비용과 한계의 증가!
확장 가능한 애플리케이션 서버가 비즈니스 로직 처리를 담당하고, 확장이 어려운 DB 서버는 저장과 데이터 관리 역할을 담당

3. 특정 DB에 대한 종속성
특정 DB에 대한 종속성 : 기능에 대한 문법이 제조사 마다 다름!! -> vender 종속 
*/
/* 그래서 결론 
애플리케이션 계층: 비즈니스 로직, 데이터 가공, 조건 처리, 절차 제어 등 모든 지능적인 처리를 담당한다. 데이터베이스와는 표준 SQL을 통해 소통
데이터베이스 계층: 오직 데이터의 저장, 조회, 무결성 보장(제약 조건), 트랜잭션 관리라는 데이터 본연의 역할에만 충실
*/