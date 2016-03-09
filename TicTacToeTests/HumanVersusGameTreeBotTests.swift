import XCTest
@testable import TicTacToe

class HumanVersusGameTreeBotTests: XCTestCase, TicTacToeTestCase {

    var view: GameView!
    var game: TicTacToe!
    var bot: TicTacToeBot?
    
    override func setUp() {
        super.setUp()
        newGame(.HumanVersusComputer, bot: TicTacToeGameTreeBot())
    }
    
    //MARK:- Human V Computer Basic Setup Tests
    
    func testGivenView_WhenInitialised_ThenViewsGameTypesContainsHumanVersusComputer() {
        XCTAssertTrue(view.gameTypes.contains(.HumanVersusComputer))
    }
    
    func testGivenView_WhenNewHumanVersusComputerGameStarted_ThenPlayerOneUp() {
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerOneUp)
    }
    
    func testGivenView_WhenNewHumanVersusComputerGameStarted_ThenLastTurnIsNil() {
        XCTAssertNil(view.gameBoard.lastTurn)
    }
    
    //TODO:- Test a computer responds to human moves to always win or tie
    
}
