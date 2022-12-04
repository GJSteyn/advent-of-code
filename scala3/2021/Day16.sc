import $file.Util
import java.math.BigInteger

def part1(hexString: String) = {
  val binaryString = hexToBinaryString(hexString)

  println(s"binary string: $binaryString")

  val ((packetVersion, packetTypeID), remainingString) = getHeader(binaryString)
  println(s"packet version: $packetVersion")
  println(s"packet type ID: $packetTypeID")
  println(s"remaining string: $remainingString")
}

@main def main() = {
  val input = Util.getInput("../../puzzle_input/2021/day16.txt")

  part1(input(0))
}

def hexToBinaryString(hex: String): String = {
  val hexToBinaryMap = Map(
    '0' -> "0000",
    '1' -> "0001",
    '2' -> "0010",
    '3' -> "0011",
    '4' -> "0100",
    '5' -> "0101",
    '6' -> "0110",
    '7' -> "0111",
    '8' -> "1000",
    '9' -> "1001",
    'A' -> "1010",
    'B' -> "1011",
    'C' -> "1100",
    'D' -> "1101",
    'E' -> "1110",
    'F' -> "1111"
  )

  hex.map(hexToBinaryMap(_)).mkString
}

def binToInt(binaryString: String): Int = Integer.parseInt(binaryString, 2)

// Gets the packet version and packet type ID from a binary string,
// and returns them along with the remaining string.
def getHeader(binaryString: String): ((Int, Int), String) = {
  val header = binaryString.take(6)
  val packetVersion = binToInt(header.take(3))
  val packetTypeID = binToInt(header.drop(3))
  val remainingString = binaryString.drop(6)
  ((packetVersion, packetTypeID), remainingString)
}

@main def test() = {
  val input = "38006F45291200"

  val input2 = "EE00D40C823060"

  val input3 = "8A004A801A8002F478"             // Total sum of version numbers should be 16
  part1(input3)

  val input4 = "620080001611562C8802118E34"     // Total sum of version numbers should be 12

  val input5 = "C0015000016115A2E0802F182340"   // Total sum of version numbers should be 23

  val input6 = "A0016C880162017C3686B18A3D4780" // Total sum of version numbers should be 31
}
