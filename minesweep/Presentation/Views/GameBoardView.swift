//
//  GameBoardView.swift
//  minesweep
//
//  Created by yasir abbas on 09/07/2025.
//

import SwiftUI
import SwiftData

struct GameBoardView: View {
    @ObservedObject var gameUseCase: GameUseCase
    @ObservedObject var flagMode: FlagMode
    
    private let cellSize: CGFloat = 64 // 56px cell + 4px padding on each side
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<gameUseCase.gameEngine.board.count, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<gameUseCase.gameEngine.board[row].count, id: \.self) { col in
                        GameCellView(
                            row: row,
                            col: col,
                            displayText: gameUseCase.gameEngine.getCellDisplayText(row: row, col: col),
                            cellColor: gameUseCase.gameEngine.getCellColor(row: row, col: col),
                            onTap: {
                                if flagMode.isFlagMode {
                                    gameUseCase.toggleFlag(row: row, col: col)
                                } else {
                                    // Check if this is a revealed number for chording
                                    let cell = gameUseCase.gameEngine.board[row][col]
                                    if cell.isRevealed && cell.adjacentMines > 0 {
                                        // Try chording first, if it doesn't work, do normal reveal
                                        let previousState = gameUseCase.gameEngine.gameState
                                        gameUseCase.chordCell(row: row, col: col)
                                        
                                        // If chording didn't change the game state, it means no chording occurred
                                        // In that case, do nothing (since the cell is already revealed)
                                        if gameUseCase.gameEngine.gameState == previousState {
                                            // Chording didn't happen, so we don't need to do anything
                                            // The cell is already revealed
                                        }
                                    } else {
                                        gameUseCase.revealCell(row: row, col: col)
                                    }
                                }
                            },
                            onChord: nil
                        )
                    }
                }
            }
        }
        .frame(
            width: CGFloat(gameUseCase.gameEngine.board[0].count) * cellSize,
            height: CGFloat(gameUseCase.gameEngine.board.count) * cellSize
        )
//        .cornerRadius(8)
//        .padding()
    }
}

#Preview {
    GameBoardView(
        gameUseCase: GameUseCase(repository: GameRepository(modelContext: try! ModelContainer(for: GameSession.self).mainContext)),
        flagMode: FlagMode()
    )
} 
