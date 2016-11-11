import Foundation

struct BoardAnalyzer {
    
    //MARK: Board Rules
    
    static func victory(_ board: GameBoard) ->  (result: Bool, line: BoardLine?) {
        return BoardAnalyzerMetrics.hasCompleteLine(board)
    }
    
    static func stalemate(_ board: GameBoard) -> Bool {
        return board.markers.contains(.none) == false
    }
    
    static func nextMarker(_ board: GameBoard) -> BoardMarker {
        let even = emptyPositions(board).count % 2  == 0
        return even ? .nought : .cross
    }
    
    //MARK: - Positions
    
    static func isEmpty(_ board: GameBoard, position: BoardPosition) -> Bool {
        let marker = board.markers[position.rawValue]
        return marker == .none
    }
    
    static func nextPlayersMarkedPositions(_ board: GameBoard) -> [BoardPosition] {
        
        let playersMarker = nextMarker(board)
        
        var positions = [BoardPosition]()
        
        for (index, marker) in board.markers.enumerated() {

            if marker == playersMarker {
                let position = BoardPosition(rawValue: index)!
                positions.append(position)
            }
            
        }
        return positions
    }
    
    static func lastPlayedPosition(_ board: GameBoard) -> BoardPosition? {
        
        let marker = nextMarker(board)
        var lastMarker: BoardMarker?
        
        switch marker {
        case .nought:
            lastMarker = .cross
        case .cross:
            lastMarker = .nought
        case .none:
            lastMarker = nil
        }
        
        if let lastMarker = lastMarker, let indexOfLastMarker = board.markers.index(of: lastMarker) {
            return BoardPosition(rawValue: indexOfLastMarker)!
        } else {
            return nil
        }
        
    }

    static func emptyPositions(_ board: GameBoard) -> [BoardPosition]{
        
        var positions = [BoardPosition]()
        for (index, marker) in board.markers.enumerated() {
            if marker == .none {
                let position = BoardPosition(rawValue: index)!
                positions.append(position)
            }
        }
        return positions
        
    }
    
    static func emptyWinningPosition(_ board: GameBoard) -> BoardPosition? {
        
        let lines = BoardAnalyzerMetrics.linesForMarkerCount(2, forBoard: board)
        
        var candidates = [BoardPosition]()
        
        for line in lines {
            for position in line {
                if isEmpty(board, position: position) == true {
                    candidates.append(position)
                }
            }
        }
        
        candidates.sort() { (a, b) -> Bool in
            var tryOutBoard = TicTacToeBoard(markers: board.markers)
            do {
                try tryOutBoard.takeTurnAtPosition(a)
                return BoardAnalyzer.victory(tryOutBoard).result
            } catch {
                return false
            }
            
        }
        
        return candidates.first
    }
    
    
}

//MARK: - Private Functions

private struct BoardAnalyzerMetrics {
    
    static fileprivate let lines: [BoardLine]  = {
        
        var result = [ [BoardPosition] ]()
        
        // Diagonals
        result.append([.topLeft,.middle,.bottomRight])
        result.append([.topRight,.middle, .bottomLeft])
        
        // Columns
        result.append([.topLeft,.middleLeft,.bottomLeft])
        result.append([.topMiddle,.middle,.bottomMiddle])
        result.append([.topRight,.middleRight,.bottomRight])
        
        // Rows
        result.append([.topLeft,.topMiddle,.topRight])
        result.append([.middleLeft,.middle,.middleRight])
        result.append([.bottomLeft,.bottomMiddle,.bottomRight])
        
        return result
        
        
    }()
    
    static fileprivate func hasCompleteLine(_ board: GameBoard) -> (result: Bool, line: BoardLine?){
        let lines = linesContainingSameMarkerCount(3, board: board)
        return (!lines.isEmpty, lines.first)
    }
    
    static func linesForMarkerCount(_ markerCount: Int, forBoard board: GameBoard) -> [BoardLine] {
        return linesContainingSameMarkerCount(markerCount, board: board)
    }
    
    static fileprivate func linesContainingSameMarkerCount(_ count: Int, board: GameBoard) -> [BoardLine] {
        
        var result = [BoardLine]()
        
        for line in BoardAnalyzerMetrics.lines {
            
            var marker: BoardMarker?
            var numberOfMarkers = 0
            
            for position in line {
                
                let aMarker = board.markers[position.rawValue]
                
                if marker == nil && aMarker != .none {
                    marker = aMarker
                }
                
                if marker == aMarker {
                    numberOfMarkers += 1
                }
                
            }
            
            if numberOfMarkers == count {
                result.append(line)
            }
            
        }
        
        return result
        
    }


    
}
