--MID-COURSE TEST

--Question 1: 9.99
select distinct replacement_cost
from film
order by replacement_cost;

--Question 2: 514
select
case
  when replacement_cost between 9.99 and 19.99 then 'low'
  when replacement_cost between 20 and 24.99 then 'medium'
  when replacement_cost between 25 and 29.99 then 'high'
 end as rpl_cost,
count(case
  when replacement_cost between 9.99 and 19.99 then 'low'
  when replacement_cost between 20 and 24.99 then 'medium'
  when replacement_cost between 25 and 29.99 then 'high'
 end)
from film
group by rpl_cost;

--Question 3: Sports : 184
select film.title,
film.length,
category.name as category_name
from film
join film_category on film.film_id=film_category.film_id
join category on film_category.category_id=category.category_id
where category.name in ('Drama','Sports')
order by film.length desc;

--Question 4: Sports :74 titles
select
category.name as category,
count(film.title)
from film
join film_category on film.film_id=film_category.film_id
join category on film_category.category_id=category.category_id
group by category.name
order by count desc;

--Question 5: Susan Davis : 54 movies
select actor.first_name,actor.last_name,
count(film_actor.film_id)
from actor
join film_actor on actor.actor_id=film_actor.actor_id
group by actor.first_name,actor.last_name
order by count(film_actor.film_id) desc;

--Question 6: 4
select address.address,
customer.customer_id
from address
left join customer on address.address_id=customer.address_id
where customer.customer_id is null;

--Question 7: Cape Coral : 221.55
select
city.city,
sum(payment.amount)
from city
join address on city.city_id=address.city_id
join customer on customer.address_id=address.address_id
join payment on payment.customer_id=customer.customer_id
group by city.city
order by sum(payment.amount) desc;

--Question 8: United States Cape Coral 221.55
select
concat(city.city,' ',country.country) as name,
sum(payment.amount)
from city
join country on country.country_id=city.country_id
join address on address.city_id=city.city_id
join customer on customer.address_id=address.address_id
join payment on payment.customer_id=customer.customer_id
group by concat(city.city,' ',country.country)
order by sum(payment.amount) desc;

--PRATICE 11:

--EX1:
select
COUNTRY.Continent,
floor(avg(CITY.Population))
from city
join country on CITY.CountryCode=COUNTRY.Code
group by COUNTRY.Continent;

--EX2:
SELECT
round(count(texts.email_id)::decimal/count(distinct emails.email_id)::decimal,2) as activation_rate
FROM emails
LEFT JOIN texts on emails.email_id=texts.email_id and texts.signup_action='Confirmed';

--EX3:
SELECT
age_breakdown.age_bucket,
round(sum(case when activities.activity_type='send' then activities.time_spent else 0 END)/
(sum(case when activities.activity_type='open' then activities.time_spent ELSE 0 END)+
sum(case when activities.activity_type='send' then activities.time_spent else 0 END))*100,2) 
as send_perc,
round(sum(case when activities.activity_type='open' then activities.time_spent ELSE 0 END)/
(sum(case when activities.activity_type='open' then activities.time_spent ELSE 0 END)+
sum(case when activities.activity_type='send' then activities.time_spent else 0 END))*100,2) 
as open_perc
FROM activities
join age_breakdown on age_breakdown.user_id=activities.user_id
group by age_breakdown.age_bucket;

--EX4:
with Supercloud_Customer as (SELECT
customer_contracts.customer_id as customer_id,
count(distinct products.product_category) as count_category
FROM customer_contracts
join products on customer_contracts.product_id=products.product_id
group by customer_contracts.customer_id)

select 
customer_id
from Supercloud_Customer
WHERE count_category=(select count(distinct product_category) from products);

--EX5:
select 
emp1.employee_id,
emp1.name,
count(emp2.reports_to) as reports_count,
round(avg(emp2.age),0) as average_age
from Employees as emp1
left join Employees as emp2 on emp1.employee_id=emp2.reports_to
group by emp1.employee_id,emp1.name
having count(emp2.reports_to)<>0;

--EX6:
select 
Products.product_name,
sum(orders.unit) as unit
from Products
join orders on products.product_id=orders.product_id
where extract(year from orders.order_date)=2020 and extract(month from orders.order_date)=2
group by products.product_name
having sum(orders.unit)>=100;

--EX7:
SELECT pages.page_id
FROM pages
left join page_likes on pages.page_id=page_likes.page_id
group by pages.page_id
having count(page_likes.user_id)=0
order by pages.page_id;

