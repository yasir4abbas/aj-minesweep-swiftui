//
//  StoryGameView.swift
//  minesweep
//
//  Created by yasir abbas on 09/07/2025.
//

import SwiftUI
import SwiftData
import UIKit

struct StoryGameView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var gameUseCase: GameUseCase
    @StateObject private var flagMode = FlagMode()
    @State private var showingGameHistory = false
    @State private var showingGameOverAlert = false
    
    let storyLevel: StoryLevel?
    
    init(modelContext: ModelContext, storyLevel: StoryLevel? = nil) {
        self.storyLevel = storyLevel
        let repository = GameRepository(modelContext: modelContext)
        let difficulty = storyLevel?.difficulty ?? .beginner
        self._gameUseCase = StateObject(wrappedValue: GameUseCase(repository: repository, difficulty: difficulty))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    // Story mode header
                    if let storyLevel = storyLevel {
                        HStack {
                            Text("📖 \(storyLevel.title)")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                    
                    GameHeaderView(gameUseCase: gameUseCase)
                    
                    ZoomableScrollView(gameUseCase: gameUseCase, minZoomScale: 0.5, maxZoomScale: 3.0) {
                        GameBoardView(gameUseCase: gameUseCase, flagMode: flagMode)
                    }
                    
                    // Game controls
                    HStack(spacing: 20) {
                        Button(action: {
                            // Dismiss this view to go back to start screen
                            dismiss()
                        }) {
                            Image(systemName: "house")
                                .font(.title2)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray.opacity(0.05))
                                .cornerRadius(12)
                        }
                        
                        Button(action: {
                            flagMode.isFlagMode.toggle()
                        }) {
                            VStack {
                                Image(systemName: flagMode.isFlagMode ? "flag.fill" : "flag")
                                    .font(.title2)
                                    .foregroundColor(flagMode.isFlagMode ? .orange : .blue)
                                Text(flagMode.isFlagMode ? "Flag Mode" : "Reveal Mode")
                                    .font(.caption)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(flagMode.isFlagMode ? Color.orange.opacity(0.2) : Color.blue.opacity(0.1))
                            .cornerRadius(12)
                        }
                        
                        Button(action: {
                            showingGameHistory = true
                        }) {
                            VStack {
                                Image(systemName: "chart.bar")
                                    .font(.title2)
                                Text("History")
                                    .font(.caption)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .hidden()
                        }
                    }
                    .padding()
                }
            }
            .sheet(isPresented: $showingGameHistory) {
                GameHistoryView(
                    gameUseCase: gameUseCase,
                    isPresented: $showingGameHistory
                )
            }
            .alert("Game Over", isPresented: $showingGameOverAlert) {
                Button("Back to Menu") {
                    dismiss()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text(gameOverMessage)
            }
            .onReceive(gameUseCase.$gameEngine) { engine in
                if engine.gameState == .won || engine.gameState == .lost {
                    showingGameOverAlert = true
                }
            }
        }
        .onAppear {
            if gameUseCase.currentSession == nil {
                let difficulty = storyLevel?.difficulty ?? .beginner
                gameUseCase.startNewGame(difficulty: difficulty)
            }
        }
    }
    
    private var gameOverMessage: String {
        switch gameUseCase.gameEngine.gameState {
        case .won:
            return "Congratulations! You won in \(formattedTime) with \(gameUseCase.moveCount) moves!"
        case .lost:
            return "Game Over! You hit a mine. Try again!"
        case .playing:
            return ""
        }
    }
    
    private var formattedTime: String {
        let minutes = Int(gameUseCase.elapsedTime) / 60
        let seconds = Int(gameUseCase.elapsedTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    StoryGameView(modelContext: try! ModelContainer(for: GameSession.self).mainContext)
} 
