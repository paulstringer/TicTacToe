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

enum BoardMarker {
    case None
    case Nought
    case Cross
}

enum TicTacToeBoardError: ErrorType {
    case BoardPositionTaken
}

private let LineCompleteMarkerCount = 3

struct TicTacToeBoard {
    
    private var board: [BoardMarker] = [.None, .None, .None, .None, .None, .None, .None, .None, .None]
    
    private let lines: [[Int]]  = {
        
        var result = [ [Int] ]()
        
        // Diaganals
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
    
    mutating func addMarker(marker: BoardMarker, atPosition position:BoardPosition) throws {
        guard canAddMarkerAtPosition(position) else {
            throw TicTacToeBoardError.BoardPositionTaken
        }
        board[position.rawValue] = marker
    }
    
    private func canAddMarkerAtPosition(position: BoardPosition) -> Bool{
        return board[position.rawValue] == .None
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