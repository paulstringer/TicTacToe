import Foundation

public enum BoardPosition: Int {
    case topLeft = 0
    case topMiddle = 1
    case topRight = 2
    case middleLeft = 3
    case middle = 4
    case middleRight = 5
    case bottomLeft = 6
    case bottomMiddle = 7
    case bottomRight = 8
}

enum BoardMarker {
    case none
    case nought
    case cross
}

enum BoardError: Error {
    case positionTaken
    case invalidMove
}

typealias BoardLine = [BoardPosition]

struct TicTacToeBoard: GameBoard {
    
    fileprivate static let NewBoard: [BoardMarker] = [.none, .none, .none, .none, .none, .none, .none, .none, .none]
    
    //MARK: Game Board
    
    var markers: [BoardMarker]
    
    var lastTurn: BoardPosition?
    
    var winningLine: BoardLine? {
        
        get {
            return BoardAnalyzer.victory(self).line
        }
    }
    
    init(markers: [BoardMarker] = TicTacToeBoard.NewBoard) {
        
        self.markers = markers
        
        self.lastTurn = BoardAnalyzer.lastPlayedPosition(self)
    }
    
    //MARK: Board Actions
    
    mutating func takeTurnAtPosition(_ position:BoardPosition) throws {

        let marker = BoardAnalyzer.nextMarker(self)

        try canAddMarker(marker, atPosition: position)
        
        lastTurn = position
        
        markers[position.rawValue] = marker
    }
    
    //MARK: Private
    
    fileprivate func canAddMarker(_ marker: BoardMarker, atPosition position: BoardPosition) throws {
        
        guard BoardAnalyzer.isEmpty(self, position: position) else {
            throw BoardError.positionTaken
        }
        
        guard BoardAnalyzer.nextMarker(self) == marker else {
            throw BoardError.invalidMove
        }
    }

}
