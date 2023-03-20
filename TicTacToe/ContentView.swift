//
//  ContentView.swift
//  TicTacToe
//
//  Created by Evgeny Koshkin on 20.03.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var board: [[String]] = Array(repeating: Array(repeating: "", count: 3), count: 3)
    @State private var currentPlayer: String = "X"
    @State private var gameOver: Bool = false
    @State private var winner: String? = nil

    var body: some View {
        VStack(spacing: 10) {
            ForEach(0..<3) { row in
                HStack {
                    ForEach(0..<3) { column in
                        Button(action: {
                            makeMove(row: row, column: column)
                        }) {
                            Text(board[row][column])
                                .font(.system(size: 50))
                                .frame(width: 70, height: 70)
                                .background(Color.white)
                                .foregroundColor(board[row][column] == "X" ? Color.blue : board[row][column] == "O" ? Color.red : Color.white)
                                .cornerRadius(10)
                                .shadow(color: .black, radius: 2, x: 0, y: 2)
                        }
                    }
                }
            }
            
            if gameOver {
                Text(winner != nil ? "Победитель: \(winner!)" : "Ничья!")
                    .font(.title)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.green).shadow(radius: 5))
                    .animation(.easeInOut(duration: 0.5), value: gameOver)
                
                Button(action: {
                    resetGame()
                }) {
                    Text("Начать заново")
                        .font(.system(size: 30))
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .black, radius: 2, x: 0, y: 2)
                }
                .padding(.top, 30)
            }
        }
        .padding()
    }



    func cellView(row: Int, column: Int) -> some View {
        Text(board[row][column])
            .font(.system(size: 48))
            .frame(width: 100, height: 100)
            .background(board[row][column] == "" ? Color(.systemGray6) : Color(.systemBackground))
            .border(Color.black, width: 1)
            .foregroundColor(board[row][column] == "X" ? Color.red : Color.blue)
            .animation(.easeInOut(duration: 0.2), value: board[row][column])
    }

    func makeMove(row: Int, column: Int) {
        if board[row][column] == "" && !gameOver {
            board[row][column] = currentPlayer
            if checkWinner(board: board) == currentPlayer {
                gameOver = true
                winner = currentPlayer
            } else if board.joined().contains("") {
                currentPlayer = currentPlayer == "X" ? "O" : "X"
                if currentPlayer == "O" {
                    computerMove()
                }
            } else {
                gameOver = true
            }
        }
    }


    
    func computerMove() {
        var bestScore = Int.min
        var bestMove: (row: Int, column: Int)?

        for row in 0..<3 {
            for column in 0..<3 {
                if board[row][column] == "" {
                    var newBoard = board
                    newBoard[row][column] = "O"
                    let score = minimax(board: newBoard, depth: 0, isMaximizing: false, alpha: Int.min, beta: Int.max)
                    if score > bestScore {
                        bestScore = score
                        bestMove = (row, column)
                    }
                }
            }
        }

        if let move = bestMove {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                makeMove(row: move.row, column: move.column)
            }
        }
    }

    
    func minimax(board: [[String]], depth: Int, isMaximizing: Bool, alpha: Int, beta: Int) -> Int {
        if let winner = checkWinner(board: board) {
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
                    if board[row][column] == "" {
                        var newBoard = board
                        newBoard[row][column] = "O"
                        let eval = minimax(board: newBoard, depth: depth + 1, isMaximizing: false, alpha: a, beta: beta)
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
                    if board[row][column] == "" {
                        var newBoard = board
                        newBoard[row][column] = "X"
                        let eval = minimax(board: newBoard, depth: depth + 1, isMaximizing: true, alpha: alpha, beta: b)
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

    func checkWinner(board: [[String]]) -> String? {
        // Проверка горизонталей
        for row in 0..<3 {
            if let player = board[row].first, player != "", board[row].allSatisfy({ $0 == player }) {
                return player
            }
        }

        // Проверка вертикалей
        for column in 0..<3 {
            let player = board[0][column]
            if player != "" && (0..<3).allSatisfy({ board[$0][column] == player }) {
                return player
            }
        }

        // Проверка диагоналей
        let topLeftPlayer = board[0][0]
        if topLeftPlayer != "" && (0..<3).allSatisfy({ board[$0][$0] == topLeftPlayer }) {
            return topLeftPlayer
        }

        let topRightPlayer = board[0][2]
        if topRightPlayer != "" && (0..<3).allSatisfy({ board[$0][2 - $0] == topRightPlayer }) {
            return topRightPlayer
        }

        // Проверка наличия пустых ячеек
        if board.flatMap({ $0 }).contains("") {
            return nil
        }

        // В случае ничьей
        return "Draw"
    }




    func resetGame() {
        board = Array(repeating: Array(repeating: "", count: 3), count: 3)
        currentPlayer = "X"
        gameOver = false
        winner = nil
        }
        }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
