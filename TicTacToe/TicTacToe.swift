import Foundation

enum GameStatus {
    case none
    case playerOneUp
    case playerTwoUp
    case computerUp
    case playerOneWins
    case playerTwoWins
    case computerWins
    case stalemate
}

protocol Game {
    func takeTurnAtPosition(_ position: BoardPosition)
    func takeTurnAtPosition(_ rawValue: BoardPosition.RawValue)
}

protocol GameBoard {
    var lastTurn: BoardPosition? { get }
    var markers: [BoardMarker] { get }
    var winningLine: BoardLine? { get }
}

protocol GameView: class {
    var gameStatus: GameStatus! { get set }
    var gameBoard: GameBoard! { get set }
}

protocol GameState {
    func takeTurn(_ game: TicTacToe, position: BoardPosition)
}

open class TicTacToe: Game {

    let view: GameView
    var board: TicTacToeBoard
    
    lazy var state: GameState = NewGame(game: self)

    init(view: GameView, board: TicTacToeBoard = TicTacToeBoard()) {
        
        self.view = view
        self.board = board
    }
    
    func takeTurnAtPosition(_ rawValue: BoardPosition.RawValue) {
        
        guard let position = BoardPosition(rawValue: rawValue) else {
            return
        }
        
        state.takeTurn(self, position: position )
        
    }
    
    func takeTurnAtPosition(_ position: BoardPosition) {
        
        state.takeTurn(self, position: position )
    }
    
}
