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

typealias GameBotCompletion = (BoardPosition) -> Void

protocol GameBot {
    func nextMove(board: GameBoard, completion: GameBotCompletion)
}

protocol GameState {
    func takeTurn(game: TicTacToe, position: BoardPosition)
}

public class TicTacToe: Game {

    let view: GameView
//    let bot: GameBot?
    var board: TicTacToeBoard
    
    lazy var state: GameState = NewGame(game: self)

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
