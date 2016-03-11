import Foundation

typealias BoardPositionTransform = (BoardPosition) -> (BoardPosition?)

struct HeuristicGameBot: GameBot {

    func nextMove(board: GameBoard) -> BoardPosition {

        if board.lastTurn == nil {
            return .TopLeft
        }
        

        if let position = BoardAnalyzer.emptyWinningPosition(board) {
            return position
        }
        
        if let position = emptyOppositeCorner(board) {
            return position
        }
        
        if BoardAnalyzer.isEmpty(board, position: .Middle) {
            return .Middle
        }
            
        if let position = emptyOppositeCorner(board) {
            return position
        }
            
        if let position = bestEmptyPosition(board) {
            return position
        }
            
        return BoardAnalyzer.emptyPositions(board).first!
        
        
    }
    
    private func bestEmptyPosition(board: GameBoard) -> BoardPosition? {
        
        let didCaptureCenterGround =  BoardAnalyzer.nextPlayersMarkedPositions(board).contains(.Middle)
        
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
    
    
    private func emptyOppositePosition(board: GameBoard, transform: BoardPositionTransform ) -> BoardPosition? {
        
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
    
    var diagonalOpposite: BoardPosition?{
        
        get {
            switch (self) {
            case .TopLeft:
                return .BottomRight
            case .BottomRight:
                return .TopLeft
            case .TopRight:
                return .BottomLeft
            case .BottomLeft:
                return .TopRight
            default:
                return nil
            }
        }
    }
    
    var verticalOpposite: BoardPosition?{
        
        get {
            switch (self) {
            case .TopLeft:
                return .BottomLeft
            case .TopRight:
                return .BottomRight
            case .BottomLeft:
                return .TopLeft
            case .BottomRight:
                return .TopRight
            default:
                return nil
            }
        }
    }
    
    var horizontalOpposite: BoardPosition?{
        
        get {
            switch (self) {
            case .TopLeft:
                return .TopRight
            case .TopRight:
                return .TopLeft
            case .BottomLeft:
                return .BottomRight
            case .BottomRight:
                return .BottomLeft
            default:
                return nil
            }
        }
    }
    
}