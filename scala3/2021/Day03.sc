import $file.Util

/**
 * Helper methods start
 */

def findMostCommonBit(binaryString: String): Int = {
  binaryString.groupBy(identity).mapValues(_.size).maxBy(_._2)._1.asDigit
}

def getBitsAtIndex(input: List[String], index: Int): String = {
  input.map(_(index)).mkString
}

def flipBits(binaryString: String): String = {
  binaryString.map(c => (c ^ 1).toChar)
}

def findRating(input: List[String], index: Int = 0)(ratingFunction: (String) => Int): String = {
  if (input.length == 1) {
    input(0)
  } else {
    val bitsAtIndex = getBitsAtIndex(input, index)
    val commonBit = ratingFunction(bitsAtIndex)
    val newInput = input.filter(_(index).asDigit == commonBit)
    findRating(newInput, index + 1)(ratingFunction)
  }
}

/**
 * Helper methods end
 */

def part1(input: List[String]): Int = {
  val mostCommonBits = input(0).zipWithIndex.map { case (_, index) => {
    val bitsAtIndex = getBitsAtIndex(input, index)
    findMostCommonBit(bitsAtIndex)
  }}.mkString
  val leastCommonBits = flipBits(mostCommonBits)

  Integer.parseInt(mostCommonBits, 2) * Integer.parseInt(leastCommonBits, 2)
}

def part2(input: List[String]): Int = {
  val oxygen = findRating(input)((bits) => findMostCommonBit(bits))
  val co2 = findRating(input)((bits) => findMostCommonBit(bits) ^ 1)

  Integer.parseInt(oxygen, 2) * Integer.parseInt(co2, 2)
}

@main def main() = {
  val input = Util.getInput("../../puzzle_input/2021/day03.txt")
  println(s"Part one: ${part1(input)}")
  println(s"Part two: ${part2(input)}")
}
