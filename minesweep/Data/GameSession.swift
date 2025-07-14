//
//  GameSession.swift
//  minesweep
//
//  Created by yasir abbas on 09/07/2025.
//

import Foundation
import SwiftData

@Model
final class GameSession {
    var id: UUID
    var timestamp: Date
    var width: Int
    var height: Int
    var totalMines: Int
    var gameState: String
    var duration: TimeInterval
    var moves: Int
    
    init(width: Int, height: Int, totalMines: Int) {
        self.id = UUID()
        self.timestamp = Date()
        self.width = width
        self.height = height
        self.totalMines = totalMines
        self.gameState = "playing"
        self.duration = 0
        self.moves = 0
    }
}

@Model
final class GameMove {
    var id: UUID
    var sessionId: UUID
    var timestamp: Date
    var row: Int
    var col: Int
    var moveType: String // "reveal" or "flag"
    var result: String // "success", "mine", "win", "lose"
    
    init(sessionId: UUID, row: Int, col: Int, moveType: String) {
        self.id = UUID()
        self.sessionId = sessionId
        self.timestamp = Date()
        self.row = row
        self.col = col
        self.moveType = moveType
        self.result = "success"
    }
} 