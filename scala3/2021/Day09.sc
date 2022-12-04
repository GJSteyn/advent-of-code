import $file.Util
// import scala.collection.mutable.Map

val grid = Seq(
  (-1, -1), (0, -1), (1, -1),
  (-1,  0), (0,  0), (1,  0),
  (-1,  1), (0,  1), (1,  1)
)

val axialGrid = Seq(
  (0, -1), (-1,  0), (1,  0), (0,  1)
)

def getAdjacent(caves: Seq[Seq[Int]], x: Int, y: Int): Seq[Option[Int]] = {
  axialGrid.map(point => {
    caves.lift(y + point._2).flatMap(row => row.lift(x + point._1))
  })
}

def getLowPoints(caves: Seq[Seq[Int]]): Seq[Int] = {
  val maybeLowPoints = for {
    y <- (0 until caves.length)
    x <- (0 until caves(0).length)
  } yield {
    val pointValue = caves(y)(x)
    val adjacent = getAdjacent(caves, x, y).flatten
    if (pointValue < adjacent.min) {
      Some(pointValue)
    } else {
      None
    }
  }

  maybeLowPoints.flatten
}

def gridToMap(input: Seq[Seq[Int]], mapIn: Map[(Int, Int), Int]) = {
  val indexed = for {
    y <- (0 until input.length)
    x <- (0 until input(0).length)
  } yield {
    (x, y) -> input(y)(x)
  }

  indexed.toMap
}

def floodFill(map: Map[(Int, Int), Int], x: Int, y: Int): (Map[(Int, Int), Int], Int) = {
  // If the point we're on is neither 9 or -1, count it towards the current basin.
  // Then recursively call 'floodFill' to count nearby points, and update them to
  // -1 once they've been counted.
  // We only want to Flood Fill downwards.
  
  val maybeCurrentPoint = map.get((x, y))
  maybeCurrentPoint match {
    case None => (map, 0)
    case Some(point) if (point == 9 || point == -1) => {
      // We shouldn't count this point, return 0.
      (map, 0)
    }
    case Some(point) => {
      // This point is part of a basin, count it, mark it as counted by turning it into '-1',
      // and try the adjacent points next.
      val updatedMap = map.updated((x, y), -1)
      val (floodRightMap, floodRightCount) = floodFill(updatedMap, x + 1, y)
      val (floodLeftMap, floodLeftCount) = floodFill(floodRightMap, x - 1, y)
      val (floodDownMap, floodDownCount) = floodFill(floodLeftMap, x, y + 1)
      (floodDownMap, 1 + floodRightCount + floodLeftCount + floodDownCount)
      // 1 + floodFill(map, x - 1, y) + floodFill(map, x + 1, y) + floodFill(map, x, y + 1)
    }
  }
}

def part1(input: Seq[Seq[Int]]): Int = {
  getLowPoints(input).map(_ + 1).sum
}

def part2(input: Seq[Seq[Int]]) = {
  // Turn the grid into a map of indexes.
  var map = gridToMap(input, Map())
  var count = 0

  println(s"Map before: $map")
  for (
    y <- (0 until input.length);
    x <- (0 until input(0).length)
  ) {
    val (newMap, newCount) = floodFill(map, x, y)
    map = newMap
    count += newCount
  }

  println(s"Map after: $map")
  println(s"Count: $count")

  // println(s"Res (0, 0) -> ${res._1((0, 0))}")
  // println(s"Res: ${res._2}")
}

@main def main() = {
  val input = Util.getInput("../../puzzle_input/2021/day09_test.txt").map(_.map(_.asDigit).toSeq).toSeq

  // part1(input)
  part2(input)
}
