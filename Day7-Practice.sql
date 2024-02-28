--EX1
select
name
from students
where marks>75
order by right(name,3),id;
--EX2
select
user_id,
upper(left(name,1)) || lower(right(name,length(name)-1)) as "name"
from users
order by user_id;
--EX3
SELECT
manufacturer,
concat('$',round(sum(total_sales)/1000000),' million') as "sale"
FROM pharmacy_sales
group by manufacturer
order by sum(total_sales)/1000000 desc, manufacturer;
--EX4
SELECT
extract(month from submit_date) as "month",
product_id,
round(avg(stars),2) as "rate"
FROM reviews
group by extract(month from submit_date),product_id
order by extract(month from submit_date),product_id;
--EX5
SELECT 
sender_id,
count(message_id)
FROM messages
where extract(month from sent_date)=8
and extract(year from sent_date)=2022
group by sender_id
order by count(message_id) desc
limit(2);
--EX6
select
tweet_id as tweet_id
from tweets
where length(content)>15;
--EX7


