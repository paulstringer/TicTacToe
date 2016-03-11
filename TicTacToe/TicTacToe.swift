import Foundation

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

protocol Game {
    
    func takeTurnAtPosition(position: BoardPosition)
    func takeTurnAtPosition(rawValue: BoardPosition.RawValue)
    
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

protocol GameState {
    func takeTurn(game: TicTacToe, position: BoardPosition)
}

public class TicTacToe: Game {

    let view: GameView
    var board: TicTacToeBoard
    lazy var state: GameState = NewGame(game: self)
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
