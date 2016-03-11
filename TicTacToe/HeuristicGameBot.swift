//
//  Copyright © 2016 stringerstheory. All rights reserved.
//

import Foundation

struct HeuristicGameBot: GameBot {
    
    private var didTakeFirstTurn = false
    private var myTurns = [BoardPosition]()
    
    mutating func turnTakenAtBoardPosition(position: BoardPosition) {
        myTurns.append(position)
    }
    
    mutating func nextMove(board: GameBoard) -> BoardPosition {
        
        guard let _ = board.lastTurn else {
            didTakeFirstTurn = true
            return .TopLeft
        }
        
        if let position = emptyPositionForNextWinningLine(board) {
            return position
        }
        
        if let position = emptyOppositeCorner(board) {
            return position
        }
        
        if didTakeFirstTurn == true, let position = emptyCorner(board) {
            return position
        }
        
        if BoardAnalyzer.board(board, positionEmpty: .Middle) {
            return .Middle
        }
    
        if let position = emptyOppositeCorner(board) {
            return position
        }
        
        if let position = hint(board) {
            return position
        }
        
        return BoardAnalyzer.emptyPositions(board).first!
        
    }

    private func hint(board: GameBoard) -> BoardPosition? {
        
        let didCaptureCenterGround = myTurns.contains(.Middle)
        
        for position in BoardAnalyzer.emptyPositions(board) {
            
            if didCaptureCenterGround && position.isEdge {
                return position
            } else if position.isCorner {
                return position
            }
        }
        
        return nil
    }
    
    private func emptyCorner(board: GameBoard) -> BoardPosition? {

        let emptyCorners = BoardAnalyzer.emptyPositions(board).filter({ (position) -> Bool in
            return position.isCorner
        })
        
        return emptyCorners.first
    }
    
    private func emptyOppositeCorner(board: GameBoard) -> BoardPosition? {
        
        var result: BoardPosition?
        let empties = BoardAnalyzer.emptyPositions(board)
        
        myTurns.forEach { (turn) -> () in
            if let opposite = turn.diagonalOpposite {
                if empties.contains(opposite)  {
                    result = opposite
                    return
                }
            }
        }
        
        if result == nil {
        
            myTurns.forEach { (turn) -> () in
                if let opposite = turn.horizontalOppositeCorner {
                    if empties.contains(opposite)  {
                        result = opposite
                        return
                    }
                }
            }
        
        }
        
        if result == nil {

            myTurns.forEach { (turn) -> () in
                if let opposite = turn.verticalOppositeCorner {
                    if empties.contains(opposite)  {
                        result = opposite
                        return
                    }
                }
            }
        }
        
        return result
    }
    
    
    // BOARD ANALZER FEATURE ENVY
    
    private func emptyPositionForNextWinningLine(board: GameBoard) -> BoardPosition? {
        
        let lines = BoardAnalyzer.linesForMarkerCount(2, forBoard: board)
        
        var candidates = [BoardPosition]()
        
        for line in lines {
            for position in line {
                if BoardAnalyzer.board(board, positionEmpty: position) == true {
                    candidates.append(position)
                }
            }
        }
        
        candidates.sortInPlace() { (a, b) -> Bool in
            var tryOutBoard = TicTacToeBoard(board: board.board)
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
