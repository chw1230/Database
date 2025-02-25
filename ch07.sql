-- instagram DB 진입
use instagram;

-- comments 테이블과 users 테이블 조인
select *
from comments
join users on comments.user_id = users.id;


-- comments 테이블과 users 테이블 조인한 뒤에 1번 사진에 댓글단 사용자 닉네임과 댓글 본문 조회하도록 코드 수정하기
select nickname, body
from comments
join users on comments.user_id = users.id
where photo_id = 1;

-- 연속 조인 연습
select nickname, body, filename
from comments
join users on comments.user_id =  users.id
join photos on comments.photo_id = photos.id;

-- 중복 컬럼 id에 테이블명 명시, 어떤 테이블의 id인지!
select comments.id, body, users.id, nickname
from comments
join users on comments.user_id = users.id
where photo_id = 2;

-- comments 테이블과 users 테이블에 별칭 붙이기
select nickname, body
from comments as c
join users as u on c.user_id = u.id;

-- photos 테이블과 users 테이블 inner 조인
select *
from photos
join users on photos.user_id = users.id;

-- photos 테이블과 users 테이블 left 조인
select *
from photos
left join users on photos.user_id = users.id;

-- photos 테이블과 users 테이블 right 조인
select *
from photos
right join users on photos.user_id = users.id;

-- photos 테이블과 users 테이블dmf FULL 조인한 결과와 같게 만들기
(
	select *
	from photos
	left join users on photos.user_id = users.id
)
UNION -- 두 쿼리의 결과 테이블을 하나로 합치기(중복 데이터 제거)
(
	select *
	from photos
	right join users on photos.user_id = users.id
);

-- users 테이블과 photos 테이블 조인
select nickname as '게시자', filename as '파일명'
from photos
join users on photos.user_id = users.id
where nickname = 'choi';

-- users, photos, likes 테이블 조인
select count(*) as 'choi가 올린 사진의 좋아요 수'
from users
join photos on users.id = photos.user_id and nickname = 'choi' -- where 조건 대신에 and 로 조건 표현!!!
join likes on likes.photo_id = photos.id;

-- comments 테이블과 users 테이블 조인
select count(*) as 'park이 작성한 모든 댓글의 수'
from comments
join users on comments.user_id = users.id and nickname = 'park';

-- comments와 photos 조인
select body as '댓글 내용' , filename as '파일명'
from comments
left join photos on comments.photo_id = photos.id; -- 파일명이 없는 데이터도 출력하기 위해 left 조인 사용!