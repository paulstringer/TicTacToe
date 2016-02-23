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
    
    private var board: [GameMark] = [.None, .None, .None]
    
    private var lastPlayer: GamePlayer
    
    let view: GameView
    
    init(view: GameView) {
        self.view = view
        self.lastPlayer = .None
    }
    
    func ready() {
        view.gameTypes = [.HumanVersusHuman]
        view.gameState = .PlayerOneUp
    }
    
    mutating func takeTurnAtRow(row: Int, column: Int) {
        
        guard row > 0 && column > 0 && row < 4 && column < 4 else {
            return
        }
        
        if row == 1 {
            board[column-1] = .Cross
        }
        
        var winningLine = true
        
        for mark in board {
            switch mark {
            case .Cross:
                break
            default:
                winningLine = false
                continue
            }
        }
        
        if winningLine {
            view.gameState = (lastPlayer == .HumanTwo) ? .PlayerOneWins : .PlayerTwoWins
            lastPlayer = .None
            return
        }

        switch lastPlayer {
        case .None, .HumanTwo:
            lastPlayer = .HumanOne
            view.gameState = .PlayerTwoUp
        case .HumanOne:
            lastPlayer = .HumanTwo
            view.gameState = .PlayerOneUp
        }
        

    }
    

}