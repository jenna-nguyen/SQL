--EX1:
with tbl1 AS
(SELECT EXTRACT(year from transaction_date) as year,
product_id,
spend as curr_year_spend,
lag(spend) over(PARTITION BY product_id order by product_id) 
as prev_year_spend
FROM user_transactions)
select year,product_id,curr_year_spend,prev_year_spend,
round((curr_year_spend-prev_year_spend)/prev_year_spend*100,2) as yoy_rate
from tbl1;

--EX2:

