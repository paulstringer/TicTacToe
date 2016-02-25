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

private let LineCompleteMarkerCount = 3

struct TicTacToeBoard: BoardView {
    
    private var board: [BoardMarker] = [.None, .None, .None, .None, .None, .None, .None, .None, .None]
    
    private let lines: [[Int]]  = {
        
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
    mutating func addMarker(marker: BoardMarker, atPosition position:BoardPosition) throws {
        try checkAddMarker(marker, atPosition: position)
        lastTurn = position
        board[position.rawValue] = marker
    }
    
    private func checkAddMarker(marker: BoardMarker, atPosition position: BoardPosition) throws {
        guard boardPositionIsEmpty(position) else {
            throw TicTacToeBoardError.BoardPositionTaken
        }
        guard markerIsExpectedNextMarker(marker) else {
            throw TicTacToeBoardError.InvalidMove
        }
    }
    
    private func boardPositionIsEmpty(position: BoardPosition) -> Bool {
        return board[position.rawValue] == .None
    }
    
    private func markerIsExpectedNextMarker(marker: BoardMarker) -> Bool {
        guard let lastTurn = lastTurn else { return true }
        return marker != board[lastTurn.rawValue]
    }
    
    func hasCompleteLine() -> Bool{
        
        for line in lines {

            var marker: BoardMarker?
            var contigousMarkerCount = 0
            
            for index in line {

                let nextMarker = board[index]
                
                if marker == nil {
                    marker = nextMarker
                }
                
                if nextMarker == .None {
                    break
                }
                
                if marker == nextMarker {
                    contigousMarkerCount++
                } else {
                    break
                }
            
                if contigousMarkerCount == LineCompleteMarkerCount {
                    return true
                }
    
            }
        
            
        }
        
        return false
    }
    
    func isFull() -> Bool {
        return board.contains(.None) == false
    }
    

}