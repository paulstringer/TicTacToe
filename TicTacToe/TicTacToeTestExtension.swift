import XCTest

@testable import TicTacToe

protocol GameTestCase: class {
    
    var view: GameView! { get set }
    var game: Game! { get set }
    
    var bot: GameBot? { get }
    var type: GameType { get }
}

extension GameTestCase {

    func setUpGame(markers: [BoardMarker]? = nil) {

        self.view = GameViewSpy()
        self.game = newGame(markers)
    }

    private func newGame(markers: [BoardMarker]?) -> Game {
        
        let gameBuilder = GameBuilder(gameType: type)
        let game = gameBuilder.gameWithView(view, markers: markers)
        
        if let game = game as? TicTacToe, let bot = self.bot {
            game.bot = bot
        }
//        if let bot = self.bot { game.bot = bot }
        
        return game
        
    }
    
}

extension GameBoard {
    
    var noughts: Int {
        get {
            return markers.filter { (marker) in return marker == .Nought }.count
        }
    }
    
    var crosses: Int {
        get {
            return markers.filter { (marker) in return marker == .Cross }.count
        }
    }
    
    var emptyPositions: [BoardPosition] {
        
        return BoardAnalyzer.emptyPositions(self)
        
    }
    
}