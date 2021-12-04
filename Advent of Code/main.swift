//
//  main.swift
//  No rights reserved.
//

import Foundation
import RegexHelper

func main() {
    let fileUrl = URL(fileURLWithPath: "./aoc-input")
    guard let inputString = try? String(contentsOf: fileUrl, encoding: .utf8) else { fatalError("Invalid input") }
    
    let lines = inputString.components(separatedBy: "\n")
    var boards = [[[Int]]]()

    let numbers = lines[0]
        .components(separatedBy: ",")
        .map { Int($0)! }

    var boardNum = 0
    for i in 2 ..< lines.count {
        let row = lines[i]
            .components(separatedBy: .whitespaces)
            .filter { !$0.isEmpty }
        if row.count == 5 {
            let line = row.map { Int($0)! }
            if boardNum >= boards.count {
                boards.append([line])
            } else {
                boards[boardNum].append(line)
            }
        } else {
            boardNum += 1
        }
    }

    var runningScore = [(rows: [Int], cols: [Int])]()
    for _ in 0 ..< boards.count {
        runningScore.append((rows: [0,0,0,0,0], cols: [0,0,0,0,0]))
    }

    var winningBoard: Int?
    var playedNumbers = [Int]()

outerLoop:
    for number in numbers {
        playedNumbers.append(number)
        for i in 0 ..< boards.count {
            if let position = whereOn(boards[i], number: number) {
                if runningScore[i].rows[position.row] == 4 ||
                    runningScore[i].cols[position.col] == 4 {
                    winningBoard = i
                    break outerLoop
                }
                runningScore[i].rows[position.row] += 1
                runningScore[i].cols[position.col] += 1
            }
        }
    }

    if let board = winningBoard {
        print(score(boards[board], playedNumber: playedNumbers))
    }
}

func main2() {
    let fileUrl = URL(fileURLWithPath: "./aoc-input")
    guard let inputString = try? String(contentsOf: fileUrl, encoding: .utf8) else { fatalError("Invalid input") }

    let lines = inputString.components(separatedBy: "\n")
    var boards = [[[Int]]]()

    let numbers = lines[0]
        .components(separatedBy: ",")
        .map { Int($0)! }

    var boardNum = 0
    for i in 2 ..< lines.count {
        let row = lines[i]
            .components(separatedBy: .whitespaces)
            .filter { !$0.isEmpty }
        if row.count == 5 {
            let line = row.map { Int($0)! }
            if boardNum >= boards.count {
                boards.append([line])
            } else {
                boards[boardNum].append(line)
            }
        } else {
            boardNum += 1
        }
    }

    var runningScore = [(rows: [Int], cols: [Int])]()
    for _ in 0 ..< boards.count {
        runningScore.append((rows: [0,0,0,0,0], cols: [0,0,0,0,0]))
    }

    var winningBoard: Int?
    var playedNumbers = [Int]()
    var boardsWon = [Int]()

outerLoop:
    for number in numbers {
        playedNumbers.append(number)
        for i in 0 ..< boards.count {
            if boardsWon.contains(i) {
                continue
            }
            if let position = whereOn(boards[i], number: number) {
                if runningScore[i].rows[position.row] == 4 ||
                    runningScore[i].cols[position.col] == 4 {
                    winningBoard = i
                    boardsWon.append(i)
                    if boardsWon.count == boards.count {
                        break outerLoop
                    }
                } else {
                    runningScore[i].rows[position.row] += 1
                    runningScore[i].cols[position.col] += 1
                }
            }
        }
    }

    if let board = winningBoard {
        print(score(boards[board], playedNumber: playedNumbers))
    }
}


func score(_ board: [[Int]], playedNumber: [Int]) -> Int {
    var sum = 0
    for i in 0 ..< board.count {
        for j in 0 ..< board[i].count {
            if !playedNumber.contains(board[i][j]) {
                sum += board[i][j]
            }
        }
    }
    return sum * playedNumber.last!
}

func whereOn(_ board: [[Int]], number: Int) -> (row: Int, col: Int)? {
    for i in 0 ..< board.count {
        for j in 0 ..< board[i].count {
            if board[i][j] == number { return (i, j) }
        }
    }
    return nil
}

main()
main2()
