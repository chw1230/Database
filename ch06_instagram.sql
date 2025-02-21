-- instagram DB 만들기
create database instagram;
use instagram;

-- user 테이블 만들기
create table users (
	id integer auto_increment,   -- id (자동 1씩 증가)
    nickname varchar(30),        -- nickname
    email varchar(255),			 -- email
    primary key (id)
);

-- user 데이터 삽입
insert into users (nickname, email) -- id는 자동으로 1씩 증가되기 때문에 삽입할 필요없음
values
	('choi','choihw1230@naver.com'),
	('chw','choihw031230@gmail.com'),
	('park','parkpark@gmail.com');

-- 데이터 조회
select *
from users;

-- photos 테이블 생성
create table photos (
	id integer auto_increment,
    filename varchar(255) not null,
    user_id integer,
    primary key (id),
    foreign key (user_id) references users(id)
);

-- photos 데이터 삽입
insert into photos (filename,user_id)
values
	-- 1번 사용자 게시
	('고양이.jpg',1),
	('일몰.jpg',1),
	('은하계.jpg',1),
    -- 2번 사용자 게시
	('백호.jpg',2),
	('검은 고양이.jpg',2),
    -- 사용자가 등록되지 않은 사진
	('삭제된 이미지.jpg',null),
	('삭제된 이미지.jpg',null);
    
-- 데이터 조회
select *
from photos;

-- comments 테이블 만들기
create table comments (
	id integer auto_increment,
    body varchar(1000),
    user_id integer,
    photo_id integer,
    primary key (id),
    foreign key (user_id) references users (id),
    foreign key (photo_id) references photos (id)
);

-- comments 데이터 삽입
insert into comments (body , user_id, photo_id)
values
	-- 1번 사진에 달린 댓글
	('야옹',1,1),
	('냐옹',2,1),
	('냥냥',3,1),
	-- 2번 사진에 달린 댓글
	('일몰이 멋지네',1,2),
	('해가 바다로',2,2),
	-- 3번 사진에 달린 댓글
	('안드로 메다 성운인가?',1,3),
	('성운이 아니라 은하',3,3),
	-- 대상 사진이 없는 댓글
	('우왕',3,null),
	('와우',3,null);
    
-- 댓글 데이터 조회
select *
from comments;

-- settings 테이블 생성
create table settings (
	id integer auto_increment,
    private boolean not null,
    account_suggestions boolean not null,
    user_id integer unique,  				-- user의 id와 일대일 관계를 이루기 위해 고유한 값만 들어가도록 하기
    primary key (id),
    foreign key (user_id) references users (id)
);

-- settings 데이터 삽입
insert into settings (private,account_suggestions,user_id)
values
	(false,false,1), -- 1번 사용자 비공개, 계정 추천 X
	(false,true,2), -- 2번 사용자 비공개, 계정 추천 O
	(true,true,3); -- 3번 사용자 공개, 계정 추천 O
    
-- settings 조회
select *
from settings;

-- likes 테이블 만들기
create table likes (
	id integer auto_increment,
    user_id integer,
    photo_id integer,
    primary key (id),
    foreign key (user_id) references users (id),
    foreign key (photo_id) references photos (id)
);

-- likes 데이터 삽입
insert into likes (user_id, photo_id )
values
	(1,1),
	(2,1),
	(1,2),
	(2,2),
	(3,2),
	(1,3),
	(3,3),
	(null,6),
	(null,7);
    
-- likes 데이블 조회
select *
from likes;