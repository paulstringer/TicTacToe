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
    
    func opponent() -> BoardMarker {
        
        switch self {
        case .None:
            return .None
        case .Nought:
            return .Cross
        case .Cross:
            return .Nought
        }
    }
}

enum BoardError: ErrorType {
    case BoardPositionTaken
    case InvalidMove
}

typealias BoardLine = [BoardPosition]

struct TicTacToeBoard: GameBoard {
    
    private static let newMarkers: [BoardMarker] = [.None, .None, .None, .None, .None, .None, .None, .None, .None]
    
    var board: [BoardMarker]
    
    init(board: [BoardMarker] = TicTacToeBoard.newMarkers) {
        self.board = board
        self.lastTurn = BoardAnalyzer.lastPlayedPosition(self)
    }
    
    //MARK: Game Board
    
    var lastTurn: BoardPosition?
    
    //MARK: Board Operations
    
    mutating func takeTurnAtPosition(position:BoardPosition) throws {

        let marker = BoardAnalyzer.nextMarker(self)

        try checkAddMarker(marker, atPosition: position)
        
        lastTurn = position
        
        board[position.rawValue] = marker
    }
    
    //MARK: Private Helpers
    
    private func checkAddMarker(marker: BoardMarker, atPosition position: BoardPosition) throws {
        
        guard BoardAnalyzer.isEmpty(self, position: position) else {
            throw BoardError.BoardPositionTaken
        }
        
        guard BoardAnalyzer.nextMarker(self) == marker else {
            throw BoardError.InvalidMove
        }
    }

}