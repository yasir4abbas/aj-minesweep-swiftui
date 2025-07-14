//
//  GameEngine.swift
//  minesweep
//
//  Created by yasir abbas on 09/07/2025.
//

import Foundation
import SwiftUI

class GameEngine: ObservableObject {
    @Published var board: [[Cell]] = []
    @Published var gameState: GameState = .playing
    @Published var mineCount: Int = 0
    @Published var flaggedCount: Int = 0
    @Published var revealedCount: Int = 0
    
    private let width: Int
    private let height: Int
    private let totalMines: Int
    
    init(width: Int = 9, height: Int = 9, mines: Int = 10) {
        self.width = width
        self.height = height
        self.totalMines = mines
        self.mineCount = mines
        initializeBoard()
    }
    
    private func initializeBoard() {
        board = Array(repeating: Array(repeating: Cell(), count: width), count: height)
    }
    
    func newGame() {
        gameState = .playing
        mineCount = totalMines
        flaggedCount = 0
        revealedCount = 0
        initializeBoard()
        placeMines()
        calculateNumbers()
    }
    
    private func placeMines() {
        var minesPlaced = 0
        while minesPlaced < totalMines {
            let row = Int.random(in: 0..<height)
            let col = Int.random(in: 0..<width)
            
            if !board[row][col].isMine {
                board[row][col].isMine = true
                minesPlaced += 1
            }
        }
    }
    
    private func calculateNumbers() {
        for row in 0..<height {
            for col in 0..<width {
                if !board[row][col].isMine {
                    board[row][col].adjacentMines = countAdjacentMines(row: row, col: col)
                }
            }
        }
    }
    
    private func countAdjacentMines(row: Int, col: Int) -> Int {
        var count = 0
        for dRow in -1...1 {
            for dCol in -1...1 {
                let newRow = row + dRow
                let newCol = col + dCol
                if isValidPosition(row: newRow, col: newCol) && board[newRow][newCol].isMine {
                    count += 1
                }
            }
        }
        return count
    }
    
    private func isValidPosition(row: Int, col: Int) -> Bool {
        return row >= 0 && row < board.count && col >= 0 && col < (board.first?.count ?? 0)
    }
    
    func revealCell(row: Int, col: Int) {
        guard gameState == .playing && isValidPosition(row: row, col: col) else { return }
        
        let cell = board[row][col]
        if cell.isRevealed || cell.isFlagged { return }
        
        board[row][col].isRevealed = true
        revealedCount += 1
        
        if cell.isMine {
            gameState = .lost
            revealAllMines()
            return
        }
        
        if cell.adjacentMines == 0 {
            revealAdjacentCells(row: row, col: col)
        }
        
        checkWinCondition()
    }
    
    private func revealAdjacentCells(row: Int, col: Int) {
        for dRow in -1...1 {
            for dCol in -1...1 {
                let newRow = row + dRow
                let newCol = col + dCol
                if isValidPosition(row: newRow, col: newCol) && !board[newRow][newCol].isRevealed {
                    revealCell(row: newRow, col: newCol)
                }
            }
        }
    }
    
    func toggleFlag(row: Int, col: Int) {
        guard gameState == .playing && isValidPosition(row: row, col: col) else { return }
        
        let cell = board[row][col]
        if cell.isRevealed { return }
        
        if cell.isFlagged {
            board[row][col].isFlagged = false
            flaggedCount -= 1
            mineCount += 1
        } else {
            board[row][col].isFlagged = true
            flaggedCount += 1
            mineCount -= 1
        }
    }
    
    func chordCell(row: Int, col: Int) {
        guard gameState == .playing && isValidPosition(row: row, col: col) else { return }
        
        let cell = board[row][col]
        if !cell.isRevealed || cell.adjacentMines == 0 { return }
        let flagCount = countAdjacentFlags(row: row, col: col)
        if flagCount == cell.adjacentMines {
            chordAdjacentCells(row: row, col: col)
        }
    }
    
    private func countAdjacentFlags(row: Int, col: Int) -> Int {
        var count = 0
        for dRow in -1...1 {
            for dCol in -1...1 {
                let newRow = row + dRow
                let newCol = col + dCol
                if isValidPosition(row: newRow, col: newCol) && board[newRow][newCol].isFlagged {
                    count += 1
                }
            }
        }
        return count
    }
    
    private func chordAdjacentCells(row: Int, col: Int) {
        for dRow in -1...1 {
            for dCol in -1...1 {
                let newRow = row + dRow
                let newCol = col + dCol
                if isValidPosition(row: newRow, col: newCol) && 
                   !board[newRow][newCol].isRevealed && 
                   !board[newRow][newCol].isFlagged {
                    revealCell(row: newRow, col: newCol)
                }
            }
        }
    }
    
    private func revealAllMines() {
        for row in 0..<height {
            for col in 0..<width {
                if board[row][col].isMine {
                    board[row][col].isRevealed = true
                }
            }
        }
    }
    
    private func checkWinCondition() {
        let totalCells = width * height
        if revealedCount == totalCells - totalMines {
            gameState = .won
        }
    }
    
    func getCellDisplayText(row: Int, col: Int) -> String {
        let cell = board[row][col]
        
        if cell.isFlagged {
            return "🚩"
        }
        
        if !cell.isRevealed {
            return ""
        }
        
        if cell.isMine {
            return "💣"
        }
        
        if cell.adjacentMines == 0 {
            return ""
        }
        
        return "\(cell.adjacentMines)"
    }
    
    func getCellColor(row: Int, col: Int) -> CellColor {
        let cell = board[row][col]
        
        if cell.isFlagged {
            return .flagged
        }
        
        if !cell.isRevealed {
            return .hidden
        }
        
        if cell.isMine {
            return .mine
        }
        
        return getNumberColor(cell.adjacentMines)
    }
    
    private func getNumberColor(_ number: Int) -> CellColor {
        switch number {
        case 1: return .number1
        case 2: return .number2
        case 3: return .number3
        case 4: return .number4
        case 5: return .number5
        case 6: return .number6
        case 7: return .number7
        case 8: return .number8
        default: return .revealed
        }
    }

    func newStoryGame(mask: [[Bool]], mineCount: Int) {
        let height = mask.count
        let width = mask.first?.count ?? 0
        self.mineCount = mineCount
        self.flaggedCount = 0
        self.revealedCount = 0
        self.gameState = .playing

        board = Array(repeating: Array(repeating: Cell(), count: width), count: height)
        for row in 0..<height {
            for col in 0..<width {
                board[row][col].isActive = mask[row][col]
            }
        }
        
        placeMinesForMask(mask: mask, mineCount: mineCount)
        calculateNumbersForMask(mask: mask)
    }

    private func placeMinesForMask(mask: [[Bool]], mineCount: Int) {
        var activePositions: [(Int, Int)] = []
        for row in 0..<mask.count {
            for col in 0..<mask[row].count {
                if mask[row][col] {
                    activePositions.append((row, col))
                }
            }
        }
        activePositions.shuffle()
        for i in 0..<mineCount {
            let (row, col) = activePositions[i]
            board[row][col].isMine = true
        }
    }

    private func calculateNumbersForMask(mask: [[Bool]]) {
        for row in 0..<mask.count {
            for col in 0..<mask[row].count {
                if board[row][col].isActive && !board[row][col].isMine {
                    board[row][col].adjacentMines = countAdjacentMinesMasked(row: row, col: col)
                }
            }
        }
    }

    private func countAdjacentMinesMasked(row: Int, col: Int) -> Int {
        var count = 0
        for dRow in -1...1 {
            for dCol in -1...1 {
                let newRow = row + dRow
                let newCol = col + dCol
                if isValidPosition(row: newRow, col: newCol) && board[newRow][newCol].isActive && board[newRow][newCol].isMine {
                    count += 1
                }
            }
        }
        return count
    }

    // Override revealCell for masked boards
    func revealCellMasked(row: Int, col: Int) {
        guard gameState == .playing && isValidPosition(row: row, col: col) else { return }
        let cell = board[row][col]
        if !cell.isActive || cell.isRevealed || cell.isFlagged { return }
        board[row][col].isRevealed = true
        revealedCount += 1
        if cell.isMine {
            gameState = .lost
            revealAllMinesMasked()
            return
        }
        if cell.adjacentMines == 0 {
            revealAdjacentCellsMasked(row: row, col: col)
        }
        checkWinConditionMasked()
    }

    private func revealAdjacentCellsMasked(row: Int, col: Int) {
        for dRow in -1...1 {
            for dCol in -1...1 {
                let newRow = row + dRow
                let newCol = col + dCol
                if isValidPosition(row: newRow, col: newCol) && board[newRow][newCol].isActive && !board[newRow][newCol].isRevealed {
                    revealCellMasked(row: newRow, col: newCol)
                }
            }
        }
    }

    func toggleFlagMasked(row: Int, col: Int) {
        guard gameState == .playing && isValidPosition(row: row, col: col) else { return }
        let cell = board[row][col]
        if !cell.isActive || cell.isRevealed { return }
        if cell.isFlagged {
            board[row][col].isFlagged = false
            flaggedCount -= 1
            mineCount += 1
        } else {
            board[row][col].isFlagged = true
            flaggedCount += 1
            mineCount -= 1
        }
    }

    private func revealAllMinesMasked() {
        for row in 0..<board.count {
            for col in 0..<board[row].count {
                if board[row][col].isActive && board[row][col].isMine {
                    board[row][col].isRevealed = true
                }
            }
        }
    }

    private func checkWinConditionMasked() {
        var totalActive = 0
        var revealedActive = 0
        var totalMines = 0
        for row in 0..<board.count {
            for col in 0..<board[row].count {
                if board[row][col].isActive {
                    totalActive += 1
                    if board[row][col].isRevealed { revealedActive += 1 }
                    if board[row][col].isMine { totalMines += 1 }
                }
            }
        }
        if revealedActive == totalActive - totalMines {
            gameState = .won
        }
    }
}

enum GameState {
    case playing
    case won
    case lost
}

struct Cell {
    var isMine: Bool = false
    var isRevealed: Bool = false
    var isFlagged: Bool = false
    var adjacentMines: Int = 0
    var isActive: Bool = true // NEW for story mode masking
}

enum CellColor {
    case hidden
    case revealed
    case flagged
    case mine
    case number1
    case number2
    case number3
    case number4
    case number5
    case number6
    case number7
    case number8
    
    var backgroundColor: Color {
        switch self {
        case .hidden: return Color(hex: "E7949A")
        case .revealed: return Color(hex: "E9E1DA")
        case .flagged: return Color.orange.opacity(0.3)
        case .mine: return Color.red.opacity(0.3)
        case .number1: return Color.blue.opacity(0.1)
        case .number2: return Color.green.opacity(0.1)
        case .number3: return Color.red.opacity(0.1)
        case .number4: return Color.purple.opacity(0.1)
        case .number5: return Color.orange.opacity(0.1)
        case .number6: return Color.cyan.opacity(0.1)
        case .number7: return Color.black.opacity(0.1)
        case .number8: return Color.gray.opacity(0.1)
        }
    }
    
    var textColor: Color {
        switch self {
        case .hidden, .revealed, .flagged, .mine: return Color.black
        case .number1: return Color.blue
        case .number2: return Color.green
        case .number3: return Color.red
        case .number4: return Color.purple
        case .number5: return Color.orange
        case .number6: return Color.cyan
        case .number7: return Color.black
        case .number8: return Color.gray
        }
    }
} 
