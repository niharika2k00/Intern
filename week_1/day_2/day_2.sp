
//  Top Level Benchmark
benchmark "day_2" {
  title = "Combined benchmark for multiple aws services" 
  description = "Combined benchmark" 
  children = [
    benchmark.ec2,
    benchmark.s3,
  ]
} 