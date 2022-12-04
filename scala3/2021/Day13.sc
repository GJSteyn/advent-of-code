import $file.Util

def xReflection(dot: (Int, Int), x: Int): (Int, Int) = {
  val horizontalDistance = dot._1 - x
  (x - horizontalDistance, dot._2)
}

def yReflection(dot: (Int, Int), y: Int): (Int, Int) = {
  val verticalDistance = dot._2 - y
  (dot._1, y - verticalDistance)
}

def foldLeft(dots: List[(Int, Int)], x: Int): List[(Int, Int)] = {
  val dotsLeftOfAxis = dots.filter(_._1 < x)
  val dotsRightOfAxis = dots.filter(_._1 > x)
  val reflectedRight = dotsRightOfAxis.map(dot => xReflection(dot, x))
  dotsLeftOfAxis.concat(reflectedRight).distinct
}

def foldUp(dots: List[(Int, Int)], y: Int): List[(Int, Int)] = {
  val dotsAboveAxis = dots.filter(_._2 < y)
  val dotsBelowAxis = dots.filter(_._2 > y)
  val reflectedBelow = dotsBelowAxis.map(dot => yReflection(dot, y))
  dotsAboveAxis.concat(reflectedBelow).distinct
}

def visualisePaper(dots: List[(Int, Int)]) = {
  val maxX = dots.maxBy(_._1)._1
  val maxY = dots.maxBy(_._2)._2

  for (y <- 0 to maxY) {
    for (x <- 0 to maxX) {
      if (dots.contains((x, y))) {
        print('#')
      } else {
        print('.')
      }
    }
    println()
  }
}

def part1(dots: List[(Int, Int)], fold: (Char, Int)) = {
  if (fold._1 == 'x') {
    foldLeft(dots, fold._2).length
  } else if (fold._1 == 'y') {
    foldUp(dots, fold._2).length
  }
}

def part2(dots: List[(Int, Int)], folds: List[(Char, Int)]) = {
  val finalPaper = folds.foldLeft(dots)((acc, curr) => {
    if (curr._1 == 'x') {
      foldLeft(acc, curr._2)
    } else if (curr._1 == 'y') {
      foldUp(acc, curr._2)
    } else {
      acc
    }
  })

  visualisePaper(finalPaper)
}

@main def main() = {
  val input = Util.getInput("../../puzzle_input/2021/day13.txt")
  val split = input.splitAt(input.indexOf(""))
  val dots = split._1.map(dotString => {
    val splitDot = dotString.split(',')
    (splitDot(0).toInt, splitDot(1).toInt)
  })
  val folds = split._2.drop(1).map(foldString => {
    val splitFold = foldString.split('=')
    (splitFold(0).last, splitFold(1).toInt)
  })

  // part1(dots, folds(0))
  part2(dots, folds)
}
