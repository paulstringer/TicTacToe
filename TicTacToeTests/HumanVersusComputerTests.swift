import XCTest
@testable import TicTacToe

class HumanVersusComputerTests: XCTestCase {

    let view = GameViewSpy()
    var game: TicTacToe!
    
    override func setUp() {
        super.setUp()
        game = TicTacToe(view: view)
        game.ready()
        game.gameType = .HumanVersusComputer
    }
    
    //MARK:- Humam V Human Tests
    
    func testGivenGame_WhenReady_ThenViewsGameTypesContainsHumanVersusComputer() {
        XCTAssertTrue(view.gameTypes.contains(.HumanVersusComputer))
    }
    
    func testGivenGame_WhenReady_ThenPlayerOneUp() {
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
    }
    
    func testGivenGame_WhenReady_ThenLastTurnIsNil() {
        XCTAssertNil(view.gameBoard.lastTurn)
    }
    
    func testGivenGame_WhenReady_ThenPlayerOneIsUp() {
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
    }
    
    //MARK:- Turn taking Tests
    
    func testGivenGame_WhenTakingTurn_ThenPlayerOneIsUp() {
        game.takeTurnAtPosition(0)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
    }
    
    func testGivenGame_WhenTakingTurn_ThenComputerTookATurn() {
        game.takeTurnAtPosition(.TopLeft)
        XCTAssertNotNil(view.gameBoard.lastTurn)
        XCTAssertNotEqual(view.gameBoard.lastTurn, .TopLeft)
    }
    
    func testGivenGame_WhenTakingTurnAtSecondPosition_ThenComputerTakesTurnAtDifferentPosition() {
        game.takeTurnAtPosition(1)
        XCTAssertNotEqual(view.gameBoard.lastTurn, BoardPosition(rawValue: 1))
    }
    
    func testGivenGame_WhenTakingSecondTurn_ThenComputersSecondTurnIsAtDifferentPosition() {
        game.takeTurnAtPosition(0)
        let position = view.gameBoard.emptyPositions.first!
        game.takeTurnAtPosition(position)
        XCTAssertNotEqual(view.gameBoard.lastTurn, position)
    }
    
    func testGivenGame_WhenTakingTurn_ThenBoardHasOneCrossAndOneNought() {
        game.takeTurnAtPosition(0)
        XCTAssertEqual(view.gameBoard.noughts, 1)
        XCTAssertEqual(view.gameBoard.crosses, 1)
    }
    
    func testGivenGame_WhenTakingTwoTurns_ThenBoardHasTwoCrossesAndTwoNoughts() {
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(view.gameBoard.emptyPositions.first!)
        XCTAssertEqual(view.gameBoard.noughts, 2)
        XCTAssertEqual(view.gameBoard.noughts, 2)
    }

}
