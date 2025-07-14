import SwiftUI

let storyLevelMask: [[Bool]] = [
    [false, false, true,  true,  true,  false, false],
    [false, true,  true,  true,  true,  true,  false],
    [true,  true,  true,  true,  true,  true,  true ],
    [true,  true,  true,  true,  true,  true,  true ],
    [true,  true,  true,  true,  true,  true,  true ],
    [false, true,  true,  true,  true,  true,  false],
    [false, false, true,  true,  true,  false, false]
]

struct StoryGameBoardView: View {
    let board: [[Cell]]
    let onCellTap: (Int, Int) -> Void
    
    private let cellSize: CGFloat = 56
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<board.count, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<board[row].count, id: \.self) { col in
                        let cell = board[row][col]
                        ZStack {
                            Rectangle()
                                .fill(cell.isActive ? cell.isRevealed ? Color(hex: "E9E1DA") : Color(hex: "E7949A") : Color.clear)
                                .frame(width: cellSize, height: cellSize)
                                .border(Color.gray.opacity(cell.isActive ? 0.3 : 0.0), width: 1)
                                .cornerRadius(4)
                                .padding(2)
                            if cell.isActive {
                                Text(cell.isFlagged ? "🚩" : (cell.isRevealed ? (cell.isMine ? "💣" : (cell.adjacentMines > 0 ? "\(cell.adjacentMines)" : "")) : ""))
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(cell.isRevealed ? .black : .primary)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if cell.isActive {
                                onCellTap(row, col)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    // Example board for preview
    let mask = storyLevelMask
    var previewBoard: [[Cell]] = Array(repeating: Array(repeating: Cell(), count: 7), count: 7)
    for row in 0..<7 {
        for col in 0..<7 {
            previewBoard[row][col].isActive = mask[row][col]
            if mask[row][col] {
                previewBoard[row][col].isRevealed = Bool.random()
                previewBoard[row][col].isMine = Bool.random() && Bool.random()
                previewBoard[row][col].adjacentMines = Int.random(in: 0...2)
            }
        }
    }
    return StoryGameBoardView(board: previewBoard, onCellTap: {_,_ in })
} 
