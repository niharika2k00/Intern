
//  Benchmark
benchmark "day_2_sub_2" {
  title = "Some controls of S3 Bucket"  
  children = [
    control.s3_bucket_versioning,
    control.s3_bucket_istagged,
  ]
}

//  Controls
control "s3_bucket_istagged" {
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

control "s3_bucket_versioning" {
  title       = "S3 bucket versioning enabled"
  description = "Amazon Simple Storage Service (Amazon S3) bucket versioning helps keep multiple variants of an object in the same Amazon S3 bucket."
  everity     = "low"
  sql         = query.s3_bucket_versioning_enabled.sql
}

