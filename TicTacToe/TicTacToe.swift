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
    var state: GameInternalState!
    lazy var bot: GameBot = { MinimaxGameBot() }()
    
    init(view: GameView, board: TicTacToeBoard = TicTacToeBoard()) {
        self.view = view
        self.board = board
        NewGame.performTransition(self)
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
