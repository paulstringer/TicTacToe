import Foundation

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

extension BoardPosition {
    
    var isCorner: Bool {
        get {
            return [ TopLeft, TopRight, BottomLeft, BottomRight].contains(self)
        }
    }
    
    var isEdge: Bool {
        get {
            return [ MiddleLeft, TopMiddle, MiddleRight, BottomMiddle].contains(self)
        }
    }
    
    var isMiddle: Bool {
        get {
            return self == Middle
        }
    }
    
    var diagonalOpposite: BoardPosition?{
        
        get {
            switch (self) {
            case .TopLeft:
                return .BottomRight
            case .BottomRight:
                return .TopLeft
            case .TopRight:
                return .BottomLeft
            case .BottomLeft:
                return .TopRight
            default:
                return nil
            }
        }
    }
    
    var verticalOppositeCorner: BoardPosition?{
        
        get {
            switch (self) {
            case .TopLeft:
                return .BottomLeft
            case .TopRight:
                return .BottomRight
            case .BottomLeft:
                return .TopLeft
            case .BottomRight:
                return .TopRight
            default:
                return nil
            }
        }
    }
    
    var horizontalOppositeCorner: BoardPosition?{
        
        get {
            switch (self) {
            case .TopLeft:
                return .TopRight
            case .TopRight:
                return .TopLeft
            case .BottomLeft:
                return .BottomRight
            case .BottomRight:
                return .BottomLeft
            default:
                return nil
            }
        }
    }
    
}

enum BoardMarker {
    case None
    case Nought
    case Cross
}

enum BoardError: ErrorType {
    case BoardPositionTaken
    case InvalidMove
}

typealias BoardLine = [BoardPosition]

struct TicTacToeBoard: GameBoard {
    
    var board: [BoardMarker]
    
    static private let lines: [BoardLine]  = {
        
        var result = [ [BoardPosition] ]()
        
        // Diagonals
        result.append([.TopLeft,.Middle,.BottomRight])
        result.append([.TopRight,.Middle, .BottomLeft])
        
        // Columns
        result.append([.TopLeft,.MiddleLeft,.BottomLeft])
        result.append([.TopMiddle,.Middle,.BottomMiddle])
        result.append([.TopRight,.MiddleRight,.BottomRight])
        
        // Rows
        result.append([.TopLeft,.TopMiddle,.TopRight])
        result.append([.MiddleLeft,.Middle,.MiddleRight])
        result.append([.BottomLeft,.BottomMiddle,.BottomRight])
        
        return result
        
        
    }()
    
    init(board: [BoardMarker] = [.None, .None, .None, .None, .None, .None, .None, .None, .None]) {
        self.board = board
        self.lastTurn = lastPlayersBoardPosition()
    }
    
    //MARK: Game Board
    
    var lastTurn: BoardPosition?
    
    
    //MARK: Board Operations
    
    mutating func takeTurnAtPosition(position:BoardPosition) throws {

        let marker = nextPlayersMarker()

        try checkAddMarker(marker, atPosition: position)
        
        lastTurn = position
        
        board[position.rawValue] = marker
    }
    
    //MARK: Board Analysis
    
    func hasCompleteLine() -> Bool{
        return linesForContigousMarkerCount(3).isEmpty == false
    }
    
    func linesForContigousMarkerCount(count: Int) -> [BoardLine] {
        
        var result = [BoardLine]()
        
        for line in TicTacToeBoard.lines {
            
            var marker: BoardMarker?
            var contigousMarkerCount = 0
            
            for position in line {
                
                let aMarker = board[position.rawValue]
                
                if marker == nil && aMarker != .None {
                    marker = aMarker
                }
                
                if marker == aMarker {
                    contigousMarkerCount++
                }
                
            }
            
            if contigousMarkerCount == count {
                result.append(line)
            }
            
        }
        
        return result
        
    }
    
    func isFull() -> Bool {
        return board.contains(.None) == false
    }
    
    func boardPositionIsEmpty(position: BoardPosition) -> Bool {
        return board[position.rawValue] == .None
    }
    
    func lastPlayersBoardPosition() -> BoardPosition? {
        
        let nextMarker = nextPlayersMarker()
        var lastMarker: BoardMarker?
        
        switch nextMarker {
        case .Nought:
            lastMarker = .Cross
        case .Cross:
            lastMarker = .Nought
        case .None:
            lastMarker = nil
        }
        
        if let lastMarker = lastMarker, indexOfLastMarker = board.indexOf(lastMarker) {
            return BoardPosition(rawValue: indexOfLastMarker)!
        } else {
            return nil
        }
    }
    
    //MARK: Private Helpers
    
    private func nextPlayersMarker() -> BoardMarker {
        let even = emptyPositions.count % 2  == 0
        return even ? .Nought : .Cross
    }
    
    private func checkAddMarker(marker: BoardMarker, atPosition position: BoardPosition) throws {
        
        guard boardPositionIsEmpty(position) else {
            throw BoardError.BoardPositionTaken
        }
        
        guard markerIsExpectedNextMarker(marker) else {
            throw BoardError.InvalidMove
        }
    }
    
    private func markerIsExpectedNextMarker(marker: BoardMarker) -> Bool {
        guard let lastTurn = lastTurn else { return true }
        return marker != board[lastTurn.rawValue]
    }
    
 

}