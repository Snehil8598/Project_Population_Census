--dataset 1
select *
from Data1;

--dataset for jharkhand and bihar
select *
from Data1
--where [State ]='Bihar' or [State ]='Jharkhand';
where [State ] in ('Bihar','Jharkhand');

--Total population calculation
select sum(population) as population from Data2;

--Average growth grouped by states
select [State ], avg(growth)*100 as Avg_Growth_Percent from Data1
group by [State ];

--Average sex ratio grouped by states
select [State ], round(avg(Sex_Ratio),2) as Avg_Sex_Ratio from Data1
group by [State ]
order by Avg_Sex_Ratio desc;

--Average literacy rate
select [State ], ROUND(avg(Literacy),2) as Avg_Literacy from Data1
group by [State ]
order by Avg_Literacy desc; 

--Average literacy rate above a certain constraint
select [State ], ROUND(avg(Literacy),2) as Avg_Literacy from Data1
group by [State ]
having ROUND(avg(Literacy),2)>80
order by Avg_Literacy desc; 

--Using top command
select top 3 [State ], avg(growth)*100 as Avg_Growth from Data1
group by [State ]
order by Avg_Growth desc;

--Using Inner Joins
select Data1.District, Data1.[State ], Data1.Sex_Ratio, Data2.Population 
from Data1
inner join Data2
on Data1.District=Data2.District
order by Sex_Ratio;

--Number of males and females
select d.[State ],sum(d.Males) as Total_Males,sum(d.Females) as Total_Females
from
(select c.District,c.[State ],round(c.Population/(c.Sex_Ratio+1),0) as Males,round((c.Population * c.Sex_Ratio)/(c.Sex_Ratio +1),0) as Females
from
(select Data1.District, Data1.[State ], Data1.Sex_Ratio/1000 as Sex_Ratio, Data2.Population 
from Data1
inner join Data2
on Data1.District=Data2.District) as c) as d
group by d.[State ];

--population in the previous census
select e.[State ],sum(e.Current_Population) as Current_Population_Sum,sum(e.Previous_Population) as Previous_Population_Sum
from
(select d.District, d.[State ], d.Population as Current_Population,round((d.Population/(d.Growth+1)),0) as Previous_Population
from
(select Data1.District, Data1.[State ], Data1.Growth, Data2.Population 
from Data1
inner join Data2
on Data1.District=Data2.District) as d) as e
group by e.[State ];

--total population comparison from previous census
select sum(t.Current_Population_Sum) as Total_Current_Population,sum(t.Previous_Population_Sum) as Total_Previous_Population
from
(select e.[State ],sum(e.Current_Population) as Current_Population_Sum,sum(e.Previous_Population) as Previous_Population_Sum
from
(select d.District, d.[State ], d.Population as Current_Population,round((d.Population/(d.Growth+1)),0) as Previous_Population
from
(select Data1.District, Data1.[State ], Data1.Growth, Data2.Population 
from Data1
inner join Data2
on Data1.District=Data2.District) as d) as e
group by e.[State ]) as t;