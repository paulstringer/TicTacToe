import XCTest
@testable import TicTacToe

class GameTypeHumanVersusHumanTests: XCTestCase {
    
    let view = GameViewSpy()
    var game: TicTacToe!
    
    override func setUp() {
        super.setUp()
        game = TicTacToe(view: view)
        game.ready()
    }

    //MARK:- Humam V Human Tests
    
    func testGivenGame_WhenReady_ThenViewsGameTypesNotEmpty() {
        XCTAssertFalse(view.gameTypes.isEmpty)
    }
    
    func testGivenGame_WhenReady_ThenViewsGameTypesContainsHumanHuman() {
        XCTAssertTrue(view.gameTypes.contains(.HumanVersusHuman))
    }
 
    func testGivenGame_WhenTakingTurns_ThenViewsPlayerUpAlternates() {
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
        game.takeTurnAtRow(1, column: 1)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoUp)
        game.takeTurnAtRow(2, column: 1)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
        game.takeTurnAtRow(3, column: 1)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoUp)
        game.takeTurnAtRow(1, column: 2)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
        game.takeTurnAtRow(2, column: 2)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoUp)
    }
    
    func testGivenGame_WhenTakingTurnWhereRowIsLessThanOne_ThenViewsPlayerRemainsPlayerOne() {
        game.takeTurnAtRow(0, column: 1)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
    }
    
    func testGivenGame_WhenTakingTurnWhereRowIsGreaterThanThree_ThenViewsPlayerRemainsPlayerOne() {
        game.takeTurnAtRow(4, column: 1)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
    }
    
    func testGivenGame_WhenTakingTurnWhereColumnIsLessThanOne_ThenViewsPlayerRemainsPlayerOne() {
        game.takeTurnAtRow(1, column: 0)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
    }
    
    func testGivenGame_WhenTakingTurnWhereColumnIsGreaterThanThree_ThenViewsPlayerRemainsPlayerOne() {
        game.takeTurnAtRow(1, column: 4)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
    }
    
    func testGivenGame_WhenPlayerTwoPlaysSameSquareAsPlayerOne_ThenViewsPlayerRemainsPlayerTwo(){
        game.takeTurnAtRow(1, column: 3)
        game.takeTurnAtRow(1, column: 3)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoUp)
    }
    
    func testGivenGame_WhenPlayerOnePlaysTopHorizontalLine_ThenViewsGameStateIsPlayerOneWins() {
        game.takeTurnAtRow(1, column: 1)
        game.takeTurnAtRow(2, column: 1)
        game.takeTurnAtRow(1, column: 2)
        game.takeTurnAtRow(2, column: 2)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
        game.takeTurnAtRow(1, column: 3)
        XCTAssertEqual(view.gameState, GameState.PlayerOneWins)
    }
    
    func testGivenGame_WhenPlayerTwoPlaysTopHorizontalLine_ThenViewsGameStateIsPlayerTwoWins() {
        game.takeTurnAtRow(2, column: 1)
        game.takeTurnAtRow(1, column: 1)
        game.takeTurnAtRow(2, column: 2)
        game.takeTurnAtRow(1, column: 2)
        game.takeTurnAtRow(3, column: 1)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoUp)
        game.takeTurnAtRow(1, column: 3)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoWins)
    }
    
    func testGivenGame_WhenPlayerOnePlaysMiddleHorizontalLine_ThenViewsGameStateIsPlayerOneWins() {
        game.takeTurnAtRow(2, column: 1)
        game.takeTurnAtRow(1, column: 1)
        game.takeTurnAtRow(2, column: 2)
        game.takeTurnAtRow(1, column: 2)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
        game.takeTurnAtRow(2, column: 3)
        XCTAssertEqual(view.gameState, GameState.PlayerOneWins)
    }
    
    func testGivenGame_WhenPlayerTwoPlaysMiddleHorizontalLine_ThenViewsGameStateIsPlayerOneWins() {
        game.takeTurnAtRow(1, column: 1)
        game.takeTurnAtRow(2, column: 1)
        game.takeTurnAtRow(1, column: 2)
        game.takeTurnAtRow(2, column: 2)
        game.takeTurnAtRow(3, column: 1)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoUp)
        game.takeTurnAtRow(2, column: 3)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoWins)
    }
    
    func testGivenGame_WhenPlayerOnePlaysBottomHorizontalLine_ThenViewsGameStateIsPlayerOneWins() {
        game.takeTurnAtRow(3, column: 1)
        game.takeTurnAtRow(1, column: 1)
        game.takeTurnAtRow(3, column: 2)
        game.takeTurnAtRow(1, column: 2)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
        game.takeTurnAtRow(3, column: 3)
        XCTAssertEqual(view.gameState, GameState.PlayerOneWins)
    }
    
    func testGivenGame_WhenPlayerTwoPlaysBottomHorizontalLine_ThenViewsGameStateIsPlayerTwoWins() {
        game.takeTurnAtRow(1, column: 1)
        game.takeTurnAtRow(3, column: 1)
        game.takeTurnAtRow(1, column: 2)
        game.takeTurnAtRow(3, column: 2)
        game.takeTurnAtRow(2, column: 1)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoUp)
        game.takeTurnAtRow(3, column: 3)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoWins)
    }

    func testGivenGame_WhenPlayerTwoBlocksPlayerOnesLine_ThenViewsPlayerUpIsPlayerOne() {
        game.takeTurnAtRow(1, column: 1)
        game.takeTurnAtRow(3, column: 1)
        game.takeTurnAtRow(1, column: 2)
        game.takeTurnAtRow(1, column: 3)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
    }
    
    func testGivenGame_WhenPlayerOneBlocksPlayerTwosLine_ThenViewsPlayerUpIsPlayerTwo() {
        game.takeTurnAtRow(1, column: 1)
        game.takeTurnAtRow(2, column: 1)
        game.takeTurnAtRow(1, column: 2)
        game.takeTurnAtRow(2, column: 2)
        game.takeTurnAtRow(2, column: 3)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoUp)
    }
    // TODO: Game Mode should allow human v. computer
    // TODO: Game Mode should allow computer v. computer
    
}
