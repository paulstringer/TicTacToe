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
}

private enum GamePlayer {
    case None
    case HumanOne
    case HumanTwo
}

private enum GameMark {
    case None
    case Nought
    case Cross
}



struct TicTacToe {

    private let view: GameView
    private var board = TicTacToeBoard()
    private var lastTurnPlayer: GamePlayer

    init(view: GameView) {
        self.view = view
        self.lastTurnPlayer = .None
    }
    
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
        
        let mark = markForCurrentPlayer()
        
        do {
            try board.addMark(mark, atPosition: position)
        } catch {
            return
        }

        if board.isVictoryForMark(mark) {
            advanceToCurrentPlayerWins()
        } else {
            advanceCurrentPlayer()
        }
        
    }
    
    private func boardPositionForRow(row: Int, column: Int) -> BoardPosition? {
        
        guard row > 0 && column > 0 && row < 4 && column < 4 else {
            return nil
        }
        
        let rowOffset = (row - 1) * 3
        let columnShift = column - 1
        let location = rowOffset + columnShift
        return BoardPosition(rawValue: location)
    }
    
    private mutating func advanceToCurrentPlayerWins() {
        view.gameState = (lastTurnPlayer == .HumanTwo) ? .PlayerOneWins : .PlayerTwoWins
        lastTurnPlayer = .None
    }
    
    private mutating func advanceCurrentPlayer() {
        switch lastTurnPlayer {
        case .None, .HumanTwo:
            lastTurnPlayer = .HumanOne
            view.gameState = .PlayerTwoUp
        case .HumanOne:
            lastTurnPlayer = .HumanTwo
            view.gameState = .PlayerOneUp
        }
    }
    

    
    private func markForCurrentPlayer() -> GameMark {
        return (lastTurnPlayer == .HumanOne) ? GameMark.Nought : GameMark.Cross
    }
}

enum TicTacToeBoardError: ErrorType {
    case BoardLocationTaken
}

public enum BoardPosition: Int {
    case TopLeft = 0
    case TopMiddle = 1
    case TopRight = 2
    case MiddleLeft = 3
    case Middle = 4
    case MiddleRight = 5
    case BottomLeft = 6
    case BottomMiddle = 7
    case BottomRight = 8
}

private struct TicTacToeBoard {
    
    private var board: [GameMark] = [.None, .None, .None, .None, .None, .None, .None, .None, .None]
    
    private let lines: [[Int]]  = {
        
        let indexes = [0,1,2,3,4,5,6,7,8]
        
        var result = [ [Int] ]()
        
        for diaganalOffset in [4,2] {
            let d = indexes.filter { (index) -> Bool in
                return (index % diaganalOffset) == 0
            }
            result.append(d)
        }
        
        for columnStartIndex in [0,1,2] {
            let d = indexes.filter { (index) -> Bool in
                let _index = index-columnStartIndex
                return (_index % 3) == 0
            }
            result.append(d)
        }
        
        for rowStartIndex in [0,3,6] {
            let row = Array(indexes[rowStartIndex...rowStartIndex+2])
            result.append(row)
        }
        
        return result
        
        
    }()
    
    mutating func addMark(mark: GameMark, atPosition position:BoardPosition) throws {
        guard canAddMarkAtPosition(position) else {
            throw TicTacToeBoardError.BoardLocationTaken
        }
        board[position.rawValue] = mark
    }
    
    private func canAddMarkAtPosition(location: BoardPosition) -> Bool{
        return board[location.rawValue] == .None
    }
    
    func isVictoryForMark(playersMark: GameMark) -> Bool{
        
        for line in lines {
            
            var marksInARow = 0
            
            for index in line {
                
                let mark = board[index]
                
                if mark == playersMark {
                    marksInARow++
                } else {
                    marksInARow = 0
                }
                
                if marksInARow == 3 {
                    return true
                }
                
            }
            
            
            
        }
        
        return false
    }
    
    
}