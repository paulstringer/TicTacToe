import Foundation

enum GameType {
    case HumanVersusHuman, HumanVersusComputer, ComputerVersusHuman
    
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
    var board: [BoardMarker] { get }
}

protocol GameView: class {
    var gameTypes: [GameType] { get set }
    var gameStatus: GameStatus { get set }
    var gameBoard: GameBoard! { get set }
}

protocol TicTacToeBot {
    mutating func turnTakenAtBoardPosition(position: BoardPosition)
    mutating func nextMove(board: TicTacToeBoard) -> BoardPosition
}

public class TicTacToe {

    let view: GameView
    
    var board = TicTacToeBoard()
    lazy var state:TicTacToeState = TicTacToeNewGame(game: self)
    lazy var bot: TicTacToeBot = { TicTacToeHeuristicBot() }()
    
    init(view: GameView, board: TicTacToeBoard = TicTacToeBoard()) {
        
        self.view = view
        self.board = board
        view.gameTypes = GameType.allValues
    }
    
    func newGame(type: GameType) {
        
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
