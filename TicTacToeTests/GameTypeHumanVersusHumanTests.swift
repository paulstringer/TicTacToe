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
    
    // TODO: Game Mode should allow human v. computer
    // TODO: Game Mode should allow computer v. computer
    
}
