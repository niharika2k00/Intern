select
  -- Required Columns
  arn as resource,
  case
    when monitoring_state='disabled' then 'ok'
    else 'skip'
  end status,
  case
    when monitoring_state='disabled' then title || ' monitoring disabled'
    else title || ' monitoring enabled'
  end reason,
  -- Additional Dimensions  
  region,
  account_id
from
  aws_ec2_instance;
