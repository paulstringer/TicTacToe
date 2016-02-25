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
    
    func testGivenGame_WhenReady_ThenViewsGameTypesContainsHumanVersusComputer() {
        XCTAssertTrue(view.gameTypes.contains(.HumanVersusComputer))
    }
    
    func testGivenGame_WhenSelectingGameTypeHumanVersusComputer_ThenPlayerOneUp() {
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
    }
    
    func testGivenGame_WhenReady_ThenLastTurnIsNil() {
        XCTAssertNil(view.gameBoard.lastTurn)
    }
    
    func testGivenGame_WhenTakingTurn_ThenPlayerOneIsUp() {
        game.takeTurnAtPosition(0)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
    }
    
    func testGivenGame_WhenTakingTurn_ThenComputerTakesTurn() {
        game.takeTurnAtPosition(.TopLeft)
        XCTAssertNotNil(view.gameBoard.lastTurn)
        XCTAssertNotEqual(view.gameBoard.lastTurn, .TopLeft)
    }
    
    func testGivenGame_WhenTakingTurnAtPositionOne_ThenComputerTakesTurnAtDifferentPosition() {
        game.takeTurnAtPosition(1)
        XCTAssertNotEqual(view.gameBoard.lastTurn, BoardPosition(rawValue: 1))
    }
    
    func testGivenGame_WhenTakingTwoTurns_ThenComputerTakesTurnsAtDifferentPosition() {
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(2)
        XCTAssertNotEqual(view.gameBoard.lastTurn, BoardPosition(rawValue: 2))
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
    }
    
    func testGivenGame_WhenTakingTurn_ThenBoardHasOneCrossOneNought() {
        game.takeTurnAtPosition(0)
        let noughts = view.gameBoard.markers.filter { (marker) in
            return marker == .Nought
        }
        let crosses = view.gameBoard.markers.filter { (marker) in
            return marker == .Cross
        }
        XCTAssertEqual(noughts.count, 1)
        XCTAssertEqual(crosses.count, 1)
    }
    
    func testGivenGame_WhenTakingTwoTurn_ThenBoardHasTwoCrossesTwoNoughts() {
        game.takeTurnAtPosition(0)
        game.takeTurnAtPosition(2)
        let noughts = view.gameBoard.markers.filter { (marker) in
            return marker == .Nought
        }
        let crosses = view.gameBoard.markers.filter { (marker) in
            return marker == .Cross
        }
        XCTAssertEqual(noughts.count, 2)
        XCTAssertEqual(crosses.count, 2)
    }

    
    
}
