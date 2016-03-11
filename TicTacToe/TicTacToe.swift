import Foundation

typealias GameTypeValue = String

enum GameType: GameTypeValue {
    
    case HumanVersusHuman       = "HumanVersusHuman"
    case HumanVersusComputer    = "HumanVersusComputer"
    case ComputerVersusHuman    = "ComputerVersusHuman"
    
    static var allValues: [GameType] {
        get {
            return [.HumanVersusHuman, .HumanVersusComputer, .ComputerVersusHuman]
        }
    }
    
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
    var gameStatus: GameStatus! { get set }
    var gameBoard: GameBoard! { get set }
}

protocol GameBot {
    func nextMove(board: GameBoard) -> BoardPosition
}

public class TicTacToe {

    let view: GameView
    
    var board: TicTacToeBoard
    
    lazy var state:GameState = NewGame(game: self)
    lazy var bot: GameBot = { MinimaxGameBot() }()
    
    init(view: GameView, board: TicTacToeBoard = TicTacToeBoard()) {
        self.view = view
        self.board = board
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
