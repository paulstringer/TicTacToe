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

typealias Line = [BoardPosition]

struct TicTacToeBoard: GameBoard {
    
    private var board: [BoardMarker] = [.None, .None, .None, .None, .None, .None, .None, .None, .None]
    
    private let lines: [Line]  = {
        
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
    
    
    //MARK: Game Board
    
    var lastTurn: BoardPosition?

    var markers: [BoardMarker] {
        
        get {
            return board
        }
        
    }
    
    //MARK: Board Operations
    
    mutating func takeTurnAtPosition(position:BoardPosition) throws {

        let marker = nextPlayersMarker()

        try checkAddMarker(marker, atPosition: position)
        
        lastTurn = position
        
        board[position.rawValue] = marker
    }
    
    //MARK: Board Checks
    
    func hasCompleteLine() -> Bool{
        return linesForContigousMarkerCount(3).isEmpty == false
    }
    
    func linesForContigousMarkerCount(count: Int) -> [Line] {
        
        var result = [Line]()
        
        for line in lines {
            
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
    
    //MARK: Private Helpers
    
    private func nextPlayersMarker() -> BoardMarker {
        
        guard let lastTurn = lastTurn else {
            return .Nought
        }
        
        let lastPlayersMarker = board[lastTurn.rawValue]
        
        switch (lastPlayersMarker) {
        case .Cross:
            return .Nought
        case .Nought:
            return .Cross
        default:
            return .Nought
        }
            
        
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