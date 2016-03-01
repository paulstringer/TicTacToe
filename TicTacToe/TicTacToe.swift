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

    private var gamePlayerType: TicTacToeGamePlayerType = TicTacToePlayerNone()
    let view: GameView
    var board = TicTacToeBoard()
    private var lastPlayer: TicTacToeGamePlayer {
        get {
            return gamePlayerType.type
        }
    }
    var bot = TicTacToeBot()
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
        
        if let move = gamePlayerType.nextMove(self) {
            takeTurnAtPosition(move)
            bot.turnTakenAtBoardPosition(move)
        }

    }
    
    //MARK:- Game State Transitions
    
    private mutating func incrementPlayer() {
        
        gamePlayerType = gamePlayerType.incrementPlayer(self)
        takeBotsTurn()
        
    }

    private mutating func declareVictory() {
        
        gamePlayerType.declareVictory(self)
        setGamePlayerType(.None)
    }

    private mutating func declareStalemate(){
        

        view.gameState = .Stalemate
        setGamePlayerType(.None)
    }

    
    mutating func setGamePlayerType(type: TicTacToeGamePlayer) {
        gamePlayerType = newTicTacToeGamePlayerType(type)
    }
}

