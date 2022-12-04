import $file.Util

type DistanceFunction = (List[Int], Int) => Int

def solve(crabs: List[Int])(distanceFunction: DistanceFunction): Int = {
  val min = crabs.min
  val max = crabs.max
  
  val mappedDistances = (min to max).map(target => {
    val distances = crabs.map(distanceFunction)
    (target, crabs.map(crab => (crab - target).abs).sum)
  })
  println(mappedDistances)
  println(mappedDistances.minBy(_._2))
  5
}

def part1(crabs: List[Int]): Int = {
  val min = crabs.min
  val max = crabs.max
  
  val mappedDistances = (min to max).map(target => {
    (target, crabs.map(crab => (crab - target).abs).sum)
  })
  println(mappedDistances)
  println(mappedDistances.minBy(_._2))
  5
}

def part2(crabs: List[Int]): Int = {
  val min = crabs.min
  val max = crabs.max

  val mappedDistances: List[(Int, Int)] = (min to max).map(target => {
    val fuelToTarget = crabs.map(crab => {
      (1 to (crab - target).abs).sum
    }).sum
    (target, fuelToTarget)
  }).toList

  println(mappedDistances)
  println(mappedDistances.minBy(_._2))
  5
}

@main def main() = {
  val input = Util.getInput("../../puzzle_input/2021/day07.txt")

  val crabs: List[Int] = input(0).split(',').toList.map(_.toInt)
  // part1(crabs)
  part2(crabs)
}
