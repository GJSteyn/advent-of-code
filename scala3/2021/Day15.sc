import $file.Util

case class Node(risk: Long, traversed: Boolean, minimumCumulativeRisk: Long = Int.MaxValue.toLong)

def visualiseMap(map: Map[(Int, Int), Node], attributeSelector: (Node => Long)) = {
  val maxX = map.maxBy(_._1._1)._1._1
  val maxY = map.maxBy(_._1._2)._1._2

  for (y <- 0 to maxY) {
    for (x <- 0 to maxX) {
      val maybeNode = map.get((x, y))
      if (maybeNode.map(_.traversed).getOrElse(false)) {
        maybeNode match {
          case Some(node) => print(Console.BLUE + attributeSelector(map((x, y))) + " ")
          case _ => print(Console.BLUE + "0" + " ")
        }
      } else {
        maybeNode match {
          case Some(node) => print(Console.WHITE + attributeSelector(map((x, y))) + " ")
          case _ => print(Console.WHITE + "0" + " ")
        }
      }
    }
    println
  }
  println(Console.WHITE)
}

def calculateMinimumCumulativeRisk(map: Map[(Int, Int), Node]): Map[(Int, Int), Node] = {
  val maxX = map.maxBy(_._1._1)._1._1
  val maxY = map.maxBy(_._1._2)._1._2

  var workingMap = map.updated((0, 0), Node(0, false, 0))

  for (y <- 0 to maxY) {
    for (x <- 0 to maxX) {
      val currentNode = workingMap((x, y))
      val leftNode = workingMap.get((x - 1, y))
      val rightNode = workingMap.get((x + 1, y))
      val topNode = workingMap.get((x, y - 1))
      val bottomNode = workingMap.get((x, y + 1))

      val fromLeft = leftNode.map(node => node.minimumCumulativeRisk + currentNode.risk).getOrElse(Int.MaxValue.toLong)
      val fromRight = rightNode.map(node => node.minimumCumulativeRisk + currentNode.risk).getOrElse(Int.MaxValue.toLong)
      val fromTop = topNode.map(node => node.minimumCumulativeRisk + currentNode.risk).getOrElse(Int.MaxValue.toLong)
      val fromBottom = bottomNode.map(node => node.minimumCumulativeRisk + currentNode.risk).getOrElse(Int.MaxValue.toLong)
      // println(s"Left: $fromLeft; Right: $fromRight; Top: $fromTop; Bottom: $fromBottom; Current: ${currentNode.minimumCumulativeRisk}")

      val minimumCumulativeRisk = List(fromLeft, fromRight, fromTop, fromBottom, currentNode.minimumCumulativeRisk).min
      // println(s"X: $x, Y: $y")
      // println(s"MinimumCumulative: $minimumCumulativeRisk")
      // println
      if (minimumCumulativeRisk < currentNode.minimumCumulativeRisk) {
        workingMap = workingMap.updated((x, y), Node(currentNode.risk, false, minimumCumulativeRisk))
      }
    }
  }

  workingMap
}

def incrementMapValues(map: Map[(Int, Int), Node]): Map[(Int, Int), Node] = {
  val maxX = map.maxBy(_._1._1)._1._1
  val maxY = map.maxBy(_._1._2)._1._2

  val indices = for {
    y <- 0 to maxY
    x <- 0 to maxX
  } yield (x, y)

  indices.foldLeft(map)((acc, curr) => {
    val currentNode = map((curr._1, curr._2))
    val newRisk = if (currentNode.risk == 9) 1 else currentNode.risk + 1
    acc.updated((curr._1, curr._2), Node(newRisk, false, currentNode.minimumCumulativeRisk))
  })
}

def extendMapHorizontally(map: Map[(Int, Int), Node], times: Int): Map[(Int, Int), Node] = {
  val width = map.maxBy(_._1._1)._1._1 + 1

  map.foldLeft(map)((acc, curr) => {
    (1 to times).foldLeft(acc)((accInner, currTimes) => {
      val updatedRisk = (curr._2.risk + currTimes) % 9
      val newRisk = if (updatedRisk == 0) 9 else updatedRisk
      accInner.updated(((currTimes * width) + curr._1._1, curr._1._2), curr._2.copy(risk = newRisk))
    })
  })
}

def extendMapVertically(map: Map[(Int, Int), Node], times: Int): Map[(Int, Int), Node] = {
  val height = map.maxBy(_._1._2)._1._2 + 1

  map.foldLeft(map)((acc, curr) => {
    (1 to times).foldLeft(acc)((accInner, currTimes) => {
      val updatedRisk = (curr._2.risk + currTimes) % 9
      val newRisk = if (updatedRisk == 0) 9 else updatedRisk
      accInner.updated((curr._1._1, (currTimes * height) + curr._1._2), curr._2.copy(risk = newRisk))
    })
  })
}

def part1(map: Map[(Int, Int), Node]) = {
  val mapWithCumulativeRisk = calculateMinimumCumulativeRisk(map)

  val maxX = map.maxBy(_._1._1)._1._1
  val maxY = map.maxBy(_._1._2)._1._2

  // visualiseMap(mapWithCumulativeRisk, { node => node.minimumCumulativeRisk })
  mapWithCumulativeRisk((maxX, maxY))
}

def part2(map: Map[(Int, Int), Node]) = {
  val extendedMapHorizontal = extendMapHorizontally(map, 4)
  val extendedMapVertical = extendMapVertically(extendedMapHorizontal, 4)

  // visualiseMap(extendedMapVertical, { node => node.risk })
  val maxX = extendedMapVertical.maxBy(_._1._1)._1._1
  val maxY = extendedMapVertical.maxBy(_._1._2)._1._2

  val mapWithCumulativeRisk1 = calculateMinimumCumulativeRisk(extendedMapVertical)
  val mapWithCumulativeRisk2 = calculateMinimumCumulativeRisk(mapWithCumulativeRisk1)
  val mapWithCumulativeRisk3 = calculateMinimumCumulativeRisk(mapWithCumulativeRisk2)
  val mapWithCumulativeRisk4 = calculateMinimumCumulativeRisk(mapWithCumulativeRisk3)
  val mapWithCumulativeRisk = calculateMinimumCumulativeRisk(mapWithCumulativeRisk4)
  mapWithCumulativeRisk((maxX, maxY))
}

@main def main() = {
  val input = Util.getInput("../../puzzle_input/2021/day15.txt")
  val digits = input.map(_.split("").toList)
  val map = for {
    y <- 0 until digits.length
    x <- 0 until digits(0).length
  } yield ((x, y), Node(digits(y)(x).toLong, false))

  // part1(map.toMap)
  part2(map.toMap)
}

// 2874 -> too high.
// 2870 -> too high.
// 2868 -> Right!
