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

class TicTacToe {

    private var gamePlayerType: TicTacToeGamePlayerType = TicTacToePlayerNewGame()
    let view: GameView
    var board = TicTacToeBoard()
    private var lastPlayer: TicTacToeGamePlayer {
        get {
            return gamePlayerType.type
        }
    }
    var bot = TicTacToeBot()
    var gameType: GameType {
        didSet {
            gamePlayerType.setGameType(gameType, game: self)
        }
    }
    
    init(view: GameView) {
        self.view = view
        self.gameType = .HumanVersusHuman
        view.gameTypes = [.HumanVersusHuman, .HumanVersusComputer]
        view.gameBoard = board
    }
    
    //MARK:- Game
    
    func startGame(type: GameType) {
        gamePlayerType.setGameType(type, game: self)
        view.gameState = .PlayerOneUp
    }

    func takeTurnAtPosition(rawValue: BoardPosition.RawValue) {
        
        guard let position = BoardPosition(rawValue: rawValue) else {
            return
        }

        takeTurnAtPosition(position)
        
    }
    
    func takeTurnAtPosition(position: BoardPosition) {
        
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
    
    private func declareVictoryOrStalemateIfGameOver() -> Bool {
    
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
    
    private func takeBotsTurn() {
        
        if let move = gamePlayerType.nextMove(self) {
            takeTurnAtPosition(move)
            bot.turnTakenAtBoardPosition(move)
        }

    }
    
    //MARK:- Game State Transitions
    
    private func incrementPlayer() {
        
        gamePlayerType.incrementPlayer(self)
        takeBotsTurn()
        
    }

    private func declareVictory() {
        
        gamePlayerType.declareVictory(self)
        setGamePlayerType(.NewGame) // <-- State For Game Over
    }

    private func declareStalemate(){
        

        view.gameState = .Stalemate
        setGamePlayerType(.NewGame) // <-- State For Stalemate
    }

    
    func setGamePlayerType(type: TicTacToeGamePlayer) {
        gamePlayerType = newTicTacToeGamePlayerType(type)
    }
}

