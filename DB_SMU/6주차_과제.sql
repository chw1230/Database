use smudb_test;

-- Join: 1~3번 
-- 1) 도서를 구매하지 않은 고객을 포함하여 고객의 이름과 고객이 주문한 도서의 가격을 구하시오.
select c.name, o.saleprice
from customer c left join orders o on c.custid = o.custid;

-- 2) 고객과 고객의 주문에 관한 데이터를 모두 보이시오.
select *
from customer c join orders o on c.custid = o.custid;

-- 3) 고객의 이름과 고객이 주문한 도서의 가격을 검색하시오.
select c.name, o.saleprice
from customer c join orders o on c.custid = o.custid;

-- View: 4~6번
-- (4) 주소에 ‘대한민국’을 포함하는 고객들로 구성된 뷰를 만들고 조회하시오. 단, 뷰의 이름은 vw_Customer 로 한다.
-- (4-1) 뷰 만들기
create view vw_Customer as
	(select * from customer where address like '%대한민국%');
-- (4-2) 뷰 조회하기
select * from vw_Customer;

-- (5) Orders 테이블에 고객이름과 도서이름을 바로 확인할 수 있는 뷰를 생성한 후, ‘김연아’ 고객이 구입한 도서의 도서이름을 보이시오.
-- (5-1) 뷰 만들기 
create view vw_customerName_bookName as
	 (select c.name, b.bookname
     from customer c
     join orders o on c.custid = o.custid
     join book b on o.bookid = b.bookid);
-- (5-2) ‘김연아’ 고객이 구입한 도서의 도서이름 보이기
select * from vw_customerName_bookName vw where vw.name = '김연아';

-- (6) 앞서 생성한 뷰 vw_Customer를 삭제하여라.
-- 뷰 이름 알기위해서 조회하기
SHOW TABLES;
-- 뷰 삭제하기
drop view vw_customer, vw_customername_bookname;
-- 뷰 잘 지워졌나 보기 위해서 조회하기
SHOW TABLES;

-- Integrity Constraints: PPT 49 페이지

-- Orders 테이블에 수정/삭제에 대한 cascade 옵션을 추가하시오.
-- 1.외래 키 이름을 확인하기
show create table orders;
-- 2.기존의 제약조건 삭제하기
alter table orders drop foreign key orders_ibfk_1; 
alter table orders drop foreign key orders_ibfk_2;
-- 3.외래 키 삭제 여부 확인
show create table orders;
-- 4.ON UPDATE CASCADE 와 ON DELETE CASCADE 옵션을 모두 포함하여 추가 해주기
-- custimer와 orders의 설정
alter table orders
add foreign key  (custid) references customer(custid) 
		on delete cascade 
        on update cascade;
-- book과 orders의 설정
alter table orders
add foreign key  (bookid) references book(bookid) 
		on delete cascade 
        on update cascade;
-- 5.외래 키 추가 여부 확인
show create table orders;
-- > Customer 테이블에서 ‘박지성’ 고객을 삭제
DELETE FROM customer WHERE name = '박지성';
-- 삭제 확인 
select *
from customer;
select *
from orders;

-- > Customer 테이블에서 ‘김연아’ 고객의 custid를 12로 변경
update customer set custid = 12 where name = '김연아';
-- 변경 확인 
select *
from customer;
select *
from orders;

-- > Book 테이블에서 ‘굿스포츠’에서 출판한 모든 책을 삭제
delete from book where publisher = '굿스포츠';
select *
from book;
select *
from orders;