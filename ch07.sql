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