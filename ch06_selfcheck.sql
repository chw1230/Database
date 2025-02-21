use instagram;

-- 5. 닉네임이 'park'인 사용자가 '백호.jpg' 사진에 좋아요를 눌렀습니다. 이 정보를 삽입하는 쿼리 작성
insert into likes (user_id, photo_id)
value
	( 3, 4);