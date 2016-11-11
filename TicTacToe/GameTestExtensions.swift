import XCTest

@testable import TicTacToe

protocol GameTestCase: class {
    
    var view: GameView! { get set }
    var game: Game! { get set }
    
    var bot: GameBot? { get }
    var type: GameType { get }
}

extension GameTestCase {

    func setUpGame(_ markers: [BoardMarker]? = nil) {

        self.view = GameViewSpy()
        self.game = newGame(markers)
    }

    fileprivate func newGame(_ markers: [BoardMarker]?) -> Game {
        
        let gameFactory = (self.bot != nil) ? GameFactory(gameType: type, bot: bot!) : GameFactory(gameType: type)
        let game = gameFactory.gameWithView(view, markers: markers)
        return game
        
    }
    
}

extension GameBoard {
    
    var noughts: Int {
        get {
            return markers.filter { (marker) in return marker == .nought }.count
        }
    }
    
    var crosses: Int {
        get {
            return markers.filter { (marker) in return marker == .cross }.count
        }
    }
    
    var emptyPositions: [BoardPosition] {
        
        return BoardAnalyzer.emptyPositions(self)
        
    }
    
}
