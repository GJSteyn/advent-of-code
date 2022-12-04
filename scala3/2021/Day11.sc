import $file.Util
import scala.collection.mutable.Map

// Utility function for visualising the map.
def printMap(input: Map[(Int, Int), Int]): Unit = {
  for (y <- 0 until 10) {
    for (x <- 0 until 10) {
      print(input.getOrElse((x, y), 0))
    }
    println()
  }
}

val frame = List(
  (-1, -1), (0, -1), (1, -1),
  (-1,  0),          (1,  0),
  (-1,  1), (0,  1), (1,  1)
)

def getAdjacent(input: Map[(Int, Int), Int], x: Int, y: Int): List[((Int, Int), Int)] = {
  frame.map(point => {
    ((x + point._1, y + point._2), input.getOrElse((x + point._1, y + point._2), -1))
  }).filter(_._2 != -1)
}

def incrementAll(input: Map[(Int, Int), Int]): Map[(Int, Int), Int] = {
  for {
    y <- 0 until 10
    x <- 0 until 10
    value <- input.get(x, y)
  } input.update((x, y), value + 1)

  input
}

def setGiven(input: Map[(Int, Int), Int], toUpdate: List[(Int, Int)], setTo: Int): Map[(Int, Int), Int] = {
  toUpdate.foreach(point => {
    input.update((point._1, point._2), setTo)
  })

  input
}

def incrementGiven(input: Map[(Int, Int), Int], toUpdate: List[((Int, Int), Int)]): Map[(Int, Int), Int] = {
  toUpdate.foreach(point => {
    val currentInput = input.getOrElse((point._1._1, point._1._2), 0)
    if (currentInput != 0) {
      input.update((point._1._1, point._1._2), currentInput + 1)
    }
  })

  input
}

def allHaveFlashed(input: Map[(Int, Int), Int]): Boolean = {
  input.valuesIterator.sum == 0
}

def flash(input: Map[(Int, Int), Int], flashCount: Int = 0): Int = {
  val flashReady = input.filter(_._2 > 9)
  if (flashReady.size == 0) {
    flashCount
  } else {
    val newCount = flashCount + flashReady.size
    setGiven(input, flashReady.toList.map(_._1), 0)
    val adjacentToFlashReady: List[((Int, Int), Int)] = flashReady.keysIterator.map(keys => getAdjacent(input, keys._1, keys._2)).toList.flatten
    incrementGiven(input, adjacentToFlashReady)
    flash(input, newCount)
  }
}

def findAllFlashRound(input: Map[(Int, Int), Int], round: Int = 0): Int = {
  val flashReady = input.filter(_._2 > 9)
  val allFlashed = allHaveFlashed(input)
  println(s"All have flashed?: $allFlashed")
  if (flashReady.size == 0 && allHaveFlashed(input)) {
    round
  } else {
    incrementAll(input)
    setGiven(input, flashReady.toList.map(_._1), 0)
    val adjacentToFlashReady: List[((Int, Int), Int)] = flashReady.keysIterator.map(keys => getAdjacent(input, keys._1, keys._2)).toList.flatten
    incrementGiven(input, adjacentToFlashReady)
    flash(input)
    findAllFlashRound(input, round + 1)
  }
}

def part1(input: Map[(Int, Int), Int]) = {
  var flashCount = 0
  for (x <- 0 until 100) {
    incrementAll(input)
    flashCount += flash(input)
  }

  flashCount
}

def part2(input: Map[(Int, Int), Int]) = {
  val allFlashRound = findAllFlashRound(input)
  allFlashRound
}

@main def main() = {
  val input = Util.getInput("../../puzzle_input/2021/day11_test.txt").map(_.split("").map(_.toInt).toList)
  val inputMap = Util.gridToMap(input)
  val mutableMap = Map(inputMap.toSeq: _*)

  // part1(mutableMap)
  part2(mutableMap)
}
