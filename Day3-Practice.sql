---EX1
Select NAME From CITY
Where POPULATION>120000
And CountryCode='USA';
---EX2
Select * From CITY
WHERE COUNTRYCODE ='JPN';
---EX3
Select CITY,STATE from STATION;
---EX4
select distinct CITY from STATION
where CITY like 'a%'
or CITY like 'e%'
or CITY like 'i%'
or CITY like 'o%'
or CITY like 'u%';
---EX5
Select distinct CITY from STATION
where CITY like '%a'
or CITY like '%e'
or CITY like '%i'
or CITY like '%o'
or CITY like '%u';
---EX6
select distinct CITY from STATION
where CITY not like 'a%'
and CITY not like 'e%'
and CITY not like 'i%'
and CITY not like 'o%'
and CITY not like 'u%';
---EX7
select name from Employee
order by name;
---EX8
select name from Employee
where salary>2000
and months<10
order by employee_id;
---EX9
select product_id from Products
where low_fats='Y' and recyclable='Y';
---EX10
Select Name From Customer
where referee_id<>2 or referee_id is null;
---EX11
select name,population,area from World
where area>=3000000
or population>=25000000;
---EX12
select distinct author_id as id from Views
where author_id = viewer_id
order by id;
---EX13
SELECT part,assembly_step FROM parts_assembly
where finish_date is null
---EX14
select * from lyft_drivers
where yearly_salary<=30000 or yearly_salary>=70000;
---EX15
select advertising_channel from uber_advertising
where year=2019
and money_spent>100000;
