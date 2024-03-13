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
with tbl1 as (select card_name, issued_amount,
rank() OVER(PARTITION BY card_name order by issue_year,issue_month) as rank
from monthly_cards_issued)
select card_name, issued_amount
from tbl1
where rank=1
order by issued_amount DESC;

--EX3:
with tbl1 as (SELECT * ,
RANK() over(PARTITION BY user_id order by transaction_date)
FROM transactions)
select user_id,spend,transaction_date
from tbl1
where rank=3;

--EX4:
with tbl1 as (SELECT user_id,transaction_date,count(product_id) as purchase_count,
RANK() OVER(PARTITION BY user_id order by transaction_date desc) as rank_date
FROM user_transactions
group by user_id,transaction_date)
select transaction_date,user_id, purchase_count
from tbl1
where rank_date=1
order by transaction_date;

--EX5:
SELECT user_id,Tweet_date,
round(avg(tweet_count) OVER(PARTITION BY user_id order by tweet_date 
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) as rolling_avg
FROM tweets;

--EX6:
with tbl1 as (SELECT transaction_id,merchant_id,credit_card_id,amount,
transaction_timestamp,
lead(transaction_timestamp) over(PARTITION BY credit_card_id 
order by transaction_timestamp) as transaction_after,
extract(minute from lead(transaction_timestamp) over(PARTITION BY credit_card_id 
order by transaction_timestamp)-transaction_timestamp) as minute_diff
FROM transactions)
select count(minute_diff) as payment_count
from tbl1
where minute_diff<10;

--EX7:
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

--EX8:
with tbl1 as (SELECT artists.artist_name,
count(global_song_rank.day),
dense_RANK() over(order by count(global_song_rank.day) DESC) as artist_rank
FROM artists
join songs on artists.artist_id=songs.artist_id
join global_song_rank on global_song_rank.song_id=songs.song_id
where global_song_rank.rank<=10
group by artists.artist_name)
select artist_name,artist_rank
from tbl1
where artist_rank<=5;
