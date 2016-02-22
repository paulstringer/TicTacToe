import XCTest
@testable import TicTacToe

class GameTypeHumanVersusHumanTests: XCTestCase {
    
    let view = GameViewSpy()
    var game: TicTacToe!
    
    override func setUp() {
        super.setUp()
        game = TicTacToe(view: view)
    }

    //MARK:- Humam V Human Tests
    
    func testGivenGame_WhenReady_ThenViewsGameTypesNotEmpty() {
        game.ready()
        XCTAssertFalse(view.gameTypes.isEmpty)
    }
    
    func testGivenGame_WhenReady_ThenViewsGameTypesContainsHumanVHuman() {
        game.ready()
        XCTAssertTrue(view.gameTypes.contains(.HumanVersusHuman))
    }
 
    func testGivenHumanVHumanGame_WhenTakingTurns_ThenViewsNextPlayerAlternates() {
        game.ready()
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
        game.takeTurn(0, y: 0)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoUp)
        game.takeTurn(0, y: 0)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
        game.takeTurn(0, y: 0)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoUp)
        game.takeTurn(0, y: 0)
        XCTAssertEqual(view.gameState, GameState.PlayerOneUp)
        game.takeTurn(0, y: 0)
        XCTAssertEqual(view.gameState, GameState.PlayerTwoUp)
    }
    
    // TODO: Game Mode should allow human v. computer
    // TODO: Game Mode should allow computer v. computer
    
}
