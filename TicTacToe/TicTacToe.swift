import Foundation

protocol GameView: class {
    var gameTypes: [GameType] { get set }
}

enum GameType {
    case ComputerVersusComputer
}

struct TicTacToe {
    
    let view: GameView
    
    func ready() {
        
        view.gameTypes = [.ComputerVersusComputer]
    }
}