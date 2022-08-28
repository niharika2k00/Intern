
select
  arn as resource,
  case
    when tags is null then 'alarm'
    when tags->>'cost_center' = $1 then 'ok'
    else 'info'
  end as status,
  case
    when tags is null then name || ' have no tags'
    when tags->>'cost_center' = $1 then name || ' haveing cost center as ' || (tags ->> 'cost_center') || '.'
    else 'cost enter is not kolkata'
  end as reason,
  -- Additional Dimensions
  region,
  account_id
from
  aws_s3_bucket;