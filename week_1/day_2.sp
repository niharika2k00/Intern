
//  Top Level Benchmark
benchmark "day_2" {
  title = "Turbot Training Day-2"
  description = "Combined benchmark"
  children = [
    benchmark.day_2_sub_1,
    benchmark.day_2_sub_2,
  ]
}