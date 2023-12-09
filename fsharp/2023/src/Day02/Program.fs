open Library
open FParsec

let testInput = """Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"""

type Amount = Amount of int
type Colour =
    | Red
    | Green
    | Blue
type Cube = Cube of Amount * Colour
type Set = Set of list<Cube>
type Game = Game of list<Set>

let unwrapSet (Set s) = s

let parseNum = pint32 |>> Amount

let parseColour =
    stringReturn "red"   Red   <|>
    stringReturn "green" Green <|>
    stringReturn "blue"  Blue

let parseCube =
    parseNum .>> pchar ' ' .>>. parseColour |>> Cube

let parseCubes = sepBy1 parseCube (pstring ", ") |>> Set

let parseSets = sepBy1 parseCubes (pstring "; ") |>> Game

let parseGameDescription =
    pstring "Game " >>. parseNum .>> pstring ": "

let parseGame =
    parseGameDescription
    .>>. parseSets

let parseToOption parser (input: string) =
    match run parser input with
    | Success(result, _, _) -> Some result
    | Failure(_error, _, _) -> None

type ColourValues =
    { Red   : Amount
      Green : Amount
      Blue  : Amount }

let constraints = { Red = Amount 12; Green = Amount 13; Blue = Amount 14 }

let validCube (input: Cube) =
    match input with
    | Cube(amount, Red) -> amount <= constraints.Red
    | Cube(amount, Green) -> amount <= constraints.Green
    | Cube(amount, Blue) -> amount <= constraints.Blue

let validSet (input: Set) =
    match input with
    | Set(cubeList) -> List.forall validCube cubeList

let validGame (input: Game) =
    match input with
    | Game(setList) -> List.forall validSet setList

let solution (input: list<string>) =
    input
    |> List.map (parseToOption parseGame)
    |> List.choose id
    |> List.map (fun ((Amount(id), game)) -> if validGame game then id else 0)
    |> List.sum

let maxColours (sets: list<Set>) =
    let cubes = sets |> List.map unwrapSet |> List.concat
    let mutable maxRed = 0
    let mutable maxGreen = 0
    let mutable maxBlue = 0

    cubes
    |> List.iter (fun (Cube(Amount(amount), colour)) ->
        match colour with
        | Red -> maxRed <- max amount maxRed
        | Green -> maxGreen <- max amount maxGreen
        | Blue -> maxBlue <- max amount maxBlue)

    maxRed * maxGreen * maxBlue

let solution2 (input: list<string>) =
    let games =
        input
        |> List.map (parseToOption parseGame)
        |> List.choose id

    games
    |> List.map (fun ((Amount(id), Game(sets))) -> maxColours sets)
    |> List.sum

[<EntryPoint>]
let main args =
    // let input = testInputToList testInput
    let input = readPuzzleList("day02")
    let result = solution input
    printfn $"{result}"

    // let input2 = testInputToList testInput
    let input2 = readPuzzleList("day02")
    let result2 = solution2 input2
    printfn $"{result2}"

    0
