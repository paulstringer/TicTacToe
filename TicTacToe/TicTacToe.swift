import Foundation

protocol GameView: class {
    var gameTypes: [GameType] { get set }
}

enum GameType {
    case HumanVersusHuman
}

struct TicTacToe {
    
    let view: GameView
    
    func ready() {
        
        view.gameTypes = [.HumanVersusHuman]
    }
}