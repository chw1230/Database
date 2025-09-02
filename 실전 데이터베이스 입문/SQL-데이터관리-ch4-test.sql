-- 문제 1 - 데이터베이스와 테이블 생성하기
CREATE DATABASE my_test;

use my_test;

create table members (
	id INT primary key,
    name varchar(50) not null,
    join_date date
);

DESC members;


-- 문제 2 - 데이터 추가 및 조회하기
insert into members (id,name,join_date) 
values 
	(1, '션', '2025-01-10'),
    (2, '네이트', '2025-02-15');
    
select * from members;


-- 문제 3 - 데이터 수정 및 삭제하기
update members
set name = '네이트2'
where id = 2;

delete from members
where id = 1;

select * from members;


-- 문제 4 제약 조건을 포함한 테이블 생성하기
create table products (
	product_id int primary key auto_increment,
    product_name varchar(100) not null,
    product_code varchar(20) unique,
    prcie int not null,
    stock_quantity int not null default 0
);

desc products;


-- 문제 5 - 외래 키(Foreign Key)로 테이블 관계 맺기
create table customers (
	customer_id int primary key auto_increment,
    name varchar(50) not null
);

create table orders (
	order_id int primary key auto_increment,
    customer_id INT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    constraint fk_orders_customers foreign key (customer_id) references customers(customer_id)
);

insert into customers (name)
value ('홀길동');

insert into orders (customer_id) 
value (1);

select * from customers;
select * from orders;