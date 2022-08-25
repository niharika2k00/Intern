
//  Benchmark
benchmark "ec2" {
  title = "Some controls of aws ec2 instances"  
  children = [
    control.ec2_detailed_monitoring,
    control.ec2_single_enis,
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
