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

-- 