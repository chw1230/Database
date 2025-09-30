use smudb_test;
-- 202210986 최현우

-- 41) 가장 비싼 도서의 이름은 무엇인가?
-- all 사용
select bookname
from  book
where price >= all ( select price from book ); 

-- max 사용
select bookname
from  book
where price = ( select max(price) from book ); 


-- 42) 도서를 구매한 적이 있는 고객의 이름을 검색하시오.
-- in 사용하기
select distinct name
from customer
where custid in (select custid from orders);

-- exists 사용하기
select distinct name
from customer c
where exists (select 1 from orders o where c.custid = o.custid);


-- 43) 출판사별로 출판사의 평균 도서 가격보다 비싼 도서를 구하시오.
-- Derived relation 사용 
select b1.bookname
from ( select publisher, avg(price) as avg
	   from book 
       group by publisher ) b2
join book b1 on b1.publisher = b2.publisher
where b1.price > b2.avg;

-- Correlated Subquery 사용
select bookname
from book b1
where price > (select avg(price)
               from book b2
               where b2.publisher = b1.publisher); 


-- 44) 주문이 있는 고객의 이름과 주소를 보이시오.
select name, address
from customer c
where c.custid in ( select o.custid 
					from orders o
					where o.custid = c.custid );
                    
                    
-- 45) 고객별로 주문한 도서의 총 수량과 총 판매액을 구하시오.
-- 스칼라 서브쿼리 사용하기
SELECT o1.custid,    
		(select count(*) 
         from orders o2 
         where o1.custid = o2.custid) as 도서수량,
        (select sum(o2.saleprice) 
         from orders o2 
         where o1.custid = o2.custid) as 총액
FROM orders o1
GROUP BY o1.custid;