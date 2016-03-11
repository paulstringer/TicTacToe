import Foundation

struct BoardAnalyzer {
    
    static func victory(board: GameBoard) -> Bool {
        return BoardAnalyzerMetrics.hasCompleteLine(board)
    }
    
    static func stalemate(board: GameBoard) -> Bool {
        return board.markers.contains(.None) == false
    }
    
    static func isEmpty(board: GameBoard, position: BoardPosition) -> Bool {
        let marker = board.markers[position.rawValue]
        return marker == .None
    }
    
    static func nextMarker(board: GameBoard) -> BoardMarker {
        let even = emptyPositions(board).count % 2  == 0
        return even ? .Nought : .Cross
    }
    
    static func nextPlayersMarkedPositions(board: GameBoard) -> [BoardPosition] {
        
        let playersMarker = nextMarker(board)
        
        var positions = [BoardPosition]()
        
        for (index, marker) in board.markers.enumerate() {

            if marker == playersMarker {
                let position = BoardPosition(rawValue: index)!
                positions.append(position)
            }
            
        }
        return positions
    }
    
    static func lastPlayedPosition(board: GameBoard) -> BoardPosition? {
        
        let marker = nextMarker(board)
        var lastMarker: BoardMarker?
        
        switch marker {
        case .Nought:
            lastMarker = .Cross
        case .Cross:
            lastMarker = .Nought
        case .None:
            lastMarker = nil
        }
        
        if let lastMarker = lastMarker, indexOfLastMarker = board.markers.indexOf(lastMarker) {
            return BoardPosition(rawValue: indexOfLastMarker)!
        } else {
            return nil
        }
        
    }
    
    static func linesForMarkerCount(markerCount: Int, forBoard board: GameBoard) -> [BoardLine] {
        return BoardAnalyzerMetrics.linesContainingSameMarkerCount(markerCount, board: board)
    }
    
    static func emptyPositions(board: GameBoard) -> [BoardPosition]{
        
        var positions = [BoardPosition]()
        for (index, marker) in board.markers.enumerate() {
            if marker == .None {
                let position = BoardPosition(rawValue: index)!
                positions.append(position)
            }
        }
        return positions
        
    }
    
    static func emptyWinningPosition(board: GameBoard) -> BoardPosition? {
        
        let lines = linesForMarkerCount(2, forBoard: board)
        
        var candidates = [BoardPosition]()
        
        for line in lines {
            for position in line {
                if isEmpty(board, position: position) == true {
                    candidates.append(position)
                }
            }
        }
        
        candidates.sortInPlace() { (a, b) -> Bool in
            var tryOutBoard = TicTacToeBoard(markers: board.markers)
            do {
                try tryOutBoard.takeTurnAtPosition(a)
                return BoardAnalyzer.victory(tryOutBoard)
            } catch {
                return false
            }
            
        }
        
        return candidates.first
    }
    
    
}

private struct BoardAnalyzerMetrics {
    
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
    
    static private func hasCompleteLine(board: GameBoard) -> Bool{
        return linesContainingSameMarkerCount(3, board: board).isEmpty == false
    }
    
    static private func linesContainingSameMarkerCount(count: Int, board: GameBoard) -> [BoardLine] {
        
        var result = [BoardLine]()
        
        for line in BoardAnalyzerMetrics.lines {
            
            var marker: BoardMarker?
            var contigousMarkerCount = 0
            
            for position in line {
                
                let aMarker = board.markers[position.rawValue]
                
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
    

    
}