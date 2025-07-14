//
//  GameStartView.swift
//  minesweep
//
//  Created by yasir abbas on 09/07/2025.
//

import SwiftUI
import SwiftData

struct GameStartView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var showingGameHistory = false
    @State private var showingDifficultySelection = false
    @State private var showingStoryLevelSelection = false
    @State private var showingInAppPurchase = false
    @State private var navigateToGame = false
    @State private var navigateToStoryGame = false
    @State private var selectedDifficulty: GameDifficulty = .beginner
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "E9E1DA"),
                        Color(hex: "E1B551"),
                        Color(hex: "E7949A")
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    Spacer()
                    VStack(spacing: 20) {
                        Image("bomber")
                            .resizable()
                            .frame(width: 96, height: 96)
                            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                        VStack(spacing: 0) {
                            Text("Sweeper")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text("Classic Puzzle Game")
                                .font(.title3)
                                .foregroundColor(.white.opacity(0.9))
                                .fontWeight(.medium)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 20) {
                        Button(action: {
                            showingDifficultySelection = true
                        }) {
                            HStack {
                                Image(systemName: "play.fill")
                                    .font(.title2)
                                Text("Casual Game")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.white.opacity(0.2))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                    )
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                       Button(action: {
                           showingStoryLevelSelection = true
                       }) {
                           HStack {
                               Image(systemName: "play.fill")
                                   .font(.title2)
                               Text("Story Game")
                                   .font(.title2)
                                   .fontWeight(.semibold)
                           }
                           .foregroundColor(.white)
                           .frame(maxWidth: .infinity)
                           .frame(height: 60)
                           .background(
                               RoundedRectangle(cornerRadius: 15)
                                   .fill(Color.white.opacity(0.2))
                                   .overlay(
                                       RoundedRectangle(cornerRadius: 15)
                                           .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                   )
                           )
                       }
                       .buttonStyle(PlainButtonStyle())
                        
                        Button(action: {
                            showingGameHistory = true
                        }) {
                            HStack {
                                Image(systemName: "chart.bar.fill")
                                    .font(.title2)
                                Text("Casual History")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.white.opacity(0.15))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button(action: {
                            showingInAppPurchase = true
                        }) {
                            HStack {
                                Image(systemName: "heart.fill")
                                    .font(.title2)
                                Text("Support Developer")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.white.opacity(0.15))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                    }
                    .padding(.horizontal, 40)
                    
                    Spacer()
                    
                    // Footer
                    Text("Game is for the summer and free!, I plan to add a lot more to it soon. please enjoy the game.")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(20)
                }
            }
        }
        .sheet(isPresented: $showingDifficultySelection) {
            DifficultySelectionView(
                gameUseCase: GameUseCase(repository: GameRepository(modelContext: modelContext)),
                isPresented: $showingDifficultySelection,
                onGameStart: { difficulty in
                    selectedDifficulty = difficulty
                    navigateToGame = true
                }
            )
        }
        .sheet(isPresented: $showingGameHistory) {
            GameHistoryView(
                gameUseCase: GameUseCase(repository: GameRepository(modelContext: modelContext)),
                isPresented: $showingGameHistory
            )
        }
        .fullScreenCover(isPresented: $navigateToGame) {
            MinesweeperGameView(modelContext: modelContext, difficulty: selectedDifficulty)
        }
        .sheet(isPresented: $showingStoryLevelSelection) {
            StoryLevelSelectionView()
        }
        .fullScreenCover(isPresented: $navigateToStoryGame) {
            StoryGameView(modelContext: modelContext)
        }
        .sheet(isPresented: $showingInAppPurchase) {
            InAppPurchaseView()
        }
    }
}

#Preview {
    GameStartView()
        .modelContainer(for: [GameSession.self, GameMove.self], inMemory: true)
} 
