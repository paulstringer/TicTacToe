import Foundation

protocol GameView: class {
    var gameTypes: [GameType] { get set }
    var gameState: GameState { get set }
}

enum GameType {
    case HumanVersusHuman
}

enum GameState {
    case None
    case PlayerOneUp
    case PlayerTwoUp
    case PlayerOneWins
    case PlayerTwoWins
    case Stalemate
}

private enum GamePlayer {
    case None
    case HumanOne
    case HumanTwo
}

struct TicTacToe {

    private let view: GameView
    private var board = TicTacToeBoard()
    private var lastPlayer: GamePlayer

    init(view: GameView) {
        self.view = view
        self.lastPlayer = .None
    }
    
    //MARK:- Game
    
    func ready() {
        view.gameTypes = [.HumanVersusHuman]
        view.gameState = .PlayerOneUp
    }

    mutating func takeTurnAtPosition(rawValue: BoardPosition.RawValue) {
        
        guard let position = BoardPosition(rawValue: rawValue) else {
            return
        }

        takeTurnAtPosition(position)
        
    }
    
    mutating func takeTurnAtPosition(position: BoardPosition) {
        
        let mark = nextMark()
        
        do {
            try board.addMarker(mark, atPosition: position)
             advancePlayer()
        } catch {
            return
        }

        if board.hasCompleteLine() {
            declareVictory()
        } else if board.isFull() {
            declareStalemate()
        }
        
    }
    
    //MARK:- Game Internals
    
    private mutating func advancePlayer() {
        switch lastPlayer {
        case .None, .HumanTwo:
            lastPlayer = .HumanOne
            view.gameState = .PlayerTwoUp
        case .HumanOne:
            lastPlayer = .HumanTwo
            view.gameState = .PlayerOneUp
        }
    }
    
    
    private mutating func declareVictory() {
        view.gameState = (lastPlayer == .HumanOne) ? .PlayerOneWins : .PlayerTwoWins
        lastPlayer = .None
    }

    private mutating func declareStalemate(){
        lastPlayer = .None
        view.gameState = .Stalemate
    }
    
    private func nextMark() -> BoardMarker {
        switch lastPlayer {
        case .HumanOne:
            return .Nought
        default:
            return .Cross
        }
    }
    
}

