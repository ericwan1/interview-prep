-- https://platform.stratascratch.com/coding/10046-top-5-states-with-5-star-businesses?code_type=1
with agg_stats_five_stars as (
    select 
        count(business_id) as n_businesses,
        state,
        rank() over (order by count(business_id) desc) as state_rank
    from yelp_business
    where stars = 5
    group by state
    order by state_rank
)
select 
    state, 
    n_businesses
from 
    agg_stats_five_stars
where 
    state_rank <= 5

-- https://platform.stratascratch.com/coding/9632-host-popularity-rental-prices?tabname=question
with host_concat as (
    select 
        distinct concat(price, room_type, host_since, zipcode, number_of_reviews) as host_id,
        number_of_reviews, 
        price
    from airbnb_host_searches
),
host_popularity as (
    select case 
        when number_of_reviews = 0 then 'NEW'
        when number_of_reviews between 1 and 5 then 'Rising'
        when number_of_reviews between 6 and 15 then 'Trending Up'
        when number_of_reviews between 16 and 40 then 'Popular'
        when number_of_reviews > 40 then 'Hot'
    end as host_pop_rating,
    min(price) as min_price,
    avg(price) as avg_price,
    max(price) as max_price
    from host_concat
    group by host_pop_rating
)
select
    *
from
    host_popularity

-- https://platform.stratascratch.com/coding/10077-income-by-title-and-gender?tabname=question
with cte1 as (
    select 
        id, 
        employee_title, 
        sex, 
        salary, 
        bonus 
    from sf_employee
    left join 
    (select 
        worker_ref_id, 
        sum(bonus) as bonus 
    from sf_bonus 
    group by worker_ref_id) agg_bonus
    on sf_employee.id = agg_bonus.worker_ref_id
),
cte2 as (
    select 
        employee_title,
        sex,
        avg(salary + bonus) as avg_compensation
    from cte1
    group by employee_title, sex
)
select * 
from cte2
where avg_compensation is not NULL

-- https://leetcode.com/problems/trips-and-users/
with cte1 as (
    select 
        *,
        if(status like '%cancelled%', 1, 0) as cancelled_orders
    from Trips 
    where client_id in (
            select users_id 
            from Users 
            where banned = 'No'
            )
        and driver_id in (
            select users_id 
            from Users 
            where banned = 'No'
            )
        and request_at between '2013-10-01' and '2013-10-03'
)

select 
    request_at as Day, 
    round(sum(cancelled_orders) / count(*), 2) as 'Cancellation Rate'
from cte1
group by Day

-- https://leetcode.com/problems/median-employee-salary/
with cte1 as (
    select 
        *,
        row_number() over (partition by company order by salary) as rank_in_company,
        count(*) over (partition by company) as count_per_company
    from Employee
)
select 
    id,
    company,
    salary
from cte1
where
    rank_in_company between count_per_company/2 and count_per_company/2+1

-- https://leetcode.com/problems/the-number-of-seniors-and-juniors-to-join-the-company/description/
with cte1 as (
    select 
        employee_id,
        experience,
        sum(salary) over (partition by experience order by salary, employee_id asc) as sum_salary 
    from
        candidates
)
select 
    'Senior' as experience, count(*) as accepted_candidates 
from cte1 
where experience = 'Senior' and sum_salary <= 70000

union all

select 
    'Junior' as experience, count(*) as accepted_candidates 
from cte1 
where 
    experience = 'Junior' 
    and sum_salary < (select 70000 - ifnull(max(sum_salary), 0) from cte1 where experience = 'Senior' and sum_salary <= 70000)

-- https://leetcode.com/problems/human-traffic-of-stadium/
-- An elegant solution that I did not come up with, as I originally wanted to do three joins before I got stuck. 
-- The trick here is to use window functions in conjunction with count/row_number and have a subtraction between id + visit
-- The subtraction creates the visit blocks, which are then summed in the second CTE
with cte1 as (
    select  
        *, 
        id - row_number() over (order by visit_date) as date_blocks 
    from stadium
    where people > 100
),
cte2 AS (
    SELECT 
        * , 
        count(*) over (partition by date_blocks) as consecutiveDateCount 
    from cte1
)
select 
    id,
    visit_date,
    people
from cte2
where consecutiveDateCount >= 3

-- https://leetcode.com/problems/department-top-three-salaries/description/
select 
    department, 
    employee, 
    salary
    from (
        select 
            d.name as department, 
            e.name as employee, 
            e.salary, 
            dense_rank() over (partition by d.name order by e.salary desc) as drk
        from Employee e 
        join Department d on e.DepartmentId= d.Id
    ) t 
where t.drk <= 3