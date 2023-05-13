CREATE DATABASE airline;
-- use airline

create table flight (flight_id integer not null,
airline varchar(20) not null,
capacity integer not null,
airport_departure varchar(50) not null,
airport_arrival varchar(50) not null,
delay int not null,
constraint PK_flight PRIMARY KEY (flight_id)
);

insert into flight (flight_id,airline,capacity,airport_departure,airport_arrival,delay)
values (2,'CO',500,'SFO','IAH',1),
(4,'US',410,'PHX','CLT',1),
(3,'DL',100,'LAX','MSP',1),
(1,'AA',250,'SFO','DFW',0);


create table location (
location_id int not null,
country varchar(50) not null,
state varchar(50) null,
branch  varchar(50),
constraint PK_location PRIMARY KEY (location_id)
);

insert into location (location_id,country,state,branch)
values (1,'USA','California','Dallax'),
(4,'USA','Arizona','Arizona'),
(3,'USA','California','Atlanta'),
(2,'USA','California','Fort Worth');

create table passenger (
passenger_id int not null,
first_name varchar(50) not null,
last_name varchar(50) null,
contact_address varchar(50) not null,
age integer null,
email_address varchar(50) not null,
Nationality varchar(50) null,
location_id integer not null,
constraint PK_passenger PRIMARY KEY (passenger_id),
constraint FK_passenger_location FOREIGN KEY (location_id)
references location (location_id)
);

insert into passenger (passenger_id,first_name,last_name,contact_address,age,email_address,Nationality,location_id)
values (1,'Grace','Olayemi','805-574-3918',26,'golayemi@gmail.com','Nigerian',4),
(2,'Arjun','Daksh','234-678-9067',47,'adaksh@gmail.com','Indian',3),
(3,'Kim','Jeong','345-789-1233',21,'kjeong@gmail.com','Korean',1),
(4,'Lilia','Obama','134-890-6785',62,'lobama@yahoo.com','Hawaiian',2);

create table employee (
employee_id int not null,
first_name varchar(50) not null,
last_name varchar(50) null,
designation varchar(50) null,
email_address varchar(50) not null,
flight_id integer not null,
constraint PK_employee PRIMARY KEY (employee_id),
constraint FK_employee_flight FOREIGN KEY (flight_id)
references flight (flight_id)
);

insert into employee (employee_id, first_name, last_name, designation, email_address, flight_id)
values (1, 'James','Brooklyn','California','jbrooklyn@gmail.com',2),
(2,'Tom','Brown','California','tbrown@yahoo.com',3),
(3,'Francess','Iyke','Arizona','fiyke@gmail.com',4),
(4,'Marie','William','California','mwilliam@gmail.com',1);

create table sales (
sales_id int not null,
airfare float not null,
discount float null,
passenger_id int not null,
location_id int not null,
flight_id int not null,
constraint PK_sales PRIMARY KEY (sales_id),
constraint FK_sales_passenger FOREIGN KEY (passenger_id)
references passenger (passenger_id),
constraint FK_sales_location FOREIGN KEY (location_id)
references location (location_id),
constraint FK_sales_flight FOREIGN KEY (flight_id)
references flight (flight_id)
);

insert into sales (sales_id,airfare,discount,passenger_id,location_id,flight_id)
values (2,350.0,0.1,3,1,2),
(1,120.05,0.03,1,4,4),
(3,333.0,0.06,2,3,3),
(4,441.4,0.15,4,2,1);


select top 2* from employee;

select top 2* from flight;

select top 2* from location;

select top 2* from passenger;

select top 2* from sales;

-- passengers whose flight were delayed in state California
select first_name, last_name
from passenger p
join location l
on l.location_id = p.location_id
join sales s
on s.passenger_id = p.passenger_id
join flight f
on f.flight_id = s.flight_id
where l.state = 'California' and f.delay = 1;

-- Flight with highest capacity
select airline, capacity as capacity 
from flight
order by capacity desc;


-- Find the details of the designated employee whose airport departure was delayed at SFO
select *
from
(select e.first_name, e.last_name, e.email_address, e.designation
from flight f
join employee e
on f.flight_id = e.flight_id
where f.delay=1 and airport_departure='SFO') as a;

select *
from sales;

-- find the airline that offers highest dicounted price
select  airline, discount_price 
from
(select f.airline, (airfare * discount) as discount_price
from sales s
join flight f
on s.flight_id=f.flight_id) as b
group by airline, discount_price
having discount_price > 35
order by airline asc;


-- CREATING A VIEW WITH MORE THAN 2 TABLES
-- The actual airfare paid by the individual passenger and the airline of their choice
USE airline ;   
GO 
create view passenger_airline_airfare
as
select (p.first_name + ' ' + p.last_name) as name, (airfare - (airfare*discount)) as actual_airfare, f.airline
from passenger p
join sales s
on p.passenger_id = s.passenger_id
join flight f
on f.flight_id = s.flight_id;

select * 
from passenger_airline_airfare
where actual_airfare > 300;




