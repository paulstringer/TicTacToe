//
//  Copyright © 2016 stringerstheory. All rights reserved.
//

import Foundation

struct TicTacToeBot {
    private var didTakeFirstTurn = false
    private var myTurns = [BoardPosition]()
    
    mutating func turnTakenAtBoardPosition(position: BoardPosition) {
        myTurns.append(position)
    }
    
    mutating func nextMove(board: TicTacToeBoard) -> BoardPosition {
        
        guard let _ = board.lastTurn else {
            didTakeFirstTurn = true
            return .TopLeft
        }
        
        if let position = emptyPositionForNextWinningLine(board) {
            return position
        }
        
        if didTakeFirstTurn == true, let position = emptyOppositeCorner(board) {
            return position
        }
        
        if didTakeFirstTurn == true, let position = emptyCorner(board) {
            return position
        }
        
        if board.boardPositionIsEmpty(.Middle) {
            return .Middle
        }
    
        if let position = emptyOppositeCorner(board) {
            return position
        }
        
        if let position = hint(board) {
            return position
        }
        
        return board.emptyPositions[0]
        
    }

    private func hint(board: TicTacToeBoard) -> BoardPosition? {
        
        let didCaptureCenterGround = myTurns.contains(.Middle)
        
        for position in board.emptyPositions {
            
            if didCaptureCenterGround && position.isEdge {
                return position
            } else if position.isCorner {
                return position
            }
        }
        
        return nil
    }
    
    private func emptyCorner(board: TicTacToeBoard) -> BoardPosition? {

        let emptyCorners = board.emptyPositions.filter({ (position) -> Bool in
            return position.isCorner
        })
        
        if board.emptyPositions.contains(.Middle) == false {
            return emptyCorners.first
        }
        
        return emptyCorners.first
    }
    
    private func emptyOppositeCorner(board: TicTacToeBoard) -> BoardPosition? {
        
        var result: BoardPosition?
        
        myTurns.forEach { (turn) -> () in
            if let opposite = turn.diagonalOpposite {
                if board.emptyPositions.contains(opposite)  {
                    result = opposite
                    return
                }
            }
        }
        
        if result == nil {
        
            myTurns.forEach { (turn) -> () in
                if let opposite = turn.horizontalOppositeCorner {
                    if board.emptyPositions.contains(opposite)  {
                        result = opposite
                        return
                    }
                }
            }
        
        }
        
        if result == nil {

            myTurns.forEach { (turn) -> () in
                if let opposite = turn.verticalOppositeCorner {
                    if board.emptyPositions.contains(opposite)  {
                        result = opposite
                        return
                    }
                }
            }
        }
        
        return result
    }
    
    private func emptyPositionForNextWinningLine(board: TicTacToeBoard) -> BoardPosition? {
        
        let lines = board.linesForContigousMarkerCount(2)
        
        var candidates = [BoardPosition]()
        
        for line in lines {
            for position in line {
                if board.boardPositionIsEmpty(position) {
                    candidates.append(position)
                }
            }
        }
        
        candidates.sortInPlace() { (a, b) -> Bool in
            var virtualBoard = board
            do {
                try virtualBoard.takeTurnAtPosition(a)
                return virtualBoard.hasCompleteLine()
            } catch {
                return false
            }
            
        }
        
        return candidates.first
    }
    
}
