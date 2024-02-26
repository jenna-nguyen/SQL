--EX1
select distinct City from Station
where ID%2=0;
--EX2
select
count(CITY)-count(distinct CITY) as "Difference"
from Station;
--EX4
SELECT 
round(cast(sum(item_count*order_occurrences)/sum(order_occurrences) as decimal),1) as "Mean Number"
FROM items_per_order;
SELECT 
distinct candidate_id
FROM candidates
group by candidate_id
having count(skill)=3
order by candidate_id asc;
--EX5
SELECT 
candidate_id
FROM candidates
where skill in('Python', 'Tableau','PostgreSQL')
group by candidate_id
having count(skill)=3
order by candidate_id asc;
--EX6
SELECT 
user_id,
max(post_date)::date - min(post_date)::date as "days_between"
FROM posts
where date_part('year',post_date)=2021
group by user_id
having count(post_id)>=2;
--EX7
SELECT 
card_name,
max(issued_amount)-min(issued_amount) as "Difference"
FROM monthly_cards_issued
group by card_name
order by max(issued_amount)-min(issued_amount) desc;
--EX8 (chưa giải xong)
SELECT 
manufacturer,
count(drug) as cout_of_lost,
abs(total_sales-cogs) as total_losses
FROM pharmacy_sales
group by manufacturer
having total_sales-cogs <0
order by abs(total_sales-cogs) desc;

