import XCTest
@testable import TicTacToe

class GameTreeBotTests: XCTestCase, TicTacToeTestCase {

    var view: GameView!
    var game: TicTacToe!
    
    override func setUp() {
        super.setUp()
        newGame(.ComputerVersusHuman, bot: TicTacToeMinimaxBot())
    }
    
    // MARK:- Performance Tests (keep the bot fast)
    
    func testGivenMeasureBlock_WhenBotTakesFirstTurn_MeasureBotPerformance() {
        measureBlock { () -> Void in
            self.newGame(.ComputerVersusHuman, bot: TicTacToeMinimaxBot())
        }
    }
    
    func testGivenMeasureBlock_WhenBotTakesSecondTurn_MeasureBotPerformance() {
        measureBlock { () -> Void in
            if let position = self.view.gameBoard.emptyPositions.first {
            self.game.takeTurnAtPosition(position)
            }
        }
    }
    
    func testGivenView_WhenNewComputerVersusHumanGameStarted_ThenPlayerOneUp() {
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerOneUp)
    }
    
    func testGivenView_WhenNewComputerVersusHumanGameStarted_ThenLastTurnNotNil() {
        XCTAssertNotNil(view.gameBoard.lastTurn)
    }
    
    // MARK:- First Move Tests
    
    func testGivenView_WhenBotTakesFirstTurn_FirstTurnEqualsCorner() {
        XCTAssertTrue(view.gameBoard.lastTurn!.isCorner)
    }
    

}
