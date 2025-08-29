use market;

-- 문제 1 주어진 서브 쿼리를 활용하여 전체 사용자의 1인당 평균 결제 금액 구하기
select sum(amount) / (
	select count(*)
    from users
) as '전체 사용자의 1인당 평균 결제 금액'
from payments;

-- 문제 2 주어진 서비 쿼리를 from 절에 사용해 전체 사용자의 1인당 평균 결제 금액 구하기
select avg(sub.total_amount) as '전체 사용자의 1인당 평균 결제 금액'
from (
	select u.id as user_id, sum(amount) as total_amount
    from users u
    join orders o on u.id = o.user_id
    join payments p on o.id = p.order_id
    group by u.id
) as sub;

/* 문제 3 앞의 두 문제의 정답 쿼리 실행하면
|--------------------------|
|전체 사용자의 1인당 평균 결제 금액|
|--------------------------|
|       41790.0000         |
|--------------------------|
이런 결과 나옴 이유를 설명하시오 
-> users에 있는 모두가 빠짐없이 결제 하였기 때문에
*/

-- 문제 4 주어진 서브 쿼리를 이용하여 해당 사용자의 총 결제 금액을 조회하기
select sum(amount) as '총 결제 금액'
from users u
join orders o on u.id = o.user_id
join payments p on o.id = p.order_id
where u.id = (
	select user_id
    from orders
    where status = '배송 완료'
    order by created_at desc
    limit 1
);