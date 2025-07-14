//
//  StoryLevelSelectionView.swift
//  minesweep
//
//  Created by yasir abbas on 09/07/2025.
//

import SwiftUI

struct StoryLevelSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var selectedLevel: StoryLevel?
    @State private var showingStory = false
    
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
                
                VStack(spacing: 30) {
                    // Header
                    VStack(spacing: 10) {
                        Text("Story Mode")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Join Mariko and her cat friend on their puzzle adventure!")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 40)
                    
                    // Levels
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(StoryLevels.levels) { level in
                                Button(action: {
                                    print("Button tapped for level: \(level.title)")
                                    self.selectedLevel = level
                                    print("selectedLevel set to: \(self.selectedLevel?.title ?? "nil")")
                                    showingStory = true
                                    print("showingStory set to: \(showingStory)")
                                }) {
                                    VStack(alignment: .leading, spacing: 12) {
                                        HStack {
                                            Text(level.title)
                                                .font(.title2)
                                                .fontWeight(.bold)
                                                .foregroundColor(.primary)
                                            
                                            Spacer()
                                            
                                            Text(level.difficulty.rawValue.capitalized)
                                                .font(.caption)
                                                .fontWeight(.semibold)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(
                                                    Capsule()
                                                        .fill(difficultyColor(for: level.difficulty))
                                                )
                                                .foregroundColor(.white)
                                        }
                                        
                                        Text(level.description)
                                            .font(.body)
                                            .foregroundColor(.secondary)
                                            .lineLimit(2)
                                        
                                        HStack {
                                            Text("\(level.dialogs.count) dialogs")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "play.circle.fill")
                                                .font(.title2)
                                                .foregroundColor(.blue)
                                        }
                                    }
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color(.systemBackground))
                                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer()
                    
                    // Back button
                    Button(action: {
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "arrow.left")
                                .font(.title2)
                            Text("Back to Menu")
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.2))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, 40)
                    .padding(.bottom, 30)
                }
            }
        }
        .fullScreenCover(isPresented: $showingStory) {
            if let level = self.selectedLevel {
//                print("Presenting StoryGameView for level: \(level.title)")
                StoryGameView(modelContext: modelContext, storyLevel: level)
//                StoryDialogSequenceView(storyLevel: level)
            } else {
//                print("selectedLevel is nil in sheet!")
            }
        }
        .onChange(of: showingStory) { newValue in
            print("showingStory changed to: \(newValue)")
        }
    }
    
    private func difficultyColor(for difficulty: GameDifficulty) -> Color {
        switch difficulty {
        case .beginner:
            return .green
        case .intermediate:
            return .orange
        case .expert:
            return .red
        case .custom:
            return .black
        }
    }
}

struct StoryLevelCard: View {
    let level: StoryLevel
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(level.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text(level.difficulty.rawValue.capitalized)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(difficultyColor)
                        )
                        .foregroundColor(.white)
                }
                
                Text(level.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    Text("\(level.dialogs.count) dialogs")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Image(systemName: "play.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var difficultyColor: Color {
        switch level.difficulty {
        case .beginner:
            return .green
        case .intermediate:
            return .orange
        case .expert:
            return .red
        case .custom:
            return .black
        }
    }
}

#Preview {
    StoryLevelSelectionView()
} 
