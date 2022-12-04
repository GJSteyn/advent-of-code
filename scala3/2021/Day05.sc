import $file.Util

case class Point(x: Int, y: Int)
object Point {
  // Get Point from string formatted as "x,y".
  def fromString(str: String): Point = {
    str.split(',').toList match {
      case first::second::Nil => Point(first.toInt, second.toInt)
      case _ => throw new Exception(s"Invalid Point string: $str")
    }
  }
}

case class Line(start: Point, end: Point)
object Line {
  // Get Line from string formatted as "x1,y1 -> x2,y2".
  def fromString(str: String): Line = {
    str.split(" -> ").toList match {
      case first::second::Nil => Line(Point.fromString(first), Point.fromString(second))
      case _ => throw new Exception(s"Invalid Line string: $str")
    }
  }
}

def isHorizontal(line: Line): Boolean = line.start.y == line.end.y
def isVertical(line: Line): Boolean = line.start.x == line.end.x
def isAxial(line: Line): Boolean = isHorizontal(line) || isVertical(line)
def isDiagonal(line: Line): Boolean = !isAxial(line)

def fillPointsOnLine(line: Line, startMap: Map[Point, Int]): Map[Point, Int] = {
  val xRangeStart = line.start.x.min(line.end.x)
  val xRangeEnd = line.start.x.max(line.end.x)
  val yRangeStart = line.start.y.min(line.end.y)
  val yRangeEnd = line.start.y.max(line.end.y)

  val points = if (isDiagonal(line)) {
    val xRange = if (line.start.x <= line.end.x) (line.start.x to line.end.x).toList else (line.end.x to line.start.x).reverse.toList
    val yRange = if (line.start.y <= line.end.y) (line.start.y to line.end.y).toList else (line.end.y to line.start.y).reverse.toList
    xRange.zip(yRange).map { case (x, y) => Point(x, y) }
  } else {
    for {
      x <- xRangeStart to xRangeEnd
      y <- yRangeStart to yRangeEnd
    } yield (Point(x, y))
  }

  points.toList.foldLeft(startMap)((acc, curr) => {
    val updatedValue = acc.getOrElse(curr, 0) + 1
    acc.updated(curr, updatedValue)
  })
}

def fillLines(lines: List[Line]): Map[Point, Int] = {
  val startMap: Map[Point, Int] = Map()
  lines.foldLeft(startMap)((acc, curr) => {
    fillPointsOnLine(curr, acc)
  })
}

def part1(lines: List[Line]): Int = {
  val onlyAxialLines = lines.filter(isAxial(_))

  val filled: Map[Point, Int] = fillLines(onlyAxialLines)
  filled.values.count(_ >= 2)
}

def part2(lines: List[Line]): Int = {
  val filled: Map[Point, Int] = fillLines(lines)
  filled.values.count(_ >= 2)
}

@main def main() = {
  val input = Util.getInput("../../puzzle_input/2021/day05.txt")

  val lines = input.map(Line.fromString(_))
  println(s"Part one: ${part1(lines)}")
  println(s"Part two: ${part2(lines)}")
}
