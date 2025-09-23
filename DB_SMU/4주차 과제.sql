use smudb_test;

-- 16) 고객과 고객의 주문에 관한 데이터를 고객별로 정렬하기
select c.custid, c.name, c.address, c.phone, o.orderid, o.custid, o.bookid, o.saleprice, o.orderdate
from orders o
join customer c on o.custid = c.custid
order by c.custid;

-- 17) 도서이름에 ‘축구’가 포함된 출판사를 검색하기
select bookname, publisher
from book
where bookname like '%축구%';

-- 18) 도서이름 왼쪽 두 번째 위치에 ‘구’라는 문자열을 갖는 도서를 모두 검색하기
select *
from book
where bookname like '_구%';

-- 19) 출판사가 ‘굿스포츠’ 혹은 ‘대한미디어’인 도서를 검색하기
select *
from book
where publisher in ('굿스포츠', '대한미디어');

-- 20) 도서를 이름순으로 검색하기
select *
from book
order by bookname;

-- 21) 도서를 가격의 내림차순으로 검색하기 / 만약 가격이 같다면 출판사의 오름차순으로 검색하기
select *
from book
order by price desc, publisher;

-- 22) 도서와 도서를 구입한 고객의 이름, 전화번호를 검색하기 / 단,도서명의 내림차순으로 검색
select b.bookname, c.name, c.phone, c.address
from customer c
join orders o on c.custid = o.custid
join book b on o.bookid = b.bookid
order by b.bookname desc;

-- 23) “이상미디어” 또는 “대한미디어”에서 출판한 도서를 구입한 고객의 이름, 전화번호, 구매한 도서를 검색하기 / 단, 도서명의 내림차순으로 검색하기
select c.name, c.phone, c.address, b.bookname
from customer c
join orders o on c.custid = o.custid
join book b on o.bookid = b.bookid
where b.publisher in ('이상미디어' ,'대한미디어')
order by b.bookname desc;

-- 24) '이상미디어’ 출판사 혹은 ‘대한미디어’ 출판사에서 출판한 책의 제목과 가격을 검색하기 / (반드시 Set Operations 사용)
select *
from book
where publisher = '이상미디어'

union 

select *
from book
where publisher = '대한미디어';

-- 25) “이상미디어” 또는 “굿스포츠”에서 출판한 도서를 검색하기 / (반드시 Set Operations 사용).
select *
from book
where publisher = '이상미디어'

union 

select *
from book
where publisher = '굿스포츠';

-- 26) 2번 고객과 3번 고객이 동시에 구입한 도서의 id를 검색하기 / (반드시 Set Operations 사용).
select o.bookid
from orders o
join book b on o.bookid = b.bookid
where o.custid = 2

intersect

select o.bookid
from orders o
join book b on o.bookid = b.bookid
where o.custid = 3;

-- 27) 2번 고객은 구입했으나, 3번 고객은 구입하지 않은 도서의 id를 검색하기 / (반드시 Set Operations 사용).
select o.bookid
from orders o
join book b on o.bookid = b.bookid
where o.custid = 2

except

select o.bookid
from orders o
join book b on o.bookid = b.bookid
where o.custid = 3;

-- 28) 2번 고객은 구입했으나, 3번 고객은 구입하지 않은 도서의 id, 도서명을 검색하기 / (반드시 Set Operations 사용).
-- 이 문제의 주의할 점 2번 고객이 구입한 것에 대해서 궁금하다고 해서 2번과 관련된 쿼리에서 b.bookname을 검색해서는 안된다! Set Operations을 기준으로 위의 쿼리와 아래 쿼리 가 동일한 것을 조회하고 있어야 오류가 나지 않는다!!
select o.bookid, b.bookname
from orders o
join book b on o.bookid = b.bookid
where o.custid = 2

except

select o.bookid, b.bookname
from orders o
join book b on o.bookid = b.bookid
where o.custid = 3;

-- 29) 고객이 주문한 도서의 총 판매액을 구하기
select sum(saleprice) as 총매출
from orders;

-- 30) 2번 김연아 고객이 주문한 도서의 총 판매액을 구하기
select sum(o.saleprice) as 총매출
from orders o
join customer c on o.custid = c.custid
where c.name = '김연아';

-- 31) 고객이 주문한 도서의 총 판매액, 평균값, 최저가, 최고가를 구하기
select 
	sum(saleprice) as Total, 
    avg(saleprice) as Average, 
    min(saleprice) as Minimum, 
    max(saleprice) as Maximum
from orders;

-- 32) 마당서점의 도서 판매 건수를 구하기
select count(*)
from orders;

-- 33) 고객별로 주문한 도서의 총 수량과 총 판매액을 구하기
select custid, count(*) as 도서수량, sum(saleprice) as 총액
from orders
group by c.name, c.custid; -- 고객별로 볼거니까 고객 이름으로 그룹핑, 이때 데이터 상에 동명이인은 없지만 확장성을 고려하여 custid로도 같이 그룹핑해주기

-- 34) 고객 이름별로 주문한 도서의 총 수량과 총 판매액을 구하기
select 
	name, 
    count(o.orderid) as '도서 수량',
    sum(o.saleprice) as '총액'
from orders o
join customer c on o.custid = c.custid
group by c.name, c.custid; -- 고객별로 볼거니까 고객 이름으로 그룹핑, 이때 데이터 상에 동명이인은 없지만 확장성을 고려하여 custid로도 같이 그룹핑해주기

-- 35) 고객 이름별로 주문한 도서의 총 수량과 총 판매액을 구하기 / 검색 결과를 총액순으로 정렬하여 구하기
select 
	c.name,
    count(o.orderid) as '도서 수량',
    sum(o.saleprice) as '총액'
from orders o
join customer c on o.custid = c.custid
group by c.name, c.custid -- 고객별로 볼거니까 고객 이름으로 그룹핑, 이때 데이터 상에 동명이인은 없지만 확장성을 고려하여 custid로도 같이 그룹핑해주기
order by `총액` desc;

-- 36) 출판사별로, 고객 이름별로 주문한 도서의 총 수량을 구하기
select  
	b.publisher,
    c.name,
    count(*) as '도서 수량'	
from customer c 
join orders o on c.custid = o.custid
join book b on o.bookid = b.bookid
group by b.publisher, c.name;

-- 37) 도서를 구매한 고객에 대하여 고객별 주문 도서의 총 수량을 구하기 / 단,2권 이상 구매한 고객만 구하기
select 
	o.custid,
    count(*) as '도서 수량'
from orders o
join customer c on o.custid = c.custid
group by o.custid
having `도서 수량` >= 2; 

select *
from  orders o
join customer c on o.custid = c.custid;

-- 38) 가격이 8,000원 이상인 도서를 구매한 고객에 대하여 고객별 주문 도서의 총 수량을 구하기 / 단, 2권 이상 구매한 고객만 구하기
select 
	o.custid,
    count(*) as '도서 수량'
from orders o
join customer c on o.custid = c.custid
where o.saleprice >= 8000 -- 그룹핑하기 전에 8000원 이상인 도서 필터링
group by o.custid -- 고객별로 볼거니까 고객id로 그룹핑
having `도서 수량` >= 2; -- 그룹핑하고 도서 수량이 2개 인상으로 필터링

-- 39) '대한민국'에 거주하는 고객에 대하여 고객별 주문 도서의 총 수량을 구하기 / 단, 3권 이상 구매한 고객만 구한다.
select 
	c.name,
    count(*) as '도서 수량'
from orders o
join customer c on o.custid = c.custid
where c.address like '%대한민국%' -- 그룹핑하기 전에 '대한민국'에 거주하는 고객 필터링
group by c.name, c.custid -- 고객별로 볼거니까 고객 이름으로 그룹핑, 이때 데이터 상에 동명이인은 없지만 확장성을 고려하여 custid로도 같이 그룹핑해주기
having `도서 수량` >= 3;

-- 40) '대한민국’에 거주하는 고객에 대하여 고객별 주문 도서의 총 수량을 구하기 / 단, 2권 이상 구매한 고객만 구하기 / 단, 결과를 도서수량 순으로 정렬하시오.
select 
	c.name,
    count(*) as '도서 수량'
from orders o
join customer c on o.custid = c.custid
where c.address like '%대한민국%' -- 그룹핑하기 전에 '대한민국'에 거주하는 고객 필터링
group by c.name, c.custid -- 고객별로 볼거니까 고객 이름으로 그룹핑, 이때 데이터 상에 동명이인은 없지만 확장성을 고려하여 custid로도 같이 그룹핑해주기
having `도서 수량` >= 2
order by `도서 수량` desc;