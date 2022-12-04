import scala.io.Source

def getInput(filePath: String): List[String] = {
  val source = Source.fromFile(filePath)
  val input = source.getLines().toList
  source.close()

  input
}

def gridToMap(input: List[List[Int]]): Map[(Int, Int), Int] = {
  val indexed = for {
    y <- (0 until input.length)
    x <- (0 until input(0).length)
  } yield {
    (x, y) -> input(y)(x)
  }

  indexed.toMap
}
