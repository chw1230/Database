/*
* 요구사항 : 쇼핑물에서 사용할 데이터베이스를 만드려고 합니다. 사용자는 한 번에 여러 상품을 주문할 수 있고, 여러 번에 걸쳐 주문할 수 있음, 주문이 들어 오면 
* 주문 시간과 상춤을 기록으로 남기고, 주문이 결제 되면 결제 정보도 기록으로 남기기 
*/


create database data_modeling;
use data_modeling;

create table users (
	id integer auto_increment,
    email varchar(100) not null unique,
    name varchar(50) not null,
    primary key (id)
);

create table orders (
	id integer auto_increment,
    status varchar(50),
    created_at datetime,
    user_id integer not null,
    primary key (id),
    foreign key (user_id) references users(id)
);

create table payments (
	id integer auto_increment,
    amount integer not null,
    payment_type varchar(50) not null,
    order_id integer not null,
    primary key(id),
    foreign key(order_id) references orders(id)
);

create table products (
	id integer auto_increment,
    name varchar(50) not null unique,
    price integer not null, check (price>0),
    product_type varchar(50) default 'NONE',
    primary key (id),
    index idx_product_name (name)
);

create table order_details (
	id integer auto_increment,
    order_id integer not null,
    product_id integer not null,
    count integer not null check (count>0),
    primary key (id),
    foreign key (order_id) references orders (id),
    foreign key (product_id) references products (id),
    unique (order_id, product_id)
);
