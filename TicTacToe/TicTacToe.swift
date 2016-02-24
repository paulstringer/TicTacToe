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
        
        let square = squareForRow(row, column: column)
        
        guard board[square] == .None else {
            return
        }
        
        let playersMark = markForCurrentPlayer()
        board[square] = playersMark
        
        if isWinningPosition(playersMark) {
            view.gameState = (lastTurnPlayer == .HumanTwo) ? .PlayerOneWins : .PlayerTwoWins
            lastTurnPlayer = .None
            return
        }
        
        advanceCurrentPlayer()

    }
    
    private func squareForRow(row: Int, column: Int) -> Int {
        let rowOffset = (row - 1) * 3
        let columnShift = column - 1
        return rowOffset + columnShift
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
        
        return false
    }
    
    private func markForCurrentPlayer() -> GameMark {
        return (lastTurnPlayer == .HumanOne) ? GameMark.Nought : GameMark.Cross
    }

}