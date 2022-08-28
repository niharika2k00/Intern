//  Top Level Benchmark WEEK-1
benchmark "week_1" {
  title = "Week-1 training benchmark"
  description = "Combined benchmark."
  children = [
    benchmark.day_1,
    benchmark.day_2,
  ]
}