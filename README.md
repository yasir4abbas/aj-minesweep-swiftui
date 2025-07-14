# Minesweeper iOS App

A complete Minesweeper game built with SwiftUI and SwiftData, following a clean architecture pattern. Features multiple difficulty levels, game history tracking, and in-app purchase support.

## 🎮 Features

### Game Features
- **Multiple Difficulty Levels**: Beginner (9x9, 10 mines), Intermediate (16x16, 40 mines), Expert (16x30, 99 mines)
- **Touch Controls**: Tap to reveal, long press to flag
- **Real-time Timer**: Tracks game duration
- **Move Counter**: Counts total moves made
- **Mine Counter**: Shows remaining mines
- **Auto-reveal**: Automatically reveals adjacent cells when clicking on empty cells

### Statistics & History
- **Game History**: View all past games
- **Statistics**: Win rate, best times, total games per difficulty
- **Session Tracking**: Complete game session data with moves
- **Performance Metrics**: Time, moves, and win/loss tracking

## 🚀 Setup Instructions

### Prerequisites
- Xcode 15.0 or later
- iOS 18.0 or later
- Apple Developer Account (for device testing and App Store distribution)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/minesweeper-ios.git
   cd minesweeper-ios
   ```

2. **Open the project**
   ```bash
   open minesweep.xcodeproj
   ```

3. **Configure your development team**
   - Open `minesweep.xcodeproj/project.pbxproj`
   - Replace `YOUR_TEAM_ID` with your Apple Developer Team ID
   - Update the bundle identifier to your own (e.g., `com.yourname.minesweep`)

4. **Configure in-app purchases (optional)**
   - Update product IDs in `Core/InAppPurchaseConfig.swift`
   - Configure your own StoreKit products in App Store Connect
   - Update privacy policy URLs in `Presentation/Views/InAppPurchaseView.swift`

5. **Build and run**
   - Select your target device or simulator
   - Press Cmd+R to build and run

## 🎯 Game Rules

1. **Objective**: Clear all non-mine cells without detonating any mines
2. **Revealing Cells**: Tap a cell to reveal it
3. **Flagging Mines**: Long press to place/remove a flag on suspected mines
4. **Numbers**: Revealed numbers indicate how many mines are adjacent
5. **Auto-reveal**: Empty cells automatically reveal adjacent cells
6. **Win Condition**: Reveal all non-mine cells
7. **Lose Condition**: Click on a mine

## 📊 Data Models

### GameSession
- `id`: Unique identifier
- `timestamp`: When the game was played
- `width/height`: Board dimensions
- `totalMines`: Number of mines
- `gameState`: "playing", "won", or "lost"
- `duration`: Game duration in seconds
- `moves`: Total number of moves

### GameMove
- `id`: Unique identifier
- `sessionId`: Reference to game session
- `timestamp`: When the move was made
- `row/col`: Cell coordinates
- `moveType`: "reveal" or "flag"
- `result`: "success", "mine", "win", or "lose"

## 🛠️ Customization

### Adding New Difficulty Levels
1. Add new difficulty to `GameDifficulty` enum
2. Update `DifficultySelectionView.swift`
3. Test with different board sizes

### Modifying In-App Purchases
1. Update product IDs in `InAppPurchaseConfig.swift`
2. Configure products in App Store Connect
3. Update UI text in `InAppPurchaseView.swift`

### Changing Game Logic
1. Modify `GameEngine.swift` for core game changes
2. Update `GameUseCase.swift` for business logic changes
3. Test thoroughly with different scenarios

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with SwiftUI and SwiftData
- Icons and assets created for this project
- Inspired by the classic Minesweeper game

## 📞 Support

If you have any questions or need help with the setup, please open an issue on GitHub.

---

**Note**: This is an open source project. Please respect the license terms. 