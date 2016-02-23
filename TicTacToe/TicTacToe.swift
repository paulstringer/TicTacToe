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

struct TicTacToe {
    
    private var board: [Bool] = [false, false, false]
    
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
            board[column-1] = true
        }
        
        var wins = true
        
        for mark in board {
            if mark == false {
                wins = false
                continue
            }
        }
        
        if wins {
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