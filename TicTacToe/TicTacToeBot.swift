//
//  Copyright © 2016 stringerstheory. All rights reserved.
//

import Foundation

struct TicTacToeBot {
    
    private var myTurns = [BoardPosition]()
    
    mutating func turnTakenAtBoardPosition(position: BoardPosition) {
        myTurns.append(position)
    }
    
    func nextMove(board: TicTacToeBoard) -> BoardPosition {
        
        guard let lastTurn = board.lastTurn else {
            return .TopLeft
        }
        
        if lastTurn.isCorner && board.boardPositionIsEmpty(.Middle) {
            return .Middle
        }
        
        if let position = emptyPositionForNextWinningLine(board) {
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
