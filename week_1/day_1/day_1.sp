
/* 
ARN  ->  Amazon Resource Name (ARN) parameter

Queries ->    steampipe dashboard
              steampipe check all --dry-run
              steampipe check all

              steampipe check benchmark.[name]  --dry-run
              steampipe check benchmark.combine

              steampipe check control.[name]
              steampipe query *.sql                                     [run inside query file]
              steampipe check control.lambda --output json              [to check all the output formats just do   .output]

              steampipe check all --where "severity in ('low', 'high')" --dry-run


  The MOD contains BENCHMARK    =>    BENCHMARK contains CONTROLS   =>    CONTROLS contains QUERIES.

*/

//  Global Variables
variable "place" {
  description = "name of the place"
  type        = string
  default     = "kolkata" 
}

//  Benchmark
benchmark "combine" {
  title = "Turbot Training"  
  children = [
    control.cost_center,
    control.lambda,
    control.s3_bucket,
    control.s3_bucket_versioning_enabled
  ]
}

//  Contols
control "s3_bucket" {
  title       = "S3 Untagged"
  description = "This control checks whether bucket is tagged or not."
  severity    = "high"

  sql = <<-EOT
    select
      arn as resource,
      case
        when tags is not null then 'ok'
        else 'alarm'
      end as status,
      case
        when tags is not null then name || 'has tags.'
        else name || 'has no tags.'
      end as reason,
      region,
      account_id
    from
      aws_s3_bucket
  EOT
} 

control "lambda" {
  title = "Lambda Untagged"
  description = "High IOPS PL1, PL2 and PL3 disks are costly and their usage should be reviewed."
  severity    = "low"
  sql = <<EOT
    select
      arn as resource,
      case
        when tags is not null then 'ok'
        else 'alarm'
      end as status,
      case
        when tags is not null then name || 'has tags.'
        else name || 'has no tags.'
      end as reason,
      region,
      account_id
    from
      aws_lambda_function
    order by reason
  EOT
}

// > select name,jsonb_pretty(tags) from aws_s3_bucket where tags is not null and tags ->> 'cost_center'='kolkata' ;
control "cost_center" {
  title       = "Cost Center Untagged"
  description = "This control print the names,tags of the resouce from S3 Bucket whose cost center is kolkata."
  severity    = "low"

  sql = <<-EOT
    select    
    -- Requirement Dimensions      
      arn as resource,
      case
        when tags is not null and tags ->> 'cost_center'='kolkata' then 'ok'
        else 'alarm'
      end as status,
      case 
        when tags is not null and tags ->> 'cost_center'='kolkata' then name 
        else 'resource with no tag'
      end as reason,
    -- Additional Dimensions
      name,
      jsonb_pretty(tags)
    from
      aws_s3_bucket
  EOT
}

control "cost_center_modified" {
  title       = "Cost Center Untagged"
  description = "This control print the names,tags of the resouce from S3 Bucket whose cost center is kolkata."
  severity    = "low"

  sql = <<-EOT
    select
    -- Requirement Dimensions
      arn as resource,
      case
        when tags is null then 'alarm'
        when tags ->> 'cost_center' = $1 then 'ok'
        else 'info'
      end as status,
      case
        when tags is null then name || ' have no tags'
        when tags ->> 'cost_center' = $1 then name || ' haveing cost center as ' || (tags ->> 'cost_center') || '.'
        else 'cost enter is not kolkata'
      end as reason,
       -- Additional Dimensions
      account_id,
      region
    from
      aws_s3_bucket;
  EOT

 //  passing variables in params
  param "place" {
    default = "kolkata"
  }

 //  passing variables in args
  # args = [var.place]
}

control "dummy" {
  title       = "Cost Center Untagged"
  description = "This control print the names,tags of the resouce from S3 Bucket whose cost center is kolkata."
  severity    = "low" 
  sql         = query.check.sql
  args        = [var.place]
}

// Use Case --> to validate the tags having owner as turbot ("Owner":"Turbot") and versioning enabled (TRUE)
control "validation" {
  title       = "Validation Untagged"  
  description = "This control returns the resources which have Turbot Owner and versioning enabled true."
  severity    = "low"        

  sql = <<-EOT
    select
    -- Required Column
    arn as resource,
    case
      when tags is null or not versioning_enabled then 'alarm'
      when (tags ->> 'Owner' = 'Turbot') and versioning_enabled then 'ok'
      else 'alarm'
    end as status,
    case
      when tags is null or versioning_enabled=false then name || ' either bucket having no tag or versioning disabled'
      when (tags ->> 'Owner' = 'Turbot') and versioning_enabled then name || ' having owner as ' || (tags ->> 'Owner') || ' and versioning enabled.'
      else name || ' either not having owner as turbot or versioning disabled.'
    end as reason,
    -- Additional Dimensions
    tags::jsonb->>'Owner' as owner,
    versioning_enabled,
    account_id,
    region
    from
    aws_s3_bucket
    order by status;
  EOT
} 

control "s3_bucket_versioning_enabled" {
  title       = "S3 bucket versioning should be enabled"
  description = "Amazon Simple Storage Service (Amazon S3) bucket versioning helps keep multiple variants of an object in the same "
  sql         = query.s3_bucket_versioning_enabled.sql
}

