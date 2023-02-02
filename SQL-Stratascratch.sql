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

-- https://leetcode.com/problems/trips-and-users/solutions/?orderBy=most_votes
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