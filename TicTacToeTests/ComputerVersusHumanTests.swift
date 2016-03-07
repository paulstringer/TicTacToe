import XCTest

@testable import TicTacToe
class ComputerVersusHumanTests: XCTestCase {

    var view: GameView!
    var game: TicTacToe!
    
    override func setUp() {
        view = GameViewSpy()
        game = TicTacToe(view: view)
        game.newGame(.ComputerVersusHuman)
    }


    //MARK:- Computer V Human Tests
    
    func testGivenView_WhenTicTacToeInitialised_ThenViewsGameTypesContainsComputerVersusHuman() {
        XCTAssertTrue(view.gameTypes.contains(.ComputerVersusHuman))
    }
    
    func testGivenView_WhenNewComputerVersusHumanGameStarted_ThenPlayerOneUp() {
        XCTAssertEqual(view.gameStatus, GameStatus.PlayerOneUp)
    }
    
    func testGivenView_WhenNewComputerVersusHumanGameStarted_ThenLastTurnNotNil() {
        XCTAssertNotNil(view.gameBoard.lastTurn)
    }
    
    
}
