import XCTest
@testable import TicTacToe

class GameTypeTests: XCTestCase {
    
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
    
    func testGivenGame_WhenReady_ThenViewsGameTypesContainsHumanVersusComputer() {
        game.ready()
        XCTAssertTrue(view.gameTypes.contains(.HumanVersusHuman))
    }
    
    // TODO: Game Mode should allow computer v. computer
    // TODO: Game Mode should allow compute v. computer
    
    
}
