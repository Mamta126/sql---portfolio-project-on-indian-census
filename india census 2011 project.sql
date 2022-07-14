SELECT * FROM PROJECT1.data1;
SELECT * FROM PROJECT1.data2;
##number of rows into our dataset

select count(*) from project1.data1;
select count(*) from project1.data2;

## dataset for jharkhand and bihar
select * from project1.data1 where state in('jharkhand','bihar');
##population of india
select sum(population) as population from project1.data2;

##avg growth 
select avg(growth)*100 avg_growth from project1.data1;

##state avg growth
select state ,avg(growth)*100 avg_growth from project1.data1 group by state;

##avg sex ratio
select state, round(avg(sex_ratio) ,0) avg_sex_ratio from project1.data1 group by state order by avg_sex_ratio desc;

##avg literacy rate of india
select avg(literacy) avg_literacy_rate from project1.data1 ;

##avg literacy rate of state
select state, round(avg(literacy),0) avg_literacy_rate from project1.data1 group by state order by avg_literacy_rate desc;

select state, round(avg(literacy),0) avg_literacy_rate from project1.data1
 group by state having round(avg(literacy),0)>90 order by avg_literacy_rate desc;
 
 ##top 3 state showing highest growth ratio
 select state , avg(growth)*100 avg_growth from project1.data1 group by state  order by avg_growth desc limit 3;
 
 ##bottom 3 state showing lowest sex ratio
 select state,round(AVG(sex_ratio),0) avg_sex_ratio from project1.data1 group by state order by avg_sex_ratio;
 
 ## top state in literacy rate
 create table topstates
 (state varchar(255),
 topstate float
 );
 use project1;
 insert into topstates
 select state,round(avg(literacy),0) avg_literacy_rate from project1.data1
 group by state order by avg_literacy_rate desc ;
 
 select * from topstates order by topstates.topstate desc limit 3;

## BOTTOM STATE IN LITERACY
create table bottomstates
(state varchar(255),
bottomstate float
);

insert into bottomstates
select state,round(avg(literacy),0) avg_literacy_rate from project1.data1
group by state order by avg_literacy_rate asc;
select * from bottomstates order by bottomstates.bottomstate limit 3;
##  UNION OPERATOR TO COMBINE THE UPPER BOTH RESULT

SELECT* FROM(
select * from topstates order by topstates.topstate desc limit 3) a
UNION 
select * from (
select * from bottomstates order by bottomstates.bottomstate limit 3) b;

## states starting with letter a
select distinct state  from project1.data1 where lower(state) like 'a%' or lower(state) like 'b%';

##JOINING BOTH TABLE

SELECT data1.District, data1.State, data1.Sex_Ratio,data2.Population 
from project1.data1
inner join project1.data2
on data1.District = data2.District;

## find no of male and female

select d.state,sum(d.males) total_males,sum(d.females) total_females from
(select c.District,c.state,round(c.population/(c.sex_ratio+1),0) males, round((c.population*c.Sex_Ratio)/(c.Sex_Ratio+1),0) females from
(SELECT data1.District, data1.State, data1.Sex_Ratio/1000 sex_ratio,data2.Population 
from project1.data1
inner join project1.data2
on data1.District = data2.District) c)d
group by d.state;

## total literacy rate

select c.state,sum(literate_people) total_literate_pop,sum(illiterate_people) total_illiterate_pop from
(select d.district, d.state,round(d.literacy_ratio*d.population,0) literate_people,
(1-d.literacy_ratio)*d.population illiterate_people from
(SELECT data1.District, data1.State, data1.literacy/1000 literacy_ratio, data2.Population 
from project1.data1
inner join project1.data2
on data1.District = data2.District) d) c
group by c.state ;

## population in pervious census

select sum(n.pervious_census_population) pervious_census_population,sum(n.current_census_population) current_census_population from
(select a.state,sum(a.pervious_census_population) pervious_census_population,sum(a.current_census_population) current_census_population from
(select d.district, d.state,round(d.population/(1+d.growth),0) pervious_census_population,d.population current_census_population from
(SELECT data1.District, data1.State, data1.growth growth,data2.Population from project1.data1 inner join project1.data2 on data1.District = data2.District)d )a
group by a.state) n;

## population vs area

select (g.total_area/g.pervious_census_population) as pervious_census_population_vs_area, (g.total_area/g.current_census_population) as current_census_population_vs_area from
(select q.*,r.total_area from(

select '1' as keyy,m. * from
(select sum(n.pervious_census_population) pervious_census_population,sum(n.current_census_population) current_census_population from
(select a.state,sum(a.pervious_census_population) pervious_census_population,sum(a.current_census_population) current_census_population from
(select d.district, d.state,round(d.population/(1+d.growth),0) pervious_census_population,d.population current_census_population from
(SELECT data1.District, data1.State, data1.growth growth,data2.Population from project1.data1 inner join project1.data2 on data1.District = data2.District)d )a
group by a.state) n) m)q inner join(

select '1' as keyy,z.* from(
select sum(area_km2) total_area from project1.data2)z) r on q.keyy*r.keyy)g






 