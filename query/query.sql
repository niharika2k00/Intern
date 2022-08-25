
  select 
   name,
   jsonb_pretty(tags)
  from
    aws_s3_bucket
  where 
    tags is not null and tags ->> 'cost_center'='kolkata';
