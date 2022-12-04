import $file.Util

def part1(fishMap: Map[Int, Long], daysLeft: Int = 80): Long = {
  if (daysLeft == 0) {
    fishMap.values.foldLeft(0L)(_ + _)
  } else {
    val fishMapCopy = Map(
      0 -> fishMap.getOrElse(1, 0L),
      1 -> fishMap.getOrElse(2, 0L),
      2 -> fishMap.getOrElse(3, 0L),
      3 -> fishMap.getOrElse(4, 0L),
      4 -> fishMap.getOrElse(5, 0L),
      5 -> fishMap.getOrElse(6, 0L),
      6 -> (fishMap.getOrElse(7, 0L) + fishMap.getOrElse(0, 0L)),
      7 -> fishMap.getOrElse(8, 0L),
      8 -> fishMap.getOrElse(0, 0L)
    )

    part1(fishMapCopy, daysLeft - 1)
  }
}

def part2(fishMap: Map[Int, Long], daysLeft: Int = 256): Long = {
  part1(fishMap, daysLeft)
}

@main def main() = {
  val input = Util.getInput("../../puzzle_input/2021/day06.txt")(0).split(',').map(_.toInt)

  val fishMap: Map[Int, Long] = (0 to 8).map(num => (num, input.count(_ == num).toLong)).toMap

  println(s"Part one: ${part1(fishMap)}")
  println(s"Part two: ${part2(fishMap)}")
}
