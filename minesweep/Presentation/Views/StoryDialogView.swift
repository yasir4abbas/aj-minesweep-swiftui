//
//  StoryDialogView.swift
//  minesweep
//
//  Created by yasir abbas on 09/07/2025.
//

import SwiftUI

struct StoryDialogView: View {
    let dialog: StoryDialog
    let onNext: () -> Void
    
    @State private var displayedText = ""
    @State private var isTyping = true
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 16) {
                HStack {
                    Text(dialog.character.displayName)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: dialog.character.color))
                    Spacer()
                }
                .padding(.horizontal, 20)
                
                // Dialog text
                HStack(alignment: .top, spacing: 12) {
                    Text(displayedText)
                        .font(.body)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .onAppear {
            startTyping()
        }
        .onTapGesture {
            if isTyping {
                // Skip typing animation
                displayedText = dialog.text
                isTyping = false
            } else {
                // Move to next dialog
                onNext()
            }
        }
    }
    
    private func startTyping() {
        displayedText = ""
        isTyping = true
        
        let words = dialog.text.split(separator: " ")
        var currentIndex = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if currentIndex < words.count {
                displayedText += (currentIndex == 0 ? "" : " ") + String(words[currentIndex])
                currentIndex += 1
            } else {
                timer.invalidate()
                isTyping = false
            }
        }
    }
}

#Preview {
    StoryDialogView(
        dialog: StoryDialog(
            character: .mariko,
            text: "Hey, look at this strange grid! What do you think it is?"
        ),
        onNext: {}
    )
    .background(Color.gray.opacity(0.1))
} 
