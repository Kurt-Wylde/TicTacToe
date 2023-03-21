//
//  TicTacToeGame.swift
//  TicTacToe
//
//  Created by Evgeny Koshkin on 21.03.2023.
//

import Foundation

struct TicTacToeGameState {
    var board: [[String]] = Array(repeating: Array(repeating: "", count: 3), count: 3)
    var currentPlayer: String = "X"
    var gameOver: Bool = false
    var winner: String? = nil
}

func makeMove(gameState: inout TicTacToeGameState, row: Int, column: Int) -> Bool {
    if gameState.board[row][column] == "" {
        gameState.board[row][column] = gameState.currentPlayer
        
        if checkWinner(gameState: gameState) == gameState.currentPlayer {
            gameState.gameOver = true
            gameState.winner = gameState.currentPlayer
        } else if gameState.board.joined().contains("") {
            gameState.currentPlayer = gameState.currentPlayer == "X" ? "O" : "X"
            if gameState.currentPlayer == "O" {
                let move = computerMove(gameState: &gameState)
                if let move = move {
                    _ = makeMove(gameState: &gameState, row: move.0, column: move.1)
                    mediumHaptic()
                }
            }
        } else {
            gameState.gameOver = true
        }
        
        return true
    }
    
    return false
}


func checkWinner(gameState: TicTacToeGameState) -> String? {
    // Проверка горизонталей
    for row in 0..<3 {
        if let player = gameState.board[row].first, player != "", gameState.board[row].allSatisfy({ $0 == player }) {
            return player
        }
    }

    // Проверка вертикалей
    for column in 0..<3 {
        let player = gameState.board[0][column]
        if player != "" && (0..<3).allSatisfy({ gameState.board[$0][column] == player }) {
            return player
        }
    }

    // Проверка диагоналей
    let topLeftPlayer = gameState.board[0][0]
    if topLeftPlayer != "" && (0..<3).allSatisfy({ gameState.board[$0][$0] == topLeftPlayer }) {
        return topLeftPlayer
    }

    let topRightPlayer = gameState.board[0][2]
    if topRightPlayer != "" && (0..<3).allSatisfy({ gameState.board[$0][2 - $0] == topRightPlayer }) {
        return topRightPlayer
    }

    // Проверка наличия пустых ячеек
    if gameState.board.flatMap({ $0 }).contains("") {
        return nil
    }

    // В случае ничьей
    return "Draw"
}

func resetGame(gameState: inout TicTacToeGameState) {
    gameState.board = Array(repeating: Array(repeating: "", count: 3), count: 3)
    gameState.currentPlayer = "X"
    gameState.gameOver = false
    gameState.winner = nil
    }

func computerMove(gameState: inout TicTacToeGameState) -> (Int, Int)? {
    var bestScore = Int.min
    var bestMove: (row: Int, column: Int)?

    for row in 0..<3 {
        for column in 0..<3 {
            if gameState.board[row][column] == "" {
                var newGameState = gameState
                newGameState.board[row][column] = "O"
                let score = minimax(gameState: newGameState, depth: 0, isMaximizing: false, alpha: Int.min, beta: Int.max)
                if score > bestScore {
                    bestScore = score
                    bestMove = (row, column)
                }
            }
        }
    }

    return bestMove
}


func minimax(gameState: TicTacToeGameState, depth: Int, isMaximizing: Bool, alpha: Int, beta: Int) -> Int {
    if let winner = checkWinner(gameState: gameState) {
        if winner == "X" {
            return -10 + depth
        } else if winner == "O" {
            return 10 - depth
        } else {
            return 0
        }
    }

    if isMaximizing {
        var maxEval = Int.min
        var a = alpha
        for row in 0..<3 {
            for column in 0..<3 {
                if gameState.board[row][column] == "" {
                    var newGameState = gameState
                    newGameState.board[row][column] = "O"
                    let eval = minimax(gameState: newGameState, depth: depth + 1, isMaximizing: false, alpha: a, beta: beta)
                    maxEval = max(maxEval, eval)
                    a = max(a, eval)
                    if beta <= a {
                        break
                    }
                }
            }
        }
        return maxEval
    } else {
        var minEval = Int.max
        var b = beta
        for row in 0..<3 {
            for column in 0..<3 {
                if gameState.board[row][column] == "" {
                    var newGameState = gameState
                    newGameState.board[row][column] = "X"
                    let eval = minimax(gameState: newGameState, depth: depth + 1, isMaximizing: true, alpha: alpha, beta: b)
                    minEval = min(minEval, eval)
                    b = min(b, eval)
                    if b <= alpha {
                        break
                    }
                }
            }
        }
        return minEval
    }
}
