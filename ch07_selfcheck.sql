use instagram;

-- 문제 1 : 사용자가 자신의 계정을 공개하는지 여부를 조회
select nickname as '닉네임', private as '계정 공개 여부'
from settings
join users on settings.user_id = users.id;

-- 문제 2 : 누가 올렸는지 확인할 수 있는 사진에 대해서만 사진 파일명과 올린 사람 조회(누가 올렸는지 확인 -> NULL은 X -> INNER 조인 사용 )
select filename as '파일명' , nickname as '게시자'
from photos
join users on photos.user_id = users.id;

-- 문제 3 : 모든 사진에 대해 사진 파일명과 올린 사람을 다음과 같이 조회(올린 사람이 누군지 모르는 사진도 조회) -> left 조회
select filename as '파일명' , nickname as '게시자'
from photos
left join users on photos.user_id = users.id;