import Foundation

protocol GameView: class {
    var gameTypes: [GameType] { get set }
    var gameState: GameState { get set }
}

enum GameType {
    case HumanVersusHuman
}

enum GameState {
    case None
    case PlayerOneUp
    case PlayerTwoUp
    case PlayerOneWins
    case PlayerTwoWins
}

private enum GamePlayer {
    case None
    case HumanOne
    case HumanTwo
}

private enum GameMark {
    case None
    case Nought
    case Cross
}

public enum SquareLocation: Int {
    case TopLeft = 0
    case TopMiddle = 1
    case TopRight = 2
    case MiddleLeft = 3
    case Middle = 4
    case MiddleRight = 5
    case BottomLeft = 6
    case BottomMiddle = 7
    case BottomRight = 8
}

struct TicTacToe {
    
    private var board: [GameMark] = [.None, .None, .None, .None, .None, .None, .None, .None, .None]
    
    private var lastTurnPlayer: GamePlayer
    
    let view: GameView
    
    init(view: GameView) {
        self.view = view
        self.lastTurnPlayer = .None
    }
    
    func ready() {
        view.gameTypes = [.HumanVersusHuman]
        view.gameState = .PlayerOneUp
    }
    
    mutating func takeTurnAtRow(row: Int, column: Int) {
    
        guard row > 0 && column > 0 && row < 4 && column < 4 else {
            return
        }
        
        let square = squareLocationForRow(row, column: column)
        
        takeTurnAtSquare(square)
        
    }
    
    mutating func takeTurnAtSquare(index: SquareLocation.RawValue) {
        
        guard let square = SquareLocation(rawValue: index) else {
            return
        }

        takeTurnAtSquare(square)
        
    }
    
    mutating func takeTurnAtSquare(square: SquareLocation) {
        
        guard board[square.rawValue] == .None else {
            return
        }
        
        addMarkAtSquare(square)

    }
    
    private mutating func addMarkAtSquare(square: SquareLocation) {
        
        let playersMark = markForCurrentPlayer()
        board[square.rawValue] = playersMark
        
        if isWinningPosition(playersMark) {
            advanceToCurrentPlayerWins()
        } else {
            advanceCurrentPlayer()
        }
        
    }
    private func squareLocationForRow(row: Int, column: Int) -> SquareLocation {
        let rowOffset = (row - 1) * 3
        let columnShift = column - 1
        let location = rowOffset + columnShift
        return SquareLocation(rawValue: location)!
    }
    
    private mutating func advanceToCurrentPlayerWins() {
        view.gameState = (lastTurnPlayer == .HumanTwo) ? .PlayerOneWins : .PlayerTwoWins
        lastTurnPlayer = .None
    }
    
    private mutating func advanceCurrentPlayer() {
        switch lastTurnPlayer {
        case .None, .HumanTwo:
            lastTurnPlayer = .HumanOne
            view.gameState = .PlayerTwoUp
        case .HumanOne:
            lastTurnPlayer = .HumanTwo
            view.gameState = .PlayerOneUp
        }
    }
    
    private func isWinningPosition(mark: GameMark) -> Bool{
        
        let playersMark = markForCurrentPlayer()
        
        var marksInARow = 0
        
        for square in board {
            if square != playersMark {
                marksInARow = 0
            } else {
                marksInARow++
            }
            if marksInARow == 3 {
                return true
            }
        }

        
        for columnShift in 0...2 {

            marksInARow = 0
            
            for (location, square) in board.enumerate() {
                
                let index = location-columnShift
                
                if index % 3 == 0 {
                    
                    if square != playersMark {
                        marksInARow = 0
                    } else {
                        marksInARow++
                    }
                    
                    if marksInARow == 3 {
                        return true
                    }
                    
                }
            }
            
        }
        
        return false
    }
    
    private func markForCurrentPlayer() -> GameMark {
        return (lastTurnPlayer == .HumanOne) ? GameMark.Nought : GameMark.Cross
    }

}