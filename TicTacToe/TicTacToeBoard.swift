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
    
    static let allValues = [TopLeft.rawValue, TopMiddle.rawValue, TopRight.rawValue, MiddleLeft.rawValue, Middle.rawValue, MiddleRight.rawValue, BottomLeft.rawValue, BottomMiddle.rawValue, BottomRight.rawValue]
    
    
    var isCorner: Bool {
        get {
            return [0,2,6,8].contains(self.rawValue)
        }
    }

    var isEdge: Bool {
        get {
            return [
                BoardPosition.MiddleLeft,
                BoardPosition.TopMiddle,
                BoardPosition.MiddleRight,
                BoardPosition.BottomMiddle].contains(self)
        }
    }
}

enum BoardMarker {
    case None
    case Nought
    case Cross
}

enum TicTacToeBoardError: ErrorType {
    case BoardPositionTaken
    case InvalidMove
}

typealias Line = [Int]

private let LineCompleteMarkerCount = 3

struct TicTacToeBoard: BoardView {
    
    private var board: [BoardMarker] = [.None, .None, .None, .None, .None, .None, .None, .None, .None]
    
    private let lines: [Line]  = {
        
        var result = [ [Int] ]()
        
        // Diagonals
        result.append([0,4,8])
        result.append([2,4,6])
        
        // Columns
        result.append([0,3,6])
        result.append([1,4,7])
        result.append([2,5,8])
        
        // Rows
        result.append([0,1,2])
        result.append([3,4,5])
        result.append([6,7,8])
        
        return result
        
        
    }()
    
    var lastTurn: BoardPosition?

    var markers: [BoardMarker] {
        get {
            return board
        }
    }
    mutating func takeTurnAtPosition(position:BoardPosition) throws {

        let marker = nextBoardMarker()

        try checkAddMarker(marker, atPosition: position)
        
        lastTurn = position
        
        board[position.rawValue] = marker
    }
    
    private func nextBoardMarker() -> BoardMarker {
        if let lastTurn = lastTurn {
            switch (board[lastTurn.rawValue]) {
            case .Cross:
                return .Nought
            case .Nought:
                return .Cross
            default:
                return .Nought
            }
        } else {
            return .Nought
        }
    }
    
    private func checkAddMarker(marker: BoardMarker, atPosition position: BoardPosition) throws {
        guard boardPositionIsEmpty(position) else {
            throw TicTacToeBoardError.BoardPositionTaken
        }
        guard markerIsExpectedNextMarker(marker) else {
            throw TicTacToeBoardError.InvalidMove
        }
    }
    
    func boardPositionIsEmpty(position: BoardPosition) -> Bool {
        return board[position.rawValue] == .None
    }
    
    private func markerIsExpectedNextMarker(marker: BoardMarker) -> Bool {
        guard let lastTurn = lastTurn else { return true }
        return marker != board[lastTurn.rawValue]
    }
    
    func hasCompleteLine() -> Bool{
        return linesWithCount(LineCompleteMarkerCount).isEmpty == false
    }
    
    func linesWithCount(count: Int) -> [Line] {
        
        var result = [Line]()
        
        for line in lines {
            
            var marker: BoardMarker?
            var contigousMarkerCount = 0
            
            for index in line {
                
                let aMarker = board[index]
                
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

}