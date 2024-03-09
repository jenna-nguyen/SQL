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
WITH CTE AS
(
SELECT A.category,A.product,sum(A.spend) total_spend
FROM product_spend A
WHERE EXTRACT(Year FROM transaction_date) = 2022
GROUP BY A.category,A.product
)
SELECT A.category,A.product,A.total_spend
FROM CTE A,CTE B
WHERE
A.category=B.Category
AND A.total_spend<=B.total_spend
group by A.category,A.product,A.total_spend
having count(*)<3
order by A.category ASC,A.total_spend desc

with total AS
(select
category,product,
sum(spend) as total_spend
from product_spend
where extract(year FROM	transaction_date)=2022
group by category,product)
SELECT
total.category,total.product,total.total_spend
from total as tbl1
join total as tbl2 
on tbl1.category=tbl2.category;

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
with tbl1 as
(select product_id, min(year) as min_year from sales group by product_id)

select distinct sales.product_id,
sales.year as first_year,
sales.quantity,
sales.price
from sales
join tbl1 on tbl1.product_id=sales.product_id
where sales.year in (select min_year from tbl1);

--EX8:

