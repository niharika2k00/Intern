
//  Variable
variable "day" {
  description =   "time period for removal of stopped instances."
  type        =   number
  default     =   30
}

//  Benchmark
benchmark "day_2_sub_1" {
  title = "Some controls of aws ec2 instances"  
  children = [
    control.ec2_detailed_monitoring,
    control.ec2_instance_running_max_age,
    control.ec2_single_enis,
    control.ec2_stopped_instance_30_days,
  ]
}

//  Controls
control "ec2_detailed_monitoring" {
  title       = "EC2 detailed monitoring disabled"
  description = "This control will display the resouces whose monitoring is disabled."
  everity     = "low"
  sql         = query.ec2_detailed_monitoring_disabled.sql
}

control "ec2_single_enis" {
  title       = "EC2 instances use single enis"
  description = "This control will display the instances that doesn't have multiple enis."
  everity     = "low"
  sql         = query.ec2_instance_not_use_multiple_enis.sql
}

control "ec2_stopped_instance_30_days" {
  title       = "EC2 stopped instances should be removed in 30 days"
  description = "Enable this rule to help with the baseline configuration of Amazon Elastic Compute Cloud (Amazon EC2) instances by checking whether Amazon EC2 instances have been stopped for more than the allowed number of days, according to your organization's standards."
  sql         = query.ec2_stopped_instance_30_days.sql
  args        = [var.day]
}

control "ec2_instance_running_max_age" {
  title       = "Long running EC2 instances should be reviewed"
  description = "Instances should ideally be ephemeral and rehydrated frequently, check why these instances have been running for so long. Long running instances should be replaced with reserved instances, which provide a significant discount."
  sql         = query.ec2_instance_running_max_age.sql
  severity    = "high"

  param "day" {
    description = "The maximum number of days instances are allowed to run."
    default     = var.day
  }
}

