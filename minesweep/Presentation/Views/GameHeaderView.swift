//
//  GameHeaderView.swift
//  minesweep
//
//  Created by yasir abbas on 09/07/2025.
//

import SwiftUI
import SwiftData

struct GameHeaderView: View {
    @ObservedObject var gameUseCase: GameUseCase
    
    var body: some View {
        VStack(spacing: 12) {
//            HStack {
//                Spacer()
//                Text(gameStatusText)
//                    .font(.title2)
//                    .fontWeight(.bold)
//                    .foregroundColor(gameStatusColor)
//                Spacer()
//            }
//            .padding(.vertical, 8)
//            .background(Color.gray.opacity(0.1))
//            .cornerRadius(8)
            
            HStack {
                HStack {
                    Text("💣")
                        .font(.title2)
                        .padding(.leading, 8)
                    Text("\(gameUseCase.gameEngine.mineCount)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.trailing, 8)
                }
                .background(Color.gray.opacity(0.1))
                .cornerRadius(24)
                .frame(maxWidth: .infinity)
                
                HStack {
                    Text("⏱️")
                        .font(.title2)
                        .padding(.leading, 8)
                    Text(formattedTime)
                        .font(.headline)
                        .fontWeight(.bold)
                        .monospacedDigit()
                        .padding(.trailing, 8)
                }
                .background(Color.gray.opacity(0.1))
                .cornerRadius(24)
                .frame(maxWidth: .infinity)
                
                HStack {
                    Text("👆")
                        .font(.title2)
                        .padding(.leading, 8)
                    Text("\(gameUseCase.moveCount)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.trailing, 8)
                }
                .background(Color.gray.opacity(0.1))
                .cornerRadius(24)
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)
        }
        .padding()
    }
    
    private var gameStatusText: String {
        switch gameUseCase.gameEngine.gameState {
        case .playing:
            return "Playing"
        case .won:
            return "🎉 You Won! 🎉"
        case .lost:
            return "💥 Game Over 💥"
        }
    }
    
    private var gameStatusColor: Color {
        switch gameUseCase.gameEngine.gameState {
        case .playing:
            return .primary
        case .won:
            return .green
        case .lost:
            return .red
        }
    }
    
    private var formattedTime: String {
        let minutes = Int(gameUseCase.elapsedTime) / 60
        let seconds = Int(gameUseCase.elapsedTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    GameHeaderView(gameUseCase: GameUseCase(repository: GameRepository(modelContext: try! ModelContainer(for: GameSession.self).mainContext)))
} 
