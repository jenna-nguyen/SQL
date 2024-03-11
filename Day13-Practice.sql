--EX1:
with count_tbl AS
(SELECT company_id,title,description,
count(job_id) as count_job
FROM job_listings
group by company_id,title,description)
select 
count(company_id)
from count_tbl
where count_job>=2;
--EX2:
with tbl1 AS
(select
category,product,
sum(spend) as total_spend
from product_spend
where extract(year FROM	transaction_date)=2022
group by category,product
order by category,total_spend DESC),

tbl2 as (select category, product,total_spend,
RANK() over(PARTITION BY category order by total_spend DESC) as ranking
from tbl1)

select category, product, total_spend
from tbl2
where ranking <3;

--EX3:
with call_record AS
(SELECT policy_holder_id,
count(case_id) as count_call
FROM callers
group by policy_holder_id)

select count(policy_holder_id)
from call_record
where count_call>=3;


--EX4:
SELECT pages.page_id
FROM pages
left join page_likes on pages.page_id=page_likes.page_id
group by pages.page_id
having count(page_likes.user_id)=0
order by pages.page_id;

--EX5:
with tbl1 AS
(select user_id,
extract(month from event_date) as month,
count(event_id)
from user_actions
where extract(year from event_date)=2022 
and extract(month from event_date)=6
group by user_id, extract(month from event_date)
having count(event_id)>0),

tbl2 AS
(select user_id,
extract(month from event_date) as month,
count(event_id)
from user_actions
where extract(year from event_date)=2022 
and extract(month from event_date)=7
group by user_id, extract(month from event_date)
having count(event_id)>0)

SELECT
tbl2.month,
count(DISTINCT tbl2.user_id)
from tbl2
join tbl1 on tbl1.user_id=tbl2.user_id
group by tbl2.month;

--EX6:
with tbl1 as 
(select
extract(year from trans_date)||'-'||extract(month from trans_date) as month,
COUNTRY,
count(state) as approved_count,
sum(amount) as approved_total_amount
from transactions
where state='approved'
group by country, month),

tbl2 as
(select *,
extract(year from Transactions.trans_date)||'-'||extract(month from Transactions.trans_date) as month
from Transactions)

select 
tbl2.month,
tbl2.country,
count(tbl2.id) as trans_count,
tbl1.approved_count,
sum(tbl2.amount) as trans_total_amount,
tbl1.approved_total_amount
from Tbl2
join tbl1 on tbl1.month=tbl2.month and tbl2.country=tbl1.country
group by tbl2.month,tbl2.country,tbl1.approved_count,tbl1.approved_total_amount;

--EX7:
select product_id,
year as first_year,
quantity,
price
from sales
where (product_id,year) in (select product_id,min(year) from sales group by product_id)

--EX8:
select customer_id
from Customer
group by customer_id
having count(distinct product_key)=(select count(distinct product_key) from Product);

--EX9:
select employee_id
from employees
where manager_id not in (select employee_id from employees)
and salary<30000
order by employee_id;

--EX10:
with count_tbl AS
(SELECT company_id,title,description,
count(job_id) as count_job
FROM job_listings
group by company_id,title,description)
select 
count(distinct company_id)
from count_tbl
where count_job>=2;

--EX11:
with name_count as
(select
count(MovieRating.movie_id),
Users.name as results
from MovieRating
join users on MovieRating.user_id=users.user_id
group by Users.name
order by count(MovieRating.movie_id) desc,Users.name
limit(1)),
highest_avg as
(select 
avg(MovieRating.rating),
Movies.title as results
from Movies
join MovieRating on MovieRating.movie_id=Movies.movie_id
where extract(year from MovieRating.created_at)=2020 and extract(month from MovieRating.created_at)=2
group by Movies.title
order by avg(MovieRating.rating) desc,Movies.title asc
limit(1))
select results from name_count
union all
select results from highest_avg;

--EX12:
with ID as (select requester_id as ID from RequestAccepted union all select accepter_id as ID from RequestAccepted)
select 
ID,
count(*) as num
from ID
group by ID
order by count(*) desc
limit (1);
