--Create table
create table SALES_DATASET_RFM_PRJ
(
  ordernumber VARCHAR,
  quantityordered VARCHAR,
  priceeach        VARCHAR,
  orderlinenumber  VARCHAR,
  sales            VARCHAR,
  orderdate        VARCHAR,
  status           VARCHAR,
  productline      VARCHAR,
  msrp             VARCHAR,
  productcode      VARCHAR,
  customername     VARCHAR,
  phone            VARCHAR,
  addressline1     VARCHAR,
  addressline2     VARCHAR,
  city             VARCHAR,
  state            VARCHAR,
  postalcode       VARCHAR,
  country          VARCHAR,
  territory        VARCHAR,
  contactfullname  VARCHAR,
  dealsize         VARCHAR
) 

--1. Chuyển đổi kiểu dữ liệu phù hợp cho các trường
alter table sales_dataset_rfm_prj
alter column ordernumber type integer USING (ordernumber::integer);
alter table sales_dataset_rfm_prj
alter column quantityordered type numeric USING (quantityordered::numeric);
alter table sales_dataset_rfm_prj
alter column priceeach type numeric USING (priceeach::numeric);
alter table sales_dataset_rfm_prj
alter column orderlinenumber type integer USING (orderlinenumber::integer);
alter table sales_dataset_rfm_prj
alter column sales type numeric USING (sales::numeric);
alter table sales_dataset_rfm_prj
alter column msrp type integer USING (msrp::integer);
alter table sales_dataset_rfm_prj
alter column ORDERDATE type TIMESTAMP USING (ORDERDATE::TIMESTAMP);

--2. Check NULL/BLANK (‘’)
select * from sales_dataset_rfm_prj
where ORDERNUMBER=0 or ORDERNUMBER is null
or QUANTITYORDERED=0 or QUANTITYORDERED is null
or PRICEEACH=0 or PRICEEACH is null
or ORDERLINENUMBER=0 or ORDERLINENUMBER is null
or SALES=0 or SALES is null
or ORDERDATE is null;

/*3. Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME 
được tách ra từ CONTACTFULLNAME*/
alter table sales_dataset_rfm_prj
add column CONTACTFIRSTNAME varchar(50);
alter table sales_dataset_rfm_prj
add column CONTACTLASTNAME varchar(50);
UPDATE sales_dataset_rfm_prj
SET
contactlastname= upper(substring(contactfullname 
				from position('-' in contactfullname)+1 for 1))||
lower(substring(contactfullname from position('-' in contactfullname)+2
	 for length(contactfullname)-position('-' in contactfullname)-2)),
	
	contactfirstname = UPPER(LEFT(contactfullname,1))||
LOWER(SUBSTRING(contactfullname from 2 
				for POSITION('-' IN contactfullname)-2))


/*4. Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là 
Qúy, tháng, năm được lấy ra từ ORDERDATE */
alter table sales_dataset_rfm_prj
add column QTR_ID numeric;
alter table sales_dataset_rfm_prj
add column MONTH_ID numeric;
alter table sales_dataset_rfm_prj
add column YEAR_ID numeric;
UPDATE sales_dataset_rfm_prj
SET QTR_ID=ceiling(extract(month from orderdate)/3),
MONTH_ID=extract(month from orderdate),
YEAR_ID=extract(year from orderdate);

/*5. Hãy tìm outlier (nếu có) cho cột QUANTITYORDERED 
và hãy chọn cách xử lý cho bản ghi đó (2 cách)*/
--Cách 1: Sử dụng IQR

with tbl2 as (select pct_25-1.5*IQR as min_value,
pct_75+1.5*IQR as max_value
from (
select 
percentile_cont(0.25) within group (order by QUANTITYORDERED) as pct_25,
percentile_cont(0.75) within group (order by QUANTITYORDERED) as pct_75,
percentile_cont(0.75) within group (order by QUANTITYORDERED)-
percentile_cont(0.25) within group (order by QUANTITYORDERED) as IQR
from sales_dataset_rfm_prj) as tbl1)

SELECT * FROM sales_dataset_rfm_prj
where QUANTITYORDERED<(select min_value from tbl2)
or QUANTITYORDERED>(select max_value from tbl2)

--Cách 2: zscore
with tbl1 as
(select *,
(select avg(QUANTITYORDERED) from sales_dataset_rfm_prj) as avg,
(select stddev(QUANTITYORDERED) from sales_dataset_rfm_prj) as stddev
from sales_dataset_rfm_prj)

select *,
(QUANTITYORDERED-avg)/stddev as z_score
from tbl1
where abs((QUANTITYORDERED-avg)/stddev)>3

