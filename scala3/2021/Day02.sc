import $file.Util

case class Command(val direction: String, quantity: Int)
object Command {
  def fromString(str: String) = {
    val split = str.split(" ")
    Command(split(0), split(1).toInt)
  }
}

case class Position(val horizontal: Int, val depth: Int) {
  def changePosition(command: Command) = {
    command.direction match {
      case "up" => Position(this.horizontal, this.depth - command.quantity)
      case "down" => Position(this.horizontal, this.depth + command.quantity)
      case "forward" => Position(this.horizontal + command.quantity, this.depth)
    }
  }
}

case class PositionWithAim(val horizontal: Int, val depth: Int, val aim: Int) {
  def takeCommand(command: Command) = {
    command.direction match {
      case "up" => PositionWithAim(this.horizontal, this.depth, this.aim - command.quantity)
      case "down" => PositionWithAim(this.horizontal, this.depth, this.aim + command.quantity)
      case "forward" => PositionWithAim(this.horizontal + command.quantity, this.depth + this.aim * command.quantity, this.aim)
    }
  }
}

def part1(input: List[Command]): Int = {
  val finalPosition = input.foldLeft(Position(0, 0))((acc, curr) => acc.changePosition(curr))
  finalPosition.horizontal * finalPosition.depth
}

def part2(input: List[Command]): Int = {
  val finalPosition = input.foldLeft(PositionWithAim(0, 0, 0))((acc, curr) => acc.takeCommand(curr))
  finalPosition.horizontal * finalPosition.depth
}

@main def main() = {
  val input = Util.getInput("../../puzzle_input/2021/day02.txt").map(Command.fromString)
  println(part1(input))
  println(part2(input))
}
