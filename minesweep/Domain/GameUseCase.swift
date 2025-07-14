//
//  GameUseCase.swift
//  minesweep
//
//  Created by yasir abbas on 09/07/2025.
//

import Foundation
import SwiftData

class GameUseCase: ObservableObject {
    @Published var gameEngine: GameEngine
    @Published var currentSession: GameSession?
    @Published var gameTimer: Timer?
    @Published var elapsedTime: TimeInterval = 0
    @Published var moveCount: Int = 0
    
    private let repository: GameRepository
    private var gameStartTime: Date?
    
    init(repository: GameRepository, difficulty: GameDifficulty = .beginner) {
        self.repository = repository
        self.gameEngine = GameEngine(
            width: difficulty.width,
            height: difficulty.height,
            mines: difficulty.mines
        )
    }
    
    func startNewGame(difficulty: GameDifficulty = .beginner) {
        // Stop current timer if running
        stopTimer()
        
        // Create new game session
        let session = GameSession(
            width: difficulty.width,
            height: difficulty.height,
            totalMines: difficulty.mines
        )
        repository.saveGameSession(session)
        currentSession = session
        
        // Initialize game engine
        gameEngine = GameEngine(
            width: difficulty.width,
            height: difficulty.height,
            mines: difficulty.mines
        )
        
        // Reset game state
        elapsedTime = 0
        moveCount = 0
        gameStartTime = Date()
        
        // Start timer
        startTimer()
        
        // Start new game
        gameEngine.newGame()
    }
    
    func revealCell(row: Int, col: Int) {
        guard let session = currentSession else { return }
        
        let previousState = gameEngine.gameState
        gameEngine.revealCell(row: row, col: col)
        
        // Record move
        let move = GameMove(sessionId: session.id, row: row, col: col, moveType: "reveal")
        
        if gameEngine.gameState == .lost {
            move.result = "lose"
            endGame(session: session, result: "lost")
        } else if gameEngine.gameState == .won {
            move.result = "win"
            endGame(session: session, result: "won")
        } else {
            move.result = "success"
        }
        
        repository.saveGameMove(move)
        moveCount += 1
    }
    
    func toggleFlag(row: Int, col: Int) {
        guard let session = currentSession else { return }
        
        gameEngine.toggleFlag(row: row, col: col)
        
        // Record move
        let move = GameMove(sessionId: session.id, row: row, col: col, moveType: "flag")
        repository.saveGameMove(move)
        moveCount += 1
    }
    
    func chordCell(row: Int, col: Int) {
        guard let session = currentSession else { return }
        
        let previousState = gameEngine.gameState
        gameEngine.chordCell(row: row, col: col)
        
        // Record move
        let move = GameMove(sessionId: session.id, row: row, col: col, moveType: "chord")
        
        if gameEngine.gameState == .lost {
            move.result = "lose"
            endGame(session: session, result: "lost")
        } else if gameEngine.gameState == .won {
            move.result = "win"
            endGame(session: session, result: "won")
        } else {
            move.result = "success"
        }
        
        repository.saveGameMove(move)
        moveCount += 1
    }
    
    private func startTimer() {
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self, let startTime = self.gameStartTime else { return }
            self.elapsedTime = Date().timeIntervalSince(startTime)
        }
    }
    
    private func stopTimer() {
        gameTimer?.invalidate()
        gameTimer = nil
    }
    
    private func endGame(session: GameSession, result: String) {
        stopTimer()
        
        session.gameState = result
        session.duration = elapsedTime
        session.moves = moveCount
        
        repository.updateGameSession(session)
    }
    
    func getGameStatistics(for difficulty: GameDifficulty) -> GameStatistics {
        let totalGames = repository.getTotalGames(for: difficulty)
        let winCount = repository.getWinCount(for: difficulty)
        let bestTime = repository.getBestTime(for: difficulty)
        
        let winRate = totalGames > 0 ? Double(winCount) / Double(totalGames) * 100 : 0
        
        return GameStatistics(
            totalGames: totalGames,
            winCount: winCount,
            winRate: winRate,
            bestTime: bestTime
        )
    }
    
    func getGameHistory() -> [GameSession] {
        return repository.getGameSessions()
    }
    
    func deleteGameSession(_ session: GameSession) {
        repository.deleteGameSession(session)
    }
}

struct GameStatistics {
    let totalGames: Int
    let winCount: Int
    let winRate: Double
    let bestTime: TimeInterval?
    
    var formattedWinRate: String {
        return String(format: "%.1f%%", winRate)
    }
    
    var formattedBestTime: String {
        guard let bestTime = bestTime else { return "N/A" }
        let minutes = Int(bestTime) / 60
        let seconds = Int(bestTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
} 