open System
open Library

let testInput = """1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet"""

let testInput2 = """two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen"""

let extractNumericChars (input: string) =
    input
    |> Seq.filter Char.IsDigit
    |> Seq.toArray

let concatFirstLast (input: char[]) =
    [|input[0]; input[input.Length - 1]|] |> String |> int

let numberWords = [|("one", "1"); ("two", "2"); ("three", "3"); ("four", "4"); ("five", "5"); ("six", "6"); ("seven", "7"); ("eight", "8"); ("nine", "9")|]

let replaceWordsWithNumbers (input: string) =
    let mutable result = input
    for (x1, x2) in numberWords do
        // Cheat a little bit by leaving the first and last characters intact.
        let replacement = String.concat "" [string x1[0]; x2; string x1[x1.Length - 1]]
        result <- result.Replace(x1, replacement)
    result

let solution (input: list<string>) =
    input
    |> List.map (fun x -> extractNumericChars x)
    |> List.map concatFirstLast
    |> List.sum

let solution2 (input: list<string>) =
    input
    |> List.map replaceWordsWithNumbers
    |> List.map (fun x -> extractNumericChars x)
    |> List.map concatFirstLast
    |> List.sum

[<EntryPoint>]
let main args =
    // let input = testInputToList testInput
    let input = readPuzzleList("day01")
    let result = solution input
    printfn $"{result}"

    // let input2 = testInputToList testInput2
    let input2 = readPuzzleList("day01")
    let result2 = solution2 input2
    printfn $"{result2}"

    0
