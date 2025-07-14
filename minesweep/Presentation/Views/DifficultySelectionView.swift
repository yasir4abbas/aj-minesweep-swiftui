//
//  DifficultySelectionView.swift
//  minesweep
//
//  Created by yasir abbas on 09/07/2025.
//

import SwiftUI
import SwiftData

struct DifficultySelectionView: View {
    @ObservedObject var gameUseCase: GameUseCase
    @Binding var isPresented: Bool
    var onGameStart: ((GameDifficulty) -> Void)?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Select Difficulty")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                
                VStack(spacing: 16) {
                    ForEach(GameDifficulty.allCases, id: \.self) { difficulty in
                        DifficultyCardView(
                            difficulty: difficulty,
                            statistics: gameUseCase.getGameStatistics(for: difficulty)
                        ) {
                            gameUseCase.startNewGame(difficulty: difficulty)
                            isPresented = false
                            onGameStart?(difficulty)
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
        }
    }
}

struct DifficultyCardView: View {
    let difficulty: GameDifficulty
    let statistics: GameStatistics
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(difficulty.rawValue)
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                    Text("\(difficulty.width)×\(difficulty.height)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text("\(difficulty.mines) mines")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Win Rate")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text(statistics.formattedWinRate)
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("Best Time")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text(statistics.formattedBestTime)
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    DifficultySelectionView(
        gameUseCase: GameUseCase(repository: GameRepository(modelContext: try! ModelContainer(for: GameSession.self).mainContext)),
        isPresented: .constant(true),
        onGameStart: { _ in }
    )
} 
