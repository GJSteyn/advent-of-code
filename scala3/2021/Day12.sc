import $file.Util

type Nodes = Map[String, List[String]]

def removeNodeFromNodes(nodes: Nodes, nodeName: String): Nodes = {
  nodes.map(node => (node._1, node._2.filterNot(_ == nodeName))).toMap
}

// Remove lowercase nodes that appear on a path.
def removeUsedNodes(nodes: Nodes, path: List[String]): Nodes = {
  path.foldLeft(nodes)((acc, curr) => {
    if (curr.toLowerCase == curr) {
      removeNodeFromNodes(acc, curr)
    } else {
      acc
    }
  })
}

def removeUsedNodesWithException(nodes: Nodes, path: List[String], exception: Option[String]): Nodes = {
  path.foldLeft(nodes)((acc, curr) => {
    if (exception.contains(curr)) {
      acc
    } else if (curr.toLowerCase == curr) {
      removeNodeFromNodes(acc, curr)
    } else {
      acc
    }
  })
}

def nextStepsOnPath(nodes: Nodes, path: List[String]): List[List[String]] = {
  val currentNodeName = path.last
  // Don't continue on the path if we've reached the end.
  if (currentNodeName == "end") {
    List(path)
  } else {
    val currentNodeEdges = nodes(currentNodeName)
    // If the current node has nowhere to go, just return the current path.
    if (currentNodeEdges.length == 0) {
      List(path)
    } else {
      // For each attached node, create a new path with the current one as the start.
      currentNodeEdges.map(edge => {
        path :+ edge
      })
    }
  }
}

def part1(nodes: Nodes): Int = {
  var shouldContinue = true
  var currentPaths: List[List[String]] = List(List("start"))

  while (shouldContinue) {
    val nextPaths = currentPaths.flatMap(path => {
      val availableNodesForPath = removeUsedNodes(nodes, path)
      val nextSteps = nextStepsOnPath(availableNodesForPath, path)
      nextSteps
    })

    val havePathsChanged = nextPaths.map(currentPaths.contains(_)).contains(false)
    if (!havePathsChanged) {
      shouldContinue = false
    } else {
      currentPaths = nextPaths
    }
  }

  currentPaths.filter(_.last == "end").length
}

def findAllPathsWithException(nodes: Nodes, exception: String) = {
  var shouldContinue = true
  var currentPaths: List[List[String]] = List(List("start"))

  while (shouldContinue) {
    val nextPaths = currentPaths.flatMap(path => {
      val timesVisitedException = path.count(_ == exception)
      val maybeException = if (timesVisitedException == 2) None else Some(exception)
      val availableNodesForPath = removeUsedNodesWithException(nodes, path, maybeException)
      val nextSteps = nextStepsOnPath(availableNodesForPath, path)
      nextSteps
    })

    val havePathsChanged = nextPaths != currentPaths
    if (!havePathsChanged) {
      shouldContinue = false
    } else {
      currentPaths = nextPaths
    }
  }

  currentPaths.filter(_.last == "end")
}

def part2(nodes: Nodes) = {
  val lowercaseEdges = nodes.flatMap(_._2).filter(edge => edge.toLowerCase == edge).to(Set).toList.filterNot(edge => edge == "start" || edge == "end")

  val allPaths = lowercaseEdges.flatMap(edge => {
    findAllPathsWithException(nodes, edge)
  })

  allPaths.to(Set).size
}

@main def main() = {
  val input = Util.getInput("../../puzzle_input/2021/day12.txt")

  val split = input.map(_.split('-').toList)
  val edges = split.map {
    case first::second::Nil => (first, second)
  }
  val nodeNames = (split.map(_(0)) ++ split.map(_(1))).to(Set)
  val nodes = nodeNames.map(nodeName => {
    val edgesForNode = edges.map(edge => {
      if (edge._1 == nodeName) {
        Some(edge._2)
      } else if (edge._2 == nodeName) {
        Some(edge._1)
      } else {
        None
      }
    }).flatten
    (nodeName, edgesForNode)
  }).toMap

  // part1(nodes)
  part2(nodes)
}
