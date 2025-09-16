-- 데이터 베이스 과제 - 202210986 최현우
create database smudb_test;

use smudb_test;

create table Book (
	bookid int,
    bookname varchar(50),
    publisher varchar(20),
    price int,
    primary key (bookid)
);
desc Book;

create table Customer (
	custid int,
    name varchar(10),
    address varchar(20),
    phone varchar(15),
    primary key (custid)
);
desc Customer;

create table Orders (
	orderid int,
    custid int,
    bookid int,
    saleprice int,
    orderdate date,
    primary key (orderid),
    foreign key (custid) references Customer (custid),
    foreign key (bookid) references Book (bookid)
);
desc Orders;
    
insert into Book values (1, '축구의 역사', '굿스포츠', 7000);
insert into Book values (2, '축구 아는 여자', '나무수', 13000);
insert into Book values (3, '축구의 이해', '대한미디어', 22000);
insert into Book values (4, '골프 바이블', '대한미디어', 35000);
insert into Book values (5, '피겨 교본', '굿스포츠', 8000);
insert into Book values (6, '역도 단계별기술', '굿스포츠', 6000);
insert into Book values (7, '야구의 추억', '이상미디어', 20000);
insert into Book values (8, '야구를 부탁해', '이상미디어', 13000);
insert into Book values (9, '올림픽 이야기', '삼성당', 7500);
insert into Book values (10, 'Olympic Champions', 'Pearson', 13000);

insert into Customer values (1, '박지성', '영국 맨체스타', '000-5000-0001');
insert into Customer values (2, '김연아', '대한민국 서울', '000-6000-0001');
insert into Customer values (3, '장미란', '대한민국 강원도', '000-7000-0001');
insert into Customer values (4, '추신수', '미국 클리블랜드', '000-8000-0001');
insert into Customer values (5, '박세리', '대한민국 대전', null);

insert into Orders values (1, 1, 1, 6000, '2013-07-01');
insert into Orders values (2, 1, 3, 21000, '2013-07-03');
insert into Orders values (3, 2, 5, 8000, '2013-07-03');
insert into Orders values (4, 3, 6, 6000, '2013-07-04');
insert into Orders values (5, 4, 7, 20000, '2013-07-05');
insert into Orders values (6, 1, 2, 12000, '2013-07-07');
insert into Orders values (7, 4, 8, 13000, '2013-07-07');
insert into Orders values (8, 3, 10, 12000, '2013-07-08');
insert into Orders values (9, 2, 10, 7000, '2013-07-09');
insert into Orders values (10, 3, 8, 13000, '2013-07-10');

select * from Book;
select * from Customer;
select * from Orders;

-- 실습 : 서점 데이터 (select)

-- 1) 모든 도서의 이름과 가격을 검색하시오
select bookname, price
from Book;

-- 2)c모든 도서의 도서번호, 도서이름, 출판사, 가격을 검색하시오
select *
from Book;

-- 3) 도서 테이블에 있는 모든 출판사를 검색하시오
select publisher
from Book;

-- 4) 가격이 20,000원 미만인 도서를 검색하시오
select *
from Book
where price < 20000;

-- 5) 가격이 10,000원 이상 20,000 이하인 도서를 검색하시오
select *
from Book
where price between 10000 and 20000; -- 10000 <= price and price <= 20000; 사이에 있는 값 between 써보쟈!

-- 6) ＂이상미디어”에서 출판한 도서중에 가격이 15,000 미만인 도서를 검색하시오.
select *
from Book
where price < 15000 and publisher = '이상미디어';

-- 7) ＂이상미디어” 또는 “대한미디어”에서 출판한 도서중에 가격이 25,000 미만인 도서를 검색하시오.
select *
from Book
where 25000 <= price and ( publisher = '이상미디어' or publisher = '대한미디어');

-- 8) “장미란” 고객의 주소, 전화번호를 검색하시오.
select address, phone
from Customer
where name = '장미란';

-- 9) 고객과 고객의 주문에 관한 데이터를 모두 보이시오.
select *
from Customer c
join Orders o on c.custid = o.custid;
/* 수업시간에 배운 방식으로도 해보기 : from 절에 테이블1, 테이블2 방식 / natural join 키워드 사용하기 */
-- 방식 1
select *
from Customer, Orders
where Customer.custid = Orders.custid;

-- 방식 2
select *
from Customer natural join Orders;
-- 둘의 차이점 : from절 ',' 조인은 동일한 이름의 컬럼(custid)을 찾아서 join, NATURAL JOIN 은 custid이 양쪽에 있어도 한번만 나오는 특징을 가짐
-- 그러면 내가 사용한 join 방식은 어떤식으로 나오나? -> from절 ',' 조인 방식과 같은 결과를 반환함!

-- 10) 고객의 이름과 고객이 주문한 도서의 가격을 검색하시오.
select c.name, o.saleprice as price
from Customer c
join Orders o on c.custid = o.custid;

-- 11) 고객의 이름과 고객이 주문한 도서의 이름을 구하시오
select c.name, b.bookname
from Customer c
join Orders o on c.custid = o.custid
join Book b on o.bookid = b.bookid;

-- 12) 가격이 20,000원인 도서를 주문한 고객의 이름과 도서의 이름을 구하시오.
select c.name, b.bookname
from Customer c
join Orders o on c.custid = o.custid
join Book b on o.bookid = b.bookid
where o.saleprice = 20000;

-- 13) "야구를 부탁해" 도서를 구매한 고객의 이름, 전화번호를 검색하시오.
select c.name, c.phone
from Customer c
join Orders o on c.custid = o.custid
join Book b on o.bookid = b.bookid
where b.bookname = '야구를 부탁해';

-- 14) "박지성" 고객이 구입한 모든 도서의 도서명, 출판사, 가격을 구하시오.
select b.bookname, b.publisher, o.saleprice as price
from Customer c
join Orders o on c.custid = o.custid
join Book b on o.bookid = b.bookid
where c.name = '박지성';

-- 15) “박지성” 또는 “장미란” 고객이 구입한 모든 도서의 도서명, 출판사, 가격을 구하시오.
select b.bookname, b.publisher, o.saleprice as price
from Customer c
join Orders o on c.custid = o.custid
join Book b on o.bookid = b.bookid
where c.name = '박지성' or c.name = '장미란';