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

enum BoardError: ErrorType {
    case PositionTaken
    case InvalidMove
}

typealias BoardLine = [BoardPosition]

struct TicTacToeBoard: GameBoard {
    
    private static let newMarkers: [BoardMarker] = [.None, .None, .None, .None, .None, .None, .None, .None, .None]
    
    //MARK: Game Board
    
    var markers: [BoardMarker]
    
    var lastTurn: BoardPosition?
    
    init(markers: [BoardMarker] = TicTacToeBoard.newMarkers) {
        self.markers = markers
        self.lastTurn = BoardAnalyzer.lastPlayedPosition(self)
    }
    
    //MARK: Board Operations
    
    mutating func takeTurnAtPosition(position:BoardPosition) throws {

        let marker = BoardAnalyzer.nextMarker(self)

        try canAddMarker(marker, atPosition: position)
        
        lastTurn = position
        
        markers[position.rawValue] = marker
    }
    
    //MARK: Private Helpers
    
    private func canAddMarker(marker: BoardMarker, atPosition position: BoardPosition) throws {
        
        guard BoardAnalyzer.isEmpty(self, position: position) else {
            throw BoardError.PositionTaken
        }
        
        guard BoardAnalyzer.nextMarker(self) == marker else {
            throw BoardError.InvalidMove
        }
    }

}