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
}

enum GamePlayer {
    case None
    case HumanOne
    case HumanTwo
}

struct TicTacToe {

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
    
    mutating func takeTurn(x: Int, y: Int) {
        
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