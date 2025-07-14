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
                                    gameUseCase.revealCell(row: row, col: col)
                                }
                            }
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
