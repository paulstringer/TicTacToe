import Foundation

protocol GameView: class {
    var gameTypes: [GameType] { get set }
}

enum GameType {
    case HumanVersusComputer
}

struct TicTacToe {
    
    let view: GameView
    
    func ready() {
        
        view.gameTypes = [.HumanVersusComputer]
    }
}