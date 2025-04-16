set search_path to oe,hr;
-- CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
	-- Task 1 (5 Point)
	-- Create table & relasinya untuk table bank,users,carts,cart_items & attribute tambahan yang ada di table orders.
	-- table bank --
create table oe.bank (
    bank_code VARCHAR(4) primary key,
    bank_name VARCHAR(55),
    created_at TIMESTAMP default current_timestamp
);

	-- table users --
create table oe.users(
user_id SERIAL PRIMARY KEY,
user_name varchar(30),
user_email varchar (80) unique,
user_password varchar(125),
user_handphone varchar(24) unique,
created_on TIMESTAMP default CURRENT_TIMESTAMP
);

-- ALTER TABLE oe.users
-- ADD COLUMN user_handphone VARCHAR(20) UNIQUE;
-- ALTER TABLE users
-- ALTER COLUMN email TYPE VARCHAR(80);
-- ALTER TABLE oe.users
-- ALTER COLUMN email DROP NOT NULL;

select * from users

	-- table charts --
create table oe.carts(
cart_id smallint primary key,
created_on TIMESTAMP default CURRENT_TIMESTAMP,
user_id int unique,
foreign key (user_id) references oe.users (user_id)
on update cascade on delete cascade
);


	-- table chart item --
create table oe.cart_items(
cart_item_id smallint primary key,
product_id int unique,
quantity smallint,
created_on TIMESTAMP default CURRENT_TIMESTAMP,
cart_id integer not null,
foreign key (cart_id) references oe.carts (cart_id)
);

select * from oe.cart_items

alter table oe.cart_items
add constraint cart_product_id_fk foreign key (product_id) 
references oe.products(product_id)

-- DROP TABLE oe.users CASCADE;

	-- 	--
alter table oe.orders
 add column user_id integer,
 add constraint user_id_fk foreign key (user_id) references oe.users(user_id),
 add column bank_code varchar(4),
 add constraint bank_code_fk foreign key (bank_code) references oe.bank(bank_code),
 add column total_discount decimal(5,2),
 add column total_amount decimal(8,2),
 add column payment_type varchar(15),
 add column card_no varchar(25),
 add column transac_no varchar(25),
 add column transac_date timestamp,
 add column ref_no varchar(25);

select * from oe.orders
select * from locations

-- Task 2 (5 Point)
-- Buat link antara table hr.locations dan table oe.orders, dan update kolom location_id di table oe.orders.

alter table oe.orders
add column location_id integer;

alter table oe.orders
add constraint order_location_fk Foreign Key (location_id) REFERENCES
hr.locations(location_id);

-- update--
update oe.orders as o
set location_id = (select location_id from oe.location_x l 
where l.street_address=o.ship_address and l.city=o.ship_city and l.postal_code=o.ship_postal_code and l.country_name=o.ship_country)

-- Task 3 (10 Point)
-- Pindahkan data employee dari schema oe.employees ke schema hr.employees. Data yang dipindahkan cukup mengikuti kolom yang ada di schema hr.employees.
select first_name, last_name from hr.employees 
union
select first_name, last_name from oe.employees 

select * from hr.employees
select * from oe.employees

insert into hr.employees (employee_id, first_name, last_name, email, hire_date, job_id, salary)
select employee_id, first_name, last_name, LOWER(first_name||  '.' || last_name || '@sqltutorial.com')
as email, hire_date, j.job_id,
0.00 as salary
from oe.employees
JOIN (
    SELECT job_id
    FROM hr.jobs
    ORDER BY RANDOM()
	limit 1
) j ON TRUE;
select * from hr.employees

-- Buat relasi antara table hr.employees dengan table oe.orders --

alter table oe.orders
add constraint employee_id foreign key(employee_id) 
references hr.employees(employee_id) 

-- Task 4 (10 Point)
-- Create table users di shema oe.

-- Pindahkan data dari table oe.customers ke table users.
CREATE EXTENSION IF NOT EXISTS pgcrypto;

select * from oe.customers

select * from users
insert into oe.users (user_name, user_password, user_handphone)
select 
	lower(customer_id) as username,
    crypt(lower(customer_id), gen_salt('bf', 12)) as password,
    phone as user_handphone
from oe.customers;


	-- Buat relasi antara table oe.users dengan table oe.orders --

select * from oe.orders
select * from oe.users

ALTER TABLE oe.orders DROP COLUMN user_id;
ALTER TABLE oe.orders ADD COLUMN IF NOT EXISTS user_id INTEGER;

update oe.orders o
set user_id = u.user_id
from oe.users u
where lower(u.user_name) = lower(o.customer_id);

alter table oe.orders add constraint fk_orders_user
    foreign key (user_id) references oe.users(user_id);

	-- Untuk value password gunakan function crypt(). Kolom password diambil dari kolom lower(customer_id).
 INSERT INTO users (username, password) 
 VALUES ('Samuel', crypt('MySecureP@ssw0rd', gen_salt('bf', 12)));

 SELECT crypt('$2a$12$PQV8MkvZTIRjAV3XvDlorOxMNcL0J0bV9TtyO27dkuzAlO2.EK4sC', gen_salt('bf', 12));

 
