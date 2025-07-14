//
//  StoryDialogSequenceView.swift
//  minesweep
//
//  Created by yasir abbas on 09/07/2025.
//

import SwiftUI
import SwiftData

struct StoryDialogSequenceView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var currentDialogIndex = 0
    @State private var showingGame = false
    
    let storyLevel: StoryLevel
    
    var body: some View {
        ZStack {
            // Background gradient
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
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 10) {
                    Text(storyLevel.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(storyLevel.description)
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top, 40)
                
                Spacer()
                
                // Dialog view
                if currentDialogIndex < storyLevel.dialogs.count {
                    StoryDialogView(
                        dialog: storyLevel.dialogs[currentDialogIndex],
                        onNext: {
                            currentDialogIndex += 1
                            if currentDialogIndex >= storyLevel.dialogs.count {
                                // All dialogs finished, show game
                                showingGame = true
                            }
                        }
                    )
                }
                
                Spacer()
                
                // Progress indicator
                HStack(spacing: 8) {
                    ForEach(0..<storyLevel.dialogs.count, id: \.self) { index in
                        Circle()
                            .fill(index <= currentDialogIndex ? Color.white : Color.white.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .fullScreenCover(isPresented: $showingGame) {
            StoryGameView(modelContext: modelContext, storyLevel: storyLevel)
        }
    }
}

#Preview {
    StoryDialogSequenceView(storyLevel: StoryLevels.levels[0])
        .modelContainer(for: [GameSession.self, GameMove.self], inMemory: true)
} 