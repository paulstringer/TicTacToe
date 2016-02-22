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
        game.takeTurn(1, column: 1)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoUp)
        game.takeTurn(2, column: 1)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
        game.takeTurn(3, column: 1)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoUp)
        game.takeTurn(1, column: 2)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
        game.takeTurn(2, column: 2)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoUp)
    }
    
    func testGivenGame_WhenTakingTurnWhereRowIsLessThanOne_ThenViewsPlayerRemainsPlayerOne() {
        game.takeTurn(0, column: 1)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
    }
    
    func testGivenGame_WhenTakingTurnWhereRowIsGreaterThanThree_ThenViewsPlayerRemainsPlayerOne() {
        game.takeTurn(4, column: 1)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
    }
    
    func testGivenGame_WhenTakingTurnWhereColumnIsLessThanOne_ThenViewsPlayerRemainsPlayerOne() {
        game.takeTurn(1, column: 0)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
    }
    
    func testGivenGame_WhenTakingTurnWhereColumnIsGreaterThanThree_ThenViewsPlayerRemainsPlayerOne() {
        game.takeTurn(1, column: 4)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
    }
    
    // TODO: Game Mode should allow human v. computer
    // TODO: Game Mode should allow computer v. computer
    
}
