//
//  ContentView.swift
//  minesweep
//
//  Created by yasir abbas on 09/07/2025.
//

import SwiftUI
import SwiftData


struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        GameStartView()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [GameSession.self, GameMove.self], inMemory: true)
}
