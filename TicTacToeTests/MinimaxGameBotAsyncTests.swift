import XCTest
@testable import TicTacToe

class MinimaxGameBotAsyncTests: XCTestCase, GameTestCase {

    var view: GameView!
    var game: Game!
    var bot: GameBot? = MinimaxGameBot(testable: false)
    var type: GameType = .HumanVersusComputer
    
    override func setUp() {
        super.setUp()
        setUpGame()
    }
    
    func testGivenGame_WhenBotMoveInProgress_ThenDoesNotTakeTurns() {
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(1)
        XCTAssertNotEqual(view.gameBoard.lastTurn, BoardPosition(rawValue: 1))
    }
}
