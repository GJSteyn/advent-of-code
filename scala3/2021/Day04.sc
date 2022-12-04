import $file.Util

case class Entry(val value: Int, val wasCalled: Boolean)
type Line = List[Entry]
case class Board(val lines: List[Line], winPosition: Int = 0, winningCall: Int = 0)

def hasWon(board: Board): Boolean = {
  val horizontalWin = board.lines.map(line => {
    line.exists((entry: Entry) => !entry.wasCalled)
  }).contains(false)
  val flippedBoard = for (y <- 0 until 5) yield (board.lines.map(_(y)))
  val verticalWin = flippedBoard.map(line => {
    line.exists((entry: Entry) => !entry.wasCalled)
  }).contains(false)
  horizontalWin || verticalWin
}

def haveAllBoardsWon(boards: List[Board]): Boolean = {
  !boards.map(board => hasWon(board)).contains(false)
}

def findWinningBoard(boards: List[Board]): Either[Option[String], Board] = {
  boards match {
    case Nil => Left(None)
    case head::tail =>
      if (hasWon(head)) {
        Right(head)
      } else {
        findWinningBoard(tail)
      }
  }
}

def updateBoards(boards: List[Board], calledNumber: Int): List[Board] = {
  var currentWinCount = boards.maxBy(_.winPosition).winPosition
  boards.map(board => {
    val updatedLines = board.lines.map(line => line.map(entry => {
      if (entry.value == calledNumber) {
        Entry(calledNumber, true)
      } else {
        entry
      }
    }))
    if (board.winPosition == 0 && hasWon(Board(updatedLines))) {
      currentWinCount += 1
      Board(updatedLines, currentWinCount, calledNumber)
    } else {
      Board(updatedLines, board.winPosition, board.winningCall)
    }
  })
}

def execute(boards: List[Board], calls: List[Int]): Either[Option[String], (Board, Int)] = {
  calls match {
    case Nil => Left(Some("No winners here"))
    case currentCall::tail =>
      val updatedBoards = updateBoards(boards, currentCall)
      findWinningBoard(updatedBoards) match {
        case Right(board) => Right((board, currentCall))
        case Left(_) => execute(updatedBoards, tail)
      }
  }
}

def getLastWinningBoard(boards: List[Board]): Board = boards.maxBy(_.winPosition)

def execute2(boards: List[Board], calls: List[Int]): Either[Option[String], Board] = {
  calls match {
    case Nil => Right(getLastWinningBoard(boards))
    case currentCall::tail =>
      val updatedBoards = updateBoards(boards, currentCall)
      if (haveAllBoardsWon(updatedBoards)) {
        Right(getLastWinningBoard(updatedBoards))
      } else {
        execute2(updatedBoards, tail)
      }
  }
}

def calculateScore(board: Board, calledNumber: Int): Int = {
  val lineTotals = board.lines.map(line => line.foldLeft(0)((acc, curr) => if (!curr.wasCalled) acc + curr.value else acc))
  lineTotals.reduce(_ + _) * calledNumber
}

def part1(boards: List[Board], calls: List[Int]): Int = {
  val winningBoard = execute(boards, calls)
  winningBoard match {
    case Left(_) => 0
    case Right((board, calledNumber)) =>
      calculateScore(board, calledNumber)
  }
}

def part2(boards: List[Board], calls: List[Int]): Int = {
  val winningBoard = execute2(boards, calls)
  winningBoard match {
    case Left(_) => 0
    case Right(board) => calculateScore(board, board.winningCall)
  }
}

@main def main() = {
  val input = Util.getInput("../../puzzle_input/2021/day04.txt")

  val calls = input(0).split(',').toList.map(_.toInt)
  val boards: List[Board] = input.drop(2).filter(_ != "").sliding(5, 5).map(board => {
    val boardLines = board.map(line => {
      line.split(" ").toList.filter(_ != "").map(number => Entry(number.toInt, false))
    })
    Board(boardLines, 0, 0)
  }).toList

  println(s"Part one: ${part1(boards, calls)}")
  println(s"Part two: ${part2(boards, calls)}")
}
