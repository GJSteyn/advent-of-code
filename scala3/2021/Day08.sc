import $file.Util

def countOnLine(input: List[String]): Int = {
  input.foldLeft(0)((acc, curr) => {
    if (curr.length == 2 || curr.length == 3 || curr.length == 4 || curr.length == 7) {
      acc + 1
    } else {
      acc
    }
  })
}

def part1(input: List[String]) = {
  val parsed = input.map(line => line.split('|')(1).trim.split(' ').toList)

  parsed.map(countOnLine).foldLeft(0)(_ + _)
}

def getOne(inputs: List[String]): String = {
  inputs.filter(_.length == 2)(0)
}

def getSeven(inputs: List[String]): String = {
  inputs.filter(_.length == 3)(0)
}

def getFour(inputs: List[String]): String = {
  inputs.filter(_.length == 4)(0)
}

def getEight(inputs: List[String]): String = {
  inputs.filter(_.length == 7)(0)
}

def listContainsAnother[T](list1: List[T], list2: List[T]): Boolean = {
  !list2.map(list1.contains(_)).contains(false)
}

def deductList[T](list1: List[T], list2: List[T]): List[T] = {
  list1.filterNot(list2.contains)
}

def getNumbersFromInputs(inputs: List[String]): Map[String, Int] = {
  val one = getOne(inputs)
  val seven = getSeven(inputs)
  val four = getFour(inputs)
  val eight = getEight(inputs)

  val remaining = inputs.filter(str => str != one && str != seven && str != four && str != eight)
  val fiveSegments = remaining.filter(_.length == 5)
  val sixSegments = remaining.filter(_.length == 6)

  val splitFiveSegments = fiveSegments.map(_.split("").toList)
  val splitSixSegments = sixSegments.map(_.split("").toList)

  val three = splitFiveSegments.filter(splitNum => listContainsAnother(splitNum, seven.split("").toList))(0).mkString
  val fourMinusOne = deductList(four.split("").toList, one.split("").toList)
  val five = splitFiveSegments.filter(splitNum => listContainsAnother(splitNum, fourMinusOne))(0).mkString
  val two = fiveSegments.filter(str => str != five && str != three)(0)
  
  val nine = splitSixSegments.filter(charList => listContainsAnother(charList, three.split("").toList))(0).mkString
  val splitSixSegments2 = sixSegments.filterNot(_ == nine).map(_.split("").toList)
  val six = splitSixSegments2.filter(charList => listContainsAnother(charList, fourMinusOne))(0).mkString
  val zero = sixSegments.filter(str => str != six && str != nine)(0)

  Map(
    one -> 1,
    two -> 2,
    three -> 3,
    four -> 4,
    five -> 5,
    six -> 6,
    seven -> 7,
    eight -> 8,
    nine -> 9,
    zero -> 0
  )
}

def getOutput(digitMap: Map[String, Int], digits: List[String]): Int = {
  digitMap(digits(0)) * 1000 + digitMap(digits(1)) * 100 + digitMap(digits(2)) * 10 + digitMap(digits(3))
}

def part2(input: List[String]) = {
  val foo = input.map(line => {
    val split = line.split(" \\| ").toList
    val inputs = split(0).split(' ').toList.map(_.sorted)
    val outputs = split(1).split(' ').toList.map(_.sorted)

    val numbers = getNumbersFromInputs(inputs)
    getOutput(numbers, outputs)
  })

  foo.sum
}

@main def main() = {
  val input = Util.getInput("../../puzzle_input/2021/day08.txt")
  
  part1(input)
  part2(input)
}
