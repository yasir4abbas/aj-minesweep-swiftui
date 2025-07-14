//
//  GameRepository.swift
//  minesweep
//
//  Created by yasir abbas on 09/07/2025.
//

import Foundation
import SwiftData

class GameRepository {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func saveGameSession(_ session: GameSession) {
        modelContext.insert(session)
        try? modelContext.save()
    }
    
    func saveGameMove(_ move: GameMove) {
        modelContext.insert(move)
        try? modelContext.save()
    }
    
    func updateGameSession(_ session: GameSession) {
        try? modelContext.save()
    }
    
    func getGameSessions() -> [GameSession] {
        let descriptor = FetchDescriptor<GameSession>(sortBy: [SortDescriptor(\.timestamp, order: .reverse)])
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func getGameMoves(for sessionId: UUID) -> [GameMove] {
        let descriptor = FetchDescriptor<GameMove>(
            predicate: #Predicate<GameMove> { move in
                move.sessionId == sessionId
            },
            sortBy: [SortDescriptor(\.timestamp)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func deleteGameSession(_ session: GameSession) {
        modelContext.delete(session)
        try? modelContext.save()
    }
    
    func getBestTime(for difficulty: GameDifficulty) -> TimeInterval? {
        let width = difficulty.width
        let height = difficulty.height
        let mines = difficulty.mines
        
        var descriptor = FetchDescriptor<GameSession>(
            predicate: #Predicate<GameSession> { session in
                session.gameState == "won" && 
                session.width == width && 
                session.height == height && 
                session.totalMines == mines
            },
            sortBy: [SortDescriptor(\.duration)]
        )
        descriptor.fetchLimit = 1
        
        return try? modelContext.fetch(descriptor).first?.duration
    }
    
    func getWinCount(for difficulty: GameDifficulty) -> Int {
        let width = difficulty.width
        let height = difficulty.height
        let mines = difficulty.mines
        
        let descriptor = FetchDescriptor<GameSession>(
            predicate: #Predicate<GameSession> { session in
                session.gameState == "won" && 
                session.width == width && 
                session.height == height && 
                session.totalMines == mines
            }
        )
        return (try? modelContext.fetch(descriptor).count) ?? 0
    }
    
    func getTotalGames(for difficulty: GameDifficulty) -> Int {
        let width = difficulty.width
        let height = difficulty.height
        let mines = difficulty.mines
        
        let descriptor = FetchDescriptor<GameSession>(
            predicate: #Predicate<GameSession> { session in
                session.width == width && 
                session.height == height && 
                session.totalMines == mines
            }
        )
        return (try? modelContext.fetch(descriptor).count) ?? 0
    }
}

enum GameDifficulty: String, CaseIterable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case expert = "Expert"
    case custom = "Custom"
    
    var width: Int {
        switch self {
        case .beginner: return 9
        case .intermediate: return 16
        case .expert: return 16
        case .custom: return 9
        }
    }
    
    var height: Int {
        switch self {
        case .beginner: return 9
        case .intermediate: return 16
        case .expert: return 30
        case .custom: return 9
        }
    }
    
    var mines: Int {
        switch self {
        case .beginner: return 10
        case .intermediate: return 40
        case .expert: return 99
        case .custom: return 10
        }
    }
} 
