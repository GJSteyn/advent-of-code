module Library
open NUnit.Framework

let readLines filePath = System.IO.File.ReadLines(filePath);;

let readPuzzleList inputName =
    // TODO: Find a better way to consistently get the puzzle input path.
    let puzzleDir = $"{NUnit.Framework.TestContext.CurrentContext.TestDirectory}/../../../../../../../puzzle_input/2023/"
    let fullPath = System.IO.Path.GetFullPath puzzleDir
    let puzzleFile = System.IO.Path.GetFullPath $"{fullPath}{inputName}.txt"
    let lines = readLines puzzleFile
    lines |> Seq.toList

let testInputToList (input: string) =
    input.Split('\n') |> Array.toList
