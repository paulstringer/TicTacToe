import Foundation

private typealias BoardPositionTransform = (BoardPosition) -> (BoardPosition?)

struct HeuristicGameBot: GameBot {
    
    func nextMove(_ board: GameBoard, completion:GameBotCompletion) {

        if board.lastTurn == nil {
            return completion(.topLeft)
        }
        
        if let position = BoardAnalyzer.emptyWinningPosition(board) {
            return completion(position)
        }
        
        if let position = emptyOppositeCorner(board) {
            return completion(position)
        }
        
        if BoardAnalyzer.isEmpty(board, position: .middle) {
            return completion(.middle)
        }
            
        if let position = emptyOppositeCorner(board) {
            return completion(position)
        }
            
        if let position = bestEmptyPosition(board) {
            return completion(position)
        }
            
        completion(BoardAnalyzer.emptyPositions(board).first!)
        
    }
    
    fileprivate func bestEmptyPosition(_ board: GameBoard) -> BoardPosition? {
        
        let didCaptureCenterGround =  BoardAnalyzer.nextPlayersMarkedPositions(board).contains(.middle)
        
        for position in BoardAnalyzer.emptyPositions(board) {
            
            if didCaptureCenterGround && position.isEdge {
                return position
            } else if position.isCorner {
                return position
            }
        }
        
        return nil
    }
    
    fileprivate func emptyCorner(_ board: GameBoard) -> BoardPosition? {

        let emptyCorners = BoardAnalyzer.emptyPositions(board).filter({ (position) -> Bool in
            return position.isCorner
        })
        
        return emptyCorners.first
    }
    
    fileprivate func emptyOppositeCorner(_ board: GameBoard) -> BoardPosition? {
        
        if let result = emptyOppositePosition(board, transform: { (position) in return position.diagonalOpposite } ) {
            return result
        }
        
        if let result = emptyOppositePosition(board, transform: { (position) in return position.horizontalOpposite } ) {
            return result
        }
        
        if let result = emptyOppositePosition(board, transform: { (position) in return position.verticalOpposite } ) {
            return result
        }
        
        return nil
    }
    
    
    fileprivate func emptyOppositePosition(_ board: GameBoard, transform: @escaping BoardPositionTransform ) -> BoardPosition? {
        
        let myPositions = BoardAnalyzer.nextPlayersMarkedPositions(board)
        let empties = BoardAnalyzer.emptyPositions(board)
        var result: BoardPosition?
        
        myPositions.forEach { (position) -> () in
            if let opposite = transform(position) {
                if empties.contains(opposite)  {
                    result = opposite
                }
            }
        }
        
        return result
    }
    

}

extension BoardPosition {
    
    var isCorner: Bool {
        get {
            return [ topLeft, topRight, bottomLeft, bottomRight].contains(self)
        }
    }
    
    var isEdge: Bool {
        get {
            return [ middleLeft, topMiddle, middleRight, bottomMiddle].contains(self)
        }
    }
    
    var isMiddle: Bool {
        get {
            return self == middle
        }
    }
    
    var diagonalOpposite: BoardPosition?{
        
        get {
            switch (self) {
            case .topLeft:
                return .bottomRight
            case .bottomRight:
                return .topLeft
            case .topRight:
                return .bottomLeft
            case .bottomLeft:
                return .topRight
            default:
                return nil
            }
        }
    }
    
    var verticalOpposite: BoardPosition?{
        
        get {
            switch (self) {
            case .topLeft:
                return .bottomLeft
            case .topRight:
                return .bottomRight
            case .bottomLeft:
                return .topLeft
            case .bottomRight:
                return .topRight
            default:
                return nil
            }
        }
    }
    
    var horizontalOpposite: BoardPosition?{
        
        get {
            switch (self) {
            case .topLeft:
                return .topRight
            case .topRight:
                return .topLeft
            case .bottomLeft:
                return .bottomRight
            case .bottomRight:
                return .bottomLeft
            default:
                return nil
            }
        }
    }
    
}
