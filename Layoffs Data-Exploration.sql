
-- explore the data and find trends or patterns or anything interesting like outliers


select * 
from layoffs_staging;

select max(total_laid_off)
from layoffs_staging;






-- Looking at Percentage to see how big these layoffs were
select max(percentage_laid_off),  min(percentage_laid_off)
from layoffs_staging
where  percentage_laid_off IS NOT NULL;

-- Which companies had 1 which is basically 100 percent of they company laid off
select *
from layoffs_staging
where  percentage_laid_off = 1;
-- these are mostly startups it looks like who all went out of business during this time

-- if we order by funcs_raised_millions we can see how big some of these companies were
select *
from layoffs_staging
where  percentage_laid_off = 1
order by funds_raised_millions desc;





-- Companies with the biggest single Layoff

select company, total_laid_off
from layoffs_staging
order by 2 desc
LIMIT 5;
-- now that's just on a single day

-- Companies with the most Total Layoffs
select company, sum(total_laid_off)
from layoffs_staging
group by company
order by 2 desc
LIMIT 10;



-- by location
select location, sum(total_laid_off)
from layoffs_staging
group by location
order by 2 desc
LIMIT 10;

-- this it total in the past 3 years or in the dataset

select country, sum(total_laid_off)
from layoffs_staging
group by country
order by 2 desc;

select year(date), sum(total_laid_off)
from layoffs_staging
group by year(date)
order by 1 asc;


select industry, sum(total_laid_off)
from layoffs_staging
group by industry
order by 2 desc;


select stage, sum(total_laid_off)
from layoffs_staging
group by stage
order by 2 desc;







-- looking at layoffs but per year.

with Company_year as 
(
  select company, year(date) as years, sum(total_laid_off) as total_laid_off
  from layoffs_staging
  group by company, year(date)
)
, Company_year_Rank as (
  select company, years, total_laid_off, dense_rank() over (partition by years order by total_laid_off desc) as ranking
  from Company_year
)
select company, years, total_laid_off, ranking
from Company_year_Rank
where ranking <= 3
AND years IS NOT NULL
order by years asc, total_laid_off desc;




-- Rolling Total of Layoffs Per Month
select substring(date,1,7) as dates, sum(total_laid_off) as total_laid_off
from layoffs_staging
group by dates
order by dates asc;

-- use it in a CTE so we can query off of it
with DATE_CTE as 
(
select substring(date,1,7) as dates, sum(total_laid_off) as total_laid_off
from layoffs_staging
group by dates
order by dates asc
)
select dates, sum(total_laid_off) over (order by dates asc) as rolling_total_layoffs
from DATE_CTE
order by dates asc;



















































