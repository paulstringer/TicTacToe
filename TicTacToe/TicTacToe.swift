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
                    positions.append(BoardPosition(rawValue: index)!)
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
    case Stalemate
    case ComputerWins
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
        
        do {
            try board.takeTurnAtPosition(position)
        } catch {
            return
        }
        
        view.gameBoard = board
        
        guard false == board.hasCompleteLine() else {
            declareVictory()
            return
        }
        
        guard false == board.isFull() else {
            declareStalemate()
            return
        }
        
        updateGameState()
        
        takeComputersTurnIfNeeded()
        
    }
    
    //MARK:- Computer's Strategy
    
    private var computerPositions = [BoardPosition]()
    
    private mutating func takeComputersTurnIfNeeded() {
        guard gameType == .HumanVersusComputer &&  lastPlayer != .Computer else {
            return
        }
        
        takeTurnAtPosition( hint() )

    }
    
    private func hint() -> BoardPosition {
        
        guard let lastTurn = board.lastTurn else {
            return .TopLeft
        }
        
        if lastTurn.isCorner && board.boardPositionIsEmpty(.Middle) {
            return .Middle
        }

        if let strategicPosition = emptyPositionForNextWinningLine() {
            return strategicPosition
        }
        
        if let strategicPosition = bestStrategicMove() {
            return strategicPosition
        }
        
        return board.emptyPositions[0]
        
    }
    
    private func emptyPositionForNextWinningLine() -> BoardPosition? {
        
        let lines = board.linesWithCount(2)
        
        var candidates = [BoardPosition]()
        
        for line in lines {
            for value in line {
                let position = BoardPosition(rawValue: value)!
                if board.boardPositionIsEmpty(position) {
                    candidates.append(position)
                }
            }
        }

        candidates.sortInPlace { (a, b) -> Bool in
            var virtualBoard = self.board
            do {
               try virtualBoard.takeTurnAtPosition(a)
                return virtualBoard.hasCompleteLine()
            } catch {
                return false
            }

        }
        
        return candidates.first
    }
    
    
    private func bestStrategicMove() -> BoardPosition? {
        
        let computerCapturedTheMiddleGround = computerPositions.contains(.Middle)
        
        for position in board.emptyPositions {
            if computerCapturedTheMiddleGround && position.isEdge {
                return position
            } else if position.isCorner {
                return position
            }
        }
        
        return nil
    }
    
    //MARK:- Game State Transitions
    
    private mutating func updateGameState() {
        
        switch lastPlayer {
        case .None, .HumanTwo, .Computer:
            lastPlayer = .HumanOne
            switch gameType {
            case .HumanVersusHuman:
                view.gameState = .PlayerTwoUp
            case .HumanVersusComputer:
                view.gameState = .PlayerOneUp
            }
        case .HumanOne:
            switch gameType {
            case .HumanVersusHuman:
                lastPlayer = .HumanTwo
                view.gameState = .PlayerOneUp
            case .HumanVersusComputer:
                computerPositions.append(board.lastTurn!)
                lastPlayer = .Computer
            }
        }
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

        lastPlayer = .None
    }

    private mutating func declareStalemate(){
        lastPlayer = .None
        view.gameState = .Stalemate
    }
}

