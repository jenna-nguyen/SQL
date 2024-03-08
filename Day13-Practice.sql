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
on tbl1.category=tbl2.category
