module Library

let readLines filePath = System.IO.File.ReadLines(filePath);;

let readPuzzleList inputName =
    let lines = readLines $"../../../../puzzle_input/2023/{inputName}.txt"
    lines |> Seq.toList

let testInputToList (input: string) =
    input.Split('\n') |> Array.toList
