import XCTest

@testable import TicTacToe

protocol TicTacToeTestCase: class {
    var view: GameViewSpy! { get set }
    var game: TicTacToe! { get set }
}

extension TicTacToeTestCase {
    
    func takeTurnsAtPositions(positions: [BoardPosition.RawValue]) {
        
        for position in positions {
            game.takeTurnAtPosition(position)
        }
    }


}
