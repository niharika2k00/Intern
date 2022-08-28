select
  --Required Columns
  arn as resource,
  case
    when tags is null then 'alarm'
    --["kolkata", "mumbai"]
    -- ["kolkata", "mumbai"]::text[]
    -- to_json (["kolkata", "mumbai"]::text[])
    -- json_array_elements_text (to_json (["kolkata", "mumbai"]::text[]))
    when (tags ->> 'cost_center') in (select * from json_array_elements_text(to_json($1::text[])))
      then 'ok'
    else 'info'
  end as status,
  case
    when tags is null then name || ' have no tags'
    when (tags ->> 'cost_center') in (select * from json_array_elements_text(to_json($1::text[])))
      then name || ' having cost center as ' || (tags ->> 'cost_center') || '.'
    else  name || ' not having cost center in the list ' || $1::text
  end as reason,
    -- Additional Dimensions
  region,
  account_id
from
  aws_s3_bucket;
