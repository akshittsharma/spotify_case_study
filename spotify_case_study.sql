create database spotify;

use spotify;

CREATE table activity
(
user_id varchar(20),
event_name varchar(20),
event_date date,
country varchar(20)
);

insert into activity values (1,'app-installed','2022-01-01','India')
,(1,'app-purchase','2022-01-02','India')
,(2,'app-installed','2022-01-01','USA')
,(3,'app-installed','2022-01-01','USA')
,(3,'app-purchase','2022-01-03','USA')
,(4,'app-installed','2022-01-03','India')
,(4,'app-purchase','2022-01-03','India')
,(5,'app-installed','2022-01-03','SL')
,(5,'app-purchase','2022-01-03','SL')
,(6,'app-installed','2022-01-04','Pakistan')
,(6,'app-purchase','2022-01-04','Pakistan');



-- -- Daily active users
select event_date as date, count(distinct user_id) as no_of_users from activity group by event_date;

-- -- Weekly active users

select week(event_date) as week_no, count(distinct user_id) as no_of_users from activity group by week(event_date);


-- -- same day install and purchase

select user_id, count(distinct event_name)as no_of_users
from activity group by user_id, event_date 
having count(distinct event_name);


-- -- country wise paid users
 
 select country, count(distinct user_id) as cnt
 from activity where event_name="app-purchase" 
 group by country;


-- among all the users who installed the app on a given day, how many did an in-app purchase on very next day


with cte as (select * ,
lag(event_date,1) over(partition by user_id order by event_date) as prev_event_date,
lag(event_name,1) over(partition by user_id order by event_name) as prev_event_name
from activity )
select event_date, count(distinct user_id) as cnt_users from 
cte
where event_name="app-purchase" and prev_event_name="app-installed" and datediff(event_date,prev_event_date)=1
group by event_date;















