//
//  MinesweeperGameView.swift
//  minesweep
//
//  Created by yasir abbas on 09/07/2025.
//

import SwiftUI
import SwiftData
import UIKit

//extension Color {
//    init(hex: String) {
//        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
//        var int: UInt64 = 0
//        Scanner(string: hex).scanHexInt64(&int)
//        let a, r, g, b: UInt64
//        switch hex.count {
//        case 3: // RGB (12-bit)
//            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
//        case 6: // RGB (24-bit)
//            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
//        case 8: // ARGB (32-bit)
//            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
//        default:
//            (a, r, g, b) = (1, 1, 1, 0)
//        }
//
//        self.init(
//            .sRGB,
//            red: Double(r) / 255,
//            green: Double(g) / 255,
//            blue:  Double(b) / 255,
//            opacity: Double(a) / 255
//        )
//    }
//}

class FlagMode: ObservableObject {
    @Published var isFlagMode: Bool = false
}

struct ZoomableScrollView<Content: View>: UIViewRepresentable {
    let content: Content
    let gameUseCase: GameUseCase
    let minZoomScale: CGFloat
    let maxZoomScale: CGFloat
    let initialZoomScale: CGFloat
    
    init(gameUseCase: GameUseCase, minZoomScale: CGFloat = 0.5, maxZoomScale: CGFloat = 3.0, initialZoomScale: CGFloat = 0.3, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.gameUseCase = gameUseCase
        self.minZoomScale = minZoomScale
        self.maxZoomScale = maxZoomScale
        self.initialZoomScale = initialZoomScale
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        scrollView.minimumZoomScale = minZoomScale
        scrollView.maximumZoomScale = maxZoomScale
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.bouncesZoom = true
        scrollView.bounces = true
        scrollView.alwaysBounceHorizontal = true
        scrollView.alwaysBounceVertical = true
        scrollView.backgroundColor = UIColor.systemBackground
        
        let hostingController = UIHostingController(rootView: content)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.backgroundColor = UIColor.systemBackground
        
        scrollView.addSubview(hostingController.view)
        
        // Calculate proper content size based on actual cell dimensions (64px per cell)
        let cellSize: CGFloat = 64 // 56px cell + 4px padding on each side
        let boardWidth = CGFloat(gameUseCase.gameEngine.board[0].count) * cellSize
        let boardHeight = CGFloat(gameUseCase.gameEngine.board.count) * cellSize
        let contentSize = CGSize(width: boardWidth, height: boardHeight)
        
        scrollView.contentSize = contentSize
        hostingController.view.frame = CGRect(origin: .zero, size: contentSize)
        
        context.coordinator.hostingController = hostingController
        context.coordinator.boardSize = contentSize
        context.coordinator.initialZoomScale = initialZoomScale
        
        // Set initial zoom scale
        scrollView.zoomScale = initialZoomScale
        context.coordinator.centerScrollViewContents(scrollView)
        
        // Animate to normal zoom after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.animate(withDuration: 1.0, delay: 0, options: [.curveEaseInOut], animations: {
                scrollView.zoomScale = 1.0
                context.coordinator.centerScrollViewContents(scrollView)
            })
        }
        
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        context.coordinator.hostingController?.rootView = content
        
        // Update content size when board changes
        if let hostingController = context.coordinator.hostingController {
            let cellSize: CGFloat = 64 // 56px cell + 4px padding on each side
            let boardWidth = CGFloat(gameUseCase.gameEngine.board[0].count) * cellSize
            let boardHeight = CGFloat(gameUseCase.gameEngine.board.count) * cellSize
            let contentSize = CGSize(width: boardWidth, height: boardHeight)
            
            uiView.contentSize = contentSize
            hostingController.view.frame = CGRect(origin: .zero, size: contentSize)
            context.coordinator.boardSize = contentSize
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var hostingController: UIHostingController<Content>?
        var boardSize: CGSize = .zero
        var initialZoomScale: CGFloat = 0.3
        
        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return hostingController?.view
        }
        
        func scrollViewDidZoom(_ scrollView: UIScrollView) {
            centerScrollViewContents(scrollView)
        }
        
        func centerScrollViewContents(_ scrollView: UIScrollView) {
            guard let contentView = hostingController?.view else { return }
            
            let boundsSize = scrollView.bounds.size
            var contentFrame = contentView.frame
            
            if contentFrame.size.width < boundsSize.width {
                contentFrame.origin.x = (boundsSize.width - contentFrame.size.width) / 2.0
            } else {
                contentFrame.origin.x = 0.0
            }
            
            if contentFrame.size.height < boundsSize.height {
                contentFrame.origin.y = (boundsSize.height - contentFrame.size.height) / 2.0
            } else {
                contentFrame.origin.y = 0.0
            }
            
            contentView.frame = contentFrame
        }
    }
}

struct MinesweeperGameView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var gameUseCase: GameUseCase
    @StateObject private var flagMode = FlagMode()
    @State private var showingGameHistory = false
    @State private var showingGameOverAlert = false
    private let difficulty: GameDifficulty
    
    init(modelContext: ModelContext, difficulty: GameDifficulty = .beginner) {
        let repository = GameRepository(modelContext: modelContext)
        self._gameUseCase = StateObject(wrappedValue: GameUseCase(repository: repository, difficulty: difficulty))
        self.difficulty = difficulty
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                GameHeaderView(gameUseCase: gameUseCase)
                
                ZoomableScrollView(gameUseCase: gameUseCase, minZoomScale: 0.5, maxZoomScale: 3.0, initialZoomScale: 0.3) {
                    GameBoardView(gameUseCase: gameUseCase, flagMode: flagMode)
                }
                .overlay(
                    Group {
                        if gameUseCase.gameEngine.gameState == .won {
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    VStack(spacing: 12) {
                                        Text("🎉")
                                            .font(.system(size: 48))
                                        Text("YOU WON!")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundColor(.green)
                                        Text("Tap to continue")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding()
                                    .background(Color.white.opacity(0.9))
                                    .cornerRadius(16)
                                    .shadow(radius: 10)
                                    .onTapGesture {
                                        showingGameOverAlert = true
                                    }
                                    Spacer()
                                }
                                Spacer()
                            }
                            .background(Color.black.opacity(0.3))
                            .allowsHitTesting(true)
                        }
                    }
                )
                
                // Game controls
                HStack(spacing: 20) {
                    Button(action: {
                        // Dismiss this view to go back to start screen
                        dismiss()
                    }) {
                        Image(systemName: "house")
                            .font(.title2)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.05))
                            .cornerRadius(12)
                    }
                    
                    Button(action: {
                        flagMode.isFlagMode.toggle()
                    }) {
                        VStack {
                            Image(systemName: flagMode.isFlagMode ? "flag.fill" : "flag")
                                .font(.title2)
                                .foregroundColor(flagMode.isFlagMode ? .orange : .blue)
                            Text(flagMode.isFlagMode ? "Flag Mode" : "Reveal Mode")
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(flagMode.isFlagMode ? Color.orange.opacity(0.2) : Color.blue.opacity(0.1))
                        .cornerRadius(12)
                    }
                    
                    Button(action: {
                        showingGameHistory = true
                    }) {
                        VStack {
                            Image(systemName: "chart.bar")
                                .font(.title2)
                            Text("History")
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .hidden()
                    }
                }
                .padding()
            }

            .sheet(isPresented: $showingGameHistory) {
                GameHistoryView(
                    gameUseCase: gameUseCase,
                    isPresented: $showingGameHistory
                )
            }
            .alert(gameUseCase.gameEngine.gameState == .won ? "🎉 Congratulations! 🎉" : "Game Over", isPresented: $showingGameOverAlert) {
                Button("Back to Menu") {
                    dismiss()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text(gameOverMessage)
            }
            .onReceive(gameUseCase.$gameEngine) { engine in
                if engine.gameState == .won || engine.gameState == .lost {
                    showingGameOverAlert = true
                }
            }
//            .background(Color(hex: "7EAEC7"))
        }
        .onAppear {
            if gameUseCase.currentSession == nil {
                gameUseCase.startNewGame(difficulty: difficulty)
            }
        }
    }
    
    private var gameOverMessage: String {
        switch gameUseCase.gameEngine.gameState {
        case .won:
            return "🎉 You successfully cleared all mines! 🎉\n\nTime: \(formattedTime)\nMoves: \(gameUseCase.moveCount)\n\nGreat job!"
        case .lost:
            return "Game Over! You hit a mine. Try again!"
        case .playing:
            return ""
        }
    }
    
    private var formattedTime: String {
        let minutes = Int(gameUseCase.elapsedTime) / 60
        let seconds = Int(gameUseCase.elapsedTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

//#Preview {
//    MinesweeperGameView(modelContext: try! ModelContainer(for: GameSession.self).mainContext)
//} 
