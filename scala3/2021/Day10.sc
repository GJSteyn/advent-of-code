import $file.Util

// Points:
val pointsMap_errors = Map(
  ')' -> 3,
  ']' -> 57,
  '}' -> 1197,
  '>' -> 25137
)

val pointsMap_incomplete = Map(
  ')' -> 1,
  ']' -> 2,
  '}' -> 3,
  '>' -> 4
)

def findIllegalCharacter(line: List[Char], index: Int = 0, stack: List[Char] = List()): Either[Char, List[Char]] = {
  line.lift(index) match {
    case Some(char) => char match {
      case '(' => findIllegalCharacter(line, index + 1, stack :+ ')')
      case '[' => findIllegalCharacter(line, index + 1, stack :+ ']')
      case '{' => findIllegalCharacter(line, index + 1, stack :+ '}')
      case '<' => findIllegalCharacter(line, index + 1, stack :+ '>')
      case ')' => {
        if (stack.last == ')') {
          findIllegalCharacter(line, index + 1, stack.dropRight(1))
        } else {
          Left(')')
        }
      }
      case ']' => {
        if (stack.last == ']') {
          findIllegalCharacter(line, index + 1, stack.dropRight(1))
        } else {
          Left(']')
        }
      }
      case '}' => {
        if (stack.last == '}') {
          findIllegalCharacter(line, index + 1, stack.dropRight(1))
        } else {
          Left('}')
        }
      }
      case '>' => {
        if (stack.last == '>') {
          findIllegalCharacter(line, index + 1, stack.dropRight(1))
        } else {
          Left('>')
        }
      }
    }
    case None => Right(stack.reverse)
  }
}

def part1(input: List[String]) = {
  val lines = input.map(_.toCharArray.toList)
  lines.map(line => findIllegalCharacter(line)).flatMap(_.left.toOption).map(pointsMap_errors(_)).sum
}

def incompleteLineToScore(line: List[Char], count: Long = 0): Long = {
  line match {
    case Nil => count
    case head::tail => {
      val newCount = (count * 5) + pointsMap_incomplete(head)
      incompleteLineToScore(line.drop(1), newCount)
    }
  }
}

def part2(input: List[String]) = {
  val lines = input.map(_.toCharArray.toList)
  val incomplete = lines.map(line => findIllegalCharacter(line)).flatMap(_.right.toOption)
  val results = incomplete.map(incomplete => incompleteLineToScore(incomplete))
  val middleIndex = (results.length - 1) / 2
  val sortedResults = results.sorted
  sortedResults(middleIndex)
}

@main def main() = {
  val input = Util.getInput("../../puzzle_input/2021/day10.txt")

  part1(input)
  part2(input)
}
