import Foundation

enum GameType {
    case HumanVersusHuman
    case HumanVersusComputer
}

enum GameStatus {
    case None
    case PlayerOneUp
    case PlayerTwoUp
    case ComputerUp
    case PlayerOneWins
    case PlayerTwoWins
    case ComputerWins
    case Stalemate
}

protocol GameBoard {
    var lastTurn: BoardPosition? { get }
    var markers: [BoardMarker] { get }
}

protocol GameView: class {
    var gameTypes: [GameType] { get set }
    var gameStatus: GameStatus { get set }
    var gameBoard: GameBoard! { get set }
}

class TicTacToe {

    let view: GameView
    
    var state = TicTacToePlayerNewGame() as TicTacToeGameState
    var board = TicTacToeBoard()
    var bot = TicTacToeBot()
    
    init(view: GameView) {
        
        self.view = view
        
        view.gameTypes = [.HumanVersusHuman, .HumanVersusComputer]
    }
    
    func startGame(type: GameType) {
        
        state.setGameType(type, game: self)
        
        view.gameBoard = board
    }

    func takeTurnAtPosition(rawValue: BoardPosition.RawValue) {
        
        guard let position = BoardPosition(rawValue: rawValue) else {
            return
        }
        
        state.takeTurn(self, position: position )
        
    }
    
    func takeTurnAtPosition(position: BoardPosition) {
        
        state.takeTurn(self, position: position )
    }
}
