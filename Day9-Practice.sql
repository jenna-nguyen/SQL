--EX1
SELECT 
sum(CASE
when device_type='laptop' then 1 else 0
end) as laptops_views,
sum(CASE
  when device_type in ('tablet','phone') then 1 else 0
  end) as mobile_views
FROM viewership;
--EX2
select
x,y,z,
case
  when x+y>z and x+z>y and y+z>x then 'Yes'
  else 'No'
end as triangle
from Triangle;
--EX3
SELECT 
round(100*sum(CASE when call_category='n/a' or call_category is null then 1 
else 0
end)/count(case_id),1) as call_percentage
FROM callers;
--EX4
Select Name From Customer
where referee_id<>2 or referee_id is null;
--or
select
name
from Customer
where case
      when referee_id=2 then 0
      else 1
      end=1;
--EX5
select
survived,
sum(case when pclass=1 then 1 end) as first_class,
sum(case when pclass=2 then 1 end) as second_class,
sum(case when pclass=3 then 1 end) as third_class
from titanic
group by survived;
