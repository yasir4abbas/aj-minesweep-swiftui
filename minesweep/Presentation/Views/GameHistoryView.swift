//
//  GameHistoryView.swift
//  minesweep
//
//  Created by yasir abbas on 09/07/2025.
//

import SwiftUI
import SwiftData

struct GameHistoryView: View {
    @ObservedObject var gameUseCase: GameUseCase
    @Binding var isPresented: Bool
    @State private var selectedDifficulty: GameDifficulty = .beginner
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Difficulty picker
                Picker("Difficulty", selection: $selectedDifficulty) {
                    ForEach(GameDifficulty.allCases, id: \.self) { difficulty in
                        Text(difficulty.rawValue).tag(difficulty)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                // Statistics
                StatisticsView(statistics: gameUseCase.getGameStatistics(for: selectedDifficulty))
                
                // Game history list
                List {
                    ForEach(filteredGameSessions, id: \.id) { session in
                        GameSessionRowView(session: session) {
                            gameUseCase.deleteGameSession(session)
                        }
                    }
                }
            }
            .navigationTitle("Game History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                }
            }
        }
    }
    
    private var filteredGameSessions: [GameSession] {
        return gameUseCase.getGameHistory().filter { session in
            session.width == selectedDifficulty.width &&
            session.height == selectedDifficulty.height &&
            session.totalMines == selectedDifficulty.mines
        }
    }
}

struct StatisticsView: View {
    let statistics: GameStatistics
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Statistics")
                .font(.headline)
                .fontWeight(.bold)
            
            HStack(spacing: 40) {
                VStack {
                    Text("\(statistics.totalGames)")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Total Games")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack {
                    Text("\(statistics.winCount)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    Text("Wins")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack {
                    Text(statistics.formattedWinRate)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    Text("Win Rate")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack {
                    Text(statistics.formattedBestTime)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    Text("Best Time")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct GameSessionRowView: View {
    let session: GameSession
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(session.gameState.capitalized)
                        .font(.headline)
                        .foregroundColor(session.gameState == "won" ? .green : .red)
                    
                    Spacer()
                    
                    Text(formattedDate)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Time: \(formattedDuration)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("Moves: \(session.moves)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, 4)
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: session.timestamp)
    }
    
    private var formattedDuration: String {
        let minutes = Int(session.duration) / 60
        let seconds = Int(session.duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    GameHistoryView(
        gameUseCase: GameUseCase(repository: GameRepository(modelContext: try! ModelContainer(for: GameSession.self).mainContext)),
        isPresented: .constant(true)
    )
} 
