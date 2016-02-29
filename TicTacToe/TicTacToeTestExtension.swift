import XCTest

@testable import TicTacToe

protocol TicTacToeTestCase: class {
    var view: GameViewSpy! { get set }
    var game: TicTacToe! { get set }
}

extension TicTacToeTestCase where Self: XCTestCase{
    
    func takeTurnsAtPositions(positions: [BoardPosition.RawValue]) {
        
        for (index, p) in positions.enumerate() {
            assertTurnCanBeTaken(index)
            game.takeTurnAtPosition(p)
        }
    }
    
    func assertTurnCanBeTaken(turn: Int) {
        
        switch game.gameType {
        case .HumanVersusHuman:
            let expectedGameState: GameState = (turn % 2 == 0) ? .PlayerOneUp : .PlayerTwoUp
            XCTAssertEqual(view.gameState, expectedGameState)
        case .HumanVersusComputer:
            XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
        }
    }

}
