import $file.Util

def applyRules(template: List[String], rules: Map[String, String]): List[String] = {
  val pairs = template.sliding(2)
  pairs.foldLeft(template.take(1))((acc, curr) => {
    val rule = rules(curr.toList.mkString)
    acc :+ rule :+ curr(1)
  })
}

def applyRulesToMap(templateMap: Map[String, Long], keysCount: Map[String, Long], updateMapping: Map[String, (String, String)], rules: Map[String, String]): (Map[String, Long], Map[String, Long]) = {
  val valuesToAdd = templateMap.foldLeft(List[(String, Long)]())((acc, curr) => {
    if (curr._2 > 0) {
      val keysToUpdate = updateMapping(curr._1)
      acc :+ (keysToUpdate._1, curr._2) :+ (keysToUpdate._2, curr._2)
    } else {
      acc
    }
  })

  val keysToAdd = templateMap.foldLeft(List[(String, Long)]())((acc, curr) => {
    if (curr._2 > 0) {
      val keyToAdd = rules(curr._1)
      acc :+ (keyToAdd, curr._2)
    } else {
      acc
    }
  })

  val newKeysCount = keysToAdd.foldLeft(keysCount)((acc, curr) => acc.updated(curr._1, acc(curr._1) + curr._2))

  val valuesToSubtract = templateMap.filter(_._2 > 0)

  val added = valuesToAdd.foldLeft(templateMap)((acc, curr) => acc.updated(curr._1, acc(curr._1) + curr._2))
  val subtracted = valuesToSubtract.foldLeft(added)((acc, curr) => acc.updated(curr._1, acc(curr._1) - curr._2))
  (subtracted, newKeysCount)
}

def part1(template: List[String], rules: Map[String, String]) = {
  val result = (0 until 10).foldLeft(template)((acc, curr) => {
    applyRules(acc, rules)
  })
  val grouped = result.mkString.groupBy(_.toChar).mapValues(_.size)
  val most = grouped.maxBy(_._2)._2
  val least = grouped.minBy(_._2)._2
  most - least
}

def part2(template: List[String], rules: Map[String, String]) = {
  val templateMap = rules.keys.map((_ -> 0L)).toMap
  val initialValues = template.sliding(2).foldLeft(templateMap)((acc, curr) => {
    val key = (curr(0) + curr(1))
    acc.updated(key, acc(key) + 1)
  })
  val initialKeysCount = rules.values.toSet.map((key: String) => (key, template.count(_ == key).toLong)).toMap

  val updateMapping = rules.map(rule => {
    val value1 = rule._1.take(1) + rule._2
    val value2 = rule._2 + rule._1.drop(1)
    rule._1 -> (value1, value2)
  })

  val result = (0 until 40).foldLeft((initialValues, initialKeysCount))((acc, curr) => {
    applyRulesToMap(acc._1, acc._2, updateMapping, rules)
  })
  
  val keysCount = result._2
  println(s"Keys Count: $keysCount")
  val most = keysCount.maxBy(_._2)._2
  val least = keysCount.minBy(_._2)._2
  most - least
}

@main def main() = {
  val input = Util.getInput("../../puzzle_input/2021/day14.txt")
  val template = input(0).split("").toList
  val rules = input.drop(2).map(rule => {
    rule.split(" -> ") match {
      case Array(a, b) => (a, b)
    }
  }).toMap

  // part1(template, rules)
  part2(template, rules)
}
