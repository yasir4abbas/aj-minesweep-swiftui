//
//  StoryLevel.swift
//  minesweep
//
//  Created by yasir abbas on 09/07/2025.
//

import Foundation

struct StoryLevel: Identifiable {
    let id: Int
    let title: String
    let difficulty: GameDifficulty
    let dialogs: [StoryDialog]
    let description: String
    
    init(id: Int, title: String, difficulty: GameDifficulty, description: String, dialogs: [StoryDialog]) {
        self.id = id
        self.title = title
        self.difficulty = difficulty
        self.description = description
        self.dialogs = dialogs
    }
}

struct StoryDialog: Identifiable {
    let id = UUID()
    let character: StoryCharacter
    let text: String
    let isChoice: Bool
    let choices: [String]?
    
    init(character: StoryCharacter, text: String, isChoice: Bool = false, choices: [String]? = nil) {
        self.character = character
        self.text = text
        self.isChoice = isChoice
        self.choices = choices
    }
}

enum StoryCharacter: String, CaseIterable {
    case mariko = "Mariko"
    case cat = "Cat"
    
    var displayName: String {
        return self.rawValue
    }
    
    var color: String {
        switch self {
        case .mariko:
            return "#E7949A" // Pink color for Mariko
        case .cat:
            return "#E1B551" // Orange color for Cat
        }
    }
}

// Story levels data
struct StoryLevels {
    static let levels: [StoryLevel] = [
        StoryLevel(
            id: 1,
            title: "First Steps",
            difficulty: .beginner,
            description: "Mariko and her cat friend discover a mysterious puzzle...",
            dialogs: [
                StoryDialog(
                    character: .mariko,
                    text: "Hey, look at this strange grid! What do you think it is?"
                ),
                StoryDialog(
                    character: .cat,
                    text: "Meow! It looks like a puzzle to me. I see some numbers and empty squares."
                ),
                StoryDialog(
                    character: .mariko,
                    text: "You're right! I think I understand how it works. The numbers tell us how many mines are nearby."
                ),
                StoryDialog(
                    character: .cat,
                    text: "Be careful, Mariko! One wrong move and... BOOM! Let's solve this together!"
                ),
                StoryDialog(
                    character: .mariko,
                    text: "Ready to start our first adventure? Let's clear this grid safely!"
                )
            ]
        )
    ]
} 