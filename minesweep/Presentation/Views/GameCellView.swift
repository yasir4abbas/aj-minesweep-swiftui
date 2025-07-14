//
//  GameCellView.swift
//  minesweep
//
//  Created by yasir abbas on 09/07/2025.
//

import SwiftUI

struct GameCellView: View {
    let row: Int
    let col: Int
    let displayText: String
    let cellColor: CellColor
    let onTap: () -> Void
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(cellColor.backgroundColor)
                .frame(width: 56, height: 56)
                .border(Color.gray.opacity(0.3), width: 1)
                .cornerRadius(4)
                .padding(4)
            
            Text(displayText)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(cellColor.textColor)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    GameCellView(
        row: 0,
        col: 0,
        displayText: "1",
        cellColor: .revealed,
        onTap: {}
    )
} 
