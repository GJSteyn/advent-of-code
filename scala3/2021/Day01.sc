import $file.Util

def countIncreases(input: List[Int]) = {
  input.sliding(2).map(group => {
    if (group(1) > group(0)) 1 else 0
  }).sum
}

def part1(input: List[Int]) = {
  countIncreases(input)
}

def part2(input: List[Int]) = {
  val groupedDepths = input.sliding(3).toList
  val summed = groupedDepths.map(_.sum)
  countIncreases(summed)
}

@main def main() = {
  val input = Util.getInput("../../puzzle_input/2021/day01.txt").map(_.toInt)
  println(part1(input))
  println(part2(input))
}
