// ContentView.swift
// TicTacToe
//
// Created by Evgeny Koshkin on 20.03.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var gameState = TicTacToeGameState()
    
    var body: some View {
        VStack(spacing: 10) {
            ForEach(0..<3) { row in
                HStack {
                    ForEach(0..<3) { column in
                        Button(action: {
                            _ = makeMove(gameState: &gameState, row: row, column: column)
                            lightHaptic()
                        }) {
                            cellView(row: row, column: column)
                        }
                    }
                }
            }
            
            if gameState.gameOver {
                Text(gameState.winner != nil ? "Победитель: \(gameState.winner!)" : "Ничья!")
                    .font(.title)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.green).shadow(radius: 5))
                    .animation(.easeInOut(duration: 0.5), value: gameState.gameOver)
                
                Button(action: {
                    resetGame(gameState: &gameState)
                    heavyHaptic()
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
        let isInWinningLine = gameState.winningLine?.contains(where: { $0 == (row, column) }) ?? false
        let cellColor = isInWinningLine ? Color.yellow : Color.white

        return Text(gameState.board[row][column])
            .font(.system(size: 50))
            .frame(width: 70, height: 70)
            .background(cellColor)
            .foregroundColor(gameState.board[row][column] == "X" ? Color.blue : gameState.board[row][column] == "O" ? Color.red : Color.white)
            .cornerRadius(10)
            .shadow(color: .black, radius: 2, x: 0, y: 2)
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

