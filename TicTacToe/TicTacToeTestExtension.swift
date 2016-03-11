import XCTest

@testable import TicTacToe

protocol GameTestCase: class {
    
    var view: GameView! { get set }
    var game: TicTacToe! { get set }
    
    var bot: TicTacToeBot? { get }
    var type: GameType { get }
}

extension GameTestCase {

    func setUpGame(markers: [BoardMarker]? = nil) {

        self.view = GameViewSpy()
        prepareGame(markers)
        game.newGame(type)
    }

    private func prepareGame(markers: [BoardMarker]?) {
        
        if let markers = markers {
            let board = TicTacToeBoard(board:markers)
            self.game = TicTacToe(view: view, board: board)
        } else {
            self.game = TicTacToe(view: view)
        }
        
        if let bot = self.bot {
            game.bot = bot
        }
        
    }
    
}

extension GameBoard {
    
    var noughts: Int {
        get {
            return board.filter { (marker) in return marker == .Nought }.count
        }
    }
    
    var crosses: Int {
        get {
            return board.filter { (marker) in return marker == .Cross }.count
        }
    }
    
}
