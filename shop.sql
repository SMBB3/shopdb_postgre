drop table if exists order_items cascade;
drop table if exists orders cascade;
drop table if exists products cascade;
drop table if exists customers cascade;

create table customers (
    customer_id serial primary key,
    full_name varchar(100) not null,
    email varchar(120) unique not null,
    phone varchar(20),
    created_at timestamp default current_timestamp
);

create table products (
    product_id serial primary key,
    product_name varchar(150) not null,
    category varchar(100),
    price numeric(10,2) not null check (price >= 0),
    stock integer not null default 0 check (stock >= 0)
);

create table orders (
    order_id serial primary key,
    customer_id integer not null,
    order_date timestamp default current_timestamp,
    status varchar(30) default 'new',

    constraint fk_orders_customer
        foreign key (customer_id)
        references customers(customer_id)
        on delete cascade
);

create table order_items (
    order_item_id serial primary key,
    order_id integer not null,
    product_id integer not null,
    quantity integer not null check (quantity > 0),
    price numeric(10,2) not null check (price >= 0),

    constraint fk_orderitems_order
        foreign key (order_id)
        references orders(order_id)
        on delete cascade,

    constraint fk_orderitems_product
        foreign key (product_id)
        references products(product_id)
        on delete cascade
);

insert into customers (full_name, email, phone)
values
('Ivan Petrov', 'ivan@example.com', '+79990001122'),
('Anna Smirnova', 'anna@example.com', '+79990003344'),
('Dmitry Sokolov', 'dmitry@example.com', '+79995556677');

insert into products (product_name, category, price, stock)
values
('Gaming Mouse', 'Electronics', 49.99, 15),
('Mechanical Keyboard', 'Electronics', 120.00, 7),
('Monitor 27"', 'Displays', 299.90, 5),
('USB-C Cable', 'Accessories', 9.99, 50);

insert into orders (customer_id, status)
values
(1, 'new'),
(2, 'paid');

insert into order_items (order_id, product_id, quantity, price)
values
(1, 1, 2, 49.99),
(1, 4, 3, 9.99),
(2, 2, 1, 120.00);

select
    o.order_id,
    c.full_name,
    o.order_date,
    o.status
from orders o
join customers c
on o.customer_id = c.customer_id;

select
    oi.order_item_id,
    p.product_name,
    oi.quantity,
    oi.price
from order_items oi
join products p
on oi.product_id = p.product_id;

select
    o.order_id,
    sum(oi.quantity * oi.price) as total_amount
from orders o
join order_items oi
on o.order_id = oi.order_id
group by o.order_id;
