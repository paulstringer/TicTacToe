import Foundation

protocol GameView: class {
    var gameTypes: [GameType] { get set }
    var gameState: GameState { get set }
    var gameBoard: BoardView! { get set }
}

protocol BoardView {
    var lastTurn: BoardPosition? { get }
    var markers: [BoardMarker] { get }
}

enum GameType {
    case HumanVersusHuman
    case HumanVersusComputer
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
    case Computer
}

struct TicTacToe {

    private let view: GameView
    private var board = TicTacToeBoard()
    private var lastPlayer: GamePlayer
    
    var gameType: GameType
    
    init(view: GameView) {
        self.view = view
        self.lastPlayer = .None
        self.gameType = .HumanVersusHuman
    }
    
    //MARK:- Game
    
    func ready() {
        view.gameTypes = [.HumanVersusHuman, .HumanVersusComputer]
        view.gameState = .PlayerOneUp
        view.gameBoard = board
    }

    mutating func takeTurnAtPosition(rawValue: BoardPosition.RawValue) {
        
        guard let position = BoardPosition(rawValue: rawValue) else {
            return
        }

        takeTurnAtPosition(position)
        
    }
    
    mutating func takeTurnAtPosition(position: BoardPosition) {
        
        let marker = nextMark()
        
        do {
            try board.addMarker(marker, atPosition: position)
        } catch {
            return
        }
        
        view.gameBoard = board
        
        if board.hasCompleteLine() {
            declareVictory()
        } else if board.isFull() {
            declareStalemate()
        } else {
            takeComputersTurnIfNeeded()
            updateGameState()
        }
        
    }
    
    //MARK:- Game Internals
    
    private mutating func takeComputersTurnIfNeeded() {
        guard gameType == .HumanVersusComputer else {
            return
        }
        lastPlayer = .Computer
        takeTurnAtPosition( board.emptyPositions[0] )
    }
    
    private mutating func updateGameState() {
        switch lastPlayer {
        case .None, .HumanTwo:
            lastPlayer = .HumanOne
            view.gameState = .PlayerTwoUp
        case .HumanOne:
            lastPlayer = .HumanTwo
            view.gameState = .PlayerOneUp
        case .Computer:
            lastPlayer = .HumanOne
            break
        }
    }
    
    private mutating func declareVictory() {
        view.gameState = (lastPlayer == .HumanOne) ? .PlayerTwoWins : .PlayerOneWins
        lastPlayer = .None
    }

    private mutating func declareStalemate(){
        lastPlayer = .None
        view.gameState = .Stalemate
    }
    
    private func nextMark() -> BoardMarker {
        switch lastPlayer {
        case .HumanTwo, .None:
            return .Nought
        default:
            return .Cross
        }
    }
    
}

