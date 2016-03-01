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

extension BoardView {
    
    var emptyPositions: [BoardPosition] {
        
        get {
            var positions = [BoardPosition]()
            for (index, marker) in self.markers.enumerate() {
                if marker == .None {
                    let position = BoardPosition(rawValue: index)!
                    positions.append(position)
                }
            }
            return positions
        }
        
    }
    
}

enum GameType {
    case HumanVersusHuman
    case HumanVersusComputer
}

enum GameState {
    case None
    case PlayerOneUp
    case PlayerTwoUp
    case ComputerUp
    case PlayerOneWins
    case PlayerTwoWins
    case ComputerWins
    case Stalemate
}

struct TicTacToe {

    private var gamePlayerType: TicTacToeGamePlayerType = TicTacToeGameStatePlayerNone()
    private let view: GameView
    private var board = TicTacToeBoard()
    private var lastPlayer: TicTacToeGamePlayer {
        get {
            return gamePlayerType.type
        }
    }
    private var bot = TicTacToeBot()
    
    var gameType: GameType
    
    init(view: GameView) {
        self.view = view
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
        
        do {
            try board.takeTurnAtPosition(position)
            view.gameBoard = board
        } catch {
            return
        }
        
        if declareVictoryOrStalemateIfGameOver() {
            return
        } else {
            incrementPlayer()
        }

    }
    
    //MARK:- Computer's Strategy
    
    private mutating func declareVictoryOrStalemateIfGameOver() -> Bool {
    
        guard false == board.hasCompleteLine() else {
            declareVictory()
            return true
        }
        
        guard false == board.isFull() else {
            declareStalemate()
            return true
        }
    
        return false
    
    }
    
    private mutating func takeBotsTurn() {
        
        guard gameType == .HumanVersusComputer &&  lastPlayer != .Computer else {
            return
        }
        
        let position = bot.nextMove(board)
        takeTurnAtPosition(position)
        bot.turnTakenAtBoardPosition(position)

    }
    
    //MARK:- Game State Transitions
    
    private mutating func incrementPlayer() {
        
        switch lastPlayer {
        
        case .None, .HumanTwo, .Computer:
            
            setGamePlayerType(.HumanOne)
            
            switch gameType {
            case .HumanVersusHuman:
                view.gameState = .PlayerTwoUp
            case .HumanVersusComputer:
                view.gameState = .PlayerOneUp
            }
            
        case .HumanOne:
            
            switch gameType {
            case .HumanVersusHuman:
                setGamePlayerType(.HumanTwo)
                view.gameState = .PlayerOneUp
            case .HumanVersusComputer:
                setGamePlayerType(.Computer)
            }
            
        }
        
        
        takeBotsTurn()
        
    }

    private mutating func declareVictory() {
        
        guard lastPlayer != .None else {
            return
        }
        
        switch gameType {
        case .HumanVersusHuman:
            view.gameState = (lastPlayer == .HumanOne) ? .PlayerTwoWins : .PlayerOneWins
        case .HumanVersusComputer:
            view.gameState = (lastPlayer == .HumanOne) ? .ComputerWins : .PlayerOneWins
        }

        setGamePlayerType(.None)
    }

    private mutating func declareStalemate(){
        setGamePlayerType(.None)
        view.gameState = .Stalemate
    }

    private mutating func setGamePlayerType(type: TicTacToeGamePlayer) {
        gamePlayerType = newTicTacToeGamePlayerType(type)
    }
}

