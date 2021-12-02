import scala.io.Source

def getInput(filePath: String): List[String] = {
  val source = Source.fromFile(filePath)
  val input = source.getLines().toList
  source.close()

  input
}
